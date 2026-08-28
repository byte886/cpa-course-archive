#!/usr/bin/env python3
"""
高顿课程视频音频转文字脚本
使用阿里 FunASR (SenseVoiceSmall) + VAD 加速
用法: python transcribe_pipeline.py <视频路径> <输出目录>
"""

import sys
import os
import subprocess
import json
import time
import re

def extract_audio(video_path, output_wav):
    """提取音频为16kHz mono WAV"""
    print(f"[1/5] 提取音频...")
    cmd = [
        'ffmpeg', '-y', '-i', video_path,
        '-vn', '-acodec', 'pcm_s16le',
        '-ar', '16000', '-ac', '1',
        output_wav
    ]
    subprocess.run(cmd, capture_output=True, check=True)
    print(f"  ✓ 音频提取完成: {output_wav}")

def transcribe_with_vad(wav_path, output_dir):
    """使用FunASR + VAD进行转写"""
    print(f"[2/5] 加载模型并转写（VAD加速）...")
    
    from funasr import AutoModel
    
    # 加载模型
    model = AutoModel(
        model="iic/SenseVoiceSmall",
        vad_model="iic/speech_fsmn_vad_zh-cn-16k-common-pytorch",
        vad_kwargs={"max_single_segment_time": 30000},
        device="cpu",
    )
    
    # 转写
    result = model.generate(
        input=wav_path,
        cache={},
        language="zh",
        use_itn=True,
        batch_size_s=60,
    )
    
    print(f"  ✓ 转写完成")
    return result

def postprocess(text):
    """后处理：去除特殊标记"""
    # 去除开头的特殊标记
    text = re.sub(r'^<\|[a-zA-Z]+\|><\|[a-zA-Z]+\|><\|[a-zA-Z]+\|>', '', text)
    # 去除其他特殊标记
    text = re.sub(r'<\|[a-zA-Z]+\|>', '', text)
    return text.strip()

def save_results(result, output_dir, video_path):
    """保存转写结果为Markdown和JSON"""
    print(f"[4/5] 保存结果...")
    
    os.makedirs(output_dir, exist_ok=True)
    
    # 提取文本
    full_text = ""
    segments = []
    
    for item in result:
        text = item.get('text', '')
        text = postprocess(text)
        full_text += text + "\n\n"
        segments.append({
            'text': text,
            'start': item.get('start', 0),
            'end': item.get('end', 0),
        })
    
    # 保存Markdown
    video_name = os.path.splitext(os.path.basename(video_path))[0]
    md_path = os.path.join(output_dir, 'transcript.md')
    
    with open(md_path, 'w', encoding='utf-8') as f:
        f.write(f"# {video_name}\n\n")
        f.write(f"> 自动转写 | FunASR SenseVoiceSmall + VAD\n\n")
        f.write(full_text)
    
    print(f"  ✓ Markdown: {md_path}")
    
    # 保存JSON
    json_path = os.path.join(output_dir, 'transcript.json')
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump({
            'video': video_path,
            'model': 'SenseVoiceSmall',
            'vad': 'speech_fsmn_vad_zh-cn-16k-common-pytorch',
            'segments': segments,
            'full_text': full_text,
        }, f, ensure_ascii=False, indent=2)
    
    print(f"  ✓ JSON: {json_path}")
    
    return md_path, json_path

def main():
    if len(sys.argv) < 3:
        print("用法: python transcribe_pipeline.py <视频路径> <输出目录>")
        sys.exit(1)
    
    video_path = sys.argv[1]
    output_dir = sys.argv[2]
    
    if not os.path.exists(video_path):
        print(f"错误: 视频文件不存在: {video_path}")
        sys.exit(1)
    
    start_time = time.time()
    
    # 创建临时目录
    temp_dir = os.path.join(output_dir, 'temp')
    os.makedirs(temp_dir, exist_ok=True)
    wav_path = os.path.join(temp_dir, 'audio.wav')
    
    try:
        # 1. 提取音频
        extract_audio(video_path, wav_path)
        
        # 2-3. 转写
        result = transcribe_with_vad(wav_path, output_dir)
        
        # 4. 保存结果
        md_path, json_path = save_results(result, output_dir, video_path)
        
        # 5. 清理临时文件
        print(f"[5/5] 清理临时文件...")
        import shutil
        shutil.rmtree(temp_dir, ignore_errors=True)
        
        elapsed = time.time() - start_time
        print(f"\n✓ 转写完成！耗时: {elapsed/60:.1f}分钟")
        print(f"  输出: {md_path}")
        
    except Exception as e:
        print(f"✗ 转写失败: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == '__main__':
    main()
