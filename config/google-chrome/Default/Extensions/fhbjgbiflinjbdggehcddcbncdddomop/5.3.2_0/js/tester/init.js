var responseBody;
var responseHeaders;
var responseTime;
var responseCode;
var request;
var iteration;
var data;
var postman;
var environments;
var globals;

function xmlToJson(data) {
	var x2js = new X2JS();
	var jsonObj = x2js.xml_str2json(data);
	return jsonObj;
}

function xml2Json(data) {
	var JSON = {};
	xml2js.parseString(data, {
		explicitArray: false,
		async: false,
		trim: true,
		mergeAttrs: false
	}, function (err, result) {
		JSON = result;
	});
	return JSON;
}

$(document).ready(function() {
	var evaluator = new Evaluator();
});

