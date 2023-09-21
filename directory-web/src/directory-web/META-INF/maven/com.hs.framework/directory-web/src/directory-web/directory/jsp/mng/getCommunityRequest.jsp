<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

{
	"result": <c:out value="${errorCode}" />,
	"communityRequestID": "<c:out value="${communityRequest.communityRequestID}" />",
	"communityID": "<c:out value="${communityRequest.communityID}" />",
	"companyName": "<c:out value="${communityRequest.companyName}" />",
	"companyNameEng": "<c:out value="${communityRequest.companyNameEng}" />",
	"companyType": "<c:out value="${communityRequest.companyType}" />",
	"managerName": "<c:out value="${communityRequest.managerName}" />",
	"EMail": "<c:out value="${communityRequest.email}" />",
	"phone": "<c:out value="${communityRequest.phone}" />",
	"mobilePhone": "<c:out value="${communityRequest.mobilePhone}" />",
	"domainFlag": "<c:out value="${communityRequest.domainFlag}" />",
	"domain": "<c:out value="${communityRequest.domain}" />",
	"userCount": "<c:out value="${communityRequest.userCount}" />",
	"defaultLocale": "<c:out value="${communityRequest.defaultLocale}" />",
	"serviceMonths": "<c:out value="${communityRequest.serviceMonths}" />",
	"requestType": "<c:out value="${communityRequest.requestType}" />",
	"requestDate": "<c:out value="${communityRequest.requestDate}" />",
	"payDate": "<c:out value="${communityRequest.payDate}" />",
	"approvedDate": "<c:out value="${communityRequest.approvedDate}" />",
	"expiredDate": "<c:out value="${communityRequest.expiredDate}" />",
	"status": "<c:out value="${communityRequest.status}" />"
}