// Playwright run-code script: inject Worker hook, capture HLS AES keys for SD and FHD
// Usage: npx playwright cli -s=<session> run-code scripts/capture_key.js
// Prerequisite: player tab is active (v-glive.gaodun.com/player?token=...)

async (page) => {
  // Step 1: inject Worker communication hook before any worker is created
  await page.addInitScript(() => {
    window.__workerData = [];
    const OrigWorker = window.Worker;
    window.Worker = function (...args) {
      const worker = new OrigWorker(...args);
      window.__workerData.push({ type: 'worker_created', url: String(args[0]).substring(0, 200) });

      // Hook postMessage (main thread -> worker)
      const origPostMessage = worker.postMessage.bind(worker);
      worker.postMessage = function (msg, transfer) {
        try {
          if (msg && typeof msg === 'object') {
            const clone = JSON.parse(JSON.stringify(msg, (key, value) => {
              if (value instanceof Uint8Array) return Array.from(value);
              if (value instanceof ArrayBuffer) return Array.from(new Uint8Array(value));
              if (value instanceof Date) return value.toISOString();
              return value;
            }));
            window.__workerData.push({ direction: 'to_worker', msg: clone });
          }
        } catch (e) {
          window.__workerData.push({ direction: 'to_worker', error: String(e) });
        }
        return origPostMessage(msg, transfer);
      };

      // Hook addEventListener (worker -> main thread)
      const origAddEventListener = worker.addEventListener.bind(worker);
      worker.addEventListener = function (type, listener, options) {
        if (type === 'message') {
          const wrappedListener = function (event) {
            try {
              const data = event.data;
              if (data && typeof data === 'object') {
                let clone;
                try {
                  clone = JSON.parse(JSON.stringify(data, (key, value) => {
                    if (value instanceof Uint8Array) return Array.from(value);
                    if (value instanceof ArrayBuffer) return Array.from(new Uint8Array(value));
                    return value;
                  }));
                } catch (e) {
                  clone = { error: String(e), keys: Object.keys(data) };
                }
                window.__workerData.push({ direction: 'from_worker', msg: clone });
              }
            } catch (e) {}
            return listener.apply(this, arguments);
          };
          return origAddEventListener(type, wrappedListener, options);
        }
        return origAddEventListener(type, listener, options);
      };

      return worker;
    };
    window.Worker.prototype = OrigWorker.prototype;
  });

  // Step 2: reload so hook is active before worker creation
  await page.reload({ waitUntil: 'domcontentloaded' });
  await page.waitForTimeout(5000);

  // Step 3: seek to beginning and play
  await page.evaluate(() => {
    const wrap = document.querySelector('.gp-video-wrap');
    if (!wrap) return 'no wrap';
    const customEl = Array.from(wrap.children).find(c => c.tagName.startsWith('G-'));
    if (!customEl || !customEl.video) return 'no video';
    const v = customEl.video;
    v.currentTime = 0;
    v.play();
    return 'playing';
  });
  await page.waitForTimeout(8000);

  // Step 4: switch to FHD 1080P
  const fhdResult = await page.evaluate(() => {
    const items = document.querySelectorAll('.gp-setting-quality-item');
    for (const item of items) {
      if (item.textContent.includes('1080')) {
        item.click();
        return 'clicked 1080P';
      }
    }
    return '1080P option not found; items: ' + Array.from(items).map(i => i.textContent.trim()).join('|');
  });
  await page.waitForTimeout(8000);

  // Step 5: extract all keys and m3u8 URLs
  const result = await page.evaluate(() => {
    const msgs = window.__workerData || [];
    // initHls messages contain m3u8 URLs
    const inits = msgs.filter(m => m.msg && m.msg.type === 'initHls');
    // decrypt responses: from_worker messages with type 'decrypt' and response field
    // Note: response comes FROM worker TO main thread, then main thread sends answer BACK as to_worker
    // The actual key is in to_worker messages with msg.response (the decrypted key answer)
    const responses = msgs.filter(m => m.direction === 'to_worker' && m.msg && m.msg.response !== undefined);

    const streams = [];
    for (let i = 0; i < inits.length; i++) {
      const url = inits[i].msg.data?.hlsConfig?.url || '';
      const isFHD = url.includes('FHD');
      const resp = responses[i];
      const keyBytes = resp ? resp.msg.response : null;
      // AES key = first 16 bytes of response, interpreted as raw ASCII
      const keyAscii = keyBytes ? String.fromCharCode.apply(null, keyBytes.slice(0, 16)) : null;
      streams.push({
        quality: isFHD ? 'FHD-1080P' : 'SD-540P',
        m3u8: url,
        keyAscii: keyAscii,
        keyBytes: keyBytes ? Array.from(keyBytes) : null
      });
    }
    return JSON.stringify({ fhdSwitch: fhdResult, streams }, null, 2);
  });

  return result;
}
