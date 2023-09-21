<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.communityMng.request" /> -->
	
	<script type="text/javascript" type="text/javascript">
		function directory_listCommunityRequests_onLoad() {
		}
	</script>
</head>
<body onload="directory_listCommunityRequests_onLoad()">
	<!-- button : start -->
	<div class="btn_area with_tab">
		<c:choose>
			<c:when test="${param.status == 'approved'}">
				<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.communityMng.request.approval" /></div>
			</c:when>
			<c:when test="${param.status == 'expired'}">
				<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.communityMng.request.expiry" /></div>
			</c:when>
			<c:otherwise>
				<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.communityMng.request" /></div>
			</c:otherwise>
		</c:choose>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_history.back(2);"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
		</ul>
	</div>
	<!-- button : end -->
	<!-- table : start -->
	<table class="content_lst" border="0" cellspacing="0" cellpadding="0">
		<col width="">
		<col width="">
		<col width="">
		<col width="100px">
		<col width="120px">
		<c:choose>
			<c:when test="${param.status == 'approved' || param.status == 'expired'}">
				<col width="120px">
				<col width="120px">
			</c:when>
			<c:otherwise>
				<col width="100px">
			</c:otherwise>
		</c:choose>
		<col width="120px">
		<tr>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityRequest.companyName" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityRequest.companyNameEng" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityRequest.managerName" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityRequest.userCount" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityRequest.requestDate" /></th>
			<c:choose>
				<c:when test="${param.status == 'approved' || param.status == 'expired'}">
					<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityRequest.approvedDate" /></th>
					<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityRequest.expiredDate" /></th>
				</c:when>
				<c:otherwise>
					<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityRequest.serviceMonths" /></th>
				</c:otherwise>
			</c:choose>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityDefaultLocale" /></th>
		</tr>
		<tbody>
		<c:forEach var="communityRequest" items="${communityRequestList}">
			<tr>
				<td title="<c:out value="${communityRequest.companyName}" />"><a href="#" onclick="javascript:directory_orgMng.viewCommunityRequest('<c:out value="${communityRequest.communityRequestID}" />');"><c:out value="${communityRequest.companyName}" /></a></td>
				<td title="<c:out value="${communityRequest.companyNameEng}" />"><a href="#" onclick="javascript:directory_orgMng.viewCommunityRequest('<c:out value="${communityRequest.communityRequestID}" />');"><c:out value="${communityRequest.companyNameEng}" /></td>
				<td title="<c:out value="${communityRequest.managerName}" />"><c:out value="${communityRequest.managerName}" /></td>
				<td title="<c:out value="${communityRequest.userCount}" />"><c:out value="${communityRequest.userCount}" /></td>
				<td title="<fmt:formatDate value="${communityRequest.requestDate}" pattern="yyyy.MM.dd" />"><fmt:formatDate value="${communityRequest.requestDate}" pattern="yyyy.MM.dd" /></td>
				<c:choose>
					<c:when test="${param.status == 'approved' || param.status == 'expired'}">
						<td title="<fmt:formatDate value="${communityRequest.approvedDate}" pattern="yyyy.MM.dd" />"><fmt:formatDate value="${communityRequest.approvedDate}" pattern="yyyy.MM.dd" /></td>
						<td title="<fmt:formatDate value="${communityRequest.expiredDate}" pattern="yyyy.MM.dd" />"><fmt:formatDate value="${communityRequest.expiredDate}" pattern="yyyy.MM.dd" /></td>
					</c:when>
					<c:otherwise>
						<td title="<c:out value="${communityRequest.serviceMonths}" />"><c:out value="${communityRequest.serviceMonths}" /></td>
					</c:otherwise>
				</c:choose>
				<td title="<fmt:message bundle="${messages_directory}" key="directory.lang.${communityRequest.defaultLocale}" />"><fmt:message bundle="${messages_directory}" key="directory.lang.${communityRequest.defaultLocale}" /></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<!-- table : end -->
	<div class="paginate_area"></div>
</body>
</html>