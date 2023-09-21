function setCookie(name, value) {
	if (value == null)
		return;
	exp = new Date();
	exp.setMonth(exp.getMonth() + 1);
	value = escape(value);
	document.cookie = name + "=" + value + ";" + "expires=" + exp.toGMTString()
			+ ";";
}

function getCookieVal(offset) {
	var endstr = document.cookie.indexOf(";", offset);
	if (endstr == -1)
		endstr = document.cookie.length;
	return unescape(document.cookie.substring(offset, endstr));
}

function getCookie(name) {
	var arg = name + "=";
	var alen = arg.length;
	var clen = document.cookie.length;
	var i = 0;
	while (i < clen) {
		var j = i + alen;
		if (document.cookie.substring(i, j) == arg)
			return getCookieVal(j);
		i = document.cookie.indexOf("", i) + 1;
		if (i == 0)
			break;
	}
	return "";
}

function CheckCookie(value) {
	value1 = getCookie("name");
	if (value1 != value)
		setCookie("name", value)
}
function deleteCookie(name, path, domain) {
	if (getCookie(name)) {
		document.cookie = name + "=" + ((path) ? "; path=" + path : "")
				+ ((domain) ? "; domain=" + domain : "")
				+ "; expires=Thu, 01-Jan-1970 00:00:01 GMT";
	}
}