if(
	window.hasOwnProperty("jQuery") && !window.hasOwnProperty("$")
) {
	window.$ = window.jQuery;
}