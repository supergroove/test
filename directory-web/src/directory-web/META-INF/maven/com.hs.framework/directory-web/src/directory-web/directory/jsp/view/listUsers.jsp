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
		function directory_listUsers_onLoad() {
			directory_listUsers_addOrderClass();
		}
		
		function directory_listUsers_viewUserSpec(userID, event) {
		<c:choose>
		<c:when test="${not empty detailUserCmd}">
			<c:out value="${detailUserCmd}" />;
		</c:when>
		<c:otherwise>
			directory_orgView.viewUserSpec(userID);
		</c:otherwise>
		</c:choose>
		}
		
		function directory_listUsers_addOrderClass() {
			var orderField = $("#directory-listUsers-orderField").val();
			
			if (orderField) {
				var orderClass = $("#directory-listUsers-orderType").val() == "asc" ? "ascendent" : "descend";
				$("#directory-listUsers-order-" + orderField).addClass(orderClass);
			}
		}
		
		function directory_listUsers_selectOrderField(orderField) {
			if ($("#directory-listUsers-orderField").val() == orderField
					&& $("#directory-listUsers-orderType").val() == "asc") {
				$("#directory-listUsers-orderType").val("desc");
			} else {
				$("#directory-listUsers-orderType").val("asc");
			}
			$("#directory-listUsers-orderField").val(orderField);
			
			directory_orgView.listUsers($("#directory-listUsers-deptID").val());
		}
		
		function goListPage(page) {
			$("#directory-listUsers-currentPage").val(page);
			directory_orgView.listUsers($("#directory-listUsers-deptID").val());
		}
	</script>
</head>
<body onload="directory_listUsers_onLoad()">
	<c:if test="${IS_ENGLISH}">
		<c:if test="${not empty dept.nameEng}">
			<c:set target="${dept}" property="name" value="${dept.nameEng}" />
		</c:if>
	</c:if>
	<input type="hidden" id="directory-listUsers-deptName" value="<c:out value="${dept.name}" />" />
	<input type="hidden" id="directory-listUsers-deptID" value="<c:out value="${dept.ID}" />" />
	<input type="hidden" id="directory-listUsers-currentPage" value="<c:out value="${param.currentPage}" />" />
	<input type="hidden" id="directory-listUsers-orderField" value="<c:out value="${param.orderField}" />" />
	<input type="hidden" id="directory-listUsers-orderType" value="<c:out value="${param.orderType}" />" />
	<input type="hidden" id="directory-listUsers-searchType" value="<c:out value="${param.searchType}" />" />
	<input type="hidden" id="directory-listUsers-searchValue" value="<c:out value="${param.searchValue}" />" />
	<input type="hidden" id="directory-listUsers-listType" value="<c:out value="${param.listType}" />" />
	<input type="hidden" id="directory-listUsers-userCount" value="<c:out value="${pParam.totalCount}" />" />
	
	<!-- table : start -->
	<table class="content_lst no_btn" border="0" cellspacing="0" cellpadding="0" style="margin-top:5px">
	<c:set var="colCnt" value="5" scope="page" />
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
		<col width="">
		<col width="150px">
		<col width="150px">
		<tr>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listUsers_selectOrderField('position')" id="directory-listUsers-order-position"><fmt:message bundle="${messages_directory}" key="directory.position" /></a></th>
		<c:if test="${useRank}">
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listUsers_selectOrderField('rank')" id="directory-listUsers-order-rank"><fmt:message bundle="${messages_directory}" key="directory.rank" /></a></th>
		</c:if>
		<c:if test="${useDuty}">
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listUsers_selectOrderField('duty')" id="directory-listUsers-order-duty"><fmt:message bundle="${messages_directory}" key="directory.duty" /></a></th>
		</c:if>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listUsers_selectOrderField('name')" id="directory-listUsers-order-name"><fmt:message bundle="${messages_directory}" key="directory.userName" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listUsers_selectOrderField('email')" id="directory-listUsers-order-email"><fmt:message bundle="${messages_directory}" key="directory.en_email" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listUsers_selectOrderField('phone')" id="directory-listUsers-order-phone"><fmt:message bundle="${messages_directory}" key="directory.phone" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listUsers_selectOrderField('mobile')" id="directory-listUsers-order-mobile"><fmt:message bundle="${messages_directory}" key="directory.mobilePhone" /></a></th>
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
				<c:if test="${not empty user.rankNameEng}">
					<c:set target="${user}" property="rankName" value="${user.rankNameEng}" />
				</c:if>
			</c:if>
			<tr>
				<td title="<c:out value="${user.positionName}" />"><c:out value="${user.positionName}" /></td>
			<c:if test="${useRank}">
				<td title="<c:out value="${user.rankName}" />"><c:out value="${user.rankName}" /></td>
			</c:if>
			<c:if test="${useDuty}">
				<td title="<c:out value="${user.dutyName}" />"><c:out value="${user.dutyName}" /></td>
			</c:if>
				<td title="<c:out value="${user.name}" />">
					<a href="#" onclick="javascript:directory_listUsers_viewUserSpec('<c:out value="${user.ID}" />', event);"><c:out value="${user.name}" /></a>
					<c:if test="${param.useAbsent && user.absent}"><fmt:message bundle="${messages_directory}" key="directory.absence" /></c:if>
				</td>
				<td title="<c:out value="${user.email}" />"><c:out value="${user.email}" /></td>
				<td title="<c:out value="${user.phone}" />"><c:out value="${user.phone}" /></td>
				<td title="<c:out value="${user.mobilePhone}" />"><c:out value="${user.mobilePhone}" /></td>
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
	<div class="paginate_area">
		<jsp:include page="../common/pagination.jsp"/>
	</div>
</body>
</html>