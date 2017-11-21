(function () {
  var icon = localStorage["toolbar_icon"] || 'dark',
  radios = document.querySelectorAll('input[name=toolbar_icon]'),
  selectedRadio = document.getElementById("toolbar_icon_" + icon),
  r;

  selectedRadio.setAttribute("checked", "checked");
  for (r = 0; r < radios.length; r++) {
    radios[r].addEventListener('change', function (e) {
      var r = e.target;
      localStorage["toolbar_icon"] = r.value;

      var surfix = r.value === 'light' ? '_light.png' : '.png';

      chrome.browserAction.setIcon({
        path: {
          "19": "icon19" + surfix,
          "38": "icon38" + surfix
        }
      });
    }, false);
  }
} ());
