<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.communityMng" /> -->
	
	<script type="text/javascript" type="text/javascript">
		function directory_listCommunities_onLoad() {
		}
	</script>
</head>
<body onload="directory_listCommunities_onLoad()">
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.communityMng" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewAddCommunity();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
			<c:if test="${useCommunityRequest}">
				<li><span><a href="#" onclick="javascript:directory_orgMng.listCommunityRequests('requested');"><fmt:message bundle="${messages_directory}" key="directory.request" /></a></span></li>
				<li><span><a href="#" onclick="javascript:directory_orgMng.listCommunityRequests('approved');"><fmt:message bundle="${messages_directory}" key="directory.approval" /></a></span></li>
				<li><span><a href="#" onclick="javascript:directory_orgMng.listCommunityRequests('expired');"><fmt:message bundle="${messages_directory}" key="directory.expiry" /></a></span></li>
			</c:if>
		</ul>
	</div>
	<!-- button : end -->
	<!-- table : start -->
	<table class="content_lst" border="0" cellspacing="0" cellpadding="0">
		<col width="100px">
		<col width="">
		<col width="">
		<col width="">
		<col width="110px">
		<col width="110px">
		<col width="110px">
		<col width="110px">
		<tr>
			<th scope="col" class="cen">ID</th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityName" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityAlias" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityManagerName" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityMaxUser" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityUserCount" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityExpiryDate" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.communityDefaultLocale" /></th>
		</tr>
		<tbody>
		<c:forEach var="community" items="${communityList}">
			<tr>
				<td title="<c:out value="${community.ID}" />"><c:out value="${community.ID}" /></td>
				<td title="<c:out value="${community.name}" />"><a href="#" onclick="javascript:directory_orgMng.viewCommunity('<c:out value="${community.ID}" />');"><c:out value="${community.name}" /></a></td>
				<td title="<c:out value="${community.alias}" />"><a href="#" onclick="javascript:directory_orgMng.viewCommunity('<c:out value="${community.ID}" />');"><c:out value="${community.alias}" /></a></td>
				<td title="<c:out value="${community.managerName}" />"><c:out value="${community.managerName}" /></td>
				<td title="<c:out value="${community.maxUser}" />"><c:out value="${community.maxUser}" /></td>
				<td title="<c:out value="${community.userCount}" />"><c:out value="${community.userCount}" /></td>
				<c:choose>
					<c:when test="${not empty community.expiryDate}">
						<td title="<fmt:formatDate value="${community.expiryDate}" pattern="yyyy.MM.dd" />"><fmt:formatDate value="${community.expiryDate}" pattern="yyyy.MM.dd" /></td>
					</c:when>
					<c:otherwise>
						<td title="<fmt:message bundle="${messages_directory}" key="directory.unlimited" />"><fmt:message bundle="${messages_directory}" key="directory.unlimited" /></td>
					</c:otherwise>
				</c:choose>
				<td title="<fmt:message bundle="${messages_directory}" key="directory.lang.${community.defaultLocale}" />"><fmt:message bundle="${messages_directory}" key="directory.lang.${community.defaultLocale}" /></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<!-- table : end -->
	<div class="paginate_area"></div>
</body>
</html>