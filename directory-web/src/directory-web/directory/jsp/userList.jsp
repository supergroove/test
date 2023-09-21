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
		function directory_userList_viewUserSpec(userID, event) {
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
			$("input[name='checkUser']").each(function() {
				var o = new Recipient($(this).val(), $("#checkUser_" + $(this).val()).val(), $("#checkDept_" + $(this).val()).val(), $("#checkDeptName_" + $(this).val()).val());
				if (orgPopup.toList.contains(o)
						|| orgPopup.ccList.contains(o)
						|| orgPopup.bccList.contains(o)) {
					$(this).attr("checked", true);
				}
				if ($("#notUseUser").val() && $("#notUseUser").val().indexOf($(this).val()) > -1) {
					$(this).attr("disabled", true);
				}
			});
			
			if ($("#userSearchType").val() == "role") {
				$("#name-search").hide();
				$("#role-search").show();
			} else {
				$("#name-search").show();
				$("#role-search").hide();
			}
		});
		
		$(function() {
			$("#userSearchType").change(function() {
				if ($(this).val() == "role") {
					$('#userSearchValue').val('');
					$("#name-search").hide();
					$("#role-search").show();
				} else {
					$("#userSearchRole option[value='']").attr("selected", true);
					$("#role_subdept").attr("checked", false);
					$("#name-search").show();
					$("#role-search").hide();
				}
			});
			$("#userSearchValue").keypress(function(event) {
				if (event.keyCode == 13) {
					event.keyCode = 0;
					orgPopup.searchUser();
				}
			});
			$("#userSearchButton").click(function() {
				orgPopup.searchUser();
			});
			$("#checkUserAll").click(function() {
				orgPopup.toggleUserAll();
			});
			$("input[name='checkUser']").click(function() {
				orgPopup.toggleUser($(this));
				if (typeof itemClick != "undefined") {
					itemClick();
				}
			});
			$("#directory-table-userList tr").dblclick(function() {
				var selectObj = $(this).find("input[name='checkUser']");
				if (selectObj.length == 0 || selectObj.is(":disabled")) {
					return;
				}
				selectObj.attr("checked", (selectObj.is(":checked") ? false : true));
				
				orgPopup.toggleUser(selectObj);
				if (typeof itemDblClick != "undefined" && selectObj.is(":checked")) {
					itemDblClick();
				}
			});
		});
	</script>
</head>
<body>
	<!-- search : start -->
	<div class="srch_area" style="margin-top: 5px;">
		<fieldset class="search">
			<legend><fmt:message key="directory.search" /></legend>
			<select id="userSearchType">
				<option value="name" <c:if test="${param.searchType == 'name'}">selected="selected"</c:if>><fmt:message key="user.name" /></option>
				<option value="pos" <c:if test="${param.searchType == 'pos'}">selected="selected"</c:if>><fmt:message key="user.position" /></option>
			<c:if test="${display.charger}">
				<option value="role" <c:if test="${param.searchType == 'role'}">selected="selected"</c:if>><fmt:message key="org.charge" /></option>
			</c:if>
			</select>
			<span id="name-search" style="float: left;">
				<input type="text" id="userSearchValue" maxlength="60" value="<c:out value="${param.searchValue}" />" />
				<a class="srch_btn" href="#" id="userSearchButton"><fmt:message key="directory.search" /></a>
			</span>
			<span id="role-search" style="line-height: 22px; float: left;">
				<select id="userSearchRole" onchange="javascript:orgPopup.searchUser();">
					<option value="" <c:if test="${empty param.searchRole}">selected="selected"</c:if>><fmt:message key="org.select" /></option>
				<c:if test="${dutiesUsed.all or dutiesUsed.lieutenant}">
					<option value="S1" <c:if test="${param.searchRole == 'S1'}">selected="selected"</c:if>><fmt:message key="duty.lieutenant" /></option>
				</c:if>
				<c:if test="${dutiesUsed.all or dutiesUsed.deptmanager}">
					<option value="D5" <c:if test="${param.searchRole == 'D5'}">selected="selected"</c:if>><fmt:message key="duty.deptmanager" /></option>
				</c:if>
				<c:if test="${dutiesUsed.all or dutiesUsed.documentmanager}">
					<option value="D4" <c:if test="${param.searchRole == 'D4'}">selected="selected"</c:if>><fmt:message key="duty.documentmanager" /></option>
				</c:if>
				<c:if test="${dutiesUsed.all or dutiesUsed.sendreceivemanager}">
					<option value="D1" <c:if test="${param.searchRole == 'D1'}">selected="selected"</c:if>><fmt:message key="duty.sendreceivemanager" /></option>
				</c:if>
				<c:if test="${dutiesUsed.all or dutiesUsed.addressbookmanager}">
					<option value="D3" <c:if test="${param.searchRole == 'D3'}">selected="selected"</c:if>><fmt:message key="duty.addressbookmanager" /></option>
				</c:if>
				<c:if test="${dutiesUsed.all or dutiesUsed.schedulemanager}">
					<option value="D2" <c:if test="${param.searchRole == 'D2'}">selected="selected"</c:if>><fmt:message key="duty.schedulemanager" /></option>
				</c:if>
				</select>
				<span class="inp_raochk"><input type="checkbox" style="border: 0px;" id="role_subdept" onclick="javascript:orgPopup.searchUser();" <c:if test="${param.role_subdept}">checked="checked"</c:if> /><fmt:message key="message.subdeptinclusion" /></span>
				<input type="hidden" id="userSearchBase" value="<c:out value="${param.deptID}" />" />
			</span>
		</fieldset>
	</div>
	<!-- search : end -->
	<!-- table : start -->
	<table id="directory-table-userList" class="content_lst no_btn" border="0" cellspacing="0" cellpadding="0" style="border-bottom: 0;">
		<col width="33px">
		<col width="">
		<col width="">
		<col width="">
		<tr>
			<th scope="col" class="input_chk"><c:if test="${param.selectMode == 2 && !display.userSingle}"><input type="checkbox" class="inchk" id="checkUserAll" /></c:if></th>
			<th scope="col" class="cen"><fmt:message key="user.name" /></th>
			<th scope="col" class="cen"><fmt:message key="user.dept" /></th>
			<th scope="col" class="cen"><fmt:message key="user.position" /></th>
		</tr>
		<tbody>
		<c:set var="count" value="0" scope="page" />
		<c:forEach var="user" items="${userList}" varStatus="loop">
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
					<input type="hidden" id="checkUser_<c:out value="${user.ID}" />" value="<c:out value="${user.name}" />" />
					<input type="hidden" id="checkDept_<c:out value="${user.ID}" />" value="<c:out value="${user.deptID}" />" />
					<input type="hidden" id="checkDeptName_<c:out value="${user.ID}" />" value="<c:out value="${user.deptName}" />" />
					<input type="<c:choose><c:when test="${param.selectMode == 1 || display.userSingle}">checkbox</c:when><c:when test="${param.selectMode == 2}">checkbox</c:when></c:choose>" class="inchk" name="checkUser" value="<c:out value="${user.ID}" />" <c:if test="${param.openerType == 'M' && empty user.email}">disabled="disabled"</c:if> />
				</td>
				<td title="<c:out value="${user.name}" />">
					<c:choose>
					<c:when test="${useDetailUser}">
						<a href="#" onclick="javascript:directory_userList_viewUserSpec('<c:out value="${user.ID}" />', event);"><c:out value="${user.name}" /></a>
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
		<c:forEach var="i" begin="${count}" end="8">
			<tr>
			<c:choose>
			<c:when test="${count == 0 && i == 1}">
				<td colspan="4" class="cen">
				<c:choose>
				<c:when test="${param.searchType == 'role'}">
					<fmt:message key="duty.nocharge" />
				</c:when>
				<c:otherwise>
					<fmt:message key="user.notuser" />
				</c:otherwise>
				</c:choose>
				</td>
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