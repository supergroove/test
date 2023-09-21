<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

{
	"errorCode": <c:out value="${errorCode}" />,
	"K": "<c:out value="${authentication.userKey}" escapeXml="false" />",
	"loginName" : "<c:out value="${loginName}" escapeXml="false" />",
	"loginType" : "<c:out value="${loginType}" escapeXml="false" />",
	"changePassword" : <c:out value="${changePassword}" default="false"/>,
	"isOtherOffice" : <c:out value="${isOtherOffice}" default="false"/>
	<c:if test="${not empty users}">
	,"users" : [
	<c:forEach var="user" items="${users}" varStatus="status">
		<c:if test="${IS_ENGLISH}">
			<c:if test="${not empty user.nameEng}">
				<c:set target="${user}" property="name" value="${user.nameEng}" />
			</c:if>
			<c:if test="${not empty homonym.deptNameEng}">
				<c:set target="${user}" property="deptName" value="${user.deptNameEng}" />
			</c:if>
		</c:if>
		{"id": "<c:out value="${user.ID}" />", "name":"<c:out value="${user.name}" />", "deptName":"<c:out value="${user.deptName}" />"}
		<c:if test="${!status.last}">,</c:if>
	</c:forEach>
	]
	</c:if>
}