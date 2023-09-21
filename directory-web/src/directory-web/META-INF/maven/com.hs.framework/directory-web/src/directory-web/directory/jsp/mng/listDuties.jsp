<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.dutyMng" /> -->
	
	<script type="text/javascript">
		function directory_listDuties_onLoad() {
			$("#directory-listDuties-checkAll").click(function() {
				directory_listDuties_toggleAll();
			});
			$("input[name='directory-listDuties-check']").click(function() {
				directory_listDuties_toggle($(this));
			});
		}
		
		function directory_listDuties_toggleAll() {
			if ($("#directory-listDuties-checkAll").is(":checked")) {
				$("input[name='directory-listDuties-check']").each(function() {
					if (!$(this).is(":disabled") && !$(this).is(":checked")) {
						$(this).attr("checked", true);
					}
				});
			} else {
				$("input[name='directory-listDuties-check']").each(function() {
					if (!$(this).is(":disabled") && $(this).is(":checked")) {
						$(this).attr("checked", false);
					}
				});
			}
		}
		
		function directory_listDuties_toggle(obj) {
			if ($("#directory-listDuties-checkAll").is(":checked") && !obj.is(":checked")) {
				$("#directory-listDuties-checkAll").attr("checked", false);
			}
		}
	</script>
</head>
<body onload="directory_listDuties_onLoad()">
	<input type="hidden" id="directory-deleteDuties-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-deleteDuties-dutyDeleted" value="<fmt:message bundle="${messages_directory}" key="directory.delete.dutyDeleted" />" />
	<input type="hidden" id="directory-deleteDuties-usedDutyError" value="<fmt:message bundle="${messages_directory}" key="directory.delete.usedDutyError" />" />
	<input type="hidden" id="directory-listDuties-selectItem" value="<fmt:message bundle="${messages_directory}" key="directory.selectItem" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.dutyMng" /></div>
		<ul class="btns">
		<c:if test="${isAdmin}">
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewAddDuty();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.deleteDuties();"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewUpdateDutiesSeq();"><fmt:message bundle="${messages_directory}" key="directory.sequence" /></a></span></li>
		</c:if>
		</ul>
	</div>
	<!-- button : end -->
	<!-- table : start -->
	<table class="content_lst" border="0" cellspacing="0" cellpadding="0">
		<col width="33px">
		<col width="300px">
		<col width="">
		<tr>
			<th scope="col" class="input_chk">
			<c:if test="${isAdmin}">
				<input type="checkbox" class="inchk" id="directory-listDuties-checkAll" />
			</c:if>
			</th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.dutyCode" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.dutyName" /></th>
		</tr>
		<tbody>
		<c:forEach var="duty" items="${dutyList}">
			<tr>
				<td class="input_chk">
				<c:if test="${isAdmin}">
					<input type="checkbox" class="inchk" name="directory-listDuties-check" value="<c:out value="${duty.ID}" />" />
				</c:if>
				</td>
				<td title="<c:out value="${duty.code}" />"><c:out value="${duty.code}" /></td>
				<td title="<c:out value="${duty.name}" />">
				<c:if test="${isAdmin}"><a href="#" onclick="javascript:directory_orgMng.viewUpdateDuty('<c:out value="${duty.ID}" />');" onfocus="blur();"></c:if>
					<c:out value="${duty.name}" />
				<c:if test="${isAdmin}"></a></c:if>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<!-- table : end -->
	<div class="paginate_area"></div>
</body>
</html>