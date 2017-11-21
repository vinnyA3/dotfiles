//is set to true when this script needs to create a new window to import the collection
var toSendToNewWindow = false,
    globalLaunchData = null,
    windowCreateCallback = function (win) {
      var thisWinId = win.id;
      win.onClosed.addListener(function (thisWinId) {
        return function () {
          console.log("On closing the window");
          chrome.runtime.sendMessage({
            id: 'pmWindowClosed',
            event: 'pmWindowClosed',
            object: thisWinId // Contains the URL to import the collection from.
          });
        }
      }(thisWinId));
    };

// Listens to any message coming from a requester window
chrome.runtime.onMessage.addListener(function (receivedMessage) {
  // Postman was launched by clicking on a URL, so wait until it's initialized, and
  // then pass the URL to it.
  if (receivedMessage.name === 'postmanInitialized' && toSendToNewWindow && globalLaunchData) {
    chrome.runtime.sendMessage({
      id: 'openCollectionFromURL',
      event: 'importCollectionFromURL',
      object: globalLaunchData // Contains the URL to import the collection from.
    });
    toSendToNewWindow = false; //the next postmanInitialized event should not re-trigger the importcollection message
  }
  else if (receivedMessage.name === "openNewRequesterWindow") {
    chrome.app.window.create('html/requester.html', {
      'id': receivedMessage.windowId,
      'bounds': {
        top: 60,
        left: 60,
        width: 1074,
        height: 800
      }
    }, function (win) {
      win.contentWindow.pmWindowsOpen = receivedMessage.pmWindowsOpen;
      win.contentWindow.pmPrimaryWindowId = receivedMessage.pmPrimaryWindowId;
      win.contentWindow.pmWindowsOpenList = receivedMessage.pmWindowsOpenList;
      win.contentWindow.pmThisWindowId = receivedMessage.windowId;
      windowCreateCallback(win);
    });
  }
});

chrome.app.runtime.onLaunched.addListener(function (launchData) {

    chrome.system.display.getInfo(function (info) {
        var width = info[0].workArea.width,
            height = info[0].workArea.height,
            nWindows;

        if (width > 1400 && height > 800) {
            width = 1400;
            height = 800;
        }

        nWindows = chrome.app.window.getAll().length;

        if (nWindows === 0) {
            // Postman is not running, we need to create a new window
            toSendToNewWindow = true;
            if (launchData.id === 'postman_collection') {
              globalLaunchData = launchData;
            }
            else {
              globalLaunchData = null;
            }

            chrome.app.window.create('html/requester.html', {
                  "id": "postman-main",
                  "bounds": {
                      width: width,
                      height: height
                  },
                  "outerBounds": {
                      width: width,
                      height: height
                  }
              },windowCreateCallback);
        }
        else if (launchData.id === 'postman_collection') {
            // Postman was launched by clicking on a collection URL, and a Postman window was already open, so
            // just make the existing window import the collection.
            chrome.runtime.sendMessage({
                id: 'openCollectionFromURL',
                event: 'importCollectionFromURL',
                object: launchData
            });
        }
    });
});
