<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupMng" /> -->
	
<c:if test="${not empty detailUserSrc}">
	<script type="text/javascript" src="<c:out value="${detailUserSrc}" />"></script>
</c:if>
	
	<script type="text/javascript">
		function directory_viewDirGroup_onLoad() {
			<c:if test="${group == null && empty hirID}">
				directory_history.removeAll(); // history remove all
			</c:if>
			if (directory_history.size() < 2) {
				$("#directory-viewDirGroup-historyBack").hide();
			}
		}
		
		function directory_viewDirGroup_viewUserSpec(userID, event) {
		<c:choose>
		<c:when test="${not empty detailUserCmd}">
			<c:out value="${detailUserCmd}" />;
		</c:when>
		<c:otherwise>
			directory_orgView.viewUserSpec(userID);
		</c:otherwise>
		</c:choose>
		}
	</script>
</head>
<body onload="directory_viewDirGroup_onLoad()">
	<input type="hidden" id="directory-deleteDirGroup-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-deleteDirGroup-deleted" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupMng.deleted" />" />
	<input type="hidden" id="directory-deleteDirGroup-notDeleteGroupWithChild" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.error.notDeleteGroupWithChild" />" />
	
<c:if test="${group != null}">
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupMng" /></div>
		<ul class="btns">
			<li id="directory-viewDirGroup-historyBack"><span><a href="#" onclick="javascript:directory_history.back(2);"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewAddDirGroup('<c:out value="${group.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewUpdateDirGroup('<c:out value="${group.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
			<!--li><span><a href="#" onclick="javascript:directory_orgMng.viewMoveDirGroup('<c:out value="${group.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.move" /></a></span></li-->
			<li><span><a href="#" onclick="javascript:directory_orgMng.deleteDirGroup('<c:out value="${group.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
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
								<th><fmt:message bundle="${messages_directory}" key="directory.dirGroup.hir" /></th>
								<td><c:out value="${hir.name}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupName" /></th>
								<td><c:out value="${group.name}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.currentStatus" /></th>
								<td>
								<c:choose>
									<c:when test="${group.status == '1'}"><fmt:message bundle="${messages_directory}" key="directory.normal" /></c:when>
									<c:when test="${group.status == '8'}"><fmt:message bundle="${messages_directory}" key="directory.hidden" /></c:when>
									<c:otherwise><fmt:message bundle="${messages_directory}" key="directory.unknownStatus" /></c:otherwise>
								</c:choose>
								</td>
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
								<th><fmt:message bundle="${messages_directory}" key="directory.user" />&nbsp;<fmt:message bundle="${messages_directory}" key="directory.list" /></th>
								<td>
								<c:forEach var="member" items="${memberList}">
									<c:if test="${IS_ENGLISH}">
										<c:if test="${not empty member.nameEng}">
											<c:set target="${member}" property="name" value="${member.nameEng}" />
										</c:if>
									</c:if>
									<a href="#" onclick="javascript:directory_viewDirGroup_viewUserSpec('<c:out value="${member.ID}" />', event);"><c:out value="${member.name}" /></a><br />
								</c:forEach>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
		</table>
		<!-- table : end -->
	</div>
</c:if>
<c:if test="${group == null}">
	<c:if test="${not empty hirID}">
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupMng" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewAddDirGroup('<c:out value="${hirID}" />');"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
		</ul>
	</div>
	</c:if>
	<!-- button : end -->
	<div style="padding: 5px;">
		<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="cen"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.error.notExistGroup" /></td>
			</tr>
		</table>
	</div>
</c:if>
</body>
</html>