<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.userMng" /> -->
	
	<script type="text/javascript">
		function directory_listUsers_onLoad() {
			<c:if test="${dept == null}">
				directory_history.removeAll(); // history remove all
			</c:if>
			if (directory_history.size() < 2) {
				$("#directory-listUsers-historyBack").hide();
			}
			$("#directory-listUsers-checkAll").click(function() {
				directory_listUsers_toggleAll();
			});
			$("input[name='directory-listUsers-check']").click(function() {
				directory_listUsers_toggle($(this));
			});
			
			directory_listUsers_addOrderClass();
		}
		
		function directory_listUsers_toggleAll() {
			if ($("#directory-listUsers-checkAll").is(":checked")) {
				$("input[name='directory-listUsers-check']").each(function() {
					if (!$(this).is(":disabled") && !$(this).is(":checked")) {
						$(this).attr("checked", true);
					}
				});
			} else {
				$("input[name='directory-listUsers-check']").each(function() {
					if (!$(this).is(":disabled") && $(this).is(":checked")) {
						$(this).attr("checked", false);
					}
				});
			}
		}
		
		function directory_listUsers_toggle(obj) {
			if ($("#directory-listUsers-checkAll").is(":checked") && !obj.is(":checked")) {
				$("#directory-listUsers-checkAll").attr("checked", false);
			}
		}
		
		function directory_listUsers_addOrderClass() {
			var orderField = $("#directory-listUsers-orderField").val();
			
			if (orderField) {
				var orderClass = $("#directory-listUsers-orderType").val() == "asc" ? "ascendent" : "descend";
				$("#directory-listUsers-order-" + orderField).addClass(orderClass);
			}
		}
		
		function directory_listUsers_selectOrderField(orderField) {
			var orderType = null;
			
			if ($("#directory-listUsers-orderField").val() == orderField
					&& $("#directory-listUsers-orderType").val() == "asc") {
				orderType = "desc";
			} else {
				orderType = "asc";
			}
			
			directory_orgMng.listUsers($("#directory-listUsers-deptID").val(), orderField, orderType);
		}
	</script>
</head>
<body onload="directory_listUsers_onLoad()">
	<c:if test="${IS_ENGLISH}">
		<c:if test="${not empty dept.nameEng}">
			<c:set target="${dept}" property="name" value="${dept.nameEng}" />
		</c:if>
	</c:if>
	<input type="hidden" id="directory-listUsers-deptID" value="<c:out value="${dept.ID}" />" />
	<input type="hidden" id="directory-listUsers-orderField" value="<c:out value="${param.orderField}" />" />
	<input type="hidden" id="directory-listUsers-orderType" value="<c:out value="${param.orderType}" />" />
	
	<input type="hidden" id="directory-deleteUsers-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-deleteUsers-userDeleted" value="<fmt:message bundle="${messages_directory}" key="directory.delete.userDeleted" />" />
	<input type="hidden" id="directory-deleteUsers-deleteAdminError" value="<fmt:message bundle="${messages_directory}" key="directory.delete.deleteAdminError" />" />
	<input type="hidden" id="directory-repairUsers-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.repair.confirm" />" />
	<input type="hidden" id="directory-repairUsers-repaired" value="<fmt:message bundle="${messages_directory}" key="directory.repair.repaired" />" />
	<input type="hidden" id="directory-listUsers-selectItem" value="<fmt:message bundle="${messages_directory}" key="directory.selectItem" />" />
	
<c:if test="${dept != null}">
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.userMng" /></div>
		<ul class="btns">
			<li id="directory-listUsers-historyBack"><span><a href="#" onclick="javascript:directory_history.back(2);"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
		<c:if test="${dept.status == '1' or dept.status == '8'}">
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewAddUser('<c:out value="${dept.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
		</c:if>
		<c:if test="${not empty userList and (dept.status == '1' or dept.status == '8')}">
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewMoveUsers('<c:out value="${dept.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.move" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.deleteUsers('<c:out value="${dept.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.repairUsers('<c:out value="${dept.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.repair" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewUpdateUsersSeq('<c:out value="${dept.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.sequence" /></a></span></li>
			<!--li><span><a href="#" onclick="javascript:directory_orgMng.batchUsers();"><fmt:message bundle="${messages_directory}" key="directory.batch" /></a></span></li-->
		</c:if>
		</ul>
	</div>
	<!-- button : end -->
	<!-- table : start -->
	<table class="content_lst" border="0" cellspacing="0" cellpadding="0">
	<c:set var="colCnt" value="6" scope="page" />
		<col width="33px">
		<col width="150px">
	<c:if test="${useRank}">
		<c:set var="colCnt" value="${colCnt + 1}" />
		<col width="150px">
	</c:if>
	<c:if test="${useDuty}">
		<c:set var="colCnt" value="${colCnt + 1}" />
		<col width="150px">
	</c:if>
		<col width="150px">
		<col width="150px">
		<col width="150px">
		<col width="">
		<tr>
			<th scope="col" class="input_chk"><input type="checkbox" class="inchk" id="directory-listUsers-checkAll" /></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listUsers_selectOrderField('position')" id="directory-listUsers-order-position"><fmt:message bundle="${messages_directory}" key="directory.positionName" /></a></th>
		<c:if test="${useRank}">
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listUsers_selectOrderField('rank')" id="directory-listUsers-order-rank"><fmt:message bundle="${messages_directory}" key="directory.rankName" /></a></th>
		</c:if>
		<c:if test="${useDuty}">
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listUsers_selectOrderField('duty')" id="directory-listUsers-order-duty"><fmt:message bundle="${messages_directory}" key="directory.dutyName" /></a></th>
		</c:if>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listUsers_selectOrderField('name')" id="directory-listUsers-order-name"><fmt:message bundle="${messages_directory}" key="directory.userName" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listUsers_selectOrderField('nameEng')" id="directory-listUsers-order-nameEng"><fmt:message bundle="${messages_directory}" key="directory.userNameEng" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listUsers_selectOrderField('empCode')" id="directory-listUsers-order-empCode"><fmt:message bundle="${messages_directory}" key="directory.empCode" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listUsers_selectOrderField('email')" id="directory-listUsers-order-email"><fmt:message bundle="${messages_directory}" key="directory.en_email" /></a></th>
		</tr>
		<tbody>
		<c:set var="count" value="0" scope="page" />
		<c:forEach var="user" items="${userList}" varStatus="loop">
			<c:if test="${IS_ENGLISH}">
				<c:if test="${not empty user.positionNameEng}">
					<c:set target="${user}" property="positionName" value="${user.positionNameEng}" />
				</c:if>
				<c:if test="${not empty user.rankNameEng}">
					<c:set target="${user}" property="rankName" value="${user.rankNameEng}" />
				</c:if>
			</c:if>
			<tr>
				<td class="input_chk">
					<input type="checkbox" class="inchk" name="directory-listUsers-check" value="<c:out value="${user.ID}" />" />
					<input type="hidden" id="directory-listUsers-status<c:out value="${user.ID}" />" value="<c:out value="${user.status}" />" />
				</td>
				<td title="<c:out value="${user.positionName}" />"><c:out value="${user.positionName}" /></td>
			<c:if test="${useRank}">
				<td title="<c:out value="${user.rankName}" />"><c:out value="${user.rankName}" /></td>
			</c:if>
			<c:if test="${useDuty}">
				<td title="<c:out value="${user.dutyName}" />"><c:out value="${user.dutyName}" /></td>
			</c:if>
				<td title="<c:out value="${user.name}" />">
					<a href="#" onclick="javascript:directory_orgMng.viewUser('<c:out value="${user.ID}" />');"><c:out value="${user.name}" /></a>
					<c:if test="${param.useAbsent && user.absent}"><fmt:message bundle="${messages_directory}" key="directory.absence" /></c:if>
					<c:if test="${user.status == '4'}"><img src="<c:out value="${CONTEXT}" />/directory/images/OS4.GIF" title="<fmt:message bundle="${messages_directory}" key="directory.deleted" />" /></c:if>
				</td>
				<td title="<c:out value="${user.nameEng}" />"><c:out value="${user.nameEng}" /></td>
				<td title="<c:out value="${user.empCode}" />"><c:out value="${user.empCode}" /></td>
				<td title="<c:out value="${user.email}" />"><c:out value="${user.email}" /></td>
			</tr>
			<c:if test="${loop.last}">
				<c:set var="count" value="${loop.count}" />
			</c:if>
		</c:forEach>
		<c:forEach var="i" begin="${count}" end="9">
			<tr>
			<c:choose>
			<c:when test="${count == 0 && i == 1}">
				<td colspan="<c:out value="${colCnt}" />" class="cen"><fmt:message bundle="${messages_directory}" key="directory.search.noUser" /></td>
			</c:when>
			<c:otherwise>
				<td colspan="<c:out value="${colCnt}" />"></td>
			</c:otherwise>
			</c:choose>
			</tr>
		</c:forEach>
		<c:remove var="count" scope="page" />
		</tbody>
	<c:remove var="colCnt" scope="page" />
	</table>
	<!-- table : end -->
	<div class="paginate_area"></div>
</c:if>
<c:if test="${dept == null}">
	<div style="padding: 5px;">
		<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="cen"><fmt:message bundle="${messages_directory}" key="directory.error.notExistDept" /></td>
			</tr>
		</table>
	</div>
</c:if>
</body>
</html>