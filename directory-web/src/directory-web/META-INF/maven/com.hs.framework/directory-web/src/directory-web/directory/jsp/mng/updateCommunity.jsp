<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.communityMng.update" /> -->
	
	<script type="text/javascript">
		function directory_updateCommunity_onLoad() {
		}
	</script>
</head>
<body onload="directory_updateCommunity_onLoad()">
	<input type="hidden" id="directory-updateCommunity-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.update.confirm" />" />
	<input type="hidden" id="directory-updateCommunity-communityAdded" value="<fmt:message bundle="${messages_directory}" key="directory.update.communityUpdated" />" />
	<input type="hidden" id="directory-updateCommunity-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-updateCommunity-inputCommunityName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputCommunityName" />" />
	<input type="hidden" id="directory-updateCommunity-inputCommunityAlias" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputCommunityAlias" />" />
	<input type="hidden" id="directory-updateCommunity-invalidCommunityAlias" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCommunityAlias" />" />
	<input type="hidden" id="directory-updateCommunity-inputCommunityManagerName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputCommunityManagerName" />" />
	<input type="hidden" id="directory-updateCommunity-inputCommunityMaxUser" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputCommunityMaxUser" />" />
	<input type="hidden" id="directory-updateCommunity-invalidCommunityMaxUser" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCommunityMaxUser" />" />
	<input type="hidden" id="directory-updateCommunity-invalidCommunityExpiryDate" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCommunityExpiryDate" />" />
	<input type="hidden" id="directory-updateCommunity-inputCommunityExpiryDate" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputCommunityExpiryDate" />" />
	<input type="hidden" id="directory-updateCommunity-inputCommunityEmail" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputCommunityEmail" />" />
	<input type="hidden" id="directory-updateCommunity-invalidEmailError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidEmailError" />" />
	<input type="hidden" id="directory-updateCommunity-dupCommunityName" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupCommunityName" />" />
	<input type="hidden" id="directory-updateCommunity-dupCommunityAlias" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupCommunityAlias" />" />
	
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
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.communityMng.update" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_history.back();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.updateCommunity('<c:out value="${community.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
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
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-updateCommunity-communityName" maxlength="60" value="<c:out value="${community.name}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityAlias" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="2" id="directory-updateCommunity-communityAlias" maxlength="60" value="<c:out value="${community.alias}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityManagerName" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="3" id="directory-updateCommunity-communityManagerName" maxlength="60" value="<c:out value="${community.managerName}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityMaxUser" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="4" id="directory-updateCommunity-communityMaxUser" maxlength="10" value="<c:out value="${community.maxUser}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityExpiryDate" /></th>
								<td>
									<input type="text" class="intxt" style="width: 40%;" tabindex="5" id="directory-updateCommunity-communityExpiryDate" maxlength="10" value="<fmt:formatDate value="${community.expiryDate}" pattern="yyyy.MM.dd" />" /> ex) 2012.12.31
									<span class="inp_raochk_right"><input type="checkbox" tabindex="6" id="directory-updateCommunity-communityExpiryDateUnlimited" <c:if test="${community.expiryDate == null}">checked="checked"</c:if>/><fmt:message bundle="${messages_directory}" key="directory.unlimited" /></span>
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
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="7" id="directory-updateCommunity-communityPhone" maxlength="40" value="<c:out value="${community.phone}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityFax" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="8" id="directory-updateCommunity-communityFax" maxlength="40" value="<c:out value="${community.fax}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityHomeUrl" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="9" id="directory-updateCommunity-communityHomeUrl" maxlength="200" value="<c:out value="${community.homeUrl}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityEmail" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="10" id="directory-updateCommunity-communityEmail" maxlength="128" value="<c:out value="${community.email}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.communityDefaultLocale" /></th>
								<td>
									<select tabindex="11" id="directory-updateCommunity-communityDefaultLocale">
										<c:forTokens var="locale" items="${localeList}" delims=",">
											<option value='<c:out value="${locale}"/>' <c:if test="${locale eq community.defaultLocale}">selected</c:if>>
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