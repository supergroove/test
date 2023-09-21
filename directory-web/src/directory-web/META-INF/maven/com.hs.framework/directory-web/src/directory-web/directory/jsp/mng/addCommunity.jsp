<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.communityMng.add" /> -->
	
	<script type="text/javascript">
		function directory_addCommunity_onLoad() {
			$("#directory-addCommunity-communityName").focus();
		}
	</script>
</head>
<body onload="directory_addCommunity_onLoad()">
	<input type="hidden" id="directory-addCommunity-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.confirm" />" />
	<input type="hidden" id="directory-addCommunity-communityAdded" value="<fmt:message bundle="${messages_directory}" key="directory.add.communityAdded" />" />
	<input type="hidden" id="directory-addCommunity-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-addCommunity-inputCommunityName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputCommunityName" />" />
	<input type="hidden" id="directory-addCommunity-inputCommunityAlias" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputCommunityAlias" />" />
	<input type="hidden" id="directory-addCommunity-invalidCommunityAlias" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCommunityAlias" />" />
	<input type="hidden" id="directory-addCommunity-inputCommunityManagerName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputCommunityManagerName" />" />
	<input type="hidden" id="directory-addCommunity-inputCommunityMaxUser" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputCommunityMaxUser" />" />
	<input type="hidden" id="directory-addCommunity-invalidCommunityMaxUser" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCommunityMaxUser" />" />
	<input type="hidden" id="directory-addCommunity-invalidCommunityExpiryDate" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCommunityExpiryDate" />" />
	<input type="hidden" id="directory-addCommunity-inputCommunityExpiryDate" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputCommunityExpiryDate" />" />
	<input type="hidden" id="directory-addCommunity-inputCommunityEmail" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputCommunityEmail" />" />
	<input type="hidden" id="directory-addCommunity-invalidEmailError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidEmailError" />" />
	<input type="hidden" id="directory-addCommunity-dupCommunityName" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupCommunityName" />" />
	<input type="hidden" id="directory-addCommunity-dupCommunityAlias" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupCommunityAlias" />" />
	
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-maxLength-2" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength2" />" />
	<input type="hidden" id="directory-maxLength-3" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength3" />" />
	<input type="hidden" id="directory-communityName" value="<fmt:message bundle="${messages_directory}" key="directory.communityName" />" />
	<input type="hidden" id="directory-communityAlias" value="<fmt:message bundle="${messages_directory}" key="directory.communityAlias" />" />
	<input type="hidden" id="directory-communityManagerName" value="<fmt:message bundle="${messages_directory}" key="directory.communityManagerName" />" />
	<input type="hidden" id="directory-communityMaxUser" value="<fmt:message bundle="${messages_directory}" key="directory.communityMaxUser" />" />
	<input type="hidden" id="directory-communityExpiryDate" value="<fmt:message bundle="${messages_directory}" key="directory.communityExpiryDate" />" />
	<input type="hidden" id="directory-communityPhone" value="<fmt:message bundle="${messages_directory}" key="directory.communityPhone" />" />
	<input type="hidden" id="directory-communityFax" value="<fmt:message bundle="${messages_directory}" key="directory.communityFax" />" />
	<input type="hidden" id="directory-communityHomeUrl" value="<fmt:message bundle="${messages_directory}" key="directory.communityHomeUrl" />" />
	<input type="hidden" id="directory-communityEmail" value="<fmt:message bundle="${messages_directory}" key="directory.communityEmail" />" />
		
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.communityMng.add" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_history.back();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.addCommunity();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
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
								<th><fmt:message bundle="${messages_directory}" key="directory.communityName" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-addCommunity-communityName" maxlength="60" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityAlias" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="2" id="directory-addCommunity-communityAlias" maxlength="60" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityManagerName" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="3" id="directory-addCommunity-communityManagerName" maxlength="60" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityMaxUser" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="4" id="directory-addCommunity-communityMaxUser" maxlength="10" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityExpiryDate" /></th>
								<td>
									<input type="text" class="intxt" style="width: 40%;" tabindex="5" id="directory-addCommunity-communityExpiryDate" maxlength="10" value="" /> ex) 2012.12.31
									<span class="inp_raochk_right"><input type="checkbox" tabindex="6" id="directory-addCommunity-communityExpiryDateUnlimited"/><fmt:message bundle="${messages_directory}" key="directory.unlimited" /></span>
								</td>
							</tr>
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
								<th><fmt:message bundle="${messages_directory}" key="directory.communityPhone" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="7" id="directory-addCommunity-communityPhone" maxlength="40" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityFax" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="8" id="directory-addCommunity-communityFax" maxlength="40" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityHomeUrl" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="9" id="directory-addCommunity-communityHomeUrl" maxlength="200" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityEmail" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="10" id="directory-addCommunity-communityEmail" maxlength="128" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityDefaultLocale" /></th>
								<td>
									<select tabindex="11" id="directory-addCommunity-communityDefaultLocale">
										<c:forTokens var="locale" items="${localeList}" delims=",">
											<option value='<c:out value="${locale}"/>' <c:if test="${locale eq LOCALE}">selected</c:if>>
												<fmt:message bundle="${messages_directory}" key="directory.lang.${locale}" />
											</option>
										</c:forTokens>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
		</table>
		<!-- table : end -->
	</div>
</body>
</html>