document.addEventListener('DOMContentLoaded', function() {
  const answerInput = document.querySelector('#post_answer');
  const wordCount = document.querySelector('#word_count');

  answerInput.addEventListener('input', function() {
    const answer = answerInput.value;
    const wordCountValue = countWords(answer);
    wordCount.textContent = wordCountValue;
  });

  function countWords(str) {
    // 文字列を単語に分割する
    const words = str.split(/\s+/);
    const wordCount = words.length;

    return wordCount;
  }
})
