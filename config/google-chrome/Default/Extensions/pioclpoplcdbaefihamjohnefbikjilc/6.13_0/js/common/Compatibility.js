/*! Copyright 2009-2017 Evernote Corporation. All rights reserved. */

"use strict";var Compatibility=function(){function a(a){a&&"A"===a.target.tagName&&FIREFOX&&(a.preventDefault(),a.stopPropagation(),Browser.sendToExtension({name:"main_openTab",url:a.target.getAttribute("href")}))}return{openTab:a}}();