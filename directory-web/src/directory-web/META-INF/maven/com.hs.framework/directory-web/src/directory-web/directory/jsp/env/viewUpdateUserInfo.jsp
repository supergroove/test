<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- HANDY Directory -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/org.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/jquery.form/jquery.form.js"></script>
	
	<script type="text/javascript" type="text/javascript">
		var DIRECTORY_CONTEXT = "<c:out value="${CONTEXT}" />";
		var allowFileExt_updateUserInfo = ",bmp,gif,jpg,jpeg,png,";
		function directory_updateUserInfo_onLoad() {
			
		}
		
		function directory_updateUserInfo_updateUserInfo() {
			if (!directory_updateUserInfo_validate()) {
				return;
			}
			
			var pictureFile = $("#directory-updateUserInfo-pictureFile").val();
			
			if (pictureFile != '') {
				var ext = pictureFile.substring(pictureFile.lastIndexOf(".")+1).toLowerCase();
				orgDebug("ext:"+ext+",indexOf:"+(allowFileExt_updateUserInfo.indexOf(","+ext+",")));
				if (allowFileExt_updateUserInfo.indexOf(","+ext+",") < 0) {
					orgDebug("message:"+allowFileExt_updateUserInfo.substring(1, allowFileExt_updateUserInfo.length-1));
					alert($('#directory-updateUserInfo-fileExtention').val().replace('{0}', allowFileExt_updateUserInfo.substring(1, allowFileExt_updateUserInfo.length-1)));
					return;
				}
			}
			/*
			//파일전송
			var frm;
			frm = $('#directory-updateUserInfo-form'); 
			frm.attr("action", DIRECTORY_CONTEXT + "/org.do?acton=updateUserInfo);
			frm.submit();
			*/

			var options = {
					url: DIRECTORY_CONTEXT + "/org.do?acton=updateUserInfo",
					type: "post",
					async: false,
					dataType: "json",
					data : {},
					success: directory_updateUserInfo_showResponse,
					beforeSubmit : directory_updateUserInfo_showRequest,
					error: function(result, status) {
						alert("ERROR : " + status);
					}
				}
			$('#directory-updateUserInfo-form').ajaxForm(options);
			$('#directory-updateUserInfo-form').submit();

		}
		
		function directory_updateUserInfo_validate() {
			// check userNameEng
			var userNameEng = $("#directory-updateUserInfo-userNameEng");
			if (directory_org.stringByteSize(userNameEng.val()) > 120) {
				alert($("#directory-maxLength").val().replace("{0}", $("#directory-userNameEng").val()).replace("{1}", 40).replace("{2}", 120));
				userNameEng.focus();
				return false;
			}
			if($("#directory-updateUserInfo-allowPeriodInUsername").val() == "true"){
				if (!directory_org.isValidCharacter(userNameEng.val(), 3)) {
					alert($("#directory-updateUserInfo-includePeriodInvalidCharacterError").val().replace("{0}", $("#directory-userNameEng").val()));
					userName.focus();
					return false;
				}
			}else{
				if (!directory_org.isValidCharacter(userNameEng.val())) {
					alert($("#directory-updateUserInfo-invalidCharacterError").val().replace("{0}", $("#directory-userNameEng").val()));
					userNameEng.focus();
					return false;
				}
			}
			
			// check phone
			var phone = $("#directory-updateUserInfo-phone");
			if (directory_org.stringByteSize(phone.val()) > 40) {
				alert($("#directory-maxLength").val().replace("{0}", $("#directory-phone").val()).replace("{1}", 13).replace("{2}", 40));
				phone.focus();
				return false;
			}
			if (!directory_org.isValidCharacter(phone.val(), 1)) {
				alert($("#directory-updateUserInfo-invalidCharacterError-1").val().replace("{0}", $("#directory-phone").val()));
				phone.focus();
				return false;
			}
			
			// check mobilePhone
			var mobilePhone = $("#directory-updateUserInfo-mobilePhone");
			if (directory_org.stringByteSize(mobilePhone.val()) > 40) {
				alert($("#directory-maxLength").val().replace("{0}", $("#directory-mobilePhone").val()).replace("{1}", 13).replace("{2}", 40));
				mobilePhone.focus();
				return false;
			}
			if (!directory_org.isValidCharacter(mobilePhone.val(), 1)) {
				alert($("#directory-updateUserInfo-invalidCharacterError-1").val().replace("{0}", $("#directory-mobilePhone").val()));
				mobilePhone.focus();
				return false;
			}
			
			// check fax
			var fax = $("#directory-updateUserInfo-fax");
			if (directory_org.stringByteSize(fax.val()) > 40) {
				alert($("#directory-maxLength").val().replace("{0}", $("#directory-fax").val()).replace("{1}", 13).replace("{2}", 40));
				fax.focus();
				return false;
			}
			if (!directory_org.isValidCharacter(fax.val(), 1)) {
				alert($("#directory-updateUserInfo-invalidCharacterError-1").val().replace("{0}", $("#directory-fax").val()));
				fax.focus();
				return false;
			}
			
			// check business
			var business = $("#directory-updateUserInfo-business");
			if (directory_org.stringByteSize(business.val()) > 512) {
				alert($("#directory-maxLength").val().replace("{0}", $("#directory-business").val()).replace("{1}", 170).replace("{2}", 512));
				business.focus();
				return false;
			}
			
			return true;
		}
		
		// post-submit callback 
		var result1;
		function directory_updateUserInfo_showResponse(result,state) {
			result1 = result;
			orgDebug("result.errorCode:"+result.errorCode);
			if(result.errorCode == directory_orgErrorCode.ORG_ERROR_MAXUPLOADSIZE){
				orgDebug("result.length:"+result.length+",round:"+(Math.round(Number(result.length)/1000)));
				alert($('#directory-updateUserInfo-maxUploadSize').val().replace('{0}', Math.round(Number(result.length)/1000)));
			}else if (result.errorCode == directory_orgErrorCode.ORG_NOT_SUPPORT_FILE){
				orgDebug("message:"+allowFileExt_updateUserInfo.substring(1, allowFileExt_updateUserInfo.length-1));
				alert($('#directory-updateUserInfo-fileExtention').val().replace('{0}', allowFileExt_updateUserInfo.substring(1, allowFileExt_updateUserInfo.length-1)));
			}else if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
				alert(result.errorMessage);
			}else{
				orgDebug("result.user="+result.user+",result.user.pictureURL="+result.user.pictureURL);
				alert($("#directory-updateUserInfo-infoChanged").val());
				
				if(result.user && result.user.pictureURL){
					$("#directory-updateUserInfo-picture").attr("src","<c:out value="${CONTEXT}" />" + result.user.pictureURL);
				}else{
					$("#directory-updateUserInfo-picture").attr("src","<c:out value="${CONTEXT}" /><fmt:message bundle="${messages_directory}" key="/directory/images/NOIMAGE.GIF" />");
				}
				$("#directory-updateUserInfo-pictureFile").replaceWith($("#directory-updateUserInfo-pictureFile").clone()); // $("#directory-updateUserInfo-pictureFile").val("");
				$("#directory-updateUserInfo-deletePicture").attr("checked", false);
			}
		}
		// pre-submit callback 
		function directory_updateUserInfo_showRequest(formData, jqForm, options) {
		}
		/*
		$(function() {
			//비동기 파일 전송
			var frm=$('#directory-updateUserInfo-form'); 
			frm.ajaxForm(directory_updateUserInfo_showResponse); 
			frm.submit(function(){return false; }); 
		});
		*/
	</script>
</head>
<body onload="javascript:directory_updateUserInfo_onLoad();">
	<input type="hidden" id="directory-updateUserInfo-infoChanged" value="<fmt:message bundle="${messages_directory}" key="directory.env.userinfo.infoChanged" />" />
	<input type="hidden" id="directory-updateUserInfo-maxUploadSize" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.5007.maxUploadSize" />" />
	<input type="hidden" id="directory-updateUserInfo-fileExtention" value="<fmt:message bundle="${messages_directory}" key="directory.env.userinfo.fileExtention" />" />
	<input type="hidden" id="directory-updateUserInfo-allowPeriodInUsername" value="<c:out value="${allowPeriodInUsername}"/>" />
	
	<input type="hidden" id="directory-updateUserInfo-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-updateUserInfo-invalidCharacterError-1" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError.1" />" />
	<input type="hidden" id="directory-updateUserInfo-includePeriodInvalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.username.include.period.invalidCharacterError" />" />
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-userNameEng" value="<fmt:message bundle="${messages_directory}" key="directory.userNameEng" />" />
	<input type="hidden" id="directory-phone" value="<fmt:message bundle="${messages_directory}" key="directory.phone" />" />
	<input type="hidden" id="directory-mobilePhone" value="<fmt:message bundle="${messages_directory}" key="directory.mobilePhone" />" />
	<input type="hidden" id="directory-fax" value="<fmt:message bundle="${messages_directory}" key="directory.fax" />" />
	<input type="hidden" id="directory-clientIPAddr" value="<fmt:message bundle="${messages_directory}" key="directory.clientIPAddr" />" />
	<input type="hidden" id="directory-business" value="<fmt:message bundle="${messages_directory}" key="directory.business" />" />
	
	<form id="directory-updateUserInfo-form" name="directory-updateUserInfo-form" method="post" enctype="multipart/form-data">
	
	<div>
		<div>
			<div class="title_area">
				<h2 class="title"><span title="HOME&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.title" />&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.userinfo.title" />"><fmt:message bundle="${messages_directory}" key="directory.env.userinfo.title" /></span></h2>
			</div>
			<!-- button : start -->
			<div class="btn_area">
				<ul class="btns">
					<li><span><a href="#" onclick="javascript:directory_updateUserInfo_updateUserInfo();"><fmt:message bundle="${messages_directory}" key="directory.ok" /></a></span></li>
				</ul>
			</div>
			<!-- button : end -->
			<div style="padding: 5px;">
				<!-- table : start -->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<col width="125px">
					<col width="">
					<tr>
						<td valign="top" align="left">
							<img id="directory-updateUserInfo-picture" src="<c:choose><c:when test="${empty user.pictureURL}"><c:out value="${CONTEXT}" /><fmt:message bundle="${messages_directory}" key="/directory/images/NOIMAGE.GIF" /></c:when><c:otherwise><c:out value="${CONTEXT}${user.pictureURL}" /></c:otherwise></c:choose>" width="120" />
						</td>
						<td valign="top">
							<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
								<col width="22%" />
								<col width="" />
								<tbody>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.userNameEng" /></th>
										<td><input type="text" class="intxt" style="width: 98.8%;" id="directory-updateUserInfo-userNameEng" name="userNameEng" maxlength="120" value="<c:out value="${user.nameEng}" />" /></td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.env.userinfo.picture" /></th>
										<td>
											<input type="file" id="directory-updateUserInfo-pictureFile" name="pictureFile" size="50" />
											<span class="inp_raochk"><input type="checkbox" id="directory-updateUserInfo-deletePicture" name="deletePicture" value="1" />
											<fmt:message bundle="${messages_directory}" key="directory.env.userinfo.deletePicture" /></span>
										</td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.en_email" /></th>
										<td><c:out value="${user.email}" /></td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.phone" /></th>
										<td><input type="text" class="intxt" style="width: 98.8%;" id="directory-updateUserInfo-phone" name="phone" maxlength="40" value="<c:out value="${user.phone}" />" /></td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.mobilePhone" /></th>
										<td><input type="text" class="intxt" style="width: 98.8%;" id="directory-updateUserInfo-mobilePhone" name="mobilePhone" maxlength="40" value="<c:out value="${user.mobilePhone}" />" /></td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.fax" /></th>
										<td><input type="text" class="intxt" style="width: 98.8%;" id="directory-updateUserInfo-fax" name="fax" maxlength="40" value="<c:out value="${user.fax}" />" /></td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.business" /></th>
										<td><textarea style="width: 100%;" id="directory-updateUserInfo-business" name="business" rows="4" wrap="virtual"><c:out value="${user.business}" /></textarea></td>
									</tr>
								</tbody>
							</table>
						</td>
					</tr>
				</table>
				<!-- table : end -->
			</div>
		</div>
	</div>
	
	</form>
</body>
</html>