<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.rankMng" /> -->
	
	<script type="text/javascript">
		function directory_listRanks_onLoad() {
			$("#directory-listRanks-checkAll").click(function() {
				directory_listRanks_toggleAll();
			});
			$("input[name='directory-listRanks-check']").click(function() {
				directory_listRanks_toggle($(this));
			});
		}
		
		function directory_listRanks_toggleAll() {
			if ($("#directory-listRanks-checkAll").is(":checked")) {
				$("input[name='directory-listRanks-check']").each(function() {
					if (!$(this).is(":disabled") && !$(this).is(":checked")) {
						$(this).attr("checked", true);
					}
				});
			} else {
				$("input[name='directory-listRanks-check']").each(function() {
					if (!$(this).is(":disabled") && $(this).is(":checked")) {
						$(this).attr("checked", false);
					}
				});
			}
		}
		
		function directory_listRanks_toggle(obj) {
			if ($("#directory-listRanks-checkAll").is(":checked") && !obj.is(":checked")) {
				$("#directory-listRanks-checkAll").attr("checked", false);
			}
		}
	</script>
</head>
<body onload="directory_listRanks_onLoad()">
	<input type="hidden" id="directory-deleteRanks-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-deleteRanks-rankDeleted" value="<fmt:message bundle="${messages_directory}" key="directory.delete.rankDeleted" />" />
	<input type="hidden" id="directory-deleteRanks-usedRankError" value="<fmt:message bundle="${messages_directory}" key="directory.delete.usedRankError" />" />
	<input type="hidden" id="directory-listRanks-selectItem" value="<fmt:message bundle="${messages_directory}" key="directory.selectItem" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.rankMng" /></div>
		<ul class="btns">
		<c:if test="${isAdmin}">
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewAddRank();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.deleteRanks();"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
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
				<input type="checkbox" class="inchk" id="directory-listRanks-checkAll" />
			</c:if>
			</th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.rankCode" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.rankName" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.rankNameEng" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.rankLevel" /></th>
		</tr>
		<tbody>
		<c:forEach var="rank" items="${rankList}">
			<tr>
				<td class="input_chk">
				<c:if test="${isAdmin}">
					<input type="checkbox" class="inchk" name="directory-listRanks-check" value="<c:out value="${rank.ID}" />" />
				</c:if>
				</td>
				<td title="<c:out value="${rank.code}" />"><c:out value="${rank.code}" /></td>
				<td title="<c:out value="${rank.name}" />">
				<c:if test="${isAdmin}"><a href="#" onclick="javascript:directory_orgMng.viewUpdateRank('<c:out value="${rank.ID}" />');" onfocus="blur();"></c:if>
					<c:out value="${rank.name}" />
				<c:if test="${isAdmin}"></a></c:if>
				</td>
				<td title="<c:out value="${rank.nameEng}" />"><c:out value="${rank.nameEng}" /></td>
				<td class="cen" title="<c:out value="${rank.level}" />"><c:out value="${rank.level}" /></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<!-- table : end -->
	<div class="paginate_area"></div>
</body>
</html>