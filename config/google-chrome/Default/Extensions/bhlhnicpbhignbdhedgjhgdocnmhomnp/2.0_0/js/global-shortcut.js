/*!
   This file is part of ColorZilla
  
   Written by Alex Sirota (alex @ iosart.com)
  
   Copyright (c) iosart labs llc 2011, All Rights Reserved
   
   Please do not use without permission
*/
!function(){document.body.hasAttribute("cz-shortcut-listen")||(document.body.setAttribute("cz-shortcut-listen","true"),document.body.addEventListener("keydown",function(a){var b=navigator.userAgent.toLowerCase().indexOf("mac")>-1,c=a.keyCode;(a.ctrlKey&&a.altKey&&!b||a.metaKey&&a.altKey&&b)&&c>64&&91>c&&chrome.extension.sendRequest({"op":"hotkey-pressed","keyCode":c})},!1))}();