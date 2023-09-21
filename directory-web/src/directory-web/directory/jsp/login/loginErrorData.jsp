<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

{
	"errorCode": <c:out value="${errorCode}" />,
	"errorMessage": "<c:out value="${errorMessage}" escapeXml="false" />",
	
	"dupLoginClientName": "<c:out value="${dupLoginClientName}" escapeXml="false" />"
}