/*!
   This file is part of ColorZilla
  
   Written by Alex Sirota (alex @ iosart.com)
  
   Copyright (c) iosart labs llc 2011, All Rights Reserved
   
   Please do not use without permission
*/
ColorZilla.ChromeUtils.getExtensionVersion(function(a){document.getElementById("colorzilla-version").innerHTML=a}),ColorZilla.ChromeUtils.i18nReplace("head title, div.heading h1","about_colorzilla_for_chrome"),ColorZilla.ChromeUtils.i18nReplace("#version-label","version"),ColorZilla.ChromeUtils.i18nReplace("#created-by-label","created_by"),ColorZilla.ChromeUtils.i18nReplace("#homepage-label","home_page"),ColorZilla.ChromeUtils.i18nReplace("#licensing-label","licensing"),ColorZilla.ChromeUtils.i18nReplace("#license-link","license"),ColorZilla.ChromeUtils.i18nReplace("#attributions-label","attributions"),$("#icon-attrib").html(chrome.i18n.getMessage("some_icons_by",'<a href="http://p.yusukekamiyamane.com/">Yusuke Kamiyamane</a>')),$("#colorpicker-attrib").html(chrome.i18n.getMessage("color_picker_by",['<a href="http://www.digitalmagicpro.com/jPicker/">Christopher T. Tillman</a>','<a href="http://johndyer.name/photoshop-like-javascript-color-picker/">John Dyer</a>']));