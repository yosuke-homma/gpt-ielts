document.addEventListener('DOMContentLoaded', () => {
  const countdownDuration = 2400;
  let startTime;
  let remainingTime;
  let timerInterval;

  function startTimer(event) {
    event.preventDefault();

    clearInterval(timerInterval);

    const timerDisplay = document.getElementById('timer');

    if (startTime === undefined) {
      startTime = new Date().getTime() + countdownDuration * 1000;
    } else {
      startTime = new Date().getTime() + remainingTime;
    }

    timerInterval = setInterval(() => {
      const now = new Date().getTime();
      const timeRemaining = startTime - now;

      const minutes = Math.floor((timeRemaining % (1000 * 60 * 60)) / (1000 * 60));
      const seconds = Math.floor((timeRemaining % (1000 * 60)) / 1000);

      timerDisplay.textContent = formatTime(minutes) + ':' + formatTime(seconds);

      if (timeRemaining < 0) {
        clearInterval(timerInterval);
        timerDisplay.textContent = "Time's up!";
      }
    }, 1000);
  }

  function stopTimer(event) {
    event.preventDefault();

    clearInterval(timerInterval);
    remainingTime = startTime - new Date().getTime();
  }

  function formatTime(time) {
    return time < 10 ? '0' + time : time;
  }

  document.getElementById('startBtn').addEventListener('click', startTimer);
  document.getElementById('stopBtn').addEventListener('click', stopTimer);
});
