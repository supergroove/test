<?xml version="1.0" encoding="utf-8" standalone="no"?>
<%@ page language="java" pageEncoding="utf-8" contentType="text/xml; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<c:if test="${not empty company}">
<comp>
	<compname><c:out value="${company.name}"/></compname>
	<compID><c:out value="${company.deptCode}"/></compID>
<c:forEach var="dept" items="${deptList}">
	<dept>
		<deptid><c:out value="${dept.DEPT_CODE}"/></deptid>
		<parentid><c:out value="${dept.PAR_CODE}"/></parentid>
		<compid><c:out value="${company.deptCode}"/></compid>
		<name><c:out value="${dept.DEPT_NAME}"/></name>
	</dept>
</c:forEach>
<c:forEach var="user" items="${userList}">
	<user>
		<deptid><c:out value="${user.DEPT_CODE}"/></deptid>
		<name><c:out value="${user.NAME}"/></name>
		<userid><c:out value="${user.EMP_CODE}"/></userid>
		<phonenumber><c:out value="${user.PHONE}"/></phonenumber>
		<phoneid><c:out value="${user.EXTENSION_NUMBER}"/></phoneid>
		<rank><c:out value="${user.POS_NAME}"/></rank>
	</user>
</c:forEach>
</comp>
</c:if>