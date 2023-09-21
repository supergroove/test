<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery-ui.custom.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.cookie.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/main.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/view/orgView.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/common/divPopup.js"></script>
	
	<script type="text/javascript">
		function directory_unifiedSearch_onLoad() {
			$("#directory-workspace").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"listUnifiedSearchUsers",
				searchType:		"<c:out value="${param.searchType}" />",		// optional (default: "name") - "name, pos, rank, code, email, phone, mobile, business, dept"
				searchValue:	"<c:out value="${param.searchValue}" />",
				listPerPage:	"<c:out value="${param.listPerPage}" />",		// optional (default: "15")
				pageShortCut:	"<c:out value="${param.pageShortCut}" />",		// optional (default: "10")
				currentPage:	"1"												// optional (default: "1")
			}, function() {
				if (typeof(directory_listUnifiedSearchUsers_onLoad) != "undefined") {
					directory_listUnifiedSearchUsers_onLoad();
				}
			});
		}
	</script>
</head>
<body onload="directory_unifiedSearch_onLoad()">
	<div id="directory-workspace"></div>
</body>
</html>