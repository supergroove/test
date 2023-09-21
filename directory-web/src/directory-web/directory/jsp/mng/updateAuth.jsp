<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.authMng.update" /> -->
	
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/mng/orgMng.js"></script>
	
	<script type="text/javascript">
		function directory_updateAuth_onLoad() {
			DIRECTORY_CONTEXT = "<c:out value="${CONTEXT}" />";
			
			if ($("#directory-updateAuth-authType").val() == 0 || $("#directory-updateAuth-authType").val() == 3) {
				$("#directory-updateAuth-authMultiFlag option[value='1']").attr("selected", true);
				$("#directory-updateAuth-authMultiFlag").attr("disabled", true);
			}
			$("#directory-updateAuth-authType").change(function() {
				if ($(this).val() == 0 || $(this).val() == 3) {
					$("#directory-updateAuth-authMultiFlag option[value='1']").attr("selected", true);
					$("#directory-updateAuth-authMultiFlag").attr("disabled", true);
				} else {
					$("#directory-updateAuth-authMultiFlag").attr("disabled", false);
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
<body onload="javascript:directory_updateAuth_onLoad();">
	<input type="hidden" id="directory-updateAuth-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.update.confirm" />" />
	<input type="hidden" id="directory-updateAuth-authUpdated" value="<fmt:message bundle="${messages_directory}" key="directory.update.authUpdated" />" />
	<input type="hidden" id="directory-updateAuth-inputAuthCode" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputAuthCode" />" />
	<input type="hidden" id="directory-updateAuth-inputAuthName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputAuthName" />" />
	<input type="hidden" id="directory-updateAuth-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-deleteAuthes-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-deleteAuthes-authDeleted" value="<fmt:message bundle="${messages_directory}" key="directory.delete.authDeleted" />" />
	<input type="hidden" id="directory-deleteAuthes-usedAuthError" value="<fmt:message bundle="${messages_directory}" key="directory.delete.usedAuthError" />" />
	<input type="hidden" id="directory-listAuthes-selectItem" value="<fmt:message bundle="${messages_directory}" key="directory.selectItem" />" />
	
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-authCode" value="<fmt:message bundle="${messages_directory}" key="directory.authCode" />" />
	<input type="hidden" id="directory-authName" value="<fmt:message bundle="${messages_directory}" key="directory.authName" />" />
	<input type="hidden" id="directory-authDescription" value="<fmt:message bundle="${messages_directory}" key="directory.authDescription" />" />
	<input type="hidden" id="directory-updateAuth-updateAuthError" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.10043.updateAuthError" />" />
	
	<div id="pop_wrap" style="min-width: 300px;">
		<h1>
			<p><fmt:message bundle="${messages_directory}" key="directory.authMng.update" /></p>
		</h1>
		<!-- button : start -->
		<div class="btn_area">
			<ul class="btns">
				<li><span><a href="#" onclick="javascript:directory_orgMng.updateAuth('<c:out value="${auth.code}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
				<li><span><a href="#" onclick="javascript:directory_orgMng.deleteAuth('<c:out value="${auth.code}" />');"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
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
							<td><input type="hidden" id="directory-updateAuth-authCode" value="<c:out value="${auth.code}" />" /><c:out value="${auth.code}" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.authName" /></th>
							<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-updateAuth-authName" maxlength="60" value="<c:out value="${auth.name}" />" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.authType" /></th>
							<td>
								<select tabindex="2" id="directory-updateAuth-authType">
									<option value="0" <c:if test="${auth.type == 0}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.authType.user" /></option>
									<option value="1" <c:if test="${auth.type == 1}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.authType.usertouser" /></option>
									<option value="2" <c:if test="${auth.type == 2}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.authType.usertodept" /></option>
									<option value="3" <c:if test="${auth.type == 3}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.authType.dept" /></option>
								</select>
							</td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.authMultiFlag" /></th>
							<td>
								<select tabindex="3" id="directory-updateAuth-authMultiFlag">
									<option value="1" <c:if test="${auth.multi}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.authMultiFlag.true" /></option>
									<option value="0" <c:if test="${!auth.multi}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.authMultiFlag.false" /></option>
								</select>
							</td>
						</tr>
						<tr>
							<th colspan="2"><fmt:message bundle="${messages_directory}" key="directory.authDescription" /></th>
						</tr>
						<tr>
							<td colspan="2"><textarea style="width:100%" tabindex="4" id="directory-updateAuth-authDescription" rows="2" maxlength="90"><c:out value="${auth.description}" /></textarea></td>
						</tr>
					</tbody>
				</table>
				<!-- table : end -->
			</div>
		</div>
	</div>
</body>
</html>