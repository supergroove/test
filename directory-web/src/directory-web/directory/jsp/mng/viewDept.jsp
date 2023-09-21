<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.deptMng" /> -->
	
	<script type="text/javascript">
		function directory_viewDept_onLoad() {
			<c:if test="${dept == null}">
				directory_history.removeAll(); // history remove all
			</c:if>
			if (directory_history.size() < 2) {
				$("#directory-viewDept-historyBack").hide();
			}
		}
	</script>
</head>
<body onload="directory_viewDept_onLoad()">
	<input type="hidden" id="directory-deleteDept-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-deleteDept-deptDeleted" value="<fmt:message bundle="${messages_directory}" key="directory.delete.deptDeleted" />" />
	<input type="hidden" id="directory-deleteDept-deptWithChildError" value="<fmt:message bundle="${messages_directory}" key="directory.delete.deptWithChildError" />" />
	<input type="hidden" id="directory-repairDept-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.repair.confirm" />" />
	<input type="hidden" id="directory-repairDept-repaired" value="<fmt:message bundle="${messages_directory}" key="directory.repair.repaired" />" />
	
<c:if test="${dept != null}">
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.deptMng" /></div>
		<ul class="btns">
			<li id="directory-viewDept-historyBack"><span><a href="#" onclick="javascript:directory_history.back(2);"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
		<c:if test="${dept.status != '4'}">
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewAddDept('<c:out value="${dept.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewUpdateDept('<c:out value="${dept.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewMoveDept('<c:out value="${dept.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.move" /></a></span></li>
		<!--
			<li><span><a href="#" onclick="javascript:;"><fmt:message bundle="${messages_directory}" key="directory.detail" /></a></span></li>
		-->
		</c:if>
			<li><span><a href="#" onclick="javascript:directory_orgMng.deleteDept('<c:out value="${dept.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
		<c:if test="${dept.status == '4'}">
			<li><span><a href="#" onclick="javascript:directory_orgMng.repairDept('<c:out value="${dept.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.repair" /></a></span></li>
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
								<th><fmt:message bundle="${messages_directory}" key="directory.deptName" /></th>
								<td><c:out value="${dept.name}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.deptNameEng" /></th>
								<td><c:out value="${dept.nameEng}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.deptCode" /></th>
								<td><c:out value="${dept.deptCode}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.auth" /></th>
								<td>
								<c:forEach var="auth" items="${authes}">
									<c:if test="${auth.type == 3}">
										<c:set var="isChecked" value="" />
										<c:forEach var="userauth" items="${userAuthes}">
											<c:if test="${auth.code == userauth.auth && userauth.userID == dept.ID && userauth.relID == dept.ID}">
												<c:set var="isChecked" value="checked=\"checked\"" />
											</c:if>
										</c:forEach>
										<span class="inp_raochk"><input type="checkbox" disabled="disabled" value="<c:out value="${dept.ID}" />" <c:out value="${isChecked}" /> /><c:out value="${auth.name}" /></span><br />
									</c:if>
								</c:forEach>
								</td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.currentStatus" /></th>
								<td>
								<c:choose>
									<c:when test="${dept.status == '1'}"><fmt:message bundle="${messages_directory}" key="directory.normal" /></c:when>
									<c:when test="${dept.status == '4'}"><fmt:message bundle="${messages_directory}" key="directory.deleted" /></c:when>
									<c:when test="${dept.status == '8'}"><fmt:message bundle="${messages_directory}" key="directory.hidden" /></c:when>
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
						<c:forEach var="auth" items="${authes}">
							<c:if test="${auth.type != 3}">
							<tr>
								<th><c:out value="${auth.name}" /></th>
								<td>
								<c:forEach var="userauth" items="${userAuthes}">
									<c:if test="${auth.code == userauth.auth}">
										<c:if test="${IS_ENGLISH}">
											<c:if test="${not empty userMap[userauth.userID].nameEng}">
												<c:set target="${userMap[userauth.userID]}" property="name" value="${userMap[userauth.userID].nameEng}" />
											</c:if>
										</c:if>
										<a href="#" onclick="javascript:directory_orgMng.viewUser('<c:out value="${userauth.userID}" />');"><c:out value="${userMap[userauth.userID].name}" /></a>;
									</c:if>
								</c:forEach>
								</td>
							</tr>
							</c:if>
						</c:forEach>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.en_email" /></th>
								<td><c:out value="${dept.email}" /></td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
		</table>
		<!-- table : end -->
	</div>
</c:if>
<c:if test="${dept == null}">
	<div style="padding: 5px;">
		<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="cen"><fmt:message bundle="${messages_directory}" key="directory.error.notExistDept" /></td>
			</tr>
		</table>
	</div>
</c:if>
</body>
</html>