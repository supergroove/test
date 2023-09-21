<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
	<script type="text/javascript">
		function directory_addExternalUser_onLoad() {
			$("#directory-addExternalUser-positionID").bind('change', function() {
				var secLevel = $("#directory-addExternalUser-positionSecLevel" + $(this).val()).val();
				$("#directory-addExternalUser-secLevel").val(secLevel);
			});
			$("input[name='directory-addExternalUser-loginPassword-assign']").click(function() {
				if ($(this).is(":checked")) {
					var loginPassword = $("#directory-addExternalUser-loginPassword");
					var loginPasswordConfirm = $("#directory-addExternalUser-loginPasswordConfirm");
					
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
			
			$("#directory-addExternalUser-userName").focus();
		}
		
	</script>
<div>
	<input type="hidden" id="directory-addExternalUser-display" value="<c:out value="${param.display}" />" /> <!-- display option -->
	<input type="hidden" id="directory-addExternalUser-required" value="<c:out value="${param.required}" />" /> <!-- required option -->
	<input type="hidden" id="directory-addExternalUser-isEmailRequired" value="<c:out value="${isEmailRequired}"/>" />
	<input type="hidden" id="directory-addExternalUser-communityID" value="<c:out value="${param.communityID}"/>" />
	
	<input type="hidden" id="directory-addExternalUser-title" value="<fmt:message bundle="${messages_directory}" key="directory.add.externalUserAdd" />" /> <!-- dialog title -->
	
	<input type="hidden" id="directory-addExternalUser-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.confirm" />" />
	<input type="hidden" id="directory-addExternalUser-userAdded" value="<fmt:message bundle="${messages_directory}" key="directory.add.externalUserAdded" />" />
	<input type="hidden" id="directory-addExternalUser-inputUserName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputUserName" />" />
	<input type="hidden" id="directory-addExternalUser-inputEmpCode" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputEmpCode" />" />
	<input type="hidden" id="directory-addExternalUser-inputLoginID" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputLoginID" />" />
	<input type="hidden" id="directory-addExternalUser-inputPhone" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputPhone" />" />
	<input type="hidden" id="directory-addExternalUser-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-addExternalUser-invalidCharacterError-1" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError.1" />" />
	<input type="hidden" id="directory-addExternalUser-invalidEmailError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidEmailError" />" />
	<input type="hidden" id="directory-addExternalUser-selectPosition" value="<fmt:message bundle="${messages_directory}" key="directory.add.selectPosition" />" />
	<input type="hidden" id="directory-addExternalUser-invalidSecLevel" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidSecLevel" />" />
	<input type="hidden" id="directory-addExternalUser-inputLoginPassword" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputLoginPassword" />" />
	<input type="hidden" id="directory-addExternalUser-inputLoginPasswordConfirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputLoginPasswordConfirm" />" />
	<input type="hidden" id="directory-addExternalUser-incorrectLoginPasswordConfirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.incorrectLoginPasswordConfirm" />" />
	<input type="hidden" id="directory-addExternalUser-invalidExpiryDate" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidExpiryDate" />" />
	<input type="hidden" id="directory-addExternalUser-dupEmpCode" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupEmpCode" />" />
	<input type="hidden" id="directory-addExternalUser-dupLoginID" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupLoginID" />" />
	<input type="hidden" id="directory-addExternalUser-dupEmail" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupEmail" />" />
	<input type="hidden" id="directory-addExternalUser-notAuthorizedUser" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.5006.notAuthorizedUser" />" />
	<input type="hidden" id="directory-addExternalUser-invalidPhoneRuleID" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidPhoneRuleID" />" />
	
	
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
	
	<div style="overflow: auto; height: 100%; width: 100%;">
		<!-- table : start -->
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td valign="top">
					<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
						<col width="110px">
						<col width="">
						<tbody>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.userDeptName" />*</th>
								<td>
									<select tabindex="1" id="directory-addExternalUser-deptID">
										<c:forEach var="dept" items="${deptList}">
											<c:if test="${IS_ENGLISH}">
												<c:if test="${not empty dept.nameEng}">
													<c:set target="dept" property="name" value="${dept.nameEng}"/>
												</c:if>
											</c:if>
											<option value="<c:out value="${dept.ID}" />"><c:out value="${dept.name}" /></option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.userName" />*</th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="2" id="directory-addExternalUser-userName" maxlength="120" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.userNameEng" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="3" id="directory-addExternalUser-userNameEng" maxlength="120" value="" /></td>
							</tr>
						<c:if test="${display.empCode}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.empCode" /><c:if test="${required.empCode}">*</c:if></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="3" id="directory-addExternalUser-empCode" maxlength="40" value="" /></td>
							</tr>
						</c:if>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.position" />*</th>
								<td>
									<select tabindex="4" id="directory-addExternalUser-positionID">
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
										<input type="hidden" id="directory-addExternalUser-positionSecLevel<c:out value="${position.ID}" />" value="<c:out value="${position.securityLevel}" />" />
									</c:forEach>
									<input type="hidden" id="directory-addExternalUser-secLevel"/>
								</td>
							</tr>
						<c:if test="${useRank && display.rank}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.rank" /></th>
								<td>
									<select tabindex="5" id="directory-addExternalUser-rankID">
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
						<c:if test="${display.loginID}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.loginID" /><c:if test="${required.loginID}">*</c:if></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="6" id="directory-addExternalUser-loginID" maxlength="20" value="" /></td>
							</tr>
						</c:if>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.loginPassword" /></th>
								<td>
									<span class="inp_raochk"><input type="radio" tabindex="7" name="directory-addExternalUser-loginPassword-assign" value="0" checked="checked"><fmt:message bundle="${messages_directory}" key="directory.defaultValue" /></span>
									<span class="inp_raochk"><input type="radio" tabindex="7" name="directory-addExternalUser-loginPassword-assign" value="1"><fmt:message bundle="${messages_directory}" key="directory.assign" /></span><br />
									<input type="password" class="intxt" style="width: 95.8%;" tabindex="8" id="directory-addExternalUser-loginPassword" maxlength="15" disabled="disabled" /><br />
									<input type="password" class="intxt" style="width: 95.8%;" tabindex="9" id="directory-addExternalUser-loginPasswordConfirm" maxlength="15" disabled="disabled" />
								</td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.en_email" /><c:if test="${isEmailRequired || required.email}">*</c:if></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="21" id="directory-addExternalUser-email" maxlength="128" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.phone" /><c:if test="${required.phone}">*</c:if></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="22" id="directory-addExternalUser-phone" maxlength="40" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.mobilePhone" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="23" id="directory-addExternalUser-mobilePhone" maxlength="40" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.fax" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="24" id="directory-addExternalUser-fax" maxlength="40" value="" /></td>
							</tr>
						<c:if test="${useUC}">
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.extPhone" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="25" id="directory-addExternalUser-extPhone" maxlength="10" value="" /></td>
							</tr>
						</c:if>
						</tbody>
					</table>
				</td>
			</tr>
		</table>
		<!-- table : end -->
	</div>
	<!-- button : start -->
	<div class="footcen">
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_orgMng.addExternalUser();"><fmt:message bundle="${messages_directory}" key="directory.ok" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.closeExternalUser();"><fmt:message bundle="${messages_directory}" key="directory.cancel" /></a></span></li>
		</ul>
	</div>
	<!-- button : end -->
</div>	