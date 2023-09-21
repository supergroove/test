<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

{
	"errorCode": <c:out value="${errorCode}" />,
	"errorMessage": "<c:out value="${errorMessage}" escapeXml="false" />",
	"homonyms" : [
	<c:forEach var="homonym" items="${homonyms}" varStatus="status">
		<c:if test="${IS_ENGLISH}">
			<c:if test="${not empty homonym.nameEng}">
				<c:set target="${homonym}" property="name" value="${homonym.nameEng}" />
			</c:if>
			<c:if test="${not empty homonym.deptNameEng}">
				<c:set target="${homonym}" property="deptName" value="${homonym.deptNameEng}" />
			</c:if>
		</c:if>
		{"uniqueID": "<c:out value="${homonym.uniqueID}" />", "name":"<c:out value="${homonym.name}" />"}
		<c:if test="${!status.last}">,</c:if>
	</c:forEach>
	]
}