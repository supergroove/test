<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

{
	"errorCode" : 0,
	"userID": "<c:out value="${linkageAccount.userID}" />",
	"linkageName": "<c:out value="${linkageAccount.linkageName}"/>",
	"accountName": "<c:out value="${linkageAccount.accountName}" />",
	"accountPassword": "<c:out value="${linkageAccount.accountPassword}" />"
}