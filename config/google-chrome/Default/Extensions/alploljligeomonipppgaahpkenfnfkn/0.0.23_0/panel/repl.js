/*----------------------------------
  Events - Basic PubSub
 ---------------------------------*/
var Events = function() {};
Events.prototype = {
  _events: {},

  on: function(event, callback, context) {
    context = context || this;
    this._events[event] = this._events[event] || [];
    this._events[event].push({
      callback: callback,
      context: context
    });
  },

  trigger: function(event) {
    if(!this._events.hasOwnProperty(event)) return;
    var responses = [];
    for(handler of this._events[event]) {
      var args = Array.prototype.slice.call(arguments, 1);
      responses.push(handler.callback.apply(handler.context, args));
    }
    return responses;
  }
}

window.bus = new Events();

/*----------------------------------
  Settings and storage
 ---------------------------------*/
function Settings(repl) {
  this.domReady = false;
  this.repl = repl;
  this.DEFAULTS = this.data = {
    transformer: 'babel',
    tabSize: 2,
    indentUnit: 2,
    indentWithTabs: false,
    theme: 'default'
  }

  document.addEventListener('DOMContentLoaded', this.onDomReady.bind(this));
}

Settings.prototype.onDomReady = function() {
  this.domReady = true;
  this.DOM = {
    transformerOptions: document.querySelector('.transformer-options'),
    openSettingsBtn: document.querySelector('.open-settings'),
    closeSettingsBtn: document.querySelector('.settings__close-btn'),
    settings: document.querySelector('.settings'),
    includedScriptsContainer: document.querySelector('#includesContainer'),
  }

  this.DOM.transformerOptions.innerHTML = this.transformerOptionTemplate(this.repl.transformers);

  // Check for latest settings
  this.get(function(data) {
    // If there's no data stored, store the defaults
    if(typeof data === undefined || !data.hasOwnProperty('transformer')) {
      this.set(this.DEFAULTS, function() {
        this.setFormDefaults(this.data);
      }.bind(this));
    }
    else {
      this.data = data;
      this.setFormDefaults(data);
      for(key in data) {
        bus.trigger('settings:changed:' + key, data[key]);
      }
    }
  }.bind(this));

  this.DOM.openSettingsBtn.addEventListener('click', function() {
    this.DOM.settings.classList.toggle('is-active');
  }.bind(this));

  this.DOM.closeSettingsBtn.addEventListener('click', function() {
    this.DOM.settings.classList.remove('is-active');
  }.bind(this));

  this.DOM.transformerOptions.addEventListener('click', function(e) {
    if(e.target.name === 'transformer')
      this.set({ transformer: e.target.value });
  }.bind(this));

  [].forEach.call(document.querySelectorAll('input[name="theme"]'), function (el) {
    el.addEventListener('click', function(e) {
      this.set({ theme: e.target.value });
    }.bind(this));
  }.bind(this));

  [].forEach.call(document.querySelectorAll('input[name="tabSize"]'), function (el) {
    el.addEventListener('change', function(e) {
      var val = parseInt(e.target.value, 10);
      this.set({ tabSize: val });
      this.set({ indentUnit: val });
    }.bind(this));
  }.bind(this));

  [].forEach.call(document.querySelectorAll('input[name="indentWithTabs"]'), function (el) {
    el.addEventListener('click', function(e) {
      var val = document.querySelectorAll('input[name="indentWithTabs"]')[0].checked;
      this.set({ indentWithTabs: val });
    }.bind(this));
  }.bind(this));

  // Add the first external source input row
  this.DOM.includedScriptsContainer.insertAdjacentHTML('beforeend', this.newSourceRow());

  this.DOM.settings.addEventListener('submit', (evt) => {
    evt.preventDefault();
    const button = evt.target.querySelector('button');
    const input = evt.target.querySelector('input');
    const src = input.value.trim();

    if(src.length === 0) return;
    this.addScriptToPage(src).then(() => {
      button.innerHTML = '&#10003;';
      button.disabled = true;
      input.readOnly = true;
      this.DOM.includedScriptsContainer.insertAdjacentHTML('beforeend', this.newSourceRow());
      document.querySelector('form.settings__includes-container:last-child input').focus();
    }).catch(() => logError(exceptionInfo.value));
  });
}

Settings.prototype.newSourceRow = function() {
  return `<form action="" class="settings__option-container settings__includes-container">
  <input type="text" class="input--text" placeholder="External source URL">
  <button type="submit" class="btn btn--add-source">&#10095</button>
  </form>`;
}

Settings.prototype.addScriptToPage = function(src) {
  return new Promise((resolve, reject) => {
    chrome.devtools.inspectedWindow.eval(`document.querySelector('script[src="${src}"]')`, {}, function(scriptExists) {
      if(scriptExists) return;
      var include = `var script=document.createElement('script');script.src='${src}';document.body.appendChild(script);`;
      chrome.devtools.inspectedWindow.eval(include, {}, function (_, exceptionInfo) {
        if (typeof exceptionInfo !== "undefined" && exceptionInfo.hasOwnProperty("isException")) {
          reject(exceptionInfo.value);
        } else {
          resolve();
        }
      }.bind(this));
    }.bind(this));
  });
}

Settings.prototype.transformerOptionTemplate = function(transformers) {
  var template = '';
  for(var i in transformers) {
    var t = transformers[i];
    template +=
      `<div class="settings__option-container">
        <label>
          <input type="radio" name="transformer" value="${t.handle}" ${t.active ? 'checked' : ''}>
          <span>${t.name}</span>
        </label>
      </div>`;
  }
  return template;
}

Settings.prototype.setFormDefaults = function() {
  document.querySelector('[name="theme"][value="' + this.data.theme + '"]').checked = true;
  document.querySelector('[name="tabSize"]').value = this.data.tabSize;
  document.querySelector('[name="indentWithTabs"]').checked = this.data.indentWithTabs;
}

Settings.prototype.loadingOn = function() {
  [].forEach.call(document.querySelectorAll('.settings__spinner'), function(el) {
    if(this.domReady)
      el.classList.add('is-active');
  }.bind(this));
}

Settings.prototype.loadingOff = function() {
  [].forEach.call(document.querySelectorAll('.settings__spinner'), function(el) {
    setTimeout(function(){el.classList.remove('is-active') }, 500);
  }.bind(this));
}

Settings.prototype.get = function(cb) {
  this.loadingOn();
  // FIXME: https://code.google.com/p/chromium/issues/detail?can=2&start=0&num=100&q=&colspec=ID%20Pri%20M%20Week%20ReleaseBlock%20Cr%20Status%20Owner%20Summary%20OS%20Modified&groupby=&sort=&id=178618
  // chrome.storage.sync.get('settings', function(data) {
  chrome.runtime.sendMessage({name: 'getSettings'}, function(data) {
    this.loadingOff();
    cb(data || {});
  }.bind(this));
}

Settings.prototype.set = function(settings, cb) {
  this.loadingOn();
  var updatedSettings = this.data;
  for(i in settings) {
    updatedSettings[i] = settings[i];
  }
  // FIXME: https://code.google.com/p/chromium/issues/detail?can=2&start=0&num=100&q=&colspec=ID%20Pri%20M%20Week%20ReleaseBlock%20Cr%20Status%20Owner%20Summary%20OS%20Modified&groupby=&sort=&id=178618
  // chrome.storage.sync.set({settings: settings}, function() {
  chrome.runtime.sendMessage({name: 'setSettings', value: updatedSettings}, function(data) {
    this.data = updatedSettings;
    this.loadingOff();
    if(typeof cb === 'function')
      cb();

    for(key in settings) {
      bus.trigger('settings:changed:' + key, settings[key]);
    }
  }.bind(this));
}

function debounce(fn, delay, ctx) {
  var timer = null;
  return function () {
    var context = ctx || this, args = arguments;
    clearTimeout(timer);
    timer = setTimeout(function () {
      fn.apply(context, args);
    }, delay);
  };
}

function logError(err) {
  err = JSON.stringify(err);
  chrome.devtools.inspectedWindow.eval("console.error(\'" + err + "\');");
}

function log(msg) {
  chrome.devtools.inspectedWindow.eval("console.log(\'" + msg + "\');");
}

function xCharacters(number, string) {
  var buffer = '';
  for(var i = 0; i < number; i++) {
    buffer += string;
  }
  return buffer;
}

function Transformer() {
  bus.on('transformers:register', this.registerSelf, this);
  bus.on('settings:changed:transformer', this.onTransformerChange, this);
}

// Attributes to override on the subclass
Transformer.prototype = {
  // Required
  name: false,
  handle: false,
  runtimePath: false,
  transform: function(input) { return ''; },

  // Optional
  beforeTransform: function() {},

  // Internal
  _active: false
}

Transformer.prototype.insertRuntime = function() {
  if(!this.runtimePath) return false;
  var str =
    "if(!document.querySelector('#" + this.handle + "')) {" +
      "var st = document.createElement('script');" +
      "st.id='" + this.handle + "';" +
      "st.src = '" + chrome.extension.getURL(this.runtimePath) + "';" +
      "document.head.appendChild(st);" +
    "}";
  chrome.devtools.inspectedWindow.eval(str)
}

Transformer.prototype.onTransformerChange = function(newTransformer) {
  if(this._active && newTransformer !== this.handle) {
    this._active = false;
  } else if(newTransformer === this.handle) {
    this.insertRuntime();
    this._active = true;
    document.querySelector('input[name="transformer"][value="'+this.handle+'"]').checked = true;
  }
}

Transformer.prototype.registerSelf = function() {
  return this;
}

function BabelTransformer() {
  Transformer.call(this);

  this.name = 'Babel (' + this.getVersion() + ')';
  this.handle = 'babel';
  this.runtimePath = 'node_modules/babel-polyfill/dist/polyfill.min.js'
  this.opts = {
    filename: 'Babel',
    presets: [
      'es2015',
      'stage-0',
      'stage-1'
    ]
  };
}

// Inherit from Transformer
BabelTransformer.prototype = Object.create(Transformer.prototype);
BabelTransformer.prototype.constructor = BabelTransformer;

BabelTransformer.prototype.beforeTransform = function(){
  bus.trigger('transformers:beforeTransform');
}

BabelTransformer.prototype.transform = function(input) {
  try {
    return Babel.transform(input, this.opts).code;
  }
  catch(err) {
    if(err.name === "SyntaxError"){
      bus.trigger("transformers:error", {
        name: 'SyntaxError',
        message: err.message,
        line: err.loc.line - 1,
        column: err.loc.column
      });
    }
    else {
      throw err;
    }
    return null;
  }
}

BabelTransformer.prototype.getVersion = function() {
  return Babel.version;
}

var babelTransformer = new BabelTransformer();

function TraceurTransformer() {
  Transformer.call(this);

  this.name = 'Traceur (' + this.getVersion() + ')';
  this.handle = 'traceur';
  this.runtimePath = 'node_modules/traceur/bin/traceur-runtime.js';
}

// Inherit from Transformer
TraceurTransformer.prototype = Object.create(Transformer.prototype);
TraceurTransformer.prototype.constructor = TraceurTransformer;

TraceurTransformer.prototype.transform = function(input) {
  try {
    var options = traceur.util.Options.experimental(true);
    options.script = true;
    options.importRuntime = false; // https://github.com/google/traceur-compiler/issues/2126
    var compiler = new traceur.Compiler(options);
    return compiler.compile(input);
  }
  catch(err) {
    if(err.name === "MultipleErrors"){
      bus.trigger("transformers:error", {
        name: 'SyntaxError',
        message: err.message,
        line: 0 // no err.line from traceur :'(
      });
    }
    else {
      throw err;
    }
    return null;
  }
}

TraceurTransformer.prototype.getVersion = function() {
  var loader = new traceur.loader.TraceurLoader();
  return loader.version;
}

var traceurTransformer = new TraceurTransformer();

function Coffee() {
  Transformer.call(this);

  this.name = 'CoffeeScript (' + this.getVersion() + ')';
  this.handle = 'coffee-script';
  this.opts = {
    bare: true,
    filename: 'CoffeeScript'
  };
}

// Inherit from Transformer
Coffee.prototype = Object.create(Transformer.prototype);
Coffee.prototype.constructor = Coffee;

Coffee.prototype.beforeTransform = function() {
  bus.trigger('transformers:beforeTransform');
}

Coffee.prototype.transform = function(input) {
  try{
    var ret = CoffeeScript.compile(input, this.opts);
    return ret;
  }
  catch(err){
    if(err.name === "SyntaxError"){
      bus.trigger("transformers:error", {
        name: 'SyntaxError',
        message: err.toString(),
        line: err.location.first_line,
        column: err.location.first_column
      });
    }
    else{
      throw err;
    }
  }
  return null;
}

Coffee.prototype.getVersion = function() {
  return CoffeeScript.VERSION;
}

var coffeeTransformer = new Coffee();

var LS = require('LiveScript');

function LiveScript() {
  Transformer.call(this);

  this.name = 'LiveScript (' + this.getVersion() + ')';
  this.handle = 'LiveScript';
  this.opts = {
    bare: true
  }
}

// Inherit from Transformer
LiveScript.prototype = Object.create(Transformer.prototype);
LiveScript.prototype.constructor = LiveScript;

LiveScript.prototype.transform = function(input) {
  return LS.compile(input, this.opts);
}

LiveScript.prototype.getVersion = function() {
  return LS.VERSION;
}

var livescriptTransformer = new LiveScript();

function JavaScript() {
  Transformer.call(this);

  this.name = 'JavaScript';
  this.handle = 'javascript';
}

JavaScript.prototype = Object.create(Transformer.prototype);
JavaScript.prototype.constructor = JavaScript;

JavaScript.prototype.transform = function(input) {
  return input;
}

var javascriptTransformer = new JavaScript();

var combinationKey = 'metaKey';

function Repl() {

  var registered = bus.trigger('transformers:register');
  this.transformers = {};
  registered.forEach((transformer) => this.transformers[transformer.handle] = transformer);

  this.executionContext = 'top';
  this.settings = new Settings(this);

  this.DOM = {
    body: document.body,
    output: document.querySelector('.output'),
    outputTextArea: document.querySelector('#output'),
    input: document.querySelector('.input'),
    inputTextArea: document.querySelector('#input'),
    contextSelector: document.querySelector('.execution-context-selector'),
    combinationKey: document.querySelector('#combinationKey'),
    executeScriptBtn: document.querySelector('#executeScript'),
    toggleOutputBtn: document.querySelector('#toggleOutput'),
    resizeDivider: document.querySelector('#resize'),
    topNav: document.querySelector('.top-nav'),
  }

  document.addEventListener('DOMContentLoaded', this.onDomReady.bind(this));
}

Repl.prototype.onDomReady = function() {
  chrome.devtools.inspectedWindow.eval('document.location.href', function(currentUrl) {
    this.topLocation = currentUrl;
    this.loadContexts();
    chrome.devtools.inspectedWindow.onResourceAdded.addListener(this.loadContexts.bind(this));
  }.bind(this));

  this.addEventListeners(this);

  this.widgets = [];

  this.editor = CodeMirror.fromTextArea(this.DOM.inputTextArea, {
    lineNumbers: true,
    matchBrackets: true,
    continueComments: "Enter",
    extraKeys: {
      "Ctrl-Q": "toggleComment",
      "Ctrl-Space": "autocomplete"
    },
    tabSize: this.settings.data.tabSize || 2,
    indentUnit: this.settings.data.tabSize || 2,
    indentWithTabs: this.settings.data.indentWithTabs || false,
    autoCloseBrackets: true,
    theme: this.settings.data.theme
  });

  chrome.runtime.sendMessage({name: 'platformInfo'}, function(info) {
    if (info.os !== 'mac') {
      combinationKey = 'ctrlKey';
      this.DOM.combinationKey.textContent = 'Ctrl';
    }
  }.bind(this));

  chrome.runtime.sendMessage({name: 'getCode'}, (data) => {
    if (data.code) {
      this.editor.setValue(data.code);
    }
  });
}

Repl.prototype.loadContexts = function() {
  chrome.devtools.inspectedWindow.getResources(function(resources) {
    var contexts = Array.prototype.filter.call(resources, function(resource) {
      if(resource.type === 'document') {
        if(resource.url === this.topLocation) return false;
        return true;
      }
      return false;
    }).map(function(resource) {
      return {
        url: resource.url,
        handle: resource.url.split('/').slice(2).join('/').split('?')[0]
      }
    });

    var optionString = '<option value="top">&lt;top frame&gt;</option>';
    contexts.forEach(function(resource) {
      var selectedString = resource.url === this.executionContext ? ' selected' : '';
      optionString += `<option value="${resource.url}" ${selectedString}>${resource.handle}</option>`;
    }, this);

    this.DOM.contextSelector.innerHTML = optionString;
  }.bind(this));
}

Repl.prototype.removeWidgets = function(){
  for (var i = 0; i < this.widgets.length; ++i){
    this.editor.removeLineWidget(this.widgets[i]);
  }
  this.widgets.length = 0;
}

Repl.prototype.deliverContent = function(content){
  var transformer = this.transformers[this.settings.data.transformer];
  transformer.beforeTransform();

  try {
    var es5 = transformer.transform(content);
    var evalOptions = {};
    if(this.executionContext !== 'top') evalOptions.frameURL = this.executionContext;
    if(typeof es5 == "string"){
      chrome.devtools.inspectedWindow.eval(es5, evalOptions, function(result, exceptionInfo) {
        if(typeof exceptionInfo !== 'undefined' && exceptionInfo.hasOwnProperty('isException'))
          logError(exceptionInfo.value);
      });
    }
  }
  catch (e) {
    logError(e);
  }
}

Repl.prototype.toggleOutput = function(e, state) {
  this.output = this.output || CodeMirror.fromTextArea(this.DOM.outputTextArea, {
    lineNumbers: true,
    tabSize: 2,
    readOnly: true,
    theme: this.settings.data.theme
  });

  switch (state) {
    case 'hidden':
      this.DOM.output.classList.remove('is-bottom');
      this.DOM.output.classList.add('is-hidden');
      this.DOM.input.style.height = '100%';
      this.DOM.output.style.height = '100%';
      e.target.classList.remove('is-open');
      break;
    case 'right':
      this.DOM.output.classList.remove('is-hidden');
      this.DOM.output.classList.add('is-right');
      this.DOM.input.style.width = '70%';
      this.DOM.output.style.width = '30%';
      e.target.classList.add('is-open');
      break;
    case 'bottom':
      this.DOM.output.classList.remove('is-right');
      this.DOM.output.classList.add('is-bottom');
      this.DOM.input.style.width = '100%';
      this.DOM.input.style.height = '70%';
      this.DOM.output.style.width = '100%';
      this.DOM.output.style.height = '30%';
      break;
  }

  if (!this.DOM.output.classList.contains('is-hidden')) {
    this.updateOutput();
  }
};

Repl.prototype.updateOutput = function() {
  if(this.output === undefined) return;
  try {
    var input = this.editor.getValue();
    var transformer = this.transformers[this.settings.data.transformer];
    transformer.beforeTransform();

    var es5 = transformer.transform(input);
    this.output.setValue(es5);

    this.output.refresh();
  } catch(e) {}
}

Repl.prototype.onResizeMousedown = function() {
  var resizeOutput = this.resizeOutput.bind(this);
  this.DOM.body.classList.add('is-resizing');
  document.addEventListener('mousemove', resizeOutput);
  document.addEventListener('mouseup', function(){
    document.removeEventListener('mousemove', resizeOutput);
    this.DOM.body.classList.remove('is-resizing');
  }.bind(this));
};

Repl.prototype.resizeOutput = function(e) {
  if(this.DOM.output.classList.contains('is-right')) {
    var percentWidth = e.x / window.innerWidth * 100;
    this.DOM.input.style.width = percentWidth + "%";
    this.DOM.output.style.width = 100 - percentWidth + "%";
  } else {
    var percentHeight = e.y / window.innerHeight * 100;
    this.DOM.input.style.height = percentHeight + "%";
    this.DOM.output.style.height = 100 - percentHeight + "%";
  }
};

Repl.prototype.saveCode = function() {
  chrome.runtime.sendMessage({name: 'setCode', value: this.editor.getValue()});
}

Repl.prototype.addEventListeners = function() {
  this.DOM.executeScriptBtn.addEventListener('click', () => this.deliverContent(this.editor.getValue()));

  this.DOM.toggleOutputBtn.addEventListener('click', (function(e) {
    var _e = e, i = 0, states = ['hidden', 'right', 'bottom'];
    return function(_e) {
      i = ++i % states.length;
      this.toggleOutput(_e, states[i]);
    }.bind(this);
  }.bind(this))());

  this.DOM.contextSelector.addEventListener('change', (evt) => this.executionContext = evt.target.value);

  document.addEventListener('keydown', debounce(this.updateOutput, 200, this));
  document.addEventListener('keydown', debounce(this.saveCode, 1000, this));
  document.addEventListener('keydown', function(e) {
    if(e[combinationKey] && e.which == 13) {
      this.deliverContent(this.editor.getValue());
    }
  }.bind(this));

  this.DOM.resizeDivider.addEventListener('mousedown', debounce(this.onResizeMousedown.bind(this)), 200);

  bus.on('settings:changed:theme', function(theme) {
    this.editor.setOption('theme', theme);
    if(this.output) this.output.setOption('theme', theme);

    // Set the top nav color
    var classes = Array.prototype.slice.call(document.querySelector('.input .CodeMirror').classList);
    this.DOM.topNav.className = classes.concat('top-nav').join(' ');
  }, this);

  bus.on('settings:changed:tabSize', (tabSize) => {
    this.editor.setOption('tabSize', tabSize);
    this.editor.setOption('indentUnit', tabSize);
  });
  bus.on('settings:changed:indentWithTabs', (useTabs) => this.editor.setOption('indentWithTabs', useTabs));
  bus.on('settings:changed:transformer', () => this.updateOutput());
  bus.on('transformers:beforeTransform', () => this.removeWidgets());

  bus.on('transformers:error',function(err){
    var msgEl = document.createElement("div");
    msgEl.className = "line-error";
    var icon = msgEl.appendChild(document.createElement("span"));
    icon.innerHTML = "!";
    icon.className = "line-error-icon";

    var message = "<pre>" + err.name + ": ";
    message += err.message + "\n";
    message += "</pre>";

    var msgInfoEl = document.createElement("div");
    msgInfoEl.className = 'line-error-info';
    msgInfoEl.innerHTML = message;
    msgEl.appendChild(msgInfoEl);

    this.widgets.push(this.editor.addLineWidget(err.line, msgEl, {coverGutter: false, noHScroll: true}));
  }, this);
}

// Instantiate the object
window.repl = new Repl();
