<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.communityMng.view" /> -->
</head>
<body>
	<input type="hidden" id="directory-approveCommunityRequest-success" value="<fmt:message bundle="${messages_directory}" key="directory.add.communityRequestApproved" />" />

	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.communityMng.request.view" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_history.back(2);"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<c:choose>
				<c:when test="${communityRequest.status == 0}">
					<li><span><a href="#" onclick="javascript:directory_orgMng.approveCommunityRequest('${communityRequest.communityRequestID}');"><fmt:message bundle="${messages_directory}" key="directory.communityMng.approval" /></a></span></li>
				</c:when>
				<c:when test="${communityRequest.status == 1}">
					<li><span><a href="#" onclick="javascript:directory_orgMng.viewCommunity('${communityRequest.communityID}');"><fmt:message bundle="${messages_directory}" key="directory.communityMng.view" /></a></span></li>
				</c:when>
			</c:choose>
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
								<th><fmt:message bundle="${messages_directory}" key="directory.communityRequest.companyName" /></th>
								<td><c:out value="${communityRequest.companyName}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityRequest.companyNameEng" /></th>
								<td><c:out value="${communityRequest.companyNameEng}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityRequest.companyType" /></th>
								<td><c:out value="${communityRequest.companyType}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityRequest.managerName" /></th>
								<td><c:out value="${communityRequest.managerName}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityRequest.userCount" /></th>
								<td><c:out value="${communityRequest.userCount}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityRequest.serviceMonths" /></th>
								<td><c:out value="${communityRequest.serviceMonths}" /></td>
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
								<th><fmt:message bundle="${messages_directory}" key="directory.communityRequest.email" /></th>
								<td><c:out value="${communityRequest.email}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityRequest.phone" /></th>
								<td><c:out value="${communityRequest.phone}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityRequest.mobilePhone" /></th>
								<td><c:out value="${communityRequest.mobilePhone}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityRequest.domain" /></th>
								<td><c:out value="${communityRequest.domain}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityDefaultLocale" /></th>
								<td><fmt:message bundle="${messages_directory}" key="directory.lang.${communityRequest.defaultLocale}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityRequest.status" /></th>
								<c:choose>
									<c:when test="${communityRequest.status == 1}">
										<td><fmt:message bundle="${messages_directory}" key="directory.communityMng.status.approved" /></td>
									</c:when>
									<c:when test="${communityRequest.status == 2}">
										<td><fmt:message bundle="${messages_directory}" key="directory.communityMng.status.expired" /></td>
									</c:when>
									<c:otherwise>
										<td><fmt:message bundle="${messages_directory}" key="directory.communityMng.status.requested" /></td>
									</c:otherwise>
								</c:choose>
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