<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

{
	"result": <c:out value="${errorCode}" />,
	"errorCode": <c:out value="${errorCode}" />,
	"communityRequestID": "<c:out value="${communityRequest.communityRequestID}" />",
	"companyName": "<c:out value="${communityRequest.companyName}" />"
}