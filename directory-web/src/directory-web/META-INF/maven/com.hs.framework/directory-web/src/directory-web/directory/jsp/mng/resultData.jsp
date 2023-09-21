<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

{
	"errorCode": <c:out value="${errorCode}" />,
	"errorMessage": "<c:out value="${errorMessage}" escapeXml="false" />",
	"deptID": "<c:out value="${deptID}" />",
	"groupID": "<c:out value="${groupID}" />",
	"hirID": "<c:out value="${hirID}" />",
	"communityID": "<c:out value="${communityID}" />",
	"length": "<c:out value="${length}" />"
}