var tabbuttonselected = null;

function getReal(el, type, value) {
	var temp = el;
	while ((temp != null) && (temp.tagName != "BODY")) {
		if (eval("temp." + type) == value) {
			el = temp;
			return el;
		}
		temp = temp.parentNode;
	}
	return el;
}

function doClick(event) {
	var el = getReal(event.target || event.srcElement, "className", "tabbutton");
	if (el != tabbuttonselected) {
		if (el.className == "tabbutton") {
			if (document.getElementById("recType"))
				document.getElementById("recType").value = el.id;
			if (tabbuttonselected != null) {
				makeRaised(tabbuttonselected);
			}
			makePressed(el);
			tabbuttonselected = el;
		}
	}
}

function makePressed(el) {
	el.className = "tabbutton-selected";
	var e = document.getElementById(el.id + '-div');
	if (e) {
		e.style.display = 'block';
	}
}

function makeRaised(el) {
	el.className = "tabbutton";
	var e = document.getElementById(el.id + '-div');
	if (e) {
		e.style.display = 'none';
	}
}

function selectTabButton(tb) {
	if (typeof tb == 'string') tb = document.getElementById(tb);
	if (tb) {
		var buttons = findChildren(tb.parentNode.parentNode, "className", "tabbutton");
		for (var i = 0; i < buttons.length; i++) {
			(buttons[i] == tb) ? makePressed(buttons[i]) : makeRaised(buttons[i]);
		}
		tabbuttonselected = tb;
	}
}

function getSelectedTabButton() {
	return (tabbuttonselected != null) ? tabbuttonselected.id : '';
}

function findChildren(el, type, value) {
	var children = el.children;
	var tmp = new Array();
	for (var i = 0; i < children.length; i++) {
		if (eval("children[i]." + type + "==\"" + value + "\"")) {
			tmp[tmp.length] = children[i];
		}
		tmp = tmp.concat(findChildren(children[i], type, value));
	}
	return tmp;
}
