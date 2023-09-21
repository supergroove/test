<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.userMng.view" /> -->
	
	<script type="text/javascript">
		function directory_viewUser_onLoad() {
			<c:if test="${user == null}">
				directory_history.removeAll(); // history remove all
			</c:if>
			if (directory_history.size() < 2) {
				$("#directory-viewUser-historyBack").hide();
			}
		}
	</script>
</head>
<body onload="directory_viewUser_onLoad()">
	<input type="hidden" id="directory-deleteUsers-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-deleteUsers-userDeleted" value="<fmt:message bundle="${messages_directory}" key="directory.delete.userDeleted" />" />
	<input type="hidden" id="directory-deleteUsers-deleteAdminError" value="<fmt:message bundle="${messages_directory}" key="directory.delete.deleteAdminError" />" />
	<input type="hidden" id="directory-repairUser-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.repair.confirm" />" />
	<input type="hidden" id="directory-repairUser-repaired" value="<fmt:message bundle="${messages_directory}" key="directory.repair.repaired" />" />
	
<c:if test="${user != null}">
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.userMng.view" /></div>
		<ul class="btns">
			<li id="directory-viewUser-historyBack"><span><a href="#" onclick="javascript:directory_history.back(2);"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
		<c:if test="${user.status != '4'}">
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewUpdateUser('<c:out value="${user.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewMoveUsers('<c:out value="${user.deptID}" />', '<c:out value="${user.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.move" /></a></span></li>
		</c:if>
			<li><span><a href="#" onclick="javascript:directory_orgMng.deleteUsers('<c:out value="${user.deptID}" />', '<c:out value="${user.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
		<c:if test="${user.status == '4'}">
			<li><span><a href="#" onclick="javascript:directory_orgMng.repairUser('<c:out value="${user.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.repair" /></a></span></li>
		</c:if>
		</ul>
	</div>
	<!-- button : end -->
	<div style="padding: 5px;">
		<c:if test="${IS_ENGLISH}">
			<c:if test="${not empty user.deptNameEng}">
				<c:set target="${user}" property="deptName" value="${user.deptNameEng}" />
			</c:if>
			<c:if test="${not empty user.positionNameEng}">
				<c:set target="${user}" property="positionName" value="${user.positionNameEng}" />
			</c:if>
			<c:if test="${not empty user.rankNameEng}">
				<c:set target="${user}" property="rankName" value="${user.rankNameEng}" />
			</c:if>
		</c:if>
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
								<th><fmt:message bundle="${messages_directory}" key="directory.userName" /></th>
								<td><c:out value="${user.name}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.userNameEng" /></th>
								<td><c:out value="${user.nameEng}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.empCode" /></th>
								<td><c:out value="${user.empCode}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.position" /></th>
								<td><c:out value="${user.positionName}" /></td>
							</tr>
						<c:if test="${useRank}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.rank" /></th>
								<td><c:out value="${user.rankName}" /></td>
							</tr>
						</c:if>
						<c:if test="${useDuty}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.duty" /></th>
								<td><c:out value="${user.dutyName}" /></td>
							</tr>
						</c:if>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.secLevel" /></th>
								<td><c:out value="${user.securityLevel}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.loginID" /></th>
								<td><c:out value="${user.loginID}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.loginLock" /></th>
								<td>
								<c:if test="${!user.lock}">
									<fmt:message bundle="${messages_directory}" key="directory.loginLock.unlock" />
								</c:if>
								<c:if test="${user.lock}">
									<fmt:message bundle="${messages_directory}" key="directory.loginLock.lock" />
								</c:if>
								</td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.expiryDate" /></th>
								<td><fmt:formatDate value="${user.expireDate}" pattern="yyyy.MM.dd" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.currentStatus" /></th>
								<td>
								<c:choose>
									<c:when test="${user.status == '1'}"><fmt:message bundle="${messages_directory}" key="directory.normal" /></c:when>
									<c:when test="${user.status == '4'}"><fmt:message bundle="${messages_directory}" key="directory.deleted" /></c:when>
									<c:when test="${user.status == '8'}"><fmt:message bundle="${messages_directory}" key="directory.hidden" /></c:when>
									<c:otherwise><fmt:message bundle="${messages_directory}" key="directory.unknownStatus" /></c:otherwise>
								</c:choose>
								</td>
							</tr>
						<c:if test="${useUC}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.phoneRuleID" /></th>
								<td><c:out value="${user.phoneRuleID}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.extPhone" /></th>
								<td><c:out value="${user.extPhone}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.extPhoneHead" /></th>
								<td><c:out value="${user.extPhoneHead}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.extPhoneExch" /></th>
								<td><c:out value="${user.extPhoneExch}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.phyPhone" /></th>
								<td><c:out value="${user.phyPhone}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.fwdPhone" /></th>
								<td><c:out value="${user.fwdPhone}" /></td>
							</tr>
						</c:if>
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
								<th><fmt:message bundle="${messages_directory}" key="directory.userDeptName" /></th>
								<td><a href="#" onclick="javascript:directory_orgMng.viewDept('<c:out value="${user.deptID}" />');"><c:out value="${user.deptName}" /></a></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.en_email" /></th>
								<td><c:out value="${user.email}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.phone" /></th>
								<td><c:out value="${user.phone}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.mobilePhone" /></th>
								<td><c:out value="${user.mobilePhone}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.fax" /></th>
								<td><c:out value="${user.fax}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.clientIPAddr" /></th>
								<td><c:out value="${user.clientIPAddr}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.auth" /></th>
								<td>
								<c:forEach var="auth" items="${authes}">
									<c:if test="${auth.type == 0}">
										<c:set var="isChecked" value="" />
										<c:forEach var="userauth" items="${userAuthes}">
											<c:if test="${auth.code == userauth.auth && userauth.userID == user.ID && userauth.relID == user.ID}">
												<c:set var="isChecked" value="checked=\"checked\"" />
											</c:if>
										</c:forEach>
										<span class="inp_raochk"><input type="checkbox" disabled="disabled" value="<c:out value="${user.ID}" />" <c:out value="${isChecked}" /> /><c:out value="${auth.name}" /></span><br />
									</c:if>
								</c:forEach>
								</td>
							</tr>
						<c:forEach var="auth" items="${authes}">
							<c:if test="${auth.type == 1}">
							<tr>
								<th><c:out value="${auth.name}" /></th>
								<td>
								<c:forEach var="userauth" items="${userAuthes}">
									<c:if test="${auth.code == userauth.auth}">
										<c:if test="${IS_ENGLISH}">
											<c:if test="${not empty userMap[userauth.relID].nameEng}">
												<c:set target="${userMap[userauth.relID]}" property="name" value="${userMap[userauth.relID].nameEng}" />
											</c:if>
										</c:if>
										<a href="#" onclick="javascript:directory_orgMng.viewUser('<c:out value="${userauth.relID}" />');"><c:out value="${userMap[userauth.relID].name}" /></a>;
									</c:if>
								</c:forEach>
								</td>
							</tr>
							</c:if>
						</c:forEach>
						<c:if test="${useMail}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.mailCapacity" /></th>
								<td><c:out value="${user.capacity}" />&nbsp;MB</td>
							</tr>
						</c:if>
						<c:if test="${useCloudfolder}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.cloudfolderCapacity" /></th>
								<td><c:out value="${user.cloudfolderCapacity}" />&nbsp;MB</td>
							</tr>
						</c:if>
						</tbody>
					</table>
				</td>
			</tr>
		</table>
		<!-- table : end -->
	</div>
</c:if>
<c:if test="${user == null}">
	<div style="padding: 5px;">
		<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="cen"><fmt:message bundle="${messages_directory}" key="directory.error.notExistUser" /></td>
			</tr>
		</table>
	</div>
</c:if>
</body>
</html>