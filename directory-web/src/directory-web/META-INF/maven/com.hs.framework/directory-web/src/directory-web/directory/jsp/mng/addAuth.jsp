<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.authMng.add" /> -->
	
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/mng/orgMng.js"></script>
	
	<script type="text/javascript">
		function directory_addAuth_onLoad() {
			DIRECTORY_CONTEXT = "<c:out value="${CONTEXT}" />";
			
			$("#directory-addAuth-authCode").focus();
			
			if ($("#directory-addAuth-authType").val() == 0 || $("#directory-addAuth-authType").val() == 3) {
				$("#directory-addAuth-authMultiFlag option[value='1']").attr("selected", true);
				$("#directory-addAuth-authMultiFlag").attr("disabled", true);
			}
			$("#directory-addAuth-authType").change(function() {
				if ($(this).val() == 0 || $(this).val() == 3) {
					$("#directory-addAuth-authMultiFlag option[value='1']").attr("selected", true);
					$("#directory-addAuth-authMultiFlag").attr("disabled", true);
				} else {
					$("#directory-addAuth-authMultiFlag").attr("disabled", false);
				}
			});
		}
		document.onmouseover = function() {
			if(event.srcElement.tagName == "A") {
				 setTimeout("hideStatus()", 0);
			}
		}
		function hideStatus() {
			document.location = "#";	
		}
		hideStatus();
	</script>
</head>
<body onload="javascript:directory_addAuth_onLoad();">
	<input type="hidden" id="directory-addAuth-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.confirm" />" />
	<input type="hidden" id="directory-addAuth-authAdded" value="<fmt:message bundle="${messages_directory}" key="directory.add.authAdded" />" />
	<input type="hidden" id="directory-addAuth-inputAuthCode" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputAuthCode" />" />
	<input type="hidden" id="directory-addAuth-inputAuthName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputAuthName" />" />
	<input type="hidden" id="directory-addAuth-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-addAuth-invalidSecLevel" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidSecLevel" />" />
	<input type="hidden" id="directory-addAuth-authDupAuthCode" value="<fmt:message bundle="${messages_directory}" key="directory.add.authDupAuthCode"/>" />
	<input type="hidden" id="directory-addAuth-authDupAuthName" value="<fmt:message bundle="${messages_directory}" key="directory.add.authDupAuthName"/>" />
	
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-authCode" value="<fmt:message bundle="${messages_directory}" key="directory.authCode" />" />
	<input type="hidden" id="directory-authName" value="<fmt:message bundle="${messages_directory}" key="directory.authName" />" />
	<input type="hidden" id="directory-authDescription" value="<fmt:message bundle="${messages_directory}" key="directory.authDescription" />" />
	
	<div id="pop_wrap" style="min-width: 300px;">
		<h1>
			<p><fmt:message bundle="${messages_directory}" key="directory.authMng.add" /></p>
		</h1>
		<!-- button : start -->
		<div class="btn_area">
			<ul class="btns">
				<li><span><a href="#" onclick="javascript:directory_orgMng.addAuth();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
				<li><span><a href="#" onclick="javascript:window.close();"><fmt:message bundle="${messages_directory}" key="directory.cancel" /></a></span></li>
			</ul>
		</div>
		<!-- button : end -->
		<div id="pop_container">
			<div class="contents">
				<!-- table : start -->
				<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
					<col width="120" />
					<col width="" />
					<tbody>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.authCode" /></th>
							<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-addAuth-authCode" maxlength="3" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.authName" /></th>
							<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="2" id="directory-addAuth-authName" maxlength="60" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.authType" /></th>
							<td>
								<select tabindex="3" id="directory-addAuth-authType">
									<option value="0"><fmt:message bundle="${messages_directory}" key="directory.authType.user" /></option>
									<option value="1"><fmt:message bundle="${messages_directory}" key="directory.authType.usertouser" /></option>
									<option value="2"><fmt:message bundle="${messages_directory}" key="directory.authType.usertodept" /></option>
									<option value="3"><fmt:message bundle="${messages_directory}" key="directory.authType.dept" /></option>
								</select>
							</td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.authMultiFlag" /></th>
							<td>
								<select tabindex="4" id="directory-addAuth-authMultiFlag">
									<option value="1"><fmt:message bundle="${messages_directory}" key="directory.authMultiFlag.true" /></option>
									<option value="0"><fmt:message bundle="${messages_directory}" key="directory.authMultiFlag.false" /></option>
								</select>
							</td>
						</tr>
						<tr>
							<th colspan="2"><fmt:message bundle="${messages_directory}" key="directory.authDescription" /></th>
						</tr>
						<tr>
							<td colspan="2"><textarea style="width:100%" tabindex="5" id="directory-addAuth-authDescription" rows="2" maxlength="90"></textarea></td>
						</tr>
					</tbody>
				</table>
				<!-- table : end -->
			</div>
		</div>
	</div>
</body>
</html>