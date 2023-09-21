<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

<ul class="picz_lst">
<c:forEach var="user" items="${memberList}" varStatus="loop">
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
	<li>
		<a href="#" onclick="show_user_info('<c:out value="${user.ID}" />', event);" class="pic" title="<c:out value="${user.name}" /> <c:out value="${user.positionName}" />">
		<c:if test="${not empty user.pictureURL}">
			<img src="<c:out value="${CONTEXT}${user.pictureURL}" />" align="absmiddle" border="0" width="35" height="35" />
		</c:if>
		</a>
		<a href="#" onclick="show_user_info('<c:out value="${user.ID}" />', event);" class="" title="<c:out value="${user.name}" /> <c:out value="${user.positionName}" />"><c:out value="${user.name}" /></a>
	</li>
</c:forEach>
</ul>
