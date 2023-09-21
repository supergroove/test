<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- HANDY Directory -->
	<!--<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/org.js"></script> -->
	
	<script type="text/javascript" type="text/javascript">
		function directory_updateLinkageAccount_onLoad() {
			var linkageName = $("#directory-updateLinkageAccount-linkageName option:selected").val();
			directory_updateLinkageAccout_loadLinkageAccout(linkageName);
		}
		
		function directory_updateLinkageAccount_onchangeLinkageName() {
			var linkageName = $("#directory-updateLinkageAccount-linkageName option:selected").val();
			directory_updateLinkageAccout_loadLinkageAccout(linkageName);
		}
		
		function directory_updateLinkageAccout_loadLinkageAccout(linkageName){
			var data = {
					acton: "getLinkageAccount",
					linkageName: linkageName
				};
			$.ajax({
				url: "<c:out value="${CONTEXT}" />" + "/org.do",
				type: "post",
				async: false,
				dataType: "json",
				data: data,
				success: function(result, status) {
					if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
						alert(result.errorMessage);
					} else {
						$("#directory-updateLinkageAccount-accountName").val(result.accountName);
					}
				},
				error: function(result, status) {
					alert("ERROR : " + status);
				}
			});
		}
		
		function directory_updateLinkageAccount_updateLinkageAccount() {
			var linkageName = $("#directory-updateLinkageAccount-linkageName option:selected").val();
			var accountName = $("#directory-updateLinkageAccount-accountName").val();
			var accountPassword = $("#directory-updateLinkageAccount-accountPassword").val();
			var confirmAccountPassword = $("#directory-updateLinkageAccount-confirmAccountPassword").val();
			
			if(accountName.length == 0){
				alert($("#directory-updateLinkageAccount-input-linkageName").val());
				$("#directory-updateLinkageAccount-linkageName").focus();
				return;
			}
			if(accountName.length == 0){
				alert($("#directory-updateLinkageAccount-input-accountName").val());
				$("#directory-updateLinkageAccount-accountName").focus();
				return;
			}
			if(accountPassword.length == 0){
				alert($("#directory-updateLinkageAccount-input-accountPassword").val());
				$("#directory-updateLinkageAccount-accountPassword").focus();
				return;
			}
			if(confirmAccountPassword.length == 0){
				alert($("#directory-updateLinkageAccount-input-accountPassword").val());
				$("#directory-updateLinkageAccount-accountPassword").focus();
				return;
			}
			if(accountPassword != confirmAccountPassword.length){
				alert($("#directory-updateLinkageAccount-input-incorrectPasswordConfirm").val());
				$("#directory-updateLinkageAccount-accountPassword").val("");
				$("#directory-updateLinkageAccount-confirmAccountPassword").val("");
				$("#directory-updateLinkageAccount-accountPassword").focus();
				return;
			}
			
			var data = {
				acton: "updateLinkageAccount",
				linkageName: linkageName,
				accountName: accountName,
				accountPassword: accountPassword
			};
			$.ajax({
				url: "<c:out value="${CONTEXT}" />" + "/org.do",
				type: "post",
				async: false,
				dataType: "json",
				data: data,
				success: function(result, status) {
					if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
						alert(result.errorMessage);
					} else {
						alert($("#directory-updateLinkageAccount-changed").val());
					}
				},
				error: function(result, status) {
					alert("ERROR : " + status);
				}
			});
		}
	</script>
</head>
<body onload="javascript:directory_updateLinkageAccount_onLoad();">
	<input type="hidden" id="directory-updateLinkageAccount-changed" value="<fmt:message bundle="${messages_directory}" key="directory.env.linkageaccount.changed" />" />
	<input type="hidden" id="directory-updateLinkageAccount-input-linkageName" value="<fmt:message bundle="${messages_directory}" key="directory.env.linkageaccount.input.linkageName" />" />
	<input type="hidden" id="directory-updateLinkageAccount-input-accountName" value="<fmt:message bundle="${messages_directory}" key="directory.env.linkageaccount.input.accountName" />" />
	<input type="hidden" id="directory-updateLinkageAccount-input-accountPassword" value="<fmt:message bundle="${messages_directory}" key="directory.env.linkageaccount.input.accountPassword" />" />
	<input type="hidden" id="directory-updateLinkageAccount-input-incorrectPasswordConfirm" value="<fmt:message bundle="${messages_directory}" key="directory.env.linkageaccount.input.incorrectPasswordConfirm" />" />
	
	<div class="title_area">
		<h2 class="title"><span title="HOME&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.title" />&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.linkageaccount.title" />"><fmt:message bundle="${messages_directory}" key="directory.env.linkageaccount.title" /></span></h2>
	</div>
	<!-- button : start -->
	<div class="btn_area">
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_updateLinkageAccount_updateLinkageAccount();"><fmt:message bundle="${messages_directory}" key="directory.ok" /></a></span></li>
		</ul>
	</div>
	<!-- button : end -->
	<div style="padding: 5px;">
		<!-- table : start -->
		<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
			<col width="17%" />
			<col width="" />
			<tbody>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.env.linkageaccount.linkageName" /></th>
					<td>
						<select id="directory-updateLinkageAccount-linkageName" onchange="directory_updateLinkageAccount_onchangeLinkageName()">
						<c:forEach var="linkageName" items="${linkageAccountLinkageNameList}">
							<option value="<c:out value="${linkageName}" />">
								<c:set var="linkageNameWithLocale">directory.env.linkageaccount.linkageName.<c:out value="${linkageName}"></c:out></c:set> 
								<fmt:message bundle="${messages_directory}" key="${linkageNameWithLocale}"></fmt:message>
							</option>
						</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.env.linkageaccount.accountName" /></th>
					<td>
						<input id="directory-updateLinkageAccount-accountName" name="directory-updateLinkageAccount-accountName" type="text" size="50" value="">
					</td>
				</tr>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.env.linkageaccount.accountPassword" /></th>
					<td>
						<input id="directory-updateLinkageAccount-accountPassword" name="directory-updateLinkageAccount-accountPassword" type="password" size="50" value="">
					</td>
				</tr>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.env.linkageaccount.confirmAccountPassword" /></th>
					<td>
						<input id="directory-updateLinkageAccount-confirmAccountPassword" name="directory-updateLinkageAccount-confirmAccountPassword" type="password" size="50" value="">
					</td>
				</tr>
			</tbody>
		</table>
		<!-- table : end -->
	</div>
</body>
</html>