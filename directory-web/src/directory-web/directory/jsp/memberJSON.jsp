<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="include.jsp" %>

[
<c:set var="count" value="0" />

<c:if test="${not empty userList}">
	<c:forEach var="user" items="${userList}" varStatus="loop">
		<c:if test="${IS_ENGLISH}">
			<c:if test="${not empty user.nameEng}">
				<c:set target="${user}" property="name" value="${user.nameEng}" />
			</c:if>
			<c:if test="${not empty user.deptNameEng}">
				<c:set target="${user}" property="deptName" value="${user.deptNameEng}" />
			</c:if>
			<c:if test="${not empty user.positionNameEng}">
				<c:set target="${user}" property="positionName" value="${user.positionNameEng}" />
			</c:if>
		</c:if>
		<c:if test="${loop.count > 1}">,</c:if>
		{"uniqueID": "<c:out value="${user.ID}" />", "name": "<c:out value="${user.name}" />", "deptID": "<c:out value="${user.deptID}" />", "deptName": "<c:out value="${user.deptName}" />"}
		<c:if test="${loop.last}">
			<c:set var="count" value="${loop.count}" />
		</c:if>
	</c:forEach>
</c:if>

<c:if test="${not empty subDeptList}">
	<c:if test="${count > 0}">,</c:if>		
	<c:forEach var="subdept" items="${subDeptList}" varStatus="loop">
		<c:if test="${IS_ENGLISH}">
			<c:if test="${not empty subdept.nameEng}">
				<c:set target="${subdept}" property="name" value="${subdept.nameEng}" />
			</c:if>
		</c:if>
		<c:if test="${loop.count > 1}">,</c:if>
		{"uniqueID": "$<c:out value="${subdept.ID}" />", "name": "$<c:out value="${subdept.name}" />"}
		<c:if test="${loop.last}">
			<c:set var="count" value="${loop.count}" />
		</c:if>
	</c:forEach>
</c:if>

<c:if test="${not empty deptList}">
	<c:if test="${count > 0}">,</c:if>		
	<c:forEach var="dept" items="${deptList}" varStatus="loop">
		<c:if test="${IS_ENGLISH}">
			<c:if test="${not empty dept.nameEng}">
				<c:set target="${dept}" property="name" value="${dept.nameEng}" />
			</c:if>
		</c:if>
		<c:if test="${loop.count > 1}">,</c:if>
		{"uniqueID": "$<c:out value="${dept.ID}" />", "name": "$<c:out value="${dept.name}" />"}
	</c:forEach>
</c:if>
]
