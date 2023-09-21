<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	
	<script type="text/javascript">
		jQuery(document).ready(function() {
			test_loadOrgView();
		});
		
		function test_loadOrgView() {
		/*
			// Example
			$("#testOrgView").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"orgView",
				K:				"",		// optional (default: "")
				display:		""		// optional (default: "") - ""
			}, function() {
				directory_orgView_onLoad();
			});
		*/
			//$("#test-orgView").empty();
			$("#test-orgView").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"orgView",
				K:				$("#test-K").val(),
				display:		$("#test-display").val()
			}, function() {
				if (typeof(directory_orgView_onLoad) != "undefined") {
					directory_orgView_onLoad();
				}
			});
		}
	</script>
</head>
<body>
	<a href="<c:out value="${CONTEXT}" />/directory/test.jsp">back</a><br /><br />
	<ul>
		<li>
			Test options<br />
			<table border="0">
				<tr>
					<td width="100">K :</td>
					<td><input type="text" id="test-K" value="" /></td>
				</tr>
			</table>
		</li>
	</ul>
	<input type="button" value="submit" onclick="javascript:test_loadOrgView();" />
	
	<div id="test-orgView"></div> <!-- required - must exist "div" element -->
</body>
</html>