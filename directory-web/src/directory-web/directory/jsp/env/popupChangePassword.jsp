<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
	<script type="text/javascript" type="text/javascript">
		var DIRECTORY_CONTEXT = "<c:out value="${CONTEXT}" />";
		
		function orgDebug(msg){
			if (true) { // false -> TEST
				return;
			}
			if(window.console && window.console.debug){
				window.console.debug(msg);
			}else if(window.console && window.console.log){
				window.console.log(msg);
			}
		}
		
		function directory_changePassword_onLoad() {
			
		}
		function directory_changePassword_changePassword() {
			var oldPassword = $("#directory-changePassword-oldPassword").val();
			var newPassword = $("#directory-changePassword-newPassword").val();
			var passwordConfirm = $("#directory-changePassword-passwordConfirm").val();
			
			if(oldPassword.length == 0){
				alert($("#directory-changePassword-input-oldPassword").val());
				$("#directory-changePassword-oldPassword").focus();
				return;
			}
			if(newPassword.length == 0){
				alert($("#directory-changePassword-input-newPassword").val());
				$("#directory-changePassword-newPassword").focus();
				return;
			}
			if(passwordConfirm.length == 0){
				alert($("#directory-changePassword-input-passwordConfirm").val());
				$("#directory-changePassword-passwordConfirm").focus();
				return;
			}
			if(newPassword != passwordConfirm){
				alert($("#directory-changePassword-input-incorrectPasswordConfirm").val());
				$("#directory-changePassword-passwordConfirm").focus();
				return;
			}
			if(newPassword == oldPassword){
				alert($("#directory-changePassword-input-samePassword").val());
				$("#directory-changePassword-newPassword").focus();
				return;
			}
			var data = {
					acton: "changePassword",
					oldPassword: oldPassword,
					newPassword: newPassword
				};
			orgDebug("data="+data);
			$.ajax({
				url: DIRECTORY_CONTEXT + "/org.do",
				type: "post",
				async: false,
				dataType: "json",
				data: data,
				success: function(result, status) {
					if(result.errorCode == directory_orgErrorCode.ORG_NOT_MATCH_OLDANDNEWPASSWORD){
						alert($("#directory-changePassword-error-incorrectPassword").val());
						$("#directory-changePassword-oldPassword").val("");
						$("#directory-changePassword-oldPassword").focus();
						return;
					}else if(result.errorCode == directory_orgErrorCode.ORG_MATCH_PREVIOUS_PASSWORD){
						alert($("#directory-changePassword-error-matchPreviousPassword").val());
						$("#directory-changePassword-newPassword").val("");
						$("#directory-changePassword-passwordConfirm").val("");
						$("#directory-changePassword-newPassword").focus();
						return;
					}else if(result.errorCode == directory_orgErrorCode.ORG_ERROR_PASSWORD_RULES){
						if(result.property == 'allowEmpCode'){
							alert($("#directory-changePassword-error-allowEmpCode").val());
							$("#directory-changePassword-newPassword").focus();
							return;
						}else if(result.property == 'allowUserName'){
							alert($("#directory-changePassword-error-allowUserName").val());
							$("#directory-changePassword-newPassword").focus();
							return;
						}else if(result.property == 'minLength'){
							alert($("#directory-changePassword-error-minLength").val().replace("{0}", result.length));
							$("#directory-changePassword-newPassword").focus();
							return;
						}else if(result.property == 'minNumberLength'){
							alert($("#directory-changePassword-error-minNumberLength").val().replace("{0}", result.length));
							$("#directory-changePassword-newPassword").focus();
							return;
						}else if(result.property == 'minCharacterLength'){
							alert($("#directory-changePassword-error-minCharacterLength").val().replace("{0}", result.length));
							$("#directory-changePassword-newPassword").focus();
							return;
						}else if(result.property == 'minSpeicalCharacterLength'){
							alert($("#directory-changePassword-error-minSpeicalCharacterLength").val().replace("{0}", result.length));
							$("#directory-changePassword-newPassword").focus();
							return;
						}else if(result.property == 'allowContinuousCharacter'){
							alert($("#directory-changePassword-error-allowContinuousCharacter").val().replace("{0}", result.length));
							$("#directory-changePassword-newPassword").focus();
							return;
						}else if(result.property == 'minUpperCharacterLength'){
							alert($("#directory-changePassword-error-minUpperCharacterLength").val().replace("{0}", result.length));
							$("#directory-changePassword-newPassword").focus();
							return;
						}else if(result.property == 'minLowerCharacterLength'){
							alert($("#directory-changePassword-error-minLowerCharacterLength").val().replace("{0}", result.length));
							$("#directory-changePassword-newPassword").focus();
							return;
						}else if(result.property == 'complexTypeLength'){
							var ruleMsg = "";
							if(typeof(result.rule) != 'undefined'){
								var ruleArray = result.rule.split(',');
								for(var i=0; i<ruleArray.length; i++){
									if($("#directory-changePassword-error-complexType"+ruleArray[i]).length){
										if(ruleMsg.length > 0){
											ruleMsg += ",";
										}
										ruleMsg += $("#directory-changePassword-error-complexType"+ruleArray[i]).val();
									}
								}
							}
							alert($("#directory-changePassword-error-complexTypeLength").val().replace("{0}", (ruleMsg.length < 1 ? result.rule : ruleMsg)).replace("{1}", result.length));
							$("#directory-changePassword-newPassword").focus();
							return;
						}
						$("#directory-changePassword-newPassword").val("");
						$("#directory-changePassword-passwordConfirm").val("");
						$("#directory-changePassword-newPassword").focus();

					}else if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
						alert(result.errorMessage);
					}else{
						alert($("#directory-changePassword-changed").val());
						<c:if test="${not empty param.popupChangePasswordCallback}">
							$.<c:out value="${param.popupChangePasswordCallback}"/>();
						</c:if>
						
						directory_divPopup.close();
					}
				},
				error: function(result, status) {
					alert("ERROR : " + status);
				}
			});
		}
	</script>
	<input type="hidden" id="directory-changePassword-input-oldPassword" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.input.oldPassword" />" />
	<input type="hidden" id="directory-changePassword-input-newPassword" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.input.newPassword" />" />
	<input type="hidden" id="directory-changePassword-input-passwordConfirm" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.input.passwordConfirm" />" />
	<input type="hidden" id="directory-changePassword-input-incorrectPasswordConfirm" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.input.incorrectPasswordConfirm" />" />
	<input type="hidden" id="directory-changePassword-input-samePassword" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.input.samePassword" />" />
	<input type="hidden" id="directory-changePassword-changed" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.changed" />" />
	<input type="hidden" id="directory-changePassword-error-incorrectPassword" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5002.incorrectPassword" />" />
	<input type="hidden" id="directory-changePassword-error-allowEmpCode" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.allowEmpCode" />" />
	<input type="hidden" id="directory-changePassword-error-allowUserName" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.allowUserName" />" />
	<input type="hidden" id="directory-changePassword-error-minLength" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.minLength" />" />
	<input type="hidden" id="directory-changePassword-error-minNumberLength" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.minNumberLength" />" />
	<input type="hidden" id="directory-changePassword-error-minCharacterLength" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.minCharacterLength" />" />
	<input type="hidden" id="directory-changePassword-error-minSpeicalCharacterLength" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.minSpeicalCharacterLength" />" />
	<input type="hidden" id="directory-changePassword-error-allowContinuousCharacter" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.allowContinuousCharacter" />" />
	<input type="hidden" id="directory-changePassword-error-matchPreviousPassword" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5009.matchPreviousPassword" />" />
	<input type="hidden" id="directory-changePassword-error-minUpperCharacterLength" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.minUpperCharacterLength" />" />
	<input type="hidden" id="directory-changePassword-error-minLowerCharacterLength" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.minLowerCharacterLength" />" />
	<input type="hidden" id="directory-changePassword-error-complexTypeLength" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.complexTypeLength" />" />
	<input type="hidden" id="directory-changePassword-error-complexTypeU" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.complexTypeU" />" />
	<input type="hidden" id="directory-changePassword-error-complexTypeL" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.complexTypeL" />" />
	<input type="hidden" id="directory-changePassword-error-complexTypeN" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.complexTypeN" />" />
	<input type="hidden" id="directory-changePassword-error-complexTypeS" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.complexTypeS" />" />
	<input type="hidden" id="directory-changePassword-error-complexTypeC" value="<fmt:message bundle="${messages_directory}" key="directory.env.password.5003.complexTypeC" />" />
	
	<div id="pop_wrap" style="width: 500px; min-width: 300px;">
		<h1>
			<p><fmt:message bundle="${messages_directory}" key="directory.env.password.title" /></p>
		</h1>
		<div id="pop_container">
			<div class="contents">
				<!-- table : start -->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td valign="top">
							<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%" style="word-break: break-all;">
								<col width="110" />
								<col width="" />
								<tbody>
									<tr>
										<th colspan="2"><fmt:message bundle="${messages_directory}" key="directory.env.password.expired" /></th>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.env.password.previousPassword" /></th>
										<td><input type="password" class="intxt" style="width: 37.2%;" tabindex="1" id="directory-changePassword-oldPassword" /></td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.env.password.newPassword" /></th>
										<td><input type="password" class="intxt" style="width: 95.8%;" tabindex="2" id="directory-changePassword-newPassword" maxlength="15" /></td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.env.password.passwordConfirm" /></th>
										<td><input type="password" class="intxt" style="width: 95.8%;" tabindex="3" id="directory-changePassword-passwordConfirm" maxlength="15" /></td>
									</tr>
								</tbody>
							</table>
						</td>
					</tr>
				</table>
				<!-- table : end -->
			</div>
			<div class="footcen" style="padding-bottom: 0;">
				<ul class="btns">
					<li><span><a href="javascript:directory_changePassword_changePassword();"><fmt:message bundle="${messages_directory}" key="directory.ok"/></a></span></li>
				</ul>
			</div>
		</div>
	</div>