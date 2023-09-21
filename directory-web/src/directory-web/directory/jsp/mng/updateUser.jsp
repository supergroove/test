<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.userMng.update" /> -->
	
	<script type="text/javascript">
		function directory_updateUser_onLoad() {
			$("#directory-updateUser-positionID").change(function() {
				var secLevel = $("#directory-updateUser-positionSecLevel" + $(this).val()).val();
				$("#directory-updateUser-secLevel").val(secLevel);
			});
			$("input[name='directory-updateUser-loginPassword-update']").click(function() {
				if ($(this).is(":checked")) {
					var loginPassword = $("#directory-updateUser-loginPassword");
					var loginPasswordConfirm = $("#directory-updateUser-loginPasswordConfirm");
					
					if ($(this).val() == "0") {
						loginPassword.attr("disabled", true);
						loginPasswordConfirm.attr("disabled", true);
						loginPassword.val("");
						loginPasswordConfirm.val("");
					} else {
						loginPassword.attr("disabled", false);
						loginPasswordConfirm.attr("disabled", false);
					}
				}
			});
		}
		
		var directory = null; // required - must exist "directory" variable
		
		function directory_updateUser_openPopup(objID, objName, isMulti, notUseUser) {
			directory = $("#directory").directorypopup({
				context:		DIRECTORY_CONTEXT,
				checkbox:		"list",
				selectMode:		isMulti ? 2 : 1,		// 1:single, 2:multi
				notUseUser: notUseUser
			});
			
			var to = "";
			var idArr = objID.val().split(/[,;]/);
			var nameArr = objName.val().split(/[,;]/);
			for (var i = 0; i < idArr.length; i++) {
				if ($.trim(idArr[i])) {
					to += $.trim(idArr[i]) + "|" + $.trim(nameArr[i]) + ";";
				}
			}
			directory.init(to);
			
			directory.set(objName.val());
			directory.open(function(toList) {
				objID.val(toList.toString("id"));
				objName.val(toList.toString("name"));
			});
		}
	</script>
</head>
<body onload="directory_updateUser_onLoad()">
	<div id="directory"></div> <!-- required - must exist "div" element -->
	
	<input type="hidden" id="directory-updateUser-isEmailRequired" value="<c:out value="${isEmailRequired}"/>" />
	<input type="hidden" id="directory-updateUser-allowPeriodInUsername" value="<c:out value="${allowPeriodInUsername}"/>" />
	
	<input type="hidden" id="directory-updateUser-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.update.confirm" />" />
	<input type="hidden" id="directory-updateUser-userUpdated" value="<fmt:message bundle="${messages_directory}" key="directory.update.userUpdated" />" />
	<input type="hidden" id="directory-updateUser-inputUserName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputUserName" />" />
	<input type="hidden" id="directory-updateUser-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-updateUser-invalidCharacterError-1" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError.1" />" />
	<input type="hidden" id="directory-updateUser-includePeriodInvalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.username.include.period.invalidCharacterError" />" />
	<input type="hidden" id="directory-updateUser-invalidEmailError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidEmailError" />" />
	<input type="hidden" id="directory-updateUser-selectPosition" value="<fmt:message bundle="${messages_directory}" key="directory.add.selectPosition" />" />
	<input type="hidden" id="directory-updateUser-invalidSecLevel" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidSecLevel" />" />
	<input type="hidden" id="directory-updateUser-inputLoginPassword" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputLoginPassword" />" />
	<input type="hidden" id="directory-updateUser-inputLoginPasswordConfirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputLoginPasswordConfirm" />" />
	<input type="hidden" id="directory-updateUser-incorrectLoginPasswordConfirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.incorrectLoginPasswordConfirm" />" />
	<input type="hidden" id="directory-updateUser-invalidExpiryDate" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidExpiryDate" />" />
	<input type="hidden" id="directory-updateUser-dupEmpCode" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupEmpCode" />" />
	<input type="hidden" id="directory-updateUser-dupLoginID" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupLoginID" />" />
	<input type="hidden" id="directory-updateUser-dupEmail" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupEmail" />" />
	<input type="hidden" id="directory-updateUser-notAuthorizedUser" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.5006.notAuthorizedUser" />" />
	<input type="hidden" id="directory-updateUser-invalidPhoneRuleID" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidPhoneRuleID" />" />
	<input type="hidden" id="directory-updateUser-invalidMailCapacity" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidMailCapacity" />" />
	<input type="hidden" id="directory-updateUser-deleteAdminError" value="<fmt:message bundle="${messages_directory}" key="directory.update.deleteAdminError" />" />
	<input type="hidden" id="directory-updateUser-invalidCloudfolderCapacity" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCloudfolderCapacity" />" />
	
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-maxLength2" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength2" />" />
	<input type="hidden" id="directory-userName" value="<fmt:message bundle="${messages_directory}" key="directory.userName" />" />
	<input type="hidden" id="directory-userNameEng" value="<fmt:message bundle="${messages_directory}" key="directory.userNameEng" />" />
	<input type="hidden" id="directory-empCode" value="<fmt:message bundle="${messages_directory}" key="directory.empCode" />" />
	<input type="hidden" id="directory-loginID" value="<fmt:message bundle="${messages_directory}" key="directory.loginID" />" />
	<input type="hidden" id="directory-loginPassword" value="<fmt:message bundle="${messages_directory}" key="directory.loginPassword" />" />
	<input type="hidden" id="directory-email" value="<fmt:message bundle="${messages_directory}" key="directory.en_email" />" />
	<input type="hidden" id="directory-phone" value="<fmt:message bundle="${messages_directory}" key="directory.phone" />" />
	<input type="hidden" id="directory-mobilePhone" value="<fmt:message bundle="${messages_directory}" key="directory.mobilePhone" />" />
	<input type="hidden" id="directory-fax" value="<fmt:message bundle="${messages_directory}" key="directory.fax" />" />
	<input type="hidden" id="directory-clientIPAddr" value="<fmt:message bundle="${messages_directory}" key="directory.clientIPAddr" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.userMng.update" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_history.back();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.updateUser('<c:out value="${user.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
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
								<th><fmt:message bundle="${messages_directory}" key="directory.userName" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-updateUser-userName" maxlength="120" value="<c:out value="${user.name}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.userNameEng" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="2" id="directory-updateUser-userNameEng" maxlength="120" value="<c:out value="${user.nameEng}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.empCode" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="3" id="directory-updateUser-empCode" maxlength="40" value="<c:out value="${user.empCode}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.position" /></th>
								<td>
									<select tabindex="4" id="directory-updateUser-positionID">
										<option value="" selected="selected"><fmt:message bundle="${messages_directory}" key="directory.selectMsg" /></option>
									<c:forEach var="position" items="${positionList}">
										<c:if test="${IS_ENGLISH}">
											<c:if test="${not empty position.nameEng}">
												<c:set target="${position}" property="name" value="${position.nameEng}" />
											</c:if>
										</c:if>
										<option value="<c:out value="${position.ID}" />" <c:if test="${position.ID == user.positionID}">selected="selected"</c:if>><c:out value="${position.name}" /></option>
									</c:forEach>
									</select>
									<c:forEach var="position" items="${positionList}">
										<input type="hidden" id="directory-updateUser-positionSecLevel<c:out value="${position.ID}" />" value="<c:out value="${position.securityLevel}" />" />
									</c:forEach>
								</td>
							</tr>
						<c:if test="${useRank}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.rank" /></th>
								<td>
									<select tabindex="4" id="directory-updateUser-rankID">
										<option value="" selected="selected"><fmt:message bundle="${messages_directory}" key="directory.selectMsg" /></option>
									<c:forEach var="rank" items="${rankList}">
										<c:if test="${IS_ENGLISH}">
											<c:if test="${not empty rank.nameEng}">
												<c:set target="${rank}" property="name" value="${rank.nameEng}" />
											</c:if>
										</c:if>
										<option value="<c:out value="${rank.ID}" />" <c:if test="${rank.ID == user.rankID}">selected="selected"</c:if>><c:out value="${rank.name}" /></option>
									</c:forEach>
									</select>
								</td>
							</tr>
						</c:if>
						<c:if test="${useDuty}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.duty" /></th>
								<td>
									<select tabindex="4" id="directory-updateUser-dutyID">
										<option value="" selected="selected"><fmt:message bundle="${messages_directory}" key="directory.selectMsg" /></option>
									<c:forEach var="duty" items="${dutyList}">
										<option value="<c:out value="${duty.ID}" />" <c:if test="${duty.ID == user.dutyID}">selected="selected"</c:if>><c:out value="${duty.name}" /></option>
									</c:forEach>
									</select>
								</td>
							</tr>
						</c:if>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.secLevel" /></th>
								<td><input type="text" class="intxt" style="width: 60%;" tabindex="5" id="directory-updateUser-secLevel" maxlength="2" value="<c:out value="${user.securityLevel}" />" /> ex) 0 ~ 99</td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.loginID" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="6" id="directory-updateUser-loginID" maxlength="20" value="<c:out value="${user.loginID}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.loginPassword" /></th>
								<td>
									<span class="inp_raochk"><input type="radio" tabindex="7" name="directory-updateUser-loginPassword-update" value="0" checked="checked"><fmt:message bundle="${messages_directory}" key="directory.notUpdate" /></span>
									<span class="inp_raochk"><input type="radio" tabindex="7" name="directory-updateUser-loginPassword-update" value="1"><fmt:message bundle="${messages_directory}" key="directory.update" /></span><br />
									<input type="password" class="intxt" style="width: 95.8%;" tabindex="8" id="directory-updateUser-loginPassword" maxlength="15" disabled="disabled" /><br />
									<input type="password" class="intxt" style="width: 95.8%;" tabindex="9" id="directory-updateUser-loginPasswordConfirm" maxlength="15" disabled="disabled" />
								</td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.loginLock" /></th>
								<td>
									<span class="inp_raochk"><input type="radio" tabindex="10" name="directory-updateUser-loginLock" value="0" <c:if test="${!user.lock}">checked="checked"</c:if>><fmt:message bundle="${messages_directory}" key="directory.loginLock.unlock" /></span>
									<span class="inp_raochk"><input type="radio" tabindex="10" name="directory-updateUser-loginLock" value="1" <c:if test="${user.lock}">checked="checked"</c:if>><fmt:message bundle="${messages_directory}" key="directory.loginLock.lock" /></span>
								</td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.expiryDate" /></th>
								<td><input type="text" class="intxt" style="width: 60%;" tabindex="11" id="directory-updateUser-expiryDate" maxlength="10" value="<fmt:formatDate value="${user.expireDate}" pattern="yyyy.MM.dd" />" /> ex) 2012.12.31</td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.status" /></th>
								<td>
									<select tabindex="12" id="directory-updateUser-userStatus">
										<option value="1" <c:if test="${user.status == '1'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.normal" /></option>
										<option value="8" <c:if test="${user.status == '8'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.hidden" /></option>
									</select>
								</td>
							</tr>
						<c:if test="${useUC}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.phoneRuleID" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="25" id="directory-updateUser-phoneRuleID" maxlength="1" value="<c:out value="${user.phoneRuleID}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.extPhone" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="25" id="directory-updateUser-extPhone" maxlength="10" value="<c:out value="${user.extPhone}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.extPhoneHead" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="25" id="directory-updateUser-extPhoneHead" maxlength="10" value="<c:out value="${user.extPhoneHead}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.extPhoneExch" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="25" id="directory-updateUser-extPhoneExch" maxlength="10" value="<c:out value="${user.extPhoneExch}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.phyPhone" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="25" id="directory-updateUser-phyPhone" maxlength="10" value="<c:out value="${user.phyPhone}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.fwdPhone" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="25" id="directory-updateUser-fwdPhone" maxlength="10" value="<c:out value="${user.fwdPhone}" />" /></td>
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
								<td>
									<c:set var="deptName" value="${user.deptName}" />
									<c:if test="${IS_ENGLISH}">
										<c:if test="${not empty user.deptNameEng}">
											<c:set var="deptName" value="${user.deptNameEng}" />
										</c:if>
									</c:if>
									<c:out value="${deptName}" />
								</td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.en_email" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="12" id="directory-updateUser-email" maxlength="128" value="<c:out value="${user.email}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.phone" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="13" id="directory-updateUser-phone" maxlength="40" value="<c:out value="${user.phone}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.mobilePhone" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="14" id="directory-updateUser-mobilePhone" maxlength="40" value="<c:out value="${user.mobilePhone}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.fax" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="15" id="directory-updateUser-fax" maxlength="40" value="<c:out value="${user.fax}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.clientIPAddr" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="16" id="directory-updateUser-clientIPAddr" maxlength="64" value="<c:out value="${user.clientIPAddr}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.auth" /></th>
								<td>
								<c:forEach var="auth" items="${authes}" varStatus="status">
									<c:if test="${auth.type == 0}">
										<c:set var="isChecked" value="" />
										<c:forEach var="userauth" items="${userAuthes}">
											<c:if test="${auth.code == userauth.auth && userauth.userID == user.ID && userauth.relID == user.ID}">
												<c:set var="isChecked" value="checked=\"checked\"" />
											</c:if>
										</c:forEach>
										<span class="inp_raochk"><input type="checkbox" tabindex="17" id="directory-updateUser-relID-<c:out value="${auth.code}" />" value="<c:out value="${user.ID}" />" <c:out value="${isChecked}" /> <c:if test="${auth.code == 'ADM' && !isAdmin}">disabled="disabled"</c:if> /><c:out value="${auth.name}" /></span><br/>
									</c:if>
								</c:forEach>
								</td>
							</tr>
						<c:forEach var="auth" items="${authes}" varStatus="status">
							<c:if test="${auth.type == 1}">
							<tr>
								<th class="btntitle">
									<a href="#" onclick="javascript:directory_updateUser_openPopup($('#directory-updateUser-relID-<c:out value="${auth.code}" />'), $('#directory-updateUser-relName-<c:out value="${auth.code}" />'), <c:out value="${auth.multi}" />, '<c:out value="${user.ID}" />');"><c:out value="${auth.name}" /><span class="arr_r"></span></a>
								</th>
								<td>
									<c:set var="relIDs" value="" />
									<c:set var="relNames" value="" />
									<c:forEach var="userauth" items="${userAuthes}">
										<c:if test="${auth.code == userauth.auth}">
											<c:if test="${IS_ENGLISH}">
												<c:if test="${not empty userMap[userauth.relID].nameEng}">
													<c:set target="${userMap[userauth.relID]}" property="name" value="${userMap[userauth.relID].nameEng}" />
												</c:if>
											</c:if>
											<c:set var="relIDs" value="${userauth.relID};${relIDs}" />
											<c:set var="relNames" value="${userMap[userauth.relID].name};${relNames}" />
										</c:if>
									</c:forEach>
									<input type="hidden" id="directory-updateUser-relID-<c:out value="${auth.code}" />" value="<c:out value="${relIDs}" />" />
									<input type="text" class="intxt" style="width: 95.8%;" id="directory-updateUser-relName-<c:out value="${auth.code}" />" readonly="readonly" value="<c:out value="${relNames}" />" />
								</td>
							</tr>
							</c:if>
						</c:forEach>
						<c:if test="${useMail}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.mailCapacity" /></th>
								<td><input type="text" class="intxt" style="width: 60%;" id="directory-updateUser-capacity" maxlength="5" value="<c:out value="${user.capacity}" />" <c:if test="${!isAdmin}">disabled="disabled"</c:if> />&nbsp;MB</td>
							</tr>
						</c:if>
						<c:if test="${useCloudfolder}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.cloudfolderCapacity" /></th>
								<td><input type="text" class="intxt" style="width: 60%;" id="directory-updateUser-cloudfolderCapacity" maxlength="6" value="<c:out value="${user.cloudfolderCapacity}" />" <c:if test="${!isAdmin}">disabled="disabled"</c:if> />&nbsp;MB</td>
							</tr>
						</c:if>
						</tbody>
					</table>
				</td>
			</tr>
		</table>
		<!-- table : end -->
	</div>
</body>
</html>