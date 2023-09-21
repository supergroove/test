<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.authMng" /> -->
	
	<script type="text/javascript">
		function directory_listAuthes_onLoad() {
			$("#directory-listAuthes-checkAll").click(function() {
				directory_listAuthes_toggleAll();
			});
			$("input[name='directory-listAuthes-check']").click(function() {
				directory_listAuthes_toggle($(this));
			});
		}
		
		function directory_listAuthes_toggleAll() {
			if ($("#directory-listAuthes-checkAll").is(":checked")) {
				$("input[name='directory-listAuthes-check']").each(function() {
					if (!$(this).is(":disabled") && !$(this).is(":checked")) {
						$(this).attr("checked", true);
					}
				});
			} else {
				$("input[name='directory-listAuthes-check']").each(function() {
					if (!$(this).is(":disabled") && $(this).is(":checked")) {
						$(this).attr("checked", false);
					}
				});
			}
		}
		
		function directory_listAuthes_toggle(obj) {
			if ($("#directory-listAuthes-checkAll").is(":checked") && !obj.is(":checked")) {
				$("#directory-listAuthes-checkAll").attr("checked", false);
			}
		}
	</script>
</head>
<body onload="directory_listAuthes_onLoad">
	<input type="hidden" id="directory-deleteAuthes-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-deleteAuthes-authDeleted" value="<fmt:message bundle="${messages_directory}" key="directory.delete.authDeleted" />" />
	<input type="hidden" id="directory-deleteAuthes-usedAuthError" value="<fmt:message bundle="${messages_directory}" key="directory.delete.usedAuthError" />" />
	<input type="hidden" id="directory-listAuthes-selectItem" value="<fmt:message bundle="${messages_directory}" key="directory.selectItem" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.authMng" /></div>
		<ul class="btns">
		<c:if test="${isAdmin}">
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewAddAuth();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.deleteAuthes();"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
		</c:if>
		</ul>
	</div>
	<!-- button : end -->
	<!-- table : start -->
	<table class="content_lst" border="0" cellspacing="0" cellpadding="0">
		<col width="33px">
		<col width="150px">
		<col width="200px">
		<col width="150px">
		<col width="">
		<tr>
			<th scope="col" class="input_chk">
			<c:if test="${isAdmin}">
				<input type="checkbox" class="inchk" id="directory-listAuthes-checkAll" />
			</c:if>
			</th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.authCode" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.authName" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.authType" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.authDescription" /></th>
		</tr>
		<tbody>
		<c:forEach var="auth" items="${authList}">
			<tr>
				<td class="input_chk">
				<c:if test="${isAdmin}">
					<input type="checkbox" class="inchk" name="directory-listAuthes-check" value="<c:out value="${auth.code}" />" />
				</c:if>
				</td>
				<td title="<c:out value="${auth.code}" />"><c:out value="${auth.code}" /></td>
				<td title="<c:out value="${auth.name}" />">
				<c:if test="${isAdmin}"><a href="#" onclick="javascript:directory_orgMng.viewUpdateAuth('<c:out value="${auth.code}" />');" onfocus="blur();"></c:if>
					<c:out value="${auth.name}" />
				<c:if test="${isAdmin}"></a></c:if>
				</td>
				<td class="cen">
				<c:choose>
					<c:when test="${auth.type == '0'}"><fmt:message bundle="${messages_directory}" key="directory.authType.user" /></c:when>
					<c:when test="${auth.type == '1'}"><fmt:message bundle="${messages_directory}" key="directory.authType.usertouser" /></c:when>
					<c:when test="${auth.type == '2'}"><fmt:message bundle="${messages_directory}" key="directory.authType.usertodept" /></c:when>
					<c:when test="${auth.type == '3'}"><fmt:message bundle="${messages_directory}" key="directory.authType.dept" /></c:when>
				</c:choose>
				</td>
				<td title="<c:out value="${auth.description}" />"><c:out value="${auth.description}" /></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<!-- table : end -->
	<div class="paginate_area"></div>
</body>
</html>