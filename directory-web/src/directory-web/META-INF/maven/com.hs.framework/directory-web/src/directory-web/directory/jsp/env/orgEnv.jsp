<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- jQuery -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery-ui.custom.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.cookie.js"></script>
	
	<!-- HANDY Directory -->
<c:if test="${!display.removeCSS}">
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
</c:if>
	
	<script type="text/javascript">
		var K = "<c:out value="${DIRECTORY_AUTHENTICATION.userKey}"/>";
		var CONTEXT = "<c:out value="${CONTEXT}"/>";
		
		function loadUserEnv(index) {
			switch (index) {
				case 1: viewChangePassword(); break;
				case 2: viewSetAbsence(); break;
				case 3: groupMng(); break;
				case 4: viewUpdateUserInfo(); break;
				case 5: viewUpdateNotify(); break;
				case 6: viewUpdateLinkageAccount(); break;
			}
		}
		
		function viewChangePassword() {
			$("#test-userEnv").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"viewChangePassword",
				K:				K
			}, function() {
				if (typeof(directory_changePassword_onLoad) != "undefined") {
					directory_changePassword_onLoad();
				}
			});
		}
		function viewSetAbsence() {
			$("#test-userEnv").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"viewSetAbsence",
				K:				K
			}, function() {
				if (typeof(directory_setAbsence_onLoad) != "undefined") {
					directory_setAbsence_onLoad();
				}
			});
		}
		function groupMng() {
			$("#test-userEnv").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"groupMng",
				K:				K
			}, function() {
				if (typeof(directory_groupMng_onLoad) != "undefined") {
					directory_groupMng_onLoad();
				}
			});
		}
		function viewUpdateUserInfo() {
			$("#test-userEnv").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"viewUpdateUserInfo",
				K:				K
			}, function() {
				if (typeof(directory_updateUserInfo_onLoad) != "undefined") {
					directory_updateUserInfo_onLoad();
				}
			});
		}
		function viewUpdateNotify() {
			$("#test-userEnv").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"viewUpdateNotify",
				K:				K
			}, function() {
				if (typeof(directory_updateNotify_onLoad) != "undefined") {
					directory_updateNotify_onLoad();
				}
			});
		}
		function viewUpdateLinkageAccount(){
			$("#test-userEnv").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"viewUpdateLinkageAccount",
				K:				K
			}, function() {
				if (typeof(directory_updateLinkageAccount_onLoad) != "undefined") {
					directory_updateLinkageAccount_onLoad();
				}
			});
		}
		function directory_orgEnv_onLoad() {
			loadUserEnv(4);
			
		<c:if test="${!display.removeCSS}">
			directory_orgEnv_resize();
			$(window).resize(function() {
				directory_orgEnv_resize();
			});
		</c:if>
		}
		function directory_orgEnv_resize() {
			if ($("#directory-env-menu").length > 0) {
				$("#directory-env-menu").height(document.documentElement.clientHeight - $("#directory-env-menu").offset().top - 2);
				$("#directory-contents").height(document.documentElement.clientHeight - $("#directory-contents").offset().top);
			}
		}
	</script>
</head>
<body onload="directory_orgEnv_onLoad()">
	<div>
		<div id="directory-env-menu" class="directory_main_left">
			<div class="left_menu">
				<div class="action_area">
	                <ul >
	                    <li><a href="javascript:loadUserEnv(4);"><fmt:message bundle="${messages_directory}" key="directory.env.userinfo.title" /></a></li>
	                    <li><a href="javascript:loadUserEnv(1);"><fmt:message bundle="${messages_directory}" key="directory.env.password.title" /></a></li>
	                    <li><a href="javascript:loadUserEnv(2);"><fmt:message bundle="${messages_directory}" key="directory.env.setabsence" /></a></li>
					<c:if test="${!useDirGroup}">
	                    <li><a href="javascript:loadUserEnv(3);"><fmt:message bundle="${messages_directory}" key="directory.env.group.title" /></a></li>
					</c:if>
					<c:if test="${useNotify}">
	                    <li><a href="javascript:loadUserEnv(5);"><fmt:message bundle="${messages_directory}" key="directory.env.notify.title" /></a></li>
					</c:if>
					<c:if test="${useLinkageAccount}">
						<li><a href="javascript:loadUserEnv(6);"><fmt:message bundle="${messages_directory}" key="directory.env.linkageaccount.title" /></a></li>
					</c:if>
	                </ul>
				</div>
				<div id="menu_tree" class="menu_tree" style="overflow:auto;">
				</div>
			</div>
		</div>
		<div id="directory-contents" class="directory_main_contents">
			<div class="content_box">
				<div id="content">
					<div id="test-userEnv"></div> <!-- required - must exist "div" element -->
				</div>
			</div>
		</div>
	</div>
</body>
</html>