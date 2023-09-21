<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
<c:if test="${not empty detailUserSrc}">
	<script type="text/javascript" src="<c:out value="${detailUserSrc}" />"></script>
</c:if>
	
	<script type="text/javascript">
		function directory_listAbsentUsers_onLoad() {
			directory_listAbsentUsers_addOrderClass();
		}
		
		function directory_listAbsentUsers_viewUserSpec(userID, event) {
		<c:choose>
		<c:when test="${not empty detailUserCmd}">
			<c:out value="${detailUserCmd}" />;
		</c:when>
		<c:otherwise>
			directory_orgView.viewUserSpec(userID);
		</c:otherwise>
		</c:choose>
		}
		
		function directory_listAbsentUsers_addOrderClass() {
			var orderField = $("#directory-listAbsentUsers-orderField").val();
			
			if (orderField) {
				var orderClass = $("#directory-listAbsentUsers-orderType").val() == "asc" ? "ascendent" : "descend";
				$("#directory-listAbsentUsers-order-" + orderField).addClass(orderClass);
			}
		}
				
		function directory_listAbsentUsers_selectOrderField(orderField) {
			if ($("#directory-listAbsentUsers-orderField").val() == orderField
					&& $("#directory-listAbsentUsers-orderType").val() == "asc") {
				$("#directory-listAbsentUsers-orderType").val("desc");
			} else {
				$("#directory-listAbsentUsers-orderType").val("asc");
			}
			$("#directory-listAbsentUsers-orderField").val(orderField);
			
			directory_orgView.listAbsentUsers($("#directory-listAbsentUsers-deptID").val());
		}
		
		function goListPage(page) {
			$("#directory-listAbsentUsers-currentPage").val(page);
			directory_orgView.listAbsentUsers($("#directory-listAbsentUsers-deptID").val());
		}
	</script>
</head>
<body onload="directory_listAbsentUsers_onLoad()">
	<c:if test="${IS_ENGLISH}">
		<c:if test="${not empty dept.nameEng}">
			<c:set target="${dept}" property="name" value="${dept.nameEng}" />
		</c:if>
	</c:if>
	<input type="hidden" id="directory-listAbsentUsers-deptName" value="<c:out value="${dept.name}" />" />
	<input type="hidden" id="directory-listAbsentUsers-deptID" value="<c:out value="${dept.ID}" />" />
	<input type="hidden" id="directory-listAbsentUsers-currentPage" value="<c:out value="${param.currentPage}" />" />
	<input type="hidden" id="directory-listAbsentUsers-orderField" value="<c:out value="${param.orderField}" />" />
	<input type="hidden" id="directory-listAbsentUsers-orderType" value="<c:out value="${param.orderType}" />" />
	<input type="hidden" id="directory-listAbsentUsers-searchType" value="<c:out value="${param.searchType}" />" />
	<input type="hidden" id="directory-listAbsentUsers-searchValue" value="<c:out value="${param.searchValue}" />" />
	<input type="hidden" id="directory-listAbsentUsers-listType" value="<c:out value="${param.listType}" />" />
	<input type="hidden" id="directory-listAbsentUsers-userCount" value="<c:out value="${pParam.totalCount}" />" />
	
	<!-- table : start -->
	<table class="content_lst no_btn" border="0" cellspacing="0" cellpadding="0" style="margin-top:5px">
		<col width="150px">
		<col width="150px">
		<col width="150px">
		<col width="120px">
		<col width="120px">
		<col width="">
		<col width="">
		<tr>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listAbsentUsers_selectOrderField('position')" id="directory-listAbsentUsers-order-position"><fmt:message bundle="${messages_directory}" key="directory.position" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listAbsentUsers_selectOrderField('name')" id="directory-listAbsentUsers-order-name"><fmt:message bundle="${messages_directory}" key="directory.userName" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listAbsentUsers_selectOrderField('deptName')" id="directory-listAbsentUsers-order-deptName"><fmt:message bundle="${messages_directory}" key="directory.deptName" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listAbsentUsers_selectOrderField('absStartDate')" id="directory-listAbsentUsers-order-absStartDate"><fmt:message bundle="${messages_directory}" key="directory.startDate" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listAbsentUsers_selectOrderField('absEndDate')" id="directory-listAbsentUsers-order-absEndDate"><fmt:message bundle="${messages_directory}" key="directory.endDate" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listAbsentUsers_selectOrderField('reason')" id="directory-listAbsentUsers-order-reason"><fmt:message bundle="${messages_directory}" key="directory.env.absence.reason" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listAbsentUsers_selectOrderField('message')" id="directory-listAbsentUsers-order-message"><fmt:message bundle="${messages_directory}" key="directory.message" /></a></th>
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
				<td title="<c:out value="${user.positionName}" />"><c:out value="${user.positionName}" /></td>
				<td title="<c:out value="${user.name}" />">
					<a href="#" onclick="javascript:directory_listAbsentUsers_viewUserSpec('<c:out value="${user.ID}" />', event);"><c:out value="${user.name}" /></a>
					<c:if test="${param.useAbsent && user.absent}"><fmt:message bundle="${messages_directory}" key="directory.absence" /></c:if>
				</td>
				<td title="<c:out value="${user.deptName}" />"><a href="#" onclick="javascript:directory_orgView.viewDeptSpec('<c:out value="${user.deptID}" />');"><c:out value="${user.deptName}" /></a></td>
				<td class="cen" title="<fmt:formatDate value="${user.absSDate}" type="date" pattern="yyyy.MM.dd HH:mm" />"><fmt:formatDate value="${user.absSDate}" type="date" pattern="yyyy.MM.dd HH:mm" /></td>
				<td class="cen" title="<fmt:formatDate value="${user.absEDate}" type="date" pattern="yyyy.MM.dd HH:mm" />"><fmt:formatDate value="${user.absEDate}" type="date" pattern="yyyy.MM.dd HH:mm" /></td>
				<td class="cen" title="<fmt:message bundle="${messages_directory}" key="directory.env.absence.reason.${user.notSancID}" />"><fmt:message bundle="${messages_directory}" key="directory.env.absence.reason.${user.notSancID}" /></td>
				<td class="cen" title="<c:out value="${user.absMsg}" />"><img src="<c:out value="${CONTEXT}" />/directory/images/ABSENCE.GIF" title="<c:out value="${user.absMsg}" />" /></td>
			</tr>
			<c:if test="${loop.last}">
				<c:set var="count" value="${loop.count}" />
			</c:if>
		</c:forEach>
		<c:forEach var="i" begin="${count}" end="9">
			<tr>
			<c:choose>
			<c:when test="${count == 0 && i == 1}">
				<td colspan="7" class="cen"><fmt:message bundle="${messages_directory}" key="directory.search.noUser" /></td>
			</c:when>
			<c:otherwise>
				<td colspan="7"></td>
			</c:otherwise>
			</c:choose>
			</tr>
		</c:forEach>
		<c:remove var="count" scope="page" />
		</tbody>
	</table>
	<!-- table : end -->
	<div class="paginate_area">
		<jsp:include page="../common/pagination.jsp"/>
	</div>
</body>
</html>