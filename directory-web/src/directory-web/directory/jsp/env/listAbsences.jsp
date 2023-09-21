<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<script type="text/javascript" type="text/javascript">
		function directory_listAbsences_onLoad() {
			$("#directory-listAbsences-checkAll").click(function() {
				directory_listAbsences_toggleAll();
			});
			$("input[name='directory-listAbsences-check']").click(function() {
				directory_listAbsences_toggle($(this));
			});
		}
		
		function directory_listAbsences_toggleAll() {
			if ($("#directory-listAbsences-checkAll").is(":checked")) {
				$("input[name='directory-listAbsences-check']").each(function() {
					if (!$(this).is(":disabled") && !$(this).is(":checked")) {
						$(this).attr("checked", true);
					}
				});
			} else {
				$("input[name='directory-listAbsences-check']").each(function() {
					if (!$(this).is(":disabled") && $(this).is(":checked")) {
						$(this).attr("checked", false);
					}
				});
			}
		}
		
		function directory_listAbsences_toggle(obj) {
			if ($("#directory-listAbsences-checkAll").is(":checked") && !obj.is(":checked")) {
				$("#directory-listAbsences-checkAll").attr("checked", false);
			}
		}
	</script>
</head>
<body>
	<!-- button : start -->
	<div class="btn_area">
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_setAbsence_viewAddAbsence();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_setAbsence_deleteAbsences();"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
		</ul>
	</div>
	<!-- button : end -->
	<!-- table : start -->
	<table class="content_lst" border="0" cellspacing="0" cellpadding="0">
		<col width="33px">
		<col width="120px">
		<col width="120px">
		<col width="120px">
		<col width="">
		<tr>
			<th scope="col" class="input_chk"><input type="checkbox" class="inchk" id="directory-listAbsences-checkAll" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.startDate" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.endDate" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.env.absence.reason" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.message" /></th>
		</tr>
		<tbody>
		<c:set var="count" value="0" scope="page" />
		<c:set var="isCurrent" value="false" scope="page" />
		<c:forEach var="absence" items="${absenceList}" varStatus="loop">
			<c:set var="isCurrent" value="${absence.absSDate.time <= current.time && absence.absEDate.time > current.time}" />
			<tr <c:if test="${isCurrent}">style="font-weight: bold"</c:if>>
				<td class="input_chk"><input type="checkbox" class="inchk" name="directory-listAbsences-check" value="<c:out value="${absence.absenceID}" />" /></td>
				<td title="<fmt:formatDate value="${absence.absSDate}" type="date" pattern="yyyy.MM.dd HH:mm" />"><a href="#" onclick="javascript:directory_setAbsence_viewUpdateAbsence('<c:out value="${absence.absenceID}" />');"><fmt:formatDate value="${absence.absSDate}" type="date" pattern="yyyy.MM.dd HH:mm" /></a></td>
				<td title="<fmt:formatDate value="${absence.absEDate}" type="date" pattern="yyyy.MM.dd HH:mm" />"><a href="#" onclick="javascript:directory_setAbsence_viewUpdateAbsence('<c:out value="${absence.absenceID}" />');"><fmt:formatDate value="${absence.absEDate}" type="date" pattern="yyyy.MM.dd HH:mm" /></a></td>
				<td title="<fmt:message bundle="${messages_directory}" key="directory.env.absence.reason.${absence.notSancID}" />"><fmt:message bundle="${messages_directory}" key="directory.env.absence.reason.${absence.notSancID}" /></td>
				<td title="<c:out value="${absence.absMsg}" />"><c:out value="${absence.absMsg}" /></td>
			</tr>
			<c:if test="${loop.last}">
				<c:set var="count" value="${loop.count}" />
			</c:if>
		</c:forEach>
		<c:forEach var="i" begin="${count}" end="9">
			<tr>
			<c:choose>
			<c:when test="${count == 0 && i == 1}">
				<td colspan="5" class="cen"><fmt:message bundle="${messages_directory}" key="directory.search.noInformation" /></td>
			</c:when>
			<c:otherwise>
				<td colspan="5"></td>
			</c:otherwise>
			</c:choose>
			</tr>
		</c:forEach>
		<c:remove var="count" scope="page" />
		<c:remove var="isCurrent" scope="page" />
		</tbody>
	</table>
	<!-- table : end -->
	<div class="paginate_area"></div>
</body>
</html>