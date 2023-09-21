<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<script type="text/javascript">
		$(document).ready(function() {
			$("input[name='checkContact']").each(function() {
				var o = new Recipient($(this).val(), $(this).val());
				if (orgPopup.toList.contains(o)
						|| orgPopup.ccList.contains(o)
						|| orgPopup.bccList.contains(o)) {
					$(this).attr("checked", true);
				}
			});
			$("input[name='checkContact']:visible").length > 0 ? $("#contactList_NoData").hide() : $("#contactList_NoData").show();
		});
		
		$(function() {
			$("#contactSearchValue").keypress(function(event) {
				if (event.keyCode == 13) {
					event.keyCode = 0;
					orgPopup.searchContact();
				}
			});
			$("#contactSearchButton").click(function() {
				orgPopup.searchContact();
			});
			$("#checkContactAll").click(function() {
				orgPopup.toggleContactAll();
			});
			$("input[name='checkContact']").click(function() {
				orgPopup.toggleContact($(this));
			});
			$("#directory-table-contactList tr").dblclick(function() {
				var selectObj = $(this).find("input[name='checkContact']");
				if (selectObj.length == 0 || selectObj.is(":disabled")) {
					return;
				}
				selectObj.attr("checked", (selectObj.is(":checked") ? false : true));
				orgPopup.toggleContact(selectObj);
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
			<select id="contactSearchType">
				<option value="name"><fmt:message key="org.member.name" /></option>
				<option value="email"><fmt:message key="org.member.email" /></option>
				<option value="company"><fmt:message key="org.member.office" /></option>
			</select>
			<input type="text" id="contactSearchValue" maxlength="60" />
			<a class="srch_btn" href="#" id="contactSearchButton"><fmt:message key="directory.search" /></a>
		</fieldset>
	</div>
	<!-- search : end -->
	<!-- table : start -->
	<table id="directory-table-contactList" class="content_lst no_btn" border="0" cellspacing="0" cellpadding="0" style="border-bottom: 0;">
		<col width="33px">
		<col width="">
		<col width="">
		<col width="">
		<tr>
			<th scope="col" class="input_chk"><c:if test="${param.selectMode == 2}"><input type="checkbox" class="inchk" id="checkContactAll" /></c:if></th>
			<th scope="col" class="cen"><fmt:message key="org.member.name" /></th>
			<th scope="col" class="cen"><fmt:message key="org.member.email" /></th>
			<th scope="col" class="cen"><fmt:message key="org.member.office" /></th>
		</tr>
		<tbody>
		<c:forEach var="contact" items="${contactList}">
			<tr>
				<td class="input_chk">
					<input type="<c:if test="${param.selectMode == 1}">checkbox</c:if><c:if test="${param.selectMode == 2}">checkbox</c:if>" class="inchk" name="checkContact" value="<c:out value="${contact.name}" /> &lt;<c:out value="${contact.email}" />&gt;" <c:if test="${empty contact.email}">disabled="disabled"</c:if> />
				</td>
				<td title="<c:out value="${contact.name}" />"><c:out value="${contact.name}" /></td>
				<td title="<c:out value="${contact.email}" />"><c:out value="${contact.email}" /></td>
				<td title="<c:out value="${contact.company}" />"><c:out value="${contact.company}" /></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<table id="contactList_NoData" class="content_lst" border="0" cellspacing="0" cellpadding="0" style="border-bottom: 0;">
		<col width="">
		<tbody>
		<c:forEach var="i" begin="0" end="2">
			<tr>
			<c:choose>
			<c:when test="${i == 1}">
				<td class="cen"><fmt:message key="org.member.notinformation" /></td>
			</c:when>
			<c:otherwise>
				<td></td>
			</c:otherwise>
			</c:choose>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<!-- table : end -->
</body>
</html>