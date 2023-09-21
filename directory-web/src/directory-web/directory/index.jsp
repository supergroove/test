<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hs.framework.directory.config.OrgConfigData"%>
<%@ page import="com.hs.framework.directory.context.OrgConstant"%>
<%@ include file="./jsp/common/include.jsp" %>
<html lang="utf-8"> 
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- jQuery Dynatree -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/js/jquery/css/jquery-ui.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery-ui.custom.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/cookie.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/org.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/mng/orgMng.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/common/divPopup_jquery.js"></script>
	
<style type="text/css">
<!--

body {
	height: auto;
	background: url(<c:out value="${CONTEXT}" />/directory/images/login/LOGIN_BG.GIF) repeat-x left top;
	margin-top: 128px;
}

table.login {
	font-family: Arial, Helvetica, sans-serif, MS UI Gothic, Dotum, Tahoma,
		Verdana;
	font-size: 12px;
	color: #333333;
}

table.login td {
	padding-right: 5px;
}

input.box {
	padding: 2px;
	color: #333333;
	border: solid 1px #999;
	width: 100px;
}

.langselect {
	padding: 3px 20px 0 0
}

/***** Popup *****/
#pop_wrap {
	width: 700px;
	height: 250px;
	background: url(<c:out value="${CONTEXT}" />/directory/images/bg_title.gif) repeat-x top
}

-->
</style>

<%
	Cookie cookie1 = new Cookie("key", null);
	cookie1.setPath("/");
	cookie1.setMaxAge(0);
	response.addCookie(cookie1);
	Cookie cookie2 = new Cookie("userID", null);
	cookie2.setPath("/");
	cookie2.setMaxAge(0);
	response.addCookie(cookie2);
	
	if("1".equals(OrgConfigData.getProperty(OrgConfigData.DIRECTORY_CRYPT_PWCRYPT))){
		request.setAttribute("DIRECTORY_CRYPT_PWCRYPT", "1");
	}

	String communityID = request.getParameter("COMMUNITYID");
	if (communityID == null || communityID.trim().length() < 1) {
		communityID = OrgConstant.COMMUNITY_ID_SYSTEM;
	}
	pageContext.setAttribute("COMMUNITYID", communityID);
%>

<script> 	
var directoryLogin = null;
function loadDefault(){
	var loginName = getCookie("login_name");
	var loginType = getCookie("login_type");
	var focusOnName = true;
	if(typeof(loginName) != 'undefined'){
		$("#directory-login-name").val(loginName);
	}
	if(typeof(loginType) != 'undefined'){
		if(loginType == 'empcode'){
			$("#directory-login-empcode").attr('checked', true);
		}
	}
	if($("#directory-login-name").val() == ''){
		$("#directory-login-name").focus();
	}else{
		$("#directory-login-password").focus();
	}
	var gwLang = getCookie("GWLANG");
	if(typeof(gwLang) != 'undefined'){
		if(gwLang.match("^ko")){
			$("#directory-lang option[value='ko_KR']").attr('selected', true);
		}else if(gwLang.match("^en")){
			$("#directory-lang option[value='en_US']").attr('selected', true);
		}else if(gwLang.match("^ja")){
			$("#directory-lang option[value='ja_JP']").attr('selected', true);
		}
	}
	
	loadLoginMessages($("#directory-lang").val());
}

function loadLoginMessages(locale) {
	$.ajax({
		cache : false,
		url : "<c:out value="${CONTEXT}"/>/directory/jsp/login/login_messages.jsp", // load directory login messages
		data : {
			FRAMEWORK_DIRECTORY_LOCALE : locale // ko_KR, en_US, ja_JP
		},
		dataType : "html",
		success : function(data, status) {
			$("#directory-login-messages").html(data);
		}
	});
}

(function($){
	$(function(){
		<c:if test="${'1' eq DIRECTORY_CRYPT_PWCRYPT}">
		directoryGenerateKeyPairs({
			context : "<c:out value="${CONTEXT}"/>",
			communityID: "<c:out value="${COMMUNITYID}"/>",
			successCallback: function(publicKey, exponent){
if(window.console) window.console.log("index.jsp successCallback publicKey["+publicKey+ ", exponent["+exponent+"]");
				publicKeyModulus = publicKey ? publicKey : false;
				publicKeyExponent = exponent ? exponent : false;
if(window.console) window.console.log("index.jsp successCallback publicKeyModulus["+publicKeyModulus+"], publicKeyExponent["+publicKeyExponent+"]");
			},
			failCallback: function(msg, errorCode){
if(window.console) window.console.log("index.jsp failCallback msg["+msg+"], errorCode["+errorCode+"]");
				if(msg) alert(msg);
			}
		});
if(window.console) window.console.log("index.jsp successCallback publicKeyModulus["+publicKeyModulus+"], publicKeyExponent["+publicKeyExponent+"]");
		</c:if>
if(window.console) window.console.log("index.jsp publicKeyModulus ["+publicKeyModulus+"], publicKeyExponent["+publicKeyExponent+"]");
		directoryLogin = $('#div_login').directoryLogin({
			context : "<c:out value="${CONTEXT}"/>",
			communityID: "<c:out value="${COMMUNITYID}"/>",
			loginType: "name",
			checkDupLogin: "<%=OrgConfigData.getPropertyForBoolean(OrgConfigData.DIRECTORY_LOGIN_ALLOWDUPLOGIN) ? "0" : "1"%>", // "0": false, "1": true
			loginSuccessCallback : showResponse,
			loginFailCallback : showError
		});
	});
	
	function showError (message) {
		alert("error:"+message);
	}
	
	function showResponse (K, result, loginName) {
//		alert("success:"+K);
		if(typeof(result) != 'undefined'){
			if(typeof(result.loginName) != 'undefined'){
				setCookie("login_name", result.loginName);
			}
			if(typeof(result.loginType) != 'undefined'){
				setCookie("login_type", result.loginType);
			}
		}
		if(typeof(loginName) != 'undefined'){
			setCookie("login_name", loginName);
		}
		var gwLang = $("#directory-lang option:selected").val();
		setCookie("GWLANG", gwLang);
		$("#gotoMain #K").val(K);
		$("#gotoMain").submit();
	}
})(jQuery);
<%
if(OrgConfigData.getPropertyForBoolean(OrgConfigData.DIRECTORY_USE_EXTERNALUSER)){
%>
function addExternalUser(){
	directory_orgMng.viewAddExternalUser("001000000");
}
<%
}
%>
</script>
<c:if test="${'1' eq DIRECTORY_CRYPT_PWCRYPT}">
<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/rsa.js"></script>
</c:if>
</head>
<body onload="loadDefault();">
<form id="gotoMain" action="<c:out value="${CONTEXT}"/>/org.do" method="POST">
	<input type="hidden" name="acton" value="main"/>
	<input type="hidden" name="K" id="K" value=""/>
</form>

<div id="directory-login-messages" style="display:none;"></div>

<div id="div_login" name="div_login">
	<table width="592" border="0" align="center" cellpadding="0" cellspacing="0" style="margin: auto;">
		<tr>
			<td width="592" height="165" background="<c:out value="${CONTEXT}" />/directory/images/login/LOGIN_TOP.GIF">&nbsp;</td>
		</tr>
		<tr>
			<td style="padding-right: 38px" height="126" align="right" background="<c:out value="${CONTEXT}" />/directory/images/login/LOGIN_BOTTOM.GIF">
				<table width="100" border="0" cellpadding="0" cellspacing="0" class="login">
					<tr>
						<td>
							<input id="directory-login-name" name="directory-login-name" type="text" class="box" onkeydown="if (event.keyCode == 13) {directoryLogin.login();}">
							<div id='directory-homonyms'></div>
							<div id='directory-otheroffices'></div>
						</td>
						<td rowspan="2">
							<img src="<c:out value="${CONTEXT}" />/directory/images/login/BT_LOGIN.GIF" width="54" height="47" border="0" onclick="javascript:directoryLogin.login();" onfocus="blur();">
						</td>
					</tr>
					<tr>
						<td>
							<input id="directory-login-password" name="directory-login-password" type="password" class="box" onkeydown="if (event.keyCode == 13) {directoryLogin.login();}">
						</td>
					</tr>
					<tr>
						<td colspan="2" height="16">
							<input type="checkbox" id="directory-login-empcode" name="directory-login-empcode" value="checkbox" onkeydown="if (event.keyCode == 9) {blur(); }">
							<fmt:message bundle="${messages_directory}" key="directory.login.EmpCode" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height="20" align="right" class="langselect">
				<%
				if(OrgConfigData.getPropertyForBoolean(OrgConfigData.DIRECTORY_USE_EXTERNALUSER)){
				%>
				<a href="javascript:addExternalUser()"><fmt:message bundle="${messages_directory}" key="directory.add.externalUserAdd" /></a>
				<%
				}
				 %>
				<img src="<c:out value="${CONTEXT}" />/directory/images/login/ARROW.GIF" width="14" height="7" alt="">
				<label for="select">Language selection</label>
				<select id="directory-lang" onchange="loadLoginMessages(this.value);">
					<option value="ko_KR">한국어</option>
					<option value="en_US">English</option>
					<option value="ja_JP">日本語</option>
				</select>
			</td>
		</tr>
	</table>
</div>
</body>
</html>