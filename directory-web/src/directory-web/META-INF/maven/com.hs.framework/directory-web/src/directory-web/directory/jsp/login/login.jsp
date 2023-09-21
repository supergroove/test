<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hs.framework.directory.config.OrgConfigData" %>
<%@ include file="../common/include.jsp" %>

<script language="javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
<script language="javascript" src="<c:out value="${CONTEXT}" />/directory/js/org.js"></script>
<script> 
var directoryLogin = null;
(function($){
	$(function(){
		directoryLogin = $('#directory-login').directoryLogin(
							{
								context : "<c:out value="${CONTEXT}" />",
								communityID: "001000000",
								loginType: "name",
								checkDupLogin: "<%=OrgConfigData.getPropertyForBoolean(OrgConfigData.DIRECTORY_LOGIN_ALLOWDUPLOGIN) ? "0" : "1"%>", // "0": false, "1": true
								loginSuccessCallback : showResponse,
								loginFailCallback : showError
							}
						);
		directoryLogin.display();
	});
	
	function showError (message) {
		alert("error:"+message);
	}
	
	function showResponse (K) {
		alert("success:"+K);
		window.location = "<c:out value="${CONTEXT}" />/directory/test.jsp";
//		window.location = "<c:out value="${CONTEXT}" />/directory/testUserEnv.jsp?K="+K;
	}
	
})(jQuery);

function directory_logout() {
	directoryLogout({
		context : "<c:out value="${CONTEXT}" />",
		logoutCallback: function() {
			window.location = "<c:out value="${CONTEXT}" />/directory/test.jsp";
		}
	});
}
</script>

<div>
<%@ include file="login_messages.jsp" %> <!-- login messages -->

<div id="directory-login"></div>
<br />
<a href="javascript:directory_logout();">Logout</a>
</div>