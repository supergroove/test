<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.search" /> -->
	
	<script type="text/javascript">
		function directory_listSearch_toggleSearchValue(searchType){
			if('auth' == searchType){
				$("#directory-listSearch-searchValue").hide();
				$("#directory-listSearch-searchValue-auth").show();
				$("#directory-listSearch-searchValue-auth").focus();
			}else{
				$("#directory-listSearch-searchValue").show();
				$("#directory-listSearch-searchValue-auth").hide();
				$("#directory-listSearch-searchValue").focus();
			}
		}
		function directory_listSearch_onLoad() {
			directory_listSearch_toggleSearchValue($("#directory-listSearch-searchType").val());
			
			$("#directory-listSearch-searchType").bind("change", function(event){
				directory_listSearch_toggleSearchValue($("#directory-listSearch-searchType").val());
			});
			$("#directory-listSearch-searchValue").keypress(function(event) {
				if (event.keyCode == 13) {
					event.keyCode = 0;
					$("#directory-listSearch-searchButton").click();
				}
			});
			$("#directory-listSearch-searchButton").click(function() {
				var searchType = $("#directory-listSearch-searchType").val();
				var searchValue = $("#directory-listSearch-searchValue").val();
				if(searchType == 'auth'){
					searchValue = $("#directory-listSearch-searchValue-auth").val();
				}
				directory_orgMng.listSearch(searchType, searchValue);
			});
			$("#directory-listSearch-checkAll").click(function() {
				directory_listSearch_toggleAll();
			});
			$("input[name='directory-listSearch-check']").click(function() {
				directory_listSearch_toggle($(this));
			});
			
			directory_listSearch_addOrderClass();
		}
		
		function directory_listSearch_toggleAll() {
			if ($("#directory-listSearch-checkAll").is(":checked")) {
				$("input[name='directory-listSearch-check']").each(function() {
					if (!$(this).is(":disabled") && !$(this).is(":checked")) {
						$(this).attr("checked", true);
					}
				});
			} else {
				$("input[name='directory-listSearch-check']").each(function() {
					if (!$(this).is(":disabled") && $(this).is(":checked")) {
						$(this).attr("checked", false);
					}
				});
			}
		}
		
		function directory_listSearch_toggle(obj) {
			if ($("#directory-listSearch-checkAll").is(":checked") && !obj.is(":checked")) {
				$("#directory-listSearch-checkAll").attr("checked", false);
			}
		}
		
		function directory_listSearch_addOrderClass() {
			var orderField = $("#directory-listSearch-orderField").val();
			
			if (orderField) {
				var orderClass = $("#directory-listSearch-orderType").val() == "asc" ? "ascendent" : "descend";
				$("#directory-listSearch-order-" + orderField).addClass(orderClass);
			}
		}
		
		function directory_listSearch_selectOrderField(orderField) {
			var orderType = null;
			
			if ($("#directory-listSearch-orderField").val() == orderField
					&& $("#directory-listSearch-orderType").val() == "asc") {
				orderType = "desc";
			} else {
				orderType = "asc";
			}
			var searchType = $("#directory-listSearch-searchType").val();
			var searchValue = $("#directory-listSearch-searchValue").val();
			if(searchType == 'auth'){
				searchValue = $("#directory-listSearch-searchValue-auth").val();
			}
			directory_orgMng.listSearch(searchType, searchValue, orderField, orderType);
		}
	</script>
</head>
<body onload="directory_listSearch_onLoad()">
	<input type="hidden" id="directory-listSearch-orderField" value="<c:out value="${param.orderField}" />" />
	<input type="hidden" id="directory-listSearch-orderType" value="<c:out value="${param.orderType}" />" />
	<input type="hidden" id="directory-listSearch-authTypes" value="<c:out value="${param.authTypes}" default="0,1,2"/>" />
	
	<input type="hidden" id="directory-listSearch-noneTerm" value="<fmt:message bundle="${messages_directory}" key="directory.search.noneTerm" />" />
	
	<!-- search : start -->
	<div class="srch_area" style="margin-top: 8px;">
		<fieldset class="search">
			<legend><fmt:message bundle="${messages_directory}" key="directory.search" /></legend>
			<select id="directory-listSearch-searchType">
				<option value="name" <c:if test="${param.searchType == 'name'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.userName" /></option>
				<option value="pos" <c:if test="${param.searchType == 'pos'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.position" /></option>
			<c:if test="${useRank}">
				<option value="rank" <c:if test="${param.searchType == 'rank'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.rank" /></option>
			</c:if>
			<c:if test="${useDuty}">
				<option value="duty" <c:if test="${param.searchType == 'duty'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.duty" /></option>
			</c:if>
				<option value="code" <c:if test="${param.searchType == 'code'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.empCode" /></option>
			<c:if test="${not cryptedUserColumnsMap.phone}">
				<option value="phone" <c:if test="${param.searchType == 'phone'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.phone" /></option>
			</c:if>
			<c:if test="${not cryptedUserColumnsMap.mobile_phone}">
				<option value="mobile" <c:if test="${param.searchType == 'mobile'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.mobilePhone" /></option>
			</c:if>
			<c:if test="${not cryptedUserColumnsMap.e_mail}">
				<option value="email" <c:if test="${param.searchType == 'email'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.en_email" /></option>
			</c:if>
				<option value="auth" <c:if test="${param.searchType == 'auth'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.auth" /></option>
			</select>
			<input type="text" id="directory-listSearch-searchValue" maxlength="60" value="<c:if test="${param.searchType != 'auth'}"><c:out value="${param.searchValue}" /></c:if>" />
			<select id="directory-listSearch-searchValue-auth">
				<c:forEach var="auth" items="${authList}">
				<option value="<c:out value="${auth.code}"/>" <c:if test="${param.searchType == 'auth' and auth.code == param.searchValue}">selected</c:if>><c:out value="${auth.name}"/></option>
				</c:forEach>
			</select>
			<a class="srch_btn" href="#" id="directory-listSearch-searchButton"><fmt:message bundle="${messages_directory}" key="directory.search" /></a>
		</fieldset>
	</div>
	<!-- search : end -->
	<!-- table : start -->
	<table class="content_lst no_btn" border="0" cellspacing="0" cellpadding="0">
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
			<th scope="col" class="input_chk"><!--input type="checkbox" class="inchk" id="directory-listSearch-checkAll" /--></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listSearch_selectOrderField('position')" id="directory-listSearch-order-position"><fmt:message bundle="${messages_directory}" key="directory.positionName" /></a></th>
		<c:if test="${useRank}">
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listSearch_selectOrderField('rank')" id="directory-listSearch-order-rank"><fmt:message bundle="${messages_directory}" key="directory.rankName" /></a></th>
		</c:if>
		<c:if test="${useDuty}">
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listSearch_selectOrderField('duty')" id="directory-listSearch-order-duty"><fmt:message bundle="${messages_directory}" key="directory.dutyName" /></a></th>
		</c:if>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listSearch_selectOrderField('name')" id="directory-listSearch-order-name"><fmt:message bundle="${messages_directory}" key="directory.userName" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listSearch_selectOrderField('nameEng')" id="directory-listSearch-order-nameEng"><fmt:message bundle="${messages_directory}" key="directory.userNameEng" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listSearch_selectOrderField('empCode')" id="directory-listSearch-order-empCode"><fmt:message bundle="${messages_directory}" key="directory.empCode" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listSearch_selectOrderField('deptName')" id="directory-listSearch-order-deptName"><fmt:message bundle="${messages_directory}" key="directory.deptName" /></a></th>
		</tr>
		<tbody>
		<c:set var="count" value="0" scope="page" />
		<c:forEach var="user" items="${userList}" varStatus="loop">
			<c:if test="${IS_ENGLISH}">
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
				<td class="input_chk"><!--input type="checkbox" class="inchk" name="directory-listSearch-check" value="<c:out value="${user.ID}" />" /--></td>
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
				<td title="<c:out value="${user.deptName}" />"><a href="#" onclick="javascript:directory_orgMng.viewDept('<c:out value="${user.deptID}" />');"><c:out value="${user.deptName}" /></a></td>
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
</body>
</html>