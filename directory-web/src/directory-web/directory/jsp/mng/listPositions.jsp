<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.positionMng" /> -->
	
	<script type="text/javascript">
		function directory_listPositions_onLoad() {
			$("#directory-listPositions-checkAll").click(function() {
				directory_listPositions_toggleAll();
			});
			$("input[name='directory-listPositions-check']").click(function() {
				directory_listPositions_toggle($(this));
			});
		}
		
		function directory_listPositions_toggleAll() {
			if ($("#directory-listPositions-checkAll").is(":checked")) {
				$("input[name='directory-listPositions-check']").each(function() {
					if (!$(this).is(":disabled") && !$(this).is(":checked")) {
						$(this).attr("checked", true);
					}
				});
			} else {
				$("input[name='directory-listPositions-check']").each(function() {
					if (!$(this).is(":disabled") && $(this).is(":checked")) {
						$(this).attr("checked", false);
					}
				});
			}
		}
		
		function directory_listPositions_toggle(obj) {
			if ($("#directory-listPositions-checkAll").is(":checked") && !obj.is(":checked")) {
				$("#directory-listPositions-checkAll").attr("checked", false);
			}
		}
	</script>
</head>
<body onload="directory_listPositions_onLoad()">
	<input type="hidden" id="directory-deletePositions-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-deletePositions-positionDeleted" value="<fmt:message bundle="${messages_directory}" key="directory.delete.positionDeleted" />" />
	<input type="hidden" id="directory-deletePositions-usedPositionError" value="<fmt:message bundle="${messages_directory}" key="directory.delete.usedPositionError" />" />
	<input type="hidden" id="directory-listPositions-selectItem" value="<fmt:message bundle="${messages_directory}" key="directory.selectItem" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.positionMng" /></div>
		<ul class="btns">
		<c:if test="${isAdmin}">
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewAddPosition();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.deletePositions();"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
		</c:if>
		</ul>
	</div>
	<!-- button : end -->
	<!-- table : start -->
	<table class="content_lst" border="0" cellspacing="0" cellpadding="0">
		<col width="33px">
		<col width="150px">
		<col width="300px">
		<col width="">
		<col width="150px">
		<tr>
			<th scope="col" class="input_chk">
			<c:if test="${isAdmin}">
				<input type="checkbox" class="inchk" id="directory-listPositions-checkAll" />
			</c:if>
			</th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.positionCode" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.positionName" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.positionNameEng" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.secLevel" /></th>
		</tr>
		<tbody>
		<c:forEach var="position" items="${positionList}">
			<tr>
				<td class="input_chk">
				<c:if test="${isAdmin}">
					<input type="checkbox" class="inchk" name="directory-listPositions-check" value="<c:out value="${position.ID}" />" />
				</c:if>
				</td>
				<td title="<c:out value="${position.code}" />"><c:out value="${position.code}" /></td>
				<td title="<c:out value="${position.name}" />">
				<c:if test="${isAdmin}"><a href="#" onclick="javascript:directory_orgMng.viewUpdatePosition('<c:out value="${position.ID}" />');" onfocus="blur();"></c:if>
					<c:out value="${position.name}" />
				<c:if test="${isAdmin}"></a></c:if>
				</td>
				<td title="<c:out value="${position.nameEng}" />"><c:out value="${position.nameEng}" /></td>
				<td class="cen" title="<c:out value="${position.securityLevel}" />"><c:out value="${position.securityLevel}" /></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<!-- table : end -->
	<div class="paginate_area"></div>
</body>
</html>