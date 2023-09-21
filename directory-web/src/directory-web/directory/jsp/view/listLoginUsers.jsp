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
		function directory_listLoginUsers_onLoad() {
			directory_listLoginUsers_addOrderClass();
		}
		
		function directory_listLoginUsers_viewUserSpec(userID, event) {
		<c:choose>
		<c:when test="${not empty detailUserCmd}">
			<c:out value="${detailUserCmd}" />;
		</c:when>
		<c:otherwise>
			directory_orgView.viewUserSpec(userID);
		</c:otherwise>
		</c:choose>
		}
		
		function directory_listLoginUsers_addOrderClass() {
			var orderField = $("#directory-listLoginUsers-orderField").val();
			
			if (orderField) {
				var orderClass = $("#directory-listLoginUsers-orderType").val() == "asc" ? "ascendent" : "descend";
				$("#directory-listLoginUsers-order-" + orderField).addClass(orderClass);
			}
		}
		
		function directory_listLoginUsers_selectOrderField(orderField) {
			if ($("#directory-listLoginUsers-orderField").val() == orderField
					&& $("#directory-listLoginUsers-orderType").val() == "asc") {
				$("#directory-listLoginUsers-orderType").val("desc");
			} else {
				$("#directory-listLoginUsers-orderType").val("asc");
			}
			$("#directory-listLoginUsers-orderField").val(orderField);
			
			directory_orgView.listLoginUsers($("#directory-listLoginUsers-deptID").val());
		}
		
		function goListPage(page) {
			$("#directory-listLoginUsers-currentPage").val(page);
			directory_orgView.listLoginUsers($("#directory-listLoginUsers-deptID").val());
		}
	</script>
</head>
<body onload="directory_listLoginUsers_onLoad()">
	<c:if test="${IS_ENGLISH}">
		<c:if test="${not empty dept.nameEng}">
			<c:set target="${dept}" property="name" value="${dept.nameEng}" />
		</c:if>
	</c:if>
	<input type="hidden" id="directory-listLoginUsers-deptName" value="<c:out value="${dept.name}" />" />
	<input type="hidden" id="directory-listLoginUsers-deptID" value="<c:out value="${dept.ID}" />" />
	<input type="hidden" id="directory-listLoginUsers-currentPage" value="<c:out value="${param.currentPage}" />" />
	<input type="hidden" id="directory-listLoginUsers-orderField" value="<c:out value="${param.orderField}" />" />
	<input type="hidden" id="directory-listLoginUsers-orderType" value="<c:out value="${param.orderType}" />" />
	<input type="hidden" id="directory-listLoginUsers-searchType" value="<c:out value="${param.searchType}" />" />
	<input type="hidden" id="directory-listLoginUsers-searchValue" value="<c:out value="${param.searchValue}" />" />
	<input type="hidden" id="directory-listLoginUsers-listType" value="<c:out value="${param.listType}" />" />
	<input type="hidden" id="directory-listLoginUsers-userCount" value="<c:out value="${pParam.totalCount}" />" />
	
	<!-- table : start -->
	<table class="content_lst no_btn" border="0" cellspacing="0" cellpadding="0" style="margin-top:5px">
		<col width="150px">
		<col width="150px">
		<col width="150px">
		<col width="150px">
		<col width="">
		<tr>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listLoginUsers_selectOrderField('position')" id="directory-listLoginUsers-order-position"><fmt:message bundle="${messages_directory}" key="directory.position" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listLoginUsers_selectOrderField('name')" id="directory-listLoginUsers-order-name"><fmt:message bundle="${messages_directory}" key="directory.userName" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listLoginUsers_selectOrderField('deptName')" id="directory-listLoginUsers-order-deptName"><fmt:message bundle="${messages_directory}" key="directory.deptName" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listLoginUsers_selectOrderField('loginDate')" id="directory-listLoginUsers-order-loginDate"><fmt:message bundle="${messages_directory}" key="directory.loginDate" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listLoginUsers_selectOrderField('phone')" id="directory-listLoginUsers-order-phone"><fmt:message bundle="${messages_directory}" key="directory.phone" /></a></th>
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
					<a href="#" onclick="javascript:directory_listLoginUsers_viewUserSpec('<c:out value="${user.ID}" />', event);"><c:out value="${user.name}" /></a>
					<c:if test="${param.useAbsent && user.absent}"><fmt:message bundle="${messages_directory}" key="directory.absence" /></c:if>
				</td>
				<td title="<c:out value="${user.deptName}" />"><a href="#" onclick="javascript:directory_orgView.viewDeptSpec('<c:out value="${user.deptID}" />');"><c:out value="${user.deptName}" /></a></td>
				<td class="cen" title="<fmt:formatDate value="${user.lastLoginDate}" type="date" pattern="yyyy.MM.dd HH:mm" />"><fmt:formatDate value="${user.lastLoginDate}" type="date" pattern="yyyy.MM.dd HH:mm" /></td>
				<td title="<c:out value="${user.phone}" />"><c:out value="${user.phone}" /></td>
			</tr>
			<c:if test="${loop.last}">
				<c:set var="count" value="${loop.count}" />
			</c:if>
		</c:forEach>
		<c:forEach var="i" begin="${count}" end="9">
			<tr>
			<c:choose>
			<c:when test="${count == 0 && i == 1}">
				<td colspan="5" class="cen"><fmt:message bundle="${messages_directory}" key="directory.search.noUser" /></td>
			</c:when>
			<c:otherwise>
				<td colspan="5"></td>
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