<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

{
	"errorCode": <c:out value="${errorCode}" />,
	"key": "<c:out value="${authentication.userKey}" escapeXml="false" />",
	"loginName" : "<c:out value="${loginName}" escapeXml="false" />",
	"loginType" : "<c:out value="${loginType}" escapeXml="false" />",
	"auth" : "<c:out value="${auth}" escapeXml="false" />",
	"email" : "<c:out value="${email}" escapeXml="false" />"
}