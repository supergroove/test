<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<script type="text/javascript" type="text/javascript">
		function directory_listGroups_onLoad() {
			$("#directory-listGroups-application").change(function() {
				directory_groupMng_listGroups($(this).val());
			});
			$("#directory-listGroups-checkAll").click(function() {
				directory_listGroups_toggleAll();
			});
			$("input[name='directory-listGroups-check']").click(function() {
				directory_listGroups_toggle($(this));
			});
		}
		
		function directory_listGroups_toggleAll() {
			if ($("#directory-listGroups-checkAll").is(":checked")) {
				$("input[name='directory-listGroups-check']").each(function() {
					if (!$(this).is(":disabled") && !$(this).is(":checked")) {
						$(this).attr("checked", true);
					}
				});
			} else {
				$("input[name='directory-listGroups-check']").each(function() {
					if (!$(this).is(":disabled") && $(this).is(":checked")) {
						$(this).attr("checked", false);
					}
				});
			}
		}
		
		function directory_listGroups_toggle(obj) {
			if ($("#directory-listGroups-checkAll").is(":checked") && !obj.is(":checked")) {
				$("#directory-listGroups-checkAll").attr("checked", false);
			}
		}
	</script>
</head>
<body>
	<input type="hidden" id="directory-deleteGroups-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-deleteGroups-groupDeleted" value="<fmt:message bundle="${messages_directory}" key="directory.env.group.groupDeleted" />" />
	<input type="hidden" id="directory-listGroups-selectItem" value="<fmt:message bundle="${messages_directory}" key="directory.selectItem" />" />
	
	<div>
		<div>
			<div class="title_area">
				<h2 class="title"><span title="HOME&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.title" />&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.group.title" />"><fmt:message bundle="${messages_directory}" key="directory.env.group.title" /></span></h2>
			</div>
			<!-- button : start -->
			<div class="btn_area">
				<ul class="btns">
					<li>
						<fmt:message bundle="${messages_directory}" key="directory.env.group.application" />&nbsp;:
						<select id="directory-listGroups-application">
						<c:forEach var="groupApp" items="${groupAppList}">
							<option value="<c:out value="${groupApp.application}" />" <c:if test="${application == groupApp.application}">selected="selected"</c:if>><c:out value="${groupApp.name}" /></option>
						</c:forEach>
						</select>
					</li>
					<li><span><a href="#" onclick="javascript:directory_groupMng_viewAddGroup('<c:out value="${application}" />');"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
					<li><span><a href="#" onclick="javascript:directory_groupMng_deleteGroups('<c:out value="${application}" />');"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
				</ul>
			</div>
			<!-- button : end -->
			<!-- table : start -->
			<table class="content_lst" border="0" cellspacing="0" cellpadding="0">
				<col width="33px">
				<col width="200px">
				<col width="">
				<tr>
					<th scope="col" class="input_chk"><input type="checkbox" class="inchk" id="directory-listGroups-checkAll" /></th>
					<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.env.group.groupName" /></th>
					<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.env.group.description" /></th>
				</tr>
				<tbody>
				<c:set var="count" value="0" scope="page" />
				<c:forEach var="group" items="${groupList}" varStatus="loop">
					<tr>
						<td class="input_chk"><input type="checkbox" class="inchk" name="directory-listGroups-check" value="<c:out value="${group.ID}" />" /></td>
						<td title="<c:out value="${group.name}" />"><a href="#" onclick="javascript:directory_groupMng_viewUpdateGroup('<c:out value="${group.ID}" />');"><c:out value="${group.name}" /></a></td>
						<td title="<c:out value="${group.description}" />"><c:out value="${group.description}" /></td>
					</tr>
					<c:if test="${loop.last}">
						<c:set var="count" value="${loop.count}" />
					</c:if>
				</c:forEach>
				<c:forEach var="i" begin="${count}" end="9">
					<tr>
					<c:choose>
					<c:when test="${count == 0 && i == 1}">
						<td colspan="3" class="cen"><fmt:message bundle="${messages_directory}" key="directory.search.noInformation" /></td>
					</c:when>
					<c:otherwise>
						<td colspan="3"></td>
					</c:otherwise>
					</c:choose>
					</tr>
				</c:forEach>
				<c:remove var="count" scope="page" />
				</tbody>
			</table>
			<!-- table : end -->
			<div class="paginate_area"></div>
		</div>
	</div>
</body>
</html>