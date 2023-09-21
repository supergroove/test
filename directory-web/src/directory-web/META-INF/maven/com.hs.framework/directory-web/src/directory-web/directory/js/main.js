/********************************************************************
 * common variable
 ********************************************************************/
var start_menu;
var showOrHide = true;
var MENU_ID_ORGVIEW = 1;
var MENU_ID_ORGMNG = 2;
var MENU_ID_USERENV = 3;
var MENU_ID_DIRGROUPMNG = 4;
/********************************************************************/

/********************************************************************
 * Document READY
 ********************************************************************/
$(function() {
	start_menu = document.location.href;
});
/********************************************************************/

/********************************************************************
 * Normal Functions
 ********************************************************************/
function toggle_menu_bg(select_id){
	$("div.nav_area ul.menu li a").each(function(i){
		if($(this)[0].id == select_id)
			$(this).addClass('menu_on');
		else 
			$(this).removeClass('menu_on');
	});
}

function clear_menu_bg(){
	$("div.nav_area ul.menu li a").each(function(i){
		$(this).removeClass('menu_on');
	});
}

function loadOrgMng(){
	$("#directory-main-workspace").load(CONTEXT+"/orgMng.do", {
		acton:			"orgMng",
		K:				K
	}, function() {
		if (typeof(directory_orgMng_onLoad) != "undefined") {
			directory_orgMng_onLoad();
		}
	});
}

function loadOrgView(){
	$("#directory-main-workspace").load(CONTEXT+"/org.do", {
		acton:			"orgView",
		K:				K
	}, function() {
		if (typeof(directory_orgView_onLoad) != "undefined") {
			directory_orgView_onLoad();
		}
	});
}

function loadOrgEnv(){
	$("#directory-main-workspace").load(CONTEXT+"/org.do", {
		acton:			"orgEnv",
		K:				K
	}, function() {
		if (typeof(directory_orgEnv_onLoad) != "undefined") {
			directory_orgEnv_onLoad();
		}
	});
}

function loadDirGroupMng(){
	$("#directory-main-workspace").load(CONTEXT+"/orgMng.do", {
		acton:			"dirGroupMng",
		K:				K
	}, function() {
		if (typeof(directory_dirGroupMng_onLoad) != "undefined") {
			directory_dirGroupMng_onLoad();
		}
	});
}

function switch_main(menuID){
	switch(menuID){
	case MENU_ID_ORGVIEW: 
		loadOrgView();
		break;
	case MENU_ID_ORGMNG: 
		loadOrgMng();
		break;
	case MENU_ID_USERENV: 
		loadOrgEnv();
		break;
	case MENU_ID_DIRGROUPMNG: 
		loadDirGroupMng();
		break;
	default:
		loadOrgView();
		break;
	}
}

function switch_menu(show_menu){
	$('.nav_area ul').each(function(i, el) {
		if(el.id){
			if(el.id == show_menu){
				if($(this).is(':hidden')){
					$('#normal_menu').hide();
					$(this).slideDown();
				} else {
					$(this).hide();
					$('#normal_menu').slideDown();
				}
			} else {
				$(this).hide();
			}
		}
	});
}

function logout() {
	directoryLogout({
		context : CONTEXT,
		logoutCallback: function() {
			window.location = this.context + "/directory/index.jsp";
		}
	});
	
	deletePreCookies();

	top.location.href = CONTEXT + "/directory/index.jsp";
}

function changeAdditionalUser(UID){
	if(!directoryOtherOfficeLogin) return;
	directoryOtherOfficeLogin.changeAdditionalUser(UID);
}

function deleteCookie(name, path, domain) {
	if (getCookie(name)) {
		document.cookie = name + "=" + ((path) ? "; path=" + path : "")
				+ ((domain) ? "; domain=" + domain : "")
				+ "; expires=Thu, 01-Jan-1970 00:00:01 GMT";
	}
}

function deletePreCookies() {
	deleteCookie("key", "/");
	deleteCookie("userID", "/");
}

function setCookie(name, value, expires, path, domain, secure) {
	var curCookie = name + "=" + escape(value)
			+ ((expires) ? "; expires=" + expires.toGMTString() : "")
			+ ((path) ? "; path=" + path : "")
			+ ((domain) ? "; domain=" + domain : "")
			+ ((secure) ? "; secure" : "");
	document.cookie = curCookie;
}

function getCookie(name) {
	var dc = document.cookie;
	var prefix = name + "=";
	var begin = dc.indexOf("; " + prefix);
	if (begin == -1) {
		begin = dc.indexOf(prefix);
		if (begin != 0)
			return null;
	} else
		begin += 2;
	var end = document.cookie.indexOf(";", begin);
	if (end == -1)
		end = dc.length;
	return unescape(dc.substring(begin + prefix.length, end));
}

function toggle_hide_memu() {
	$('li.rim_hidden').each(function() {
		$(this).toggle(200);
	});
}
/********************************************************************
 * Menu Functions
 ********************************************************************/
function popup_link(url, win_name, width, height) {
	var left = screen.width / 2 - width / 2;
	var top = screen.height / 2 - height / 2;
	var popup_win = window.open(url, win_name, 'left=' + left + ',top=' + top + ',width=' + width + ',height=' + height + ',scrollbars=yes, resizable=yes, menubar=yes');
	if (popup_win) popup_win.focus();
}
/********************************************************************/