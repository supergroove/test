<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

{
	"errorCode": <c:out value="${errorCode}" />,
	"message" : "<c:out value="${message}" escapeXml="false" />",
	"contextPath" : "<c:out value="${contextPath}" escapeXml="false" />",
	"userID" : "<c:out value="${userID}" escapeXml="false" />",
	"deptID" : "<c:out value="${deptID}" escapeXml="false" />",
	"emp" : "<c:out value="${emp}" escapeXml="false" />"
}