<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="./jsp/common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message bundle="${messages_directory}" key="directory.add.externalUserAdd" /></title>
	
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/mng/orgMng.js"></script>
	
	<script type="text/javascript">
		jQuery(document).ready(function() {
			$("#directory-workspace").load("<c:out value="${CONTEXT}" />/orgMng.do", {
				acton: "viewAddExternalUser",
				communityID: "001000000",					// required
				display: "empCode, rank, loginID",			// optional (default: "") - "empCode, rank, loginID"
				required: "empCode, loginID, email, phone"	// optional (default: "") - "empCode, loginID, email, phone"
			}, function() {
				if (typeof(directory_addExternalUser_onLoad) != "undefined") {
					directory_addExternalUser_onLoad();
				}
				resizePopup(500, $("#directory-workspace").height());
			});
		});
		
		function resizePopup(width, height) {
			if (window.outerHeight - window.innerHeight > 0) {
				height += window.outerHeight - window.innerHeight;
			} else {
				height += 90; // msie 7, 8
			}
			
			var left = screen.width / 2 - width  / 2;
			var top = screen.height / 2 - height / 2;
			try {
				window.moveTo(left, top);
				window.resizeTo(width, height);
			} catch (e) {
				// ignore
			}
		}
	</script>
</head>
<body>
	<div id="directory-workspace"></div> <!-- required - must exist "div" element -->
</body>
</html>