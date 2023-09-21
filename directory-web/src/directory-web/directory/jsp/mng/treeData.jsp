<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

<c:choose>
<c:when test="${param.acton eq 'initDeptTree'}">
	[
		<c:out value="${data}" escapeXml="false" />
	]
</c:when>
<c:when test="${param.acton eq 'expandDeptTree'}">
	[
		<c:if test="${param.scope eq 'subtree'}">
			<c:out value="${data}" escapeXml="false" />	
		</c:if>
		
		<c:if test="${param.scope ne 'subtree'}">
			<c:forEach var="dept" items="${deptList}" varStatus="loop">
				<c:if test="${IS_ENGLISH}">
					<c:if test="${not empty dept.nameEng}">
						<c:set target="${dept}" property="name" value="${dept.nameEng}" />
					</c:if>
				</c:if>
				<c:if test="${loop.count > 1}">,</c:if>
				{"key": "<c:out value="${dept.ID}" />", "title": "<c:out value="${dept.name}" />", "deptStatus": "<c:out value="${dept.status}" />", "isLazy": true, "isFolder": true}
			</c:forEach>
		</c:if>
	]
</c:when>
<c:when test="${param.acton eq 'searchDeptTree'}">
	[
		{"key": "", "title": "<fmt:message bundle="${messages_directory}" key="directory.search.searchResult" />", "isFolder": true, "expand": true, "hideCheckbox": true, "noLink": true,
		"children": [
		<c:forEach var="dept" items="${deptList}" varStatus="loop">
			<c:if test="${IS_ENGLISH}">
				<c:if test="${not empty dept.nameEng}">
					<c:set target="${dept}" property="name" value="${dept.nameEng}" />
				</c:if>
			</c:if>
			<c:if test="${loop.count > 1}">,</c:if>
			{"key": "<c:out value="${dept.ID}" />", "title": "<c:out value="${dept.name}" />", "deptStatus": "<c:out value="${dept.status}" />", "isFolder": true}
		</c:forEach>
		<c:if test="${empty deptList}">
			{"key": "", "title": "<fmt:message bundle="${messages_directory}" key="directory.search.noDept" />", "hideCheckbox": true, "addClass": "ui-dynatree-statusnode-warning", "noLink": true}
		</c:if>
		]}
	]
</c:when>
<c:when test="${param.acton eq 'initDirGroupTree'}">
	[
		<c:out value="${data}" escapeXml="false" />
	]
</c:when>
<c:when test="${param.acton eq 'expandDirGroupTree'}">
	[
		<c:forEach var="group" items="${groupList}" varStatus="loop">
			<c:if test="${loop.count > 1}">,</c:if>
			{"key": "<c:out value="${group.ID}" />", "title": "<c:out value="${group.name}" />", "isLazy": true, "isFolder": true}
		</c:forEach>
	]
</c:when>
<c:when test="${param.acton eq 'searchDirGroup'}">
	[
		{"key": "", "title": "<fmt:message bundle="${messages_directory}" key="directory.search.searchResult" />", "isFolder": true, "expand": true, "hideCheckbox": true, "noLink": true,
		"children": [
		<c:forEach var="group" items="${groupList}" varStatus="loop">
			<c:if test="${loop.count > 1}">,</c:if>
			{"key": "<c:out value="${group.ID}" />", "title": "<c:out value="${group.name}" />", "isFolder": true}
		</c:forEach>
		<c:if test="${empty groupList}">
			{"key": "", "title": "<fmt:message bundle="${messages_directory}" key="directory.search.noDirGroup" />", "hideCheckbox": true, "addClass": "ui-dynatree-statusnode-warning", "noLink": true}
		</c:if>
		]}
	]
</c:when>
</c:choose>