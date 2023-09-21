<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/common/divPopup.js"></script> <!-- required - must exist "div" element for sportal -->
<c:if test="${not empty detailUserSrc}">
	<script type="text/javascript" src="<c:out value="${detailUserSrc}" />"></script>
</c:if>
	
	<script type="text/javascript">
		function directory_dirGroupMemberList_viewUserSpec(userID, event) {
		<c:choose>
		<c:when test="${not empty detailUserCmd}">
			<c:out value="${detailUserCmd}" />;
		</c:when>
		<c:otherwise>
			orgPopup.viewUserSpec(userID);
		</c:otherwise>
		</c:choose>
		}
		
		$(document).ready(function() {
			$("input[name='directory-dirGroupMemberList-check']").each(function() {
				var o = new Recipient($(this).val(), $("#directory-dirGroupMemberList-userName_" + $(this).val()).val(), $("#directory-dirGroupMemberList-deptID_" + $(this).val()).val(), $("#directory-dirGroupMemberList-deptName_" + $(this).val()).val());
				if (orgPopup.toList.contains(o)
						|| orgPopup.ccList.contains(o)
						|| orgPopup.bccList.contains(o)) {
					$(this).attr("checked", true);
				}
				if ($("#notUseUser").val() && $("#notUseUser").val().indexOf($(this).val()) > -1) {
					$(this).attr("disabled", true);
				}
			});
		});
		
		$(function() {
			/*$("#directory-dirGroupMemberList-searchValue").keypress(function(event) {
				if (event.keyCode == 13) {
					event.keyCode = 0;
					orgPopup.searchDirGroupMember();
				}
			});
			$("#directory-dirGroupMemberList-searchButton").click(function() {
				orgPopup.searchDirGroupMember();
			});*/
			$("#directory-dirGroupMemberList-checkAll").click(function() {
				orgPopup.toggleDirGroupMemberAll();
			});
			$("input[name='directory-dirGroupMemberList-check']").click(function() {
				orgPopup.toggleDirGroupMember($(this));
				if (typeof itemClick != "undefined") {
					itemClick();
				}
			});
			$("#directory-table-dirGroupMemberList tr").dblclick(function() {
				var selectObj = $(this).find("input[name='directory-dirGroupMemberList-check']");
				if (selectObj.length == 0 || selectObj.is(":disabled")) {
					return;
				}
				selectObj.attr("checked", (selectObj.is(":checked") ? false : true));
				
				orgPopup.toggleDirGroupMember(selectObj);
				if (typeof itemDblClick != "undefined" && selectObj.is(":checked")) {
					itemDblClick();
				}
			});
		});
	</script>
</head>
<body>
	<!-- search : start -->
	<!--div class="srch_area" style="margin-top: 5px;">
		<fieldset class="search">
			<legend><fmt:message key="directory.search" /></legend>
			<select id="directory-dirGroupMemberList-searchType">
				<option value="name"><fmt:message key="org.member.name" /></option>
				<option value="dept"><fmt:message key="org.member.dept" /></option>
				<option value="pos"><fmt:message key="org.member.position" /></option>
			</select>
			<input type="text" id="directory-dirGroupMemberList-searchValue" maxlength="60" />
			<a class="srch_btn" href="#" id="directory-dirGroupMemberList-searchButton"><fmt:message key="directory.search" /></a>
		</fieldset>
	</div-->
	<!-- search : end -->
	<!-- table : start -->
	<table id="directory-table-dirGroupMemberList" class="content_lst no_btn" border="0" cellspacing="0" cellpadding="0" style="border-bottom: 0; border-top: 0;">
		<col width="33px">
		<col width="">
		<col width="">
		<col width="">
		<tr>
			<th scope="col" class="input_chk"><c:if test="${param.selectMode == 2 && !display.userSingle}"><input type="checkbox" class="inchk" id="directory-dirGroupMemberList-checkAll" /></c:if></th>
			<th scope="col" class="cen"><fmt:message key="user.name" /></th>
			<th scope="col" class="cen"><fmt:message key="user.dept" /></th>
			<th scope="col" class="cen"><fmt:message key="user.position" /></th>
		</tr>
		<tbody>
		<c:set var="count" value="0" scope="page" />
		<c:forEach var="user" items="${memberList}" varStatus="loop">
			<c:if test="${IS_ENGLISH}">
				<c:if test="${not empty user.nameEng}">
					<c:set target="${user}" property="name" value="${user.nameEng}" />
				</c:if>
				<c:if test="${not empty user.deptNameEng}">
					<c:set target="${user}" property="deptName" value="${user.deptNameEng}" />
				</c:if>
				<c:if test="${not empty user.positionNameEng}">
					<c:set target="${user}" property="positionName" value="${user.positionNameEng}" />
				</c:if>
			</c:if>
			<tr>
				<td class="input_chk">
					<input type="hidden" id="directory-dirGroupMemberList-userName_<c:out value="${user.ID}" />" value="<c:out value="${user.name}" />" />
					<input type="hidden" id="directory-dirGroupMemberList-deptID_<c:out value="${user.ID}" />" value="<c:out value="${user.deptID}" />" />
					<input type="hidden" id="directory-dirGroupMemberList-deptName_<c:out value="${user.ID}" />" value="<c:out value="${user.deptName}" />" />
					<input type="<c:choose><c:when test="${param.selectMode == 1 || display.userSingle}">checkbox</c:when><c:when test="${param.selectMode == 2}">checkbox</c:when></c:choose>" class="inchk" name="directory-dirGroupMemberList-check" value="<c:out value="${user.ID}" />" <c:if test="${param.openerType == 'M' && empty user.email}">disabled="disabled"</c:if> />
				</td>
				<td title="<c:out value="${user.name}" />">
					<c:choose>
					<c:when test="${useDetailUser}">
						<a href="#" onclick="javascript:directory_dirGroupMemberList_viewUserSpec('<c:out value="${user.ID}" />', event);"><c:out value="${user.name}" /></a>
					</c:when>
					<c:otherwise>
						<c:out value="${user.name}" />
					</c:otherwise>
					</c:choose>
					<c:if test="${param.useAbsent && user.absent}"><fmt:message key="user.absence" /></c:if>
				</td>
				<td class="cen" title="<c:out value="${user.deptName}" />"><c:out value="${user.deptName}" /></td>
				<td class="cen" title="<c:out value="${user.positionName}" />"><c:out value="${user.positionName}" /></td>
			</tr>
			<c:if test="${loop.last}">
				<c:set var="count" value="${loop.count}" />
			</c:if>
		</c:forEach>
		<c:forEach var="i" begin="${count}" end="10">
			<tr>
			<c:choose>
			<c:when test="${count == 0 && i == 1}">
				<td colspan="4" class="cen"><fmt:message key="user.notuser" /></td>
			</c:when>
			<c:otherwise>
				<td colspan="4"></td>
			</c:otherwise>
			</c:choose>
			</tr>
		</c:forEach>
		<c:remove var="count" scope="page" />
		</tbody>
	</table>
	<!-- table : end -->
</body>
</html>