<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.userMng" /> -->
	
	<script type="text/javascript">
		function directory_listExternalUsers_onLoad() {
			directory_listExternalUsers_toggleSearchValue($("#directory-listExternalUsers-searchType").val());
			<c:if test="${dept == null}">
				directory_history.removeAll(); // history remove all
			</c:if>
			if (directory_history.size() < 2) {
				$("#directory-listExternalUsers-historyBack").hide();
			}
			$("#directory-listExternalUsers-checkAll").click(function() {
				directory_listExternalUsers_toggleAll();
			});
			$("input[name='directory-listExternalUsers-check']").click(function() {
				directory_listExternalUsers_toggle($(this));
			});
			
			directory_listExternalUsers_addOrderClass();
			
			$("#directory-listExternalUsers-searchType").bind("change", function(event){
				directory_listExternalUsers_toggleSearchValue($("#directory-listExternalUsers-searchType").val());
			});
			$("#directory-listExternalUsers-searchValue").keypress(function(event) {
				if (event.keyCode == 13) {
					event.keyCode = 0;
					$("#directory-listExternalUsers-searchButton").click();
				}
			});
			$("#directory-listExternalUsers-searchButton").click(function() {
				var searchType = $("#directory-listExternalUsers-searchType").length > 0 ? $("#directory-listExternalUsers-searchType").val() : "";
				var searchValue = $("#directory-listExternalUsers-searchValue").length > 0 ? $("#directory-listExternalUsers-searchValue").val() : "";
				if(searchType == 'status'){
					searchValue = $("#directory-listExternalUsers-searchValue-status").length > 0 ? $("#directory-listExternalUsers-searchValue-status").val() : "";
				}
				
				directory_orgMng.listExternalUsers("<c:out value="${dept.ID}" />", searchType, searchValue);
			});
		}
		function directory_listExternalUsers_toggleSearchValue(searchType){
			if('status' == searchType){
				$("#directory-listExternalUsers-searchValue").hide();
				$("#directory-listExternalUsers-searchValue-status").show();
				$("#directory-listExternalUsers-searchValue-status").focus();
			}else{
				$("#directory-listExternalUsers-searchValue").show();
				$("#directory-listExternalUsers-searchValue-status").hide();
				$("#directory-listExternalUsers-searchValue").focus();
			}
		}
		function directory_listExternalUsers_toggleAll() {
			if ($("#directory-listExternalUsers-checkAll").is(":checked")) {
				$("input[name='directory-listExternalUsers-check']").each(function() {
					if (!$(this).is(":disabled") && !$(this).is(":checked")) {
						$(this).attr("checked", true);
					}
				});
			} else {
				$("input[name='directory-listExternalUsers-check']").each(function() {
					if (!$(this).is(":disabled") && $(this).is(":checked")) {
						$(this).attr("checked", false);
					}
				});
			}
		}
		
		function directory_listExternalUsers_toggle(obj) {
			if ($("#directory-listExternalUsers-checkAll").is(":checked") && !obj.is(":checked")) {
				$("#directory-listExternalUsers-checkAll").attr("checked", false);
			}
		}
		
		function directory_listExternalUsers_addOrderClass() {
			var orderField = $("#directory-listExternalUsers-orderField").val();
			
			if (orderField) {
				var orderClass = $("#directory-listExternalUsers-orderType").val() == "asc" ? "ascendent" : "descend";
				$("#directory-listExternalUsers-order-" + orderField).addClass(orderClass);
			}
		}
		
		function directory_listExternalUsers_selectOrderField(orderField) {
			var searchType = $("#directory-listExternalUsers-searchType").length > 0 ? $("#directory-listExternalUsers-searchType").val() : "";
			var searchValue = $("#directory-listExternalUsers-searchValue").length > 0 ? $("#directory-listExternalUsers-searchValue").val() : "";
			if(searchType == 'status'){
				searchValue = $("#directory-listExternalUsers-searchValue-status").length > 0 ? $("#directory-listExternalUsers-searchValue-status").val() : "";
			}
			var orderType = null;
			
			if ($("#directory-listExternalUsers-orderField").val() == orderField
					&& $("#directory-listExternalUsers-orderType").val() == "asc") {
				$("#directory-listExternalUsers-orderType").val("desc");
			} else {
				$("#directory-listExternalUsers-orderType").val("asc");
			}
			orderType = $("#directory-listExternalUsers-orderType").val();
			
			orgMngDebg("directory_listExternalUsers_selectOrderField searchType["+searchType+"],searchValue["+searchValue+"],orderField["+orderField+"],orderType["+orderType+"]");
			
			directory_orgMng.listExternalUsers("<c:out value="${dept.ID}" />", searchType, searchValue, orderField, orderType);
		}
	</script>
</head>
<body onload="directory_listExternalUsers_onLoad()">
	<c:if test="${IS_ENGLISH}">
		<c:if test="${not empty dept.nameEng}">
			<c:set target="${dept}" property="name" value="${dept.nameEng}" />
		</c:if>
	</c:if>
	<input type="hidden" id="directory-listExternalUsers-deptID" value="<c:out value="${dept.ID}" />" />
	<input type="hidden" id="directory-listExternalUsers-orderField" value="<c:out value="${param.orderField}" />" />
	<input type="hidden" id="directory-listExternalUsers-orderType" value="<c:out value="${param.orderType}" />" />
	<input type="hidden" id="directory-listExternalUsers-currentPage" value="<c:out value='${param.currentPage}'/>"/>
	<input type="hidden" id="directory-listExternalUsers-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.externalUser.confirm" />" />
	<input type="hidden" id="directory-listExternalUsers-reject" value="<fmt:message bundle="${messages_directory}" key="directory.externalUser.reject" />" />
	<input type="hidden" id="directory-listExternalUsers-confirmed" value="<fmt:message bundle="${messages_directory}" key="directory.externalUser.confirmed" />" />
	<input type="hidden" id="directory-listExternalUsers-rejected" value="<fmt:message bundle="${messages_directory}" key="directory.externalUser.rejected" />" />
	<input type="hidden" id="directory-listExternalUsers-noneTerm" value="<fmt:message bundle="${messages_directory}" key="directory.search.noneTerm" />" />
	
<c:if test="${dept != null}">
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.externalUser" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_orgMng.confirmExternalUsers('<c:out value="${dept.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.confirm" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.rejectExternalUsers('<c:out value="${dept.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.reject" /></a></span></li>
		</ul>
	<!-- search : start -->
	<div class="srch_area" style="margin-top: 8px;">
		<fieldset class="search">
			<legend><fmt:message bundle="${messages_directory}" key="directory.search" /></legend>
			<select id="directory-listExternalUsers-searchType">
				<option value="name" <c:if test="${param.searchType == 'name'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.userName" /></option>
				<option value="pos" <c:if test="${param.searchType == 'pos'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.positionName" /></option>
			<c:if test="${useRank}">
				<option value="rank" <c:if test="${param.searchType == 'rank'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.rankName" /></option>
			</c:if>
				<option value="code" <c:if test="${param.searchType == 'code'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.empCode" /></option>
			<c:if test="${not cryptedUserColumnsMap.e_mail}">
				<option value="email" <c:if test="${param.searchType == 'email'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.en_email" /></option>
			</c:if>
			<c:if test="${not cryptedUserColumnsMap.phone}">
				<option value="phone" <c:if test="${param.searchType == 'phone'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.phone" /></option>
			</c:if>
			<c:if test="${not cryptedUserColumnsMap.mobile_phone}">
				<option value="mobile" <c:if test="${param.searchType == 'mobile'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.mobilePhone" /></option>
			</c:if>
				<option value="status" <c:if test="${param.searchType == 'status'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.status" /></option>
			</select>
			<input type="text" id="directory-listExternalUsers-searchValue" maxlength="60" value="<c:if test="${param.searchType != 'status'}"><c:out value="${param.searchValue}" /></c:if>" />
			<select id="directory-listExternalUsers-searchValue-status">
				<option value="confirm" <c:if test="${param.searchType == 'status' and 'confirm' == param.searchValue}">selected</c:if>><fmt:message bundle="${messages_directory}" key="directory.confirm" /></option>
				<option value="reject" <c:if test="${param.searchType == 'status' and 'reject' == param.searchValue}">selected</c:if>><fmt:message bundle="${messages_directory}" key="directory.reject" /></option>
			</select>
			<a class="srch_btn" href="#" id="directory-listExternalUsers-searchButton"><fmt:message bundle="${messages_directory}" key="directory.search" /></a>
		</fieldset>
	</div>
	<!-- search : end -->
	</div>
	<!-- button : end -->
	<!-- table : start -->
	<table class="content_lst" border="0" cellspacing="0" cellpadding="0">
		<col width="33px">
		<col width="150px">		
		<col width="150px">
	<c:if test="${useRank}">
		<col width="150px">
	</c:if>
		<col width="150px">
		<col width="150px">
		<col width="">
		<tr>
			<th scope="col" class="input_chk"><input type="checkbox" class="inchk" id="directory-listExternalUsers-checkAll" /></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listExternalUsers_selectOrderField('lockF')" id="directory-listExternalUsers-order-lock_f"><fmt:message bundle="${messages_directory}" key="directory.status" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listExternalUsers_selectOrderField('position')" id="directory-listExternalUsers-order-position"><fmt:message bundle="${messages_directory}" key="directory.positionName" /></a></th>
		<c:if test="${useRank}">
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listExternalUsers_selectOrderField('rank')" id="directory-listExternalUsers-order-rank"><fmt:message bundle="${messages_directory}" key="directory.rankName" /></a></th>
		</c:if>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listExternalUsers_selectOrderField('name')" id="directory-listExternalUsers-order-name"><fmt:message bundle="${messages_directory}" key="directory.userName" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listExternalUsers_selectOrderField('nameEng')" id="directory-listExternalUsers-order-nameEng"><fmt:message bundle="${messages_directory}" key="directory.userNameEng" /></a></th>
			<th scope="col" class="cen"><a href="#" onclick="javascript:directory_listExternalUsers_selectOrderField('email')" id="directory-listExternalUsers-order-email"><fmt:message bundle="${messages_directory}" key="directory.en_email" /></a></th>
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
				<td class="input_chk"><input type="checkbox" class="inchk" name="directory-listExternalUsers-check" value="<c:out value="${user.ID}" />" /></td>
				<td title="<c:out value="${user.empCode}" />">
					<c:if test="${not user.lock}"><fmt:message bundle="${messages_directory}" key="directory.confirm" /></c:if>
					<c:if test="${user.lock}"><fmt:message bundle="${messages_directory}" key="directory.reject" /></c:if>
				</td>
				<td title="<c:out value="${user.positionName}" />"><c:out value="${user.positionName}" /></td>
			<c:if test="${useRank}">
				<td title="<c:out value="${user.rankName}" />"><c:out value="${user.rankName}" /></td>
			</c:if>
				<td title="<c:out value="${user.name}" />">
					<a href="#" onclick="javascript:directory_orgMng.viewUser('<c:out value="${user.ID}" />');"><c:out value="${user.name}" /></a>
					<c:if test="${param.useAbsent && user.absent}"><fmt:message bundle="${messages_directory}" key="directory.absence" /></c:if>
					<c:if test="${user.status == '4'}"><img src="<c:out value="${CONTEXT}" />/directory/images/OS4.GIF" title="<fmt:message bundle="${messages_directory}" key="directory.deleted" />" /></c:if>
				</td>
				<td title="<c:out value="${user.nameEng}" />"><c:out value="${user.nameEng}" /></td>
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
				<td colspan="<c:if test="${useRank}">7</c:if><c:if test="${!useRank}">6</c:if>" class="cen"><fmt:message bundle="${messages_directory}" key="directory.search.noUser" /></td>
			</c:when>
			<c:otherwise>
				<td colspan="<c:if test="${useRank}">7</c:if><c:if test="${!useRank}">6</c:if>"></td>
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