<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.userMng.add" /> -->
	
	<script type="text/javascript">
		function directory_addUser_onLoad() {
			$("#directory-addUser-positionID").change(function() {
				var secLevel = $("#directory-addUser-positionSecLevel" + $(this).val()).val();
				$("#directory-addUser-secLevel").val(secLevel);
			});
			$("input[name='directory-addUser-loginPassword-assign']").click(function() {
				if ($(this).is(":checked")) {
					var loginPassword = $("#directory-addUser-loginPassword");
					var loginPasswordConfirm = $("#directory-addUser-loginPasswordConfirm");
					
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
			
			$("#directory-addUser-userName").focus();
		}
		
		var directory = null; // required - must exist "directory" variable
		
		function directory_addUser_openPopup(objID, objName, isMulti) {
			directory = $("#directory").directorypopup({
				context:		DIRECTORY_CONTEXT,
				checkbox:		"list",
				selectMode:		isMulti ? 2 : 1		// 1:single, 2:multi
			});
			
			directory.set(objName.val());
			directory.open(function(toList) {
				objID.val(toList.toString("id"));
				objName.val(toList.toString("name"));
			});
		}
	</script>
</head>
<body onload="directory_addUser_onLoad()">
	<div id="directory"></div> <!-- required - must exist "div" element -->
	
	<input type="hidden" id="directory-addUser-isEmailRequired" value="<c:out value="${isEmailRequired}"/>" />
	<input type="hidden" id="directory-addUser-allowPeriodInUsername" value="<c:out value="${allowPeriodInUsername}"/>" />
	
	<input type="hidden" id="directory-addUser-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.confirm" />" />
	<input type="hidden" id="directory-addUser-userAdded" value="<fmt:message bundle="${messages_directory}" key="directory.add.userAdded" />" />
	<input type="hidden" id="directory-addUser-inputUserName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputUserName" />" />
	<input type="hidden" id="directory-addUser-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-addUser-invalidCharacterError-1" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError.1" />" />
	<input type="hidden" id="directory-addUser-includePeriodInvalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.username.include.period.invalidCharacterError" />" />
	<input type="hidden" id="directory-addUser-invalidEmailError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidEmailError" />" />
	<input type="hidden" id="directory-addUser-selectPosition" value="<fmt:message bundle="${messages_directory}" key="directory.add.selectPosition" />" />
	<input type="hidden" id="directory-addUser-invalidSecLevel" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidSecLevel" />" />
	<input type="hidden" id="directory-addUser-inputLoginPassword" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputLoginPassword" />" />
	<input type="hidden" id="directory-addUser-inputLoginPasswordConfirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputLoginPasswordConfirm" />" />
	<input type="hidden" id="directory-addUser-incorrectLoginPasswordConfirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.incorrectLoginPasswordConfirm" />" />
	<input type="hidden" id="directory-addUser-invalidExpiryDate" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidExpiryDate" />" />
	<input type="hidden" id="directory-addUser-dupEmpCode" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupEmpCode" />" />
	<input type="hidden" id="directory-addUser-dupLoginID" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupLoginID" />" />
	<input type="hidden" id="directory-addUser-dupEmail" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupEmail" />" />
	<input type="hidden" id="directory-addUser-notAuthorizedUser" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.5006.notAuthorizedUser" />" />
	<input type="hidden" id="directory-addUser-invalidPhoneRuleID" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidPhoneRuleID" />" />
	<input type="hidden" id="directory-addUser-invalidMailCapacity" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidMailCapacity" />" />
	<input type="hidden" id="directory-addUser-invalidCloudfolderCapacity" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCloudfolderCapacity" />" />
	
	
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
	<input type="hidden" id="directory-extPhone" value="<fmt:message bundle="${messages_directory}" key="directory.extPhone" />" />
	<input type="hidden" id="directory-extPhoneHead" value="<fmt:message bundle="${messages_directory}" key="directory.extPhoneHead" />" />
	<input type="hidden" id="directory-extPhoneExch" value="<fmt:message bundle="${messages_directory}" key="directory.extPhoneExch" />" />
	<input type="hidden" id="directory-phyPhone" value="<fmt:message bundle="${messages_directory}" key="directory.phyPhone" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.userMng.add" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_history.back();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.addUser('<c:out value="${dept.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
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
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-addUser-userName" maxlength="120" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.userNameEng" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="2" id="directory-addUser-userNameEng" maxlength="120" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.empCode" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="3" id="directory-addUser-empCode" maxlength="40" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.position" /></th>
								<td>
									<select tabindex="4" id="directory-addUser-positionID">
										<option value="" selected="selected"><fmt:message bundle="${messages_directory}" key="directory.selectMsg" /></option>
									<c:forEach var="position" items="${positionList}">
										<c:if test="${IS_ENGLISH}">
											<c:if test="${not empty position.nameEng}">
												<c:set target="${position}" property="name" value="${position.nameEng}" />
											</c:if>
										</c:if>
										<option value="<c:out value="${position.ID}" />"><c:out value="${position.name}" /></option>
									</c:forEach>
									</select>
									<c:forEach var="position" items="${positionList}">
										<input type="hidden" id="directory-addUser-positionSecLevel<c:out value="${position.ID}" />" value="<c:out value="${position.securityLevel}" />" />
									</c:forEach>
								</td>
							</tr>
						<c:if test="${useRank}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.rank" /></th>
								<td>
									<select tabindex="4" id="directory-addUser-rankID">
										<option value="" selected="selected"><fmt:message bundle="${messages_directory}" key="directory.selectMsg" /></option>
									<c:forEach var="rank" items="${rankList}">
										<c:if test="${IS_ENGLISH}">
											<c:if test="${not empty rank.nameEng}">
												<c:set target="${rank}" property="name" value="${rank.nameEng}" />
											</c:if>
										</c:if>
										<option value="<c:out value="${rank.ID}" />"><c:out value="${rank.name}" /></option>
									</c:forEach>
									</select>
								</td>
							</tr>
						</c:if>
						<c:if test="${useDuty}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.duty" /></th>
								<td>
									<select tabindex="4" id="directory-addUser-dutyID">
										<option value="" selected="selected"><fmt:message bundle="${messages_directory}" key="directory.selectMsg" /></option>
									<c:forEach var="duty" items="${dutyList}">
										<option value="<c:out value="${duty.ID}" />"><c:out value="${duty.name}" /></option>
									</c:forEach>
									</select>
								</td>
							</tr>
						</c:if>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.secLevel" /></th>
								<td><input type="text" class="intxt" style="width: 60%;" tabindex="5" id="directory-addUser-secLevel" maxlength="2" value="" /> ex) 0 ~ 99</td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.loginID" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="6" id="directory-addUser-loginID" maxlength="20" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.loginPassword" /></th>
								<td>
									<span class="inp_raochk"><input type="radio" tabindex="7" name="directory-addUser-loginPassword-assign" value="0" checked="checked"><fmt:message bundle="${messages_directory}" key="directory.defaultValue" />(<c:out value="${defaultLoginPassword}" />)</span>
									<span class="inp_raochk"><input type="radio" tabindex="7" name="directory-addUser-loginPassword-assign" value="1"><fmt:message bundle="${messages_directory}" key="directory.assign" /></span><br />
									<input type="password" class="intxt" style="width: 95.8%;" tabindex="8" id="directory-addUser-loginPassword" maxlength="15" disabled="disabled" /><br />
									<input type="password" class="intxt" style="width: 95.8%;" tabindex="9" id="directory-addUser-loginPasswordConfirm" maxlength="15" disabled="disabled" />
								</td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.loginLock" /></th>
								<td>
									<span class="inp_raochk"><input type="radio" tabindex="10" name="directory-addUser-loginLock" value="0" checked="checked"><fmt:message bundle="${messages_directory}" key="directory.loginLock.unlock" /></span>
									<span class="inp_raochk"><input type="radio" tabindex="10" name="directory-addUser-loginLock" value="1"><fmt:message bundle="${messages_directory}" key="directory.loginLock.lock" /></span>
								</td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.expiryDate" /></th>
								<td><input type="text" class="intxt" style="width: 60%;" tabindex="11" id="directory-addUser-expiryDate" maxlength="10" value="2999.12.31" /> ex) 2012.12.31</td>
							</tr>
						<c:if test="${useUC}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.phoneRuleID" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="25" id="directory-addUser-phoneRuleID" maxlength="1" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.extPhone" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="25" id="directory-addUser-extPhone" maxlength="10" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.extPhoneHead" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="25" id="directory-addUser-extPhoneHead" maxlength="10" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.extPhoneExch" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="25" id="directory-addUser-extPhoneExch" maxlength="10" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.phyPhone" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="25" id="directory-addUser-phyPhone" maxlength="10" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.fwdPhone" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="25" id="directory-addUser-fwdPhone" maxlength="10" value="" /></td>
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
								<th><fmt:message bundle="${messages_directory}" key="directory.en_email" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="21" id="directory-addUser-email" maxlength="128" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.phone" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="22" id="directory-addUser-phone" maxlength="40" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.mobilePhone" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="23" id="directory-addUser-mobilePhone" maxlength="40" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.fax" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="24" id="directory-addUser-fax" maxlength="40" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.clientIPAddr" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="25" id="directory-addUser-clientIPAddr" maxlength="64" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.auth" /></th>
								<td>
								<c:forEach var="auth" items="${authes}">
									<c:if test="${auth.type == 0}">
										<c:set var="isChecked" value="" />
										<c:if test="${useExternalUser && auth.code == '100'}">
											<c:set var="isChecked" value="checked=\"checked\"" />
										</c:if>
										<span class="inp_raochk"><input type="checkbox" tabindex="26" id="directory-addUser-relID-<c:out value="${auth.code}" />" value="<c:out value="${auth.code}" />" <c:out value="${isChecked}" /> <c:if test="${auth.code == 'ADM' && !isAdmin}">disabled="disabled"</c:if> /><c:out value="${auth.name}" /></span><br />
									</c:if>
								</c:forEach>
								</td>
							</tr>
						<c:forEach var="auth" items="${authes}">
							<c:if test="${auth.type == 1}">
							<tr>
								<th class="btntitle">
									<a href="#" onclick="javascript:directory_addUser_openPopup($('#directory-addUser-relID-<c:out value="${auth.code}" />'), $('#directory-addUser-relName-<c:out value="${auth.code}" />'), <c:out value="${auth.multi}" />);"><c:out value="${auth.name}" /><span class="arr_r"></span></a>
								</th>
								<td>
									<input type="hidden" id="directory-addUser-relID-<c:out value="${auth.code}" />" />
									<input type="text" class="intxt" style="width: 95.8%;" id="directory-addUser-relName-<c:out value="${auth.code}" />" readonly="readonly" />
								</td>
							</tr>
							</c:if>
						</c:forEach>
						<c:if test="${useMail}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.mailCapacity" /></th>
								<td><input type="text" class="intxt" style="width: 60%;" id="directory-addUser-capacity" maxlength="5" value="<c:out value="${defaultMailCapacity}" />" <c:if test="${!isAdmin}">disabled="disabled"</c:if> />&nbsp;MB</td>
							</tr>
						</c:if>
						<c:if test="${useCloudfolder}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.cloudfolderCapacity" /></th>
								<td><input type="text" class="intxt" style="width: 60%;" id="directory-addUser-cloudfolderCapacity" maxlength="6" value="<c:out value="${defaultCloudfolderCapacity}" />" <c:if test="${!isAdmin}">disabled="disabled"</c:if> />&nbsp;MB</td>
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