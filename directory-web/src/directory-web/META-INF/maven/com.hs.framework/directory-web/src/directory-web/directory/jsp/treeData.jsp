<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="include.jsp" %>

<c:choose>
<c:when test="${param.acton eq 'initOrgTree'}">
	[
		<c:out value="${data}" escapeXml="false" />
	]
</c:when>
<c:when test="${param.acton eq 'expandOrgTree'}">
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
				{"key": "<c:out value="${dept.ID}" />", "title": "<c:out value="${dept.name}" />", "rbox": "", "isLazy": true, "isFolder": true}
			</c:forEach>
		</c:if>	
	]
</c:when>
<c:when test="${param.acton eq 'searchDept'}">
	[
		{"key": "", "title": "<fmt:message key="message.searchresult" />", "rbox": "", "isFolder": true, "expand": true, "hideCheckbox": true, "noLink": true,
		"children": [
		<c:forEach var="dept" items="${deptList}" varStatus="loop">
			<c:if test="${IS_ENGLISH}">
				<c:if test="${not empty dept.nameEng}">
					<c:set target="${dept}" property="name" value="${dept.nameEng}" />
				</c:if>
			</c:if>
			<c:if test="${loop.count > 1}">,</c:if>
			{"key": "<c:out value="${dept.ID}" />", "title": "<c:out value="${dept.name}" />", "rbox": "", "isFolder": true}
		</c:forEach>
		<c:if test="${empty deptList}">
			{"key": "", "title": "<fmt:message key="message.notdept" />", "hideCheckbox": true, "addClass": "ui-dynatree-statusnode-warning", "noLink": true}
		</c:if>
		]}
	]
</c:when>
<c:when test="${param.acton eq 'contactTree'}">
	[
	 	{"key": "<c:out value="${user.ID}" />", "title": "<fmt:message key="org.personal"/>", "isFolder": true, "expand": true, "hideCheckbox": true, "scope": "user",
		"children": [
		<c:forEach var="contact" items="${contactList}" varStatus="loop">
			<c:if test="${loop.count > 1}">,</c:if>
			{"key": "<c:out value="${contact.groupID}" />", "title": "<c:out value="${contact.groupName}" />", "isFolder": true, "scope": "group"}
		</c:forEach>
		]},
		{"key": "<c:out value="${user.deptID}"/>", "title": "<fmt:message key="org.dept"/>", "isFolder": true, "expand": true, "hideCheckbox": true, "scope": "dept"}, 
		{"key": "", "title": "<fmt:message key="org.public"/>", "isFolder": true, "expand": true, "hideCheckbox": true,
		"children": [
		<c:forEach var="contact_shared" items="${sharedContactList}" varStatus="loop">
			<c:if test="${loop.count > 1}">,</c:if>
			{"key": "<c:out value="${contact_shared.groupID}" />", "title": "<c:out value="${contact_shared.groupName}" />", "isFolder": true, "scope": "group"}
		</c:forEach>
		]}

	]
</c:when>
<c:when test="${param.acton eq 'groupTree'}">
	[
		<c:if test="${param.groupType eq 'M'}">
		 	{"key": "", "title": "<fmt:message key="org.personal"/>", "isFolder": true, "expand": true, "hideCheckbox": true,
		 	"children": [
		 	<c:forEach var="group" items="${groupList}" varStatus="loop">
				<c:if test="${loop.count > 1}">,</c:if>
				{"key": "<c:out value="${group.ID}" />", "title": "<c:out value="${group.name}" />", "isFolder": true}
			</c:forEach>
		 	]},
		 	{"key": "", "title": "<fmt:message key="org.public"/>", "isFolder": true, "expand": true, "hideCheckbox": true,
			"children": [
			<c:forEach var="group_shared" items="${sharedGroupList}" varStatus="loop">
				<c:if test="${loop.count > 1}">,</c:if>
				{"key": "<c:out value="${group_shared.ID}" />", "title": "<c:out value="${group_shared.name}" />", "isFolder": true}
			</c:forEach>
			]}
		</c:if>	
		
		<c:if test="${param.groupType ne 'M'}">
			<c:forEach var="group" items="${groupList}" varStatus="loop">
				<c:if test="${loop.count > 1}">,</c:if>
				{"key": "<c:out value="${group.ID}" />", "title": "<c:out value="${group.name}" />", "isFolder": true}
			</c:forEach>
		</c:if>
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
		{"key": "", "title": "<fmt:message key="message.searchresult" />", "isFolder": true, "expand": true, "hideCheckbox": true, "noLink": true,
		"children": [
		<c:forEach var="group" items="${groupList}" varStatus="loop">
			<c:if test="${loop.count > 1}">,</c:if>
			{"key": "<c:out value="${group.ID}" />", "title": "<c:out value="${group.name}" />", "isFolder": true}
		</c:forEach>
		<c:if test="${empty groupList}">
			{"key": "", "title": "<fmt:message key="directory.search.noDirGroup" />", "hideCheckbox": true, "addClass": "ui-dynatree-statusnode-warning", "noLink": true}
		</c:if>
		]}
	]
</c:when>
</c:choose>