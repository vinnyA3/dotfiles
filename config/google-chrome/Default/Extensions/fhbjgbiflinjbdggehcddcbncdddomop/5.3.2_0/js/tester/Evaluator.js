var Evaluator = Backbone.Model.extend({
    initialize: function() {
        this.setupListener();
        this.shimWindowFunctions();
    },

    shimWindowFunctions: function() {
      window.open = function() {
        console.error('window.open is not allowed from script sandbox');
      };
    },

    setupListener: function() {
        var oldThis = this;
        var oldJsonParser = JSON.parse;
        console.fileLog = function(fileName, message) {
            console.log(fileName+": " + message);
        };

        window.addEventListener('message', function(event) {
            source = event.source;

            var command = event.data.command;

            if(command === "sandboxEchoText") {
                event.source.postMessage({
                    'type': 'sandboxEchoResponse',
                    'result': true
                }, event.origin);
                return;
            }

            //this is for the snippet generation
            if (command === "getSnippet") {
                var requestJson = event.data.request;
                var snippetName = event.data.snippetName;
                var dataMode = event.data.dataMode;
                var options = event.data.options || {};
                try {
                    var gen = new requestSnippetGenerator.PostmanRequestSnippetGenerator(requestJson);
                    var snippet = gen[snippetName](options);
                    event.source.postMessage({
                        'type': 'snippet_generated',
                        'result': snippet,
                        'dataMode': dataMode
                    }, event.origin);
                }
                catch (e) {
                    console.log(e);
                    event.source.postMessage({
                        'type': 'snippet_error',
                        'errorMessage': e.message
                    }, event.origin);
                }
                return;
            }

            var code = event.data.code;
            var testEnvironment = event.data.environment;
            oldThis.scriptType = event.data.scriptType; //prscript or test

            request = testEnvironment.request;
            responseBody = testEnvironment.responseBody;
            responseHeaders = testEnvironment.responseHeaders;
            responseCookies = testEnvironment.responseCookies;
            responseTime = testEnvironment.responseTime;
            responseCode = testEnvironment.responseCode;

            environment = testEnvironment.environment;
            globals = testEnvironment.globals;

            if ("iteration" in testEnvironment) {
                iteration = testEnvironment.iteration;
            }

            if ("data" in testEnvironment) {
                data = testEnvironment.data;
            }
            else {
                data = {};
            }

            JSON.parse = function(str, modifierFunction) {
                try {
                    if(typeof modifierFunction === "function") {
                        return oldJsonParser(str, modifierFunction);
                    }
                    else {
                        return oldJsonParser(str);
                    }
                }
                catch(e) {
                    throw {
                        message: "There was an error during JSON.parse(): " + e.message
                    };
                }
            }

            postman = {
                getResponseCookie: function(cookieName) {
                    var numCookies = responseCookies.length || 0;
                    for(var i=0;i<numCookies;i++) {
                        var thisCookie = responseCookies[i];
                        if(thisCookie.name.toLowerCase()===cookieName.toLowerCase()) {
                            return thisCookie;
                        }
                    }
                    return null;
                },

                getResponseHeader: function(headerString) {
                    var headers = responseHeaders;
                    for(var key in headers) {
                        if(headers.hasOwnProperty(key)) {
                            if(key.toLowerCase()==headerString.toLowerCase()) {
                                return headers[key];
                            }
                        }
                    }
                    return null;
                },

                setEnvironmentVariable: function(key, value) {
                    if(value) {
                        //to prevent functions going as functions
                        value = value.toString();
                    }
                    var object = {
                        "type": "set_environment_variable",
                        "variable": {
                            "key": key,
                            "value": value
                        }
                    };
                    environment[key]=value;

                    event.source.postMessage(object, event.origin);
                },

                getEnvironmentVariable: function(key) {
                    return environment[key];
                },

                setGlobalVariable: function(key, value) {
                    if(value) {
                        //to prevent functions going as functions
                        value = value.toString();
                    }
                    var object = {
                        "type": "set_global_variable",
                        "variable": {
                            "key": key,
                            "value": value
                        }
                    };

                    globals[key]=value;

                    event.source.postMessage(object, event.origin);
                },

                getGlobalVariable: function(key) {
                    return globals[key];
                },

                clearEnvironmentVariables: function() {
                    var object = {
                        "type": "clear_environment_variables"
                    };
                    environment = {};
                    event.source.postMessage(object, event.origin);
                },

                clearEnvironmentVariable: function(key) {
                    var object = {
                        "type": "clear_environment_variable",
                        "variable": {
                            "key": key
                        }
                    };
                    delete environment[key];
                    event.source.postMessage(object, event.origin);
                },

                clearGlobalVariables: function() {
                    var object = {
                        "type": "clear_global_variables"
                    };
                    globals = {};
                    event.source.postMessage(object, event.origin);
                },

                clearGlobalVariable: function(key) {
                    var object = {
                        "type": "clear_global_variable",
                        "variable": {
                            "key": key
                        }
                    };
                    delete globals[key];
                    event.source.postMessage(object, event.origin);
                },

                setNextRequest: function(requestName) {
                    var object = {
                        "type": "set_next_request",
                        "requestName": requestName
                    };

                    event.source.postMessage(object, event.origin);
                }
            };

            if(event.data.fileList && event.data.fileList.length>0) {
                var fileArray = event.data.fileList.split("\n");
                var numFilesLeft = fileArray.length;
                oldThis.loadCustomFile(command, code, event, fileArray, numFilesLeft);
            }
            else {
                oldThis.loadCustomFile(command, code, event, [], 0);
            }

        });
    },

    loadCustomFile: function(command, code, event, fileArray, numFilesLeft) {
        var oldThis = this;
        if(numFilesLeft == 0) {
            if (command === "runtest") {
                try {
                    var result = eval(code); // eslint-disable-line security/detect-eval-with-expression
                    event.source.postMessage({'type': 'test_result', 'result': result, 'scriptType': oldThis.scriptType}, event.origin);
                }
                catch (e) {
                    console.log(e);
                    event.source.postMessage({'type': 'test_error', 'errorMessage': e.message, 'scriptType': oldThis.scriptType}, event.origin);
                }

            }

            if (command === "runprscript") {
                try {
                    var result = eval(code); // eslint-disable-line security/detect-eval-with-expression
                    event.source.postMessage({'type': 'resultReceivedPrscript', 'result': result,  'scriptType': oldThis.scriptType}, event.origin);
                }
                catch(e) {
                    console.log(e);
                    event.source.postMessage({'type': 'resultErrorPrscript', 'errorMessage': e.message,  'scriptType': oldThis.scriptType}, event.origin);
                }
            }
        }
        else {
        	var oldThis = this;
            $.getScript(fileArray.shift())
                .done(function( script, textStatus ) {
                    console.log("One script file loaded");
                    oldThis.loadCustomFile(command, code, event, fileArray, numFilesLeft-1);
                })
                .fail(function( jqxhr, settings, exception ) {
                    console.error("Could not load one file");
                    oldThis.loadCustomFile(command, code, event, fileArray, numFilesLeft-1);
                });
        }
    }
});
