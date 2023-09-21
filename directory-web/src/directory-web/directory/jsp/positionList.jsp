<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<script type="text/javascript">
		$(document).ready(function() {
			$("input[name='checkPosition']").each(function() {
				var o = new Recipient(POS + $(this).val(), POS + $("#checkPosition_" + $(this).val()).val());
				if (orgPopup.toList.contains(o)
						|| orgPopup.ccList.contains(o)
						|| orgPopup.bccList.contains(o)) {
					$(this).attr("checked", true);
				}
			});
		});
		
		$(function() {
			$("#checkPositionAll").click(function() {
				orgPopup.togglePositionAll();
			});
			$("input[name='checkPosition']").click(function() {
				orgPopup.togglePosition($(this));
			});
			$("#directory-table-positionList tr").dblclick(function() {
				var selectObj = $(this).find("input[name='checkPosition']");
				if (selectObj.length == 0 || selectObj.is(":disabled")) {
					return;
				}
				selectObj.attr("checked", (selectObj.is(":checked") ? false : true));
				orgPopup.togglePosition(selectObj);
				if (typeof itemDblClick != "undefined" && selectObj.is(":checked")) {
					itemDblClick();
				}
			});
		});
	</script>
</head>
<body>
	<!-- table : start -->
	<table id="directory-table-positionList" class="content_lst" border="0" cellspacing="0" cellpadding="0" style="border-bottom: 0;">
		<col width="33px">
		<col width="">
		<tr>
			<th scope="col" class="input_chk"><c:if test="${param.selectMode == 2}"><input type="checkbox" class="inchk" id="checkPositionAll" /></c:if></th>
			<th scope="col" class="cen"><fmt:message key="org.position" /></th>
		</tr>
		<tbody>
		<c:forEach var="position" items="${positionList}">
			<c:if test="${IS_ENGLISH}">
				<c:if test="${not empty position.nameEng}">
					<c:set target="${position}" property="name" value="${position.nameEng}" />
				</c:if>
			</c:if>
			<tr>
				<td class="input_chk">
					<input type="hidden" id="checkPosition_<c:out value="${position.ID}" />" value="<c:out value="${position.name}" />" />
					<input type="<c:if test="${param.selectMode == 1}">checkbox</c:if><c:if test="${param.selectMode == 2}">checkbox</c:if>" class="inchk" name="checkPosition" value="<c:out value="${position.ID}" />" />
				</td>
				<td title="<c:out value="${position.name}" />"><c:out value="${position.name}" /></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<!-- table : end -->
</body>
</html>