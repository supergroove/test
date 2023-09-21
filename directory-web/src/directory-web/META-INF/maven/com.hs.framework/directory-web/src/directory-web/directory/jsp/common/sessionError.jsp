<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message bundle="${messages_directory}" key="directory.error.title.sessionError" /></title>
	
	<script language='javascript'>
	function toPage()
	{
	    this.location.href = '/index.html';
	}
	</script>
</head>
<body bgcolor="white" text="black" link="blue" vlink="purple" alink="red">
	<br>
	<br>
	<br>
	<br>
	<p align="center">
		<!--a href="javascript:toPage();"-->
		<img src="<c:out value="${CONTEXT}" /><fmt:message bundle="${messages_directory}" key="/directory/images/ERROR2.GIF" />" border="0">
		
		<!--/a-->
		<br>
	</p>
	<p align="center">&nbsp;</p>
</body>
</html>