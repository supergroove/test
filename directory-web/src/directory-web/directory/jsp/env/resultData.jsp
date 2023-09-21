<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

{
	"errorCode": "<c:out value="${errorCode}" />",
	"errorMessage": "<c:out value="${errorMessage}" escapeXml="false" />",
	"deptID": "<c:out value="${deptID}" />",
	"property": "<c:out value="${property}" />",
	"rule": "<c:out value="${rule}" />",
	"length": "<c:out value="${length}" />"
	<c:if test="${!empty user}">,"user": {"pictureURL" : "<c:out value="${user.pictureURL}" />"}</c:if>
}