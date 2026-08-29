// 收集高顿教育试卷解析和用户留言的脚本
// 使用方法：在浏览器控制台执行，或者通过Playwright调用

async function collectAllAnalysis() {
  const results = [];
  const totalQuestions = 6;
  
  for (let i = 1; i <= totalQuestions; i++) {
    console.log(`正在收集第${i}题...`);
    
    // 点击答题卡跳转到第i题
    const buttons = document.querySelectorAll('button');
    for (let btn of buttons) {
      if (btn.textContent.trim() === String(i)) {
        btn.click();
        break;
      }
    }
    
    // 等待页面加载
    await new Promise(resolve => setTimeout(resolve, 2000));
    
    // 获取题目内容
    const bodyText = document.body.innerText;
    
    // 解析题目信息
    const questionMatch = bodyText.match(/(\d+)\.\s*(单选题|多选题|判断题)\s*\n([\s\S]*?)(?=\nA\n)/);
    const optionsMatch = bodyText.match(/A\n([\s\S]*?)B\n([\s\S]*?)C\n([\s\S]*?)D\n([\s\S]*?)(?=我的答案)/);
    const myAnswerMatch = bodyText.match(/我的答案：([A-D]+)/);
    const correctAnswerMatch = bodyText.match(/正确答案：([A-D]+)/);
    const analysisMatch = bodyText.match(/解析\n([\s\S]*?)(?=举一反三|考点标签|笔记|上一题)/);
    const tagMatch = bodyText.match(/考点标签\n([\s\S]*?)(?=笔记)/);
    
    // 滚动到笔记部分，加载用户留言
    const noteElements = document.querySelectorAll('[class*=note], [class*=comment], [class*=message]');
    let userNotes = [];
    for (let el of noteElements) {
      if (el.textContent && el.textContent.length > 10) {
        userNotes.push(el.textContent.trim());
      }
    }
    
    results.push({
      questionNum: i,
      questionType: questionMatch?.[2] || '',
      question: questionMatch?.[3]?.trim() || '',
      options: {
        A: optionsMatch?.[1]?.trim() || '',
        B: optionsMatch?.[2]?.trim() || '',
        C: optionsMatch?.[3]?.trim() || '',
        D: optionsMatch?.[4]?.trim() || ''
      },
      myAnswer: myAnswerMatch?.[1] || '',
      correctAnswer: correctAnswerMatch?.[1] || '',
      analysis: analysisMatch?.[1]?.trim() || '',
      tags: tagMatch?.[1]?.trim() || '',
      userNotes: userNotes
    });
  }
  
  console.log('收集完成！');
  return results;
}

// 执行收集
collectAllAnalysis().then(results => {
  console.log(JSON.stringify(results, null, 2));
});
