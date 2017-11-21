/*! Copyright 2009-2017 Evernote Corporation. All rights reserved. */

UUID={generateQuad:function(){return(65536*(1+Math.random())|0).toString(16).substring(1)},generateGuid:function(){return this.generateQuad()+this.generateQuad()+"-"+this.generateQuad()+"-"+this.generateQuad()+"-"+this.generateQuad()+"-"+this.generateQuad()+this.generateQuad()+this.generateQuad()}};