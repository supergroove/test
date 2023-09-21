<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.communityMng.view" /> -->
</head>
<body>
	<input type="hidden" id="directory-deleteCommunity-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-deleteCommunity-success" value="<fmt:message bundle="${messages_directory}" key="directory.delete.communityDeleted" />" />
	<input type="hidden" id="directory-deleteCommunity-cannotDeleteInUse" value="<fmt:message bundle="${messages_directory}" key="directory.community.deleteCommunity.cannotDeleteInUse" />" />
	<input type="hidden" id="directory-resetDeptTree-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.community.resetDeptTree.confirm" />" />
	<input type="hidden" id="directory-resetDeptTree-success" value="<fmt:message bundle="${messages_directory}" key="directory.community.resetDeptTree.success" />" />
	<input type="hidden" id="directory-resetDirGroupTree-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.community.resetDirGroupTree.confirm" />" />
	<input type="hidden" id="directory-resetDirGroupTree-success" value="<fmt:message bundle="${messages_directory}" key="directory.community.resetDirGroupTree.success" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.communityMng.view" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_history.back(2);"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<c:if test="${editable}">
				<li><span><a href="#" onclick="javascript:directory_orgMng.viewUpdateCommunity('<c:out value="${community.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
			</c:if>
			<c:if test="${deletable}">
				<li><span><a href="#" onclick="javascript:directory_orgMng.deleteCommunity('<c:out value="${community.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
			</c:if>			
			<li><span><a href="#" onclick="javascript:directory_orgMng.resetDeptTree('<c:out value="${community.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.community.resetDeptTree" /></a></span></li>
		<c:if test="${useDirGroup}">
			<li><span><a href="#" onclick="javascript:directory_orgMng.resetDirGroupTree('<c:out value="${community.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.community.resetDirGroupTree" /></a></span></li>
		</c:if>
		</ul>
	</div>
	<!-- button : end -->
	<div style="padding: 5px;">
		<!-- table : start -->
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<col width="49%">
			<col width="5px">
			<col width="">
			<tr>
				<td valign="top">
					<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
						<col width="35%">
						<col width="65%">
						<tbody>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityName" /></th>
								<td><c:out value="${community.name}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityAlias" /></th>
								<td><c:out value="${community.alias}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityManagerName" /></th>
								<td><c:out value="${community.managerName}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityMaxUser" /></th>
								<td><c:out value="${community.maxUser}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityExpiryDate" /></th>
								<c:choose>
									<c:when test="${not empty community.expiryDate}">
										<td><fmt:formatDate value="${community.expiryDate}" pattern="yyyy.MM.dd" /></td>
									</c:when>
									<c:otherwise>
										<td><fmt:message bundle="${messages_directory}" key="directory.unlimited" /></td>
									</c:otherwise>
								</c:choose>
							</tr>
						</tbody>
					</table>
				</td>
				<td></td>
				<td valign="top">
					<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
						<col width="35%">
						<col width="65%">
						<tbody>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityPhone" /></th>
								<td><c:out value="${community.phone}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityFax" /></th>
								<td><c:out value="${community.fax}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityHomeUrl" /></th>
								<td><c:out value="${community.homeUrl}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityEmail" /></th>
								<td><c:out value="${community.email}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityDefaultLocale" /></th>
								<td><fmt:message bundle="${messages_directory}" key="directory.lang.${community.defaultLocale}" /></td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
		</table>
		<!-- table : end -->
	</div>
</body>
</html>