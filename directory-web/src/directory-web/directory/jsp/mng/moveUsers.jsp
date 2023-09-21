<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.userMng.move" /> -->
</head>
<body>
	<input type="hidden" id="directory-moveUsers-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.move.confirm" />" />
	<input type="hidden" id="directory-moveUsers-userMoved" value="<fmt:message bundle="${messages_directory}" key="directory.move.userMoved" />" />
	<input type="hidden" id="directory-moveUsers-noUser" value="<fmt:message bundle="${messages_directory}" key="directory.move.noUser" />" />
	<input type="hidden" id="directory-moveUsers-selectTargetDept" value="<fmt:message bundle="${messages_directory}" key="directory.move.selectTargetDept" />" />
	<input type="hidden" id="directory-moveUsers-toSelfError" value="<fmt:message bundle="${messages_directory}" key="directory.move.toSelfError" />" />
	<input type="hidden" id="directory-moveUsers-toDeletedDeptError" value="<fmt:message bundle="${messages_directory}" key="directory.move.toDeletedDeptError.user" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.userMng.move" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_history.back();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.moveUsers('<c:out value="${param.deptID}" />', '<c:out value="${param.userIDs}" />');"><fmt:message bundle="${messages_directory}" key="directory.move" /></a></span></li>
		</ul>
	</div>
	<!-- button : end -->
	<div style="padding: 5px;">
		<!-- table : start -->
		<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
			<col width="17%">
			<col width="">
			<tbody>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.move.currentDeptName" /></th>
					<td>
						<c:set var="deptName" value="${dept.name}" />
						<c:if test="${IS_ENGLISH}">
							<c:if test="${not empty dept.nameEng}">
								<c:set var="deptName" value="${dept.nameEng}" />
							</c:if>
						</c:if>
						<c:out value="${deptName}" />
					</td>
				</tr>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.move.movingToDeptName" /></th>
					<td>
						<input type="hidden" id="directory-moveUsers-targetDeptID" />
						<input type="text" class="intxt" style="width: 35.8%;" id="directory-moveUsers-targetDeptName" readonly="readonly" onfocus="blur();" />
						<fmt:message bundle="${messages_directory}" key="directory.move.selectTargetDeptFromTree" />
					</td>
				</tr>
			</tbody>
		</table>
		<!-- table : end -->
	</div>
	<!-- table : start -->
	<table class="content_lst no_btn" border="0" cellspacing="0" cellpadding="0">
		<col width="150px">
		<col width="150px">
		<col width="150px">
		<col width="150px">
		<col width="">
		<tr>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.positionName" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.userName" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.userNameEng" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.empCode" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.en_email" /></th>
		</tr>
		<tbody>
		<c:set var="count" value="0" scope="page" />
		<c:forEach var="user" items="${userList}" varStatus="loop">
			<c:if test="${IS_ENGLISH}">
				<c:if test="${not empty user.positionNameEng}">
					<c:set target="${user}" property="positionName" value="${user.positionNameEng}" />
				</c:if>
			</c:if>
			<tr>
				<td title="<c:out value="${user.positionName}" />"><c:out value="${user.positionName}" /></td>
				<td title="<c:out value="${user.name}" />"><c:out value="${user.name}" /></td>
				<td title="<c:out value="${user.nameEng}" />"><c:out value="${user.nameEng}" /></td>
				<td title="<c:out value="${user.empCode}" />"><c:out value="${user.empCode}" /></td>
				<td title="<c:out value="${user.email}" />"><c:out value="${user.email}" /></td>
			</tr>
			<c:if test="${loop.last}">
				<c:set var="count" value="${loop.count}" />
			</c:if>
		</c:forEach>
		</tbody>
	</table>
	<!-- table : end -->
	<div class="paginate_area"></div>
</body>
</html>