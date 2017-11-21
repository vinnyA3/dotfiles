(function () {
  var interval;
  var randomText = function () {
    var tips = document.querySelectorAll('.pm-loader-text li');
    var random = Math.floor(Math.random() * tips.length) + 1;

    for (var i = 0; i < tips.length; i++) {
      tips[i].style.display = 'none';
      tips[i].style.opacity = '0';
    }

    document.querySelector('.pm-loader-text li:nth-child(' + random + ')').style.display = 'inline-block';

    setTimeout(function () {
      document.querySelector('.pm-loader-text li:nth-child(' + random + ')').style.opacity = '1';
    }, 10);

    if (document.querySelector('.pm-loader').classList.contains('is-hidden')) {
      clearInterval(interval);
    };
  }

  randomText();
  interval = setInterval(randomText, 3000);
})();
