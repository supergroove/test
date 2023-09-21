<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<script type="text/javascript">
		$(document).ready(function() {
			$("input[name='checkMember_User']").each(function() {
				var o = new Recipient($(this).val(), $("#checkMember_User_" + $(this).val()).val(), $("#checkMember_Dept_" + $(this).val()).val(), $("#checkMember_DeptName_" + $(this).val()).val(), "G");
				if (orgPopup.toList.contains(o)
						|| orgPopup.ccList.contains(o)
						|| orgPopup.bccList.contains(o)) {
					$(this).attr("checked", true);
				}
				if ($("#notUseUser").val() && $("#notUseUser").val().indexOf($(this).val()) > -1) {
					$(this).attr("disabled", true);
				}
			});
			$("input[name='checkMember_SubDept']").each(function() {
				var o = new Recipient(SDEPT + $(this).val(), SDEPT + $("#checkMember_SubDept_" + $(this).val()).val(), "", "", "G");
				if (orgPopup.toList.contains(o)
						|| orgPopup.ccList.contains(o)
						|| orgPopup.bccList.contains(o)) {
					$(this).attr("checked", true);
				}
				if ($("#notUseDept").val() && $("#notUseDept").val().indexOf($(this).val()) > -1) {
					$(this).attr("disabled", true);
				}
			});
			$("input[name='checkMember_Dept']").each(function() {
				var o = new Recipient(DEPT + $(this).val(), DEPT + $("#checkMember_Dept_" + $(this).val()).val(), "", "", "G");
				if (orgPopup.toList.contains(o)
						|| orgPopup.ccList.contains(o)
						|| orgPopup.bccList.contains(o)) {
					$(this).attr("checked", true);
				}
				if ($("#notUseDept").val() && $("#notUseDept").val().indexOf($(this).val()) > -1) {
					$(this).attr("disabled", true);
				}
			});
			$("input[name='checkMember_Email']").each(function() {
				var o = new Recipient($(this).val(), $(this).val(), "", "", "G");
				if (orgPopup.toList.contains(o)
						|| orgPopup.ccList.contains(o)
						|| orgPopup.bccList.contains(o)) {
					$(this).attr("checked", true);
				}
			});
			$("input[name^='checkMember_']:visible").length > 0 ? $("#memberList_NoData").hide() : $("#memberList_NoData").show();
		});
		
		$(function() {
			$("#memberSearchValue").keypress(function(event) {
				if (event.keyCode == 13) {
					event.keyCode = 0;
					orgPopup.searchMember();
				}
			});
			$("#memberSearchButton").click(function() {
				orgPopup.searchMember();
			});
			
			$("#checkMember_UserAll").click(function() {
				orgPopup.toggleMember_All('USER');
			});
			$("#checkMember_SubDeptAll").click(function() {
				orgPopup.toggleMember_All('SDEPT');
			});
			$("#checkMember_DeptAll").click(function() {
				orgPopup.toggleMember_All('DEPT');
			});
			$("#checkMember_EmailAll").click(function() {
				orgPopup.toggleMember_All('EMAIL');
			});
			
			$("input[name='checkMember_User']").click(function() {
				orgPopup.toggleMember('USER', $(this));
			});
			$("input[name='checkMember_SubDept']").click(function() {
				orgPopup.toggleMember('SDEPT', $(this));
			});
			$("input[name='checkMember_Dept']").click(function() {
				orgPopup.toggleMember('DEPT', $(this));
			});
			$("input[name='checkMember_Email']").click(function() {
				orgPopup.toggleMember('EMAIL', $(this));
			});
			$("#memberList_User tr").dblclick(function() {
				var selectObj = $(this).find("input[name='checkMember_User']");
				if (selectObj.length == 0 || selectObj.is(":disabled")) {
					return;
				}
				selectObj.attr("checked", (selectObj.is(":checked") ? false : true));
				orgPopup.toggleMember('USER', selectObj);
				if (typeof itemDblClick != "undefined" && selectObj.is(":checked")) {
					itemDblClick();
				}
			});
			$("#memberList_SubDept tr").dblclick(function() {
				var selectObj = $(this).find("input[name='checkMember_SubDept']");
				if (selectObj.length == 0 || selectObj.is(":disabled")) {
					return;
				}
				selectObj.attr("checked", (selectObj.is(":checked") ? false : true));
				orgPopup.toggleMember('SDEPT', selectObj);
				if (typeof itemDblClick != "undefined" && selectObj.is(":checked")) {
					itemDblClick();
				}
			});
			$("#memberList_Dept tr").dblclick(function() {
				var selectObj = $(this).find("input[name='checkMember_Dept']");
				if (selectObj.length == 0 || selectObj.is(":disabled")) {
					return;
				}
				selectObj.attr("checked", (selectObj.is(":checked") ? false : true));
				orgPopup.toggleMember('DEPT', selectObj);
				if (typeof itemDblClick != "undefined" && selectObj.is(":checked")) {
					itemDblClick();
				}
			});
			$("#memberList_Email tr").dblclick(function() {
				var selectObj = $(this).find("input[name='checkMember_Email']");
				if (selectObj.length == 0 || selectObj.is(":disabled")) {
					return;
				}
				selectObj.attr("checked", (selectObj.is(":checked") ? false : true));
				orgPopup.toggleMember('EMAIL', selectObj);
				if (typeof itemDblClick != "undefined" && selectObj.is(":checked")) {
					itemDblClick();
				}
			});
		});
	</script>
</head>
<body>
<c:choose>
	<c:when test="${param.groupType == 'S'}">
	</c:when>
	<c:when test="${param.groupType == 'G'}">
	</c:when>
	<c:otherwise>
		<!-- search : start -->
		<div class="srch_area" style="margin-top: 5px;">
			<fieldset class="search">
				<legend><fmt:message key="directory.search" /></legend>
				<select id="memberSearchType">
					<option value="name"><fmt:message key="org.member.name" /></option>
					<option value="dept"><fmt:message key="org.member.dept" /></option>
					<option value="pos"><fmt:message key="org.member.position" /></option>
				</select>
				<input type="text" id="memberSearchValue" maxlength="60" />
				<a class="srch_btn" href="#" id="memberSearchButton"><fmt:message key="directory.search" /></a>
			</fieldset>
		</div>
		<!-- search : end -->
	</c:otherwise>
</c:choose>
	
<c:if test="${not empty userList}">
	<table id="memberList_User" class="content_lst no_btn" border="0" cellspacing="0" cellpadding="0" style="border-bottom: 0;">
		<col width="33px">
		<col width="">
		<col width="">
		<col width="">
		<tr>
			<th scope="col" class="input_chk"><c:if test="${param.selectMode == 2}"><input type="checkbox" class="inchk" id="checkMember_UserAll" /></c:if></th>
			<th scope="col" class="cen"><fmt:message key="org.member.name" /></th>
			<th scope="col" class="cen"><fmt:message key="org.member.dept" /></th>
			<th scope="col" class="cen"><fmt:message key="org.member.position" /></th>
		</tr>
		<tbody>
		<c:forEach var="user" items="${userList}">
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
					<input type="hidden" id="checkMember_User_<c:out value="${user.ID}" />" value="<c:out value="${user.name}" />" />
					<input type="hidden" id="checkMember_Dept_<c:out value="${user.ID}" />" value="<c:out value="${user.deptID}" />" />
					<input type="hidden" id="checkMember_DeptName_<c:out value="${user.ID}" />" value="<c:out value="${user.deptName}" />" />
					<input type="<c:if test="${param.selectMode == 1}">checkbox</c:if><c:if test="${param.selectMode == 2}">checkbox</c:if>" class="inchk" name="checkMember_User" value="<c:out value="${user.ID}" />" <c:if test="${param.openerType == 'M' && empty user.email}">disabled="disabled"</c:if> />
				</td>
				<td title="<c:out value="${user.name}" />"><c:out value="${user.name}" /></td>
				<td class="cen" title="<c:out value="${user.deptName}" />"><c:out value="${user.deptName}" /></td>
				<td class="cen" title="<c:out value="${user.positionName}" />"><c:out value="${user.positionName}" /></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</c:if>
<c:if test="${not empty subDeptList}">
	<table id="memberList_SubDept" class="content_lst no_btn" border="0" cellspacing="0" cellpadding="0" style="border-bottom: 0;">
		<col width="33px">
		<col width="">
		<tr>
			<th scope="col" class="input_chk"><c:if test="${param.selectMode == 2}"><input type="checkbox" class="inchk" id="checkMember_SubDeptAll" /></c:if></th>
			<th scope="col" class="cen"><fmt:message key="org.member.subdept" /></th>
		</tr>
		<tbody>
		<c:forEach var="subdept" items="${subDeptList}">
			<c:if test="${IS_ENGLISH}">
				<c:if test="${not empty subdept.nameEng}">
					<c:set target="${subdept}" property="name" value="${subdept.nameEng}" />
				</c:if>
			</c:if>
			<tr>
				<td class="input_chk">
					<input type="hidden" id="checkMember_SubDept_<c:out value="${subdept.ID}" />" value="<c:out value="${subdept.name}" />" />
					<input type="<c:if test="${param.selectMode == 1}">checkbox</c:if><c:if test="${param.selectMode == 2}">checkbox</c:if>" class="inchk" name="checkMember_SubDept" value="<c:out value="${subdept.ID}" />" />
				</td>
				<td title="<c:out value="${subdept.name}" />"><c:out value="${subdept.name}" /></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</c:if>
<c:if test="${not empty deptList}">
	<table id="memberList_Dept" class="content_lst no_btn" border="0" cellspacing="0" cellpadding="0" style="border-bottom: 0;">
		<col width="33px">
		<col width="">
		<tr>
			<th scope="col" class="input_chk"><c:if test="${param.selectMode == 2}"><input type="checkbox" class="inchk" id="checkMember_DeptAll" /></c:if></th>
			<th scope="col" class="cen"><fmt:message key="org.member.dept" /></th>
		</tr>
		<tbody>
		<c:forEach var="dept" items="${deptList}">
			<c:if test="${IS_ENGLISH}">
				<c:if test="${not empty dept.nameEng}">
					<c:set target="${dept}" property="name" value="${dept.nameEng}" />
				</c:if>
			</c:if>
			<tr>
				<td class="input_chk">
					<input type="hidden" id="checkMember_Dept_<c:out value="${dept.ID}" />" value="<c:out value="${dept.name}" />" />
					<input type="<c:if test="${param.selectMode == 1}">checkbox</c:if><c:if test="${param.selectMode == 2}">checkbox</c:if>" class="inchk" name="checkMember_Dept" value="<c:out value="${dept.ID}" />" />
				</td>
				<td title="<c:out value="${dept.name}" />"><c:out value="${dept.name}" /></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</c:if>
<c:if test="${not empty emailList}">
	<table id="memberList_Email" class="content_lst no_btn" border="0" cellspacing="0" cellpadding="0" style="border-bottom: 0;">
		<col width="33px">
		<col width="">
		<tr>
			<th scope="col" class="input_chk"><c:if test="${param.selectMode == 2}"><input type="checkbox" class="inchk" id="checkMember_EmailAll" /></c:if></th>
			<th scope="col" class="cen"><fmt:message key="org.member.email" /></th>
		</tr>
		<tbody>
		<c:forEach var="member" items="${emailList}">
			<tr>
				<td class="input_chk">
					<input type="<c:if test="${param.selectMode == 1}">checkbox</c:if><c:if test="${param.selectMode == 2}">checkbox</c:if>" class="inchk" name="checkMember_Email" value="<c:out value="${member.email}" />" <c:if test="${empty member.email}">disabled="disabled"</c:if> />
				</td>
				<td title="<c:out value="${member.email}" />"><c:out value="${member.email}" /></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</c:if>
	<table id="memberList_NoData" class="content_lst no_btn" border="0" cellspacing="0" cellpadding="0" style="border-bottom: 0;">
		<col width="33px">
		<col width="">
		<col width="">
		<col width="">
		<tr>
			<th scope="col" class="input_chk"><c:if test="${param.selectMode == 2}"><input type="checkbox" class="inchk" /></c:if></th>
			<th scope="col" class="cen"><fmt:message key="org.member.name" /></th>
			<th scope="col" class="cen"><fmt:message key="org.member.dept" /></th>
			<th scope="col" class="cen"><fmt:message key="org.member.position" /></th>
		</tr>
		<tbody>
		<c:forEach var="i" begin="0" end="2">
			<tr>
			<c:choose>
			<c:when test="${i == 1}">
				<td colspan="4" class="cen"><fmt:message key="org.member.notinformation" /></td>
			</c:when>
			<c:otherwise>
				<td colspan="4"></td>
			</c:otherwise>
			</c:choose>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</body>
</html>