<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- HANDY Directory -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/org.js"></script>
	
	<script type="text/javascript" type="text/javascript">
		function directory_updateNotify_onLoad() {
			var notifyType = $("input[name='directory-updateNotify-useNotify']:checked").val();
			directory_updateNotify_setDisabled(notifyType == "0");
			
			$("input[name='directory-updateNotify-useNotify']").click(function() {
				directory_updateNotify_setDisabled($(this).val() == "0");
			});
			$("#directory-updateNotify-checkAll").click(function() {
				$("#directory-updateNotify-useBBoardNotify").attr("checked", $(this).is(":checked"));
				$("#directory-updateNotify-useMailNotify").attr("checked", $(this).is(":checked"));
			});
			$("#directory-updateNotify-useBBoardNotify").click(function() {
				if (!$(this).is(":checked")) {
					$("#directory-updateNotify-checkAll").attr("checked", false);
				}
			});
			$("#directory-updateNotify-useMailNotify").click(function() {
				if (!$(this).is(":checked")) {
					$("#directory-updateNotify-checkAll").attr("checked", false);
				}
			});
		}
		
		function directory_updateNotify_setDisabled(isDisabled) {
			$("#directory-updateNotify-checkAll").attr("disabled", isDisabled);
			$("#directory-updateNotify-useBBoardNotify").attr("disabled", isDisabled);
			$("#directory-updateNotify-useMailNotify").attr("disabled", isDisabled);
		}
		
		function directory_updateNotify_updateNotify() {
			var data = {
				acton: "updateNotify",
				useNotify: $("input[name='directory-updateNotify-useNotify']:checked").val(),
				useBBoardNotify: $("#directory-updateNotify-useBBoardNotify").is(":checked") ? "1" : "0",
				useMailNotify: $("#directory-updateNotify-useMailNotify").is(":checked") ? "1" : "0"
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
						alert($("#directory-updateNotify-changed").val());
					}
				},
				error: function(result, status) {
					alert("ERROR : " + status);
				}
			});
		}
	</script>
</head>
<body onload="javascript:directory_changePassword_onLoad();">
	<input type="hidden" id="directory-updateNotify-changed" value="<fmt:message bundle="${messages_directory}" key="directory.env.notify.changed" />" />
	
	<div class="title_area">
		<h2 class="title"><span title="HOME&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.title" />&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.notify.title" />"><fmt:message bundle="${messages_directory}" key="directory.env.notify.title" /></span></h2>
	</div>
	<!-- button : start -->
	<div class="btn_area">
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_updateNotify_updateNotify();"><fmt:message bundle="${messages_directory}" key="directory.ok" /></a></span></li>
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
					<th colspan="2"><fmt:message bundle="${messages_directory}" key="directory.env.notify.message" /></th>
				</tr>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.usageChoice" /></th>
					<td>
						<span class="inp_raochk"><input type="radio" name="directory-updateNotify-useNotify" value="1" <c:if test="${user.useNotify}">checked="checked"</c:if> /><fmt:message bundle="${messages_directory}" key="directory.used" /></span>
						<span class="inp_raochk"><input type="radio" name="directory-updateNotify-useNotify" value="0" <c:if test="${!user.useNotify}">checked="checked"</c:if> /><fmt:message bundle="${messages_directory}" key="directory.notUsed" /></span>
					</td>
				</tr>
				<tr>
					<th colspan="2"><input type="checkbox" id="directory-updateNotify-checkAll" />&nbsp;<fmt:message bundle="${messages_directory}" key="directory.selectAll" /></th>
				</tr>
			<c:if test="${useBBS}">
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.board" /></th>
					<td>
						<span class="inp_raochk"><input type="checkbox" id="directory-updateNotify-useBBoardNotify" <c:if test="${user.useBBoardNotify}">checked="checked"</c:if> /><fmt:message bundle="${messages_directory}" key="directory.env.notify.alarmBoard" /></span>
					</td>
				</tr>
			</c:if>
			<c:if test="${useMail}">
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.mail" /></th>
					<td>
						<span class="inp_raochk"><input type="checkbox" id="directory-updateNotify-useMailNotify" <c:if test="${user.useMailNotify}">checked="checked"</c:if> /><fmt:message bundle="${messages_directory}" key="directory.env.notify.alarmMail" /></span>
					</td>
				</tr>
			</c:if>
			</tbody>
		</table>
		<!-- table : end -->
	</div>
</body>
</html>