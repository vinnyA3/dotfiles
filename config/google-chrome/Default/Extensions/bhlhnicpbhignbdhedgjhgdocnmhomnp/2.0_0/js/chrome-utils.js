/*!
   This file is part of ColorZilla
  
   Written by Alex Sirota (alex @ iosart.com)
  
   Copyright (c) iosart labs llc 2011, All Rights Reserved
   
   Please do not use without permission
*/
if("undefined"==typeof ColorZilla||!ColorZilla)var ColorZilla={};ColorZilla.ChromeUtils={"openURLInNewTab":function(a){chrome.tabs.create({"url":a})},"getExtensionVersion":function(a){var b=new XMLHttpRequest;b.open("get","/manifest.json",!0),b.onreadystatechange=function(c){4==b.readyState&&a(JSON.parse(b.responseText).version)},b.send({})},"getChromeVersion":function(){if(!window||!window.navigator)return"-";var a=window.navigator.userAgent;return a&&a.match(/Chrome\/([0-9.]+)/)?RegExp.$1:"-"},"getPlatform":function(){var a=navigator.userAgent.toLowerCase();return-1!=a.indexOf("mac")?"mac":-1!=a.indexOf("windows")?"windows":-1!=a.indexOf("linux")?"linux":"unknown"},"platformIs":function(a){return this.getPlatform()==a},"platformSupportsNonForegroundHover":function(){return"windows"==this.getPlatform()},"i18nReplace":function(a,b){$(a).html(chrome.i18n.getMessage(b))}};