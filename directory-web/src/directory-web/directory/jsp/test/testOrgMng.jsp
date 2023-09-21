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
			test_loadOrgMng();
		});
		
		function test_loadOrgMng() {
		/*
			// Example
			$("#testOrgMng").load("<c:out value="${CONTEXT}" />/orgMng.do", {
				acton:			"orgMng",
				K:				"",		// optional (default: "")
				display:		""		// optional (default: "") - ""
			}, function() {
				directory_orgMng_onLoad();
			});
		*/
			//$("#test-orgMng").empty();
			$("#test-orgMng").load("<c:out value="${CONTEXT}" />/orgMng.do", {
				acton:			"orgMng",
				K:				$("#test-K").val(),
				display:		$("#test-display").val()
			}, function() {
				if (typeof(directory_orgMng_onLoad) != "undefined") {
					directory_orgMng_onLoad();
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
	<input type="button" value="submit" onclick="javascript:test_loadOrgMng();" />
	
	<div id="test-orgMng"></div> <!-- required - must exist "div" element -->
</body>
</html>