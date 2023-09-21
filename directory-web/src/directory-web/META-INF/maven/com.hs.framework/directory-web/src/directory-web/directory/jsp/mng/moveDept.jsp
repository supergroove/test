<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.deptMng.move" /> -->
</head>
<body>
	<input type="hidden" id="directory-moveDept-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.move.confirm" />" />
	<input type="hidden" id="directory-moveDept-deptMoved" value="<fmt:message bundle="${messages_directory}" key="directory.move.deptMoved" />" />
	<input type="hidden" id="directory-moveDept-selectTargetDept" value="<fmt:message bundle="${messages_directory}" key="directory.move.selectTargetDept" />" />
	<input type="hidden" id="directory-moveDept-toSelfError" value="<fmt:message bundle="${messages_directory}" key="directory.move.toSelfError" />" />
	<input type="hidden" id="directory-moveDept-toSelfSubError" value="<fmt:message bundle="${messages_directory}" key="directory.move.toSelfSubError" />" />
	<input type="hidden" id="directory-moveDept-toSamePositionError" value="<fmt:message bundle="${messages_directory}" key="directory.move.toSamePositionError" />" />
	<input type="hidden" id="directory-moveDept-toDeletedDeptError" value="<fmt:message bundle="${messages_directory}" key="directory.move.toDeletedDeptError" />" />
	<input type="hidden" id="directory-moveDept-noAuthError" value="<fmt:message bundle="${messages_directory}" key="directory.move.noAuthError" />" />
	<input type="hidden" id="directory-moveDept-dupDeptName" value="<fmt:message bundle="${messages_directory}" key="directory.move.dupDeptName" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.deptMng.move" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_history.back();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.moveDept('<c:out value="${dept.ID}" />', '<c:out value="${dept.name}" />', '<c:out value="${dept.nameEng}" />');"><fmt:message bundle="${messages_directory}" key="directory.move" /></a></span></li>
		</ul>
	</div>
	<!-- button : end -->
	<div style="padding: 5px;">
		<!-- table : start -->
		<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
			<col width="17%">
			<col width="">
			<tbody>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.deptName" /></th>
					<td>
						<c:set var="deptName" value="${dept.name}" />
						<c:if test="${IS_ENGLISH}">
							<c:if test="${not empty dept.nameEng}">
								<c:set var="deptName" value="${dept.nameEng}" />
							</c:if>
						</c:if>
						<c:out value="${deptName}" />
					</td>
				</tr>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.targetDept" /></th>
					<td>
						<input type="hidden" id="directory-moveDept-targetDeptID" />
						<input type="text" class="intxt" style="width: 35.8%;" id="directory-moveDept-targetDeptName" readonly="readonly" onfocus="blur();" />
						<select tabindex="1" id="directory-moveDept-movePosition">
							<option value="0" selected="selected"><fmt:message bundle="${messages_directory}" key="directory.move.toSub" /></option>
							<option value="1"><fmt:message bundle="${messages_directory}" key="directory.move.toAbove" /></option>
							<option value="2"><fmt:message bundle="${messages_directory}" key="directory.move.toBelow" /></option>
						</select><br />
						<fmt:message bundle="${messages_directory}" key="directory.move.selectTargetDeptFromTree" />
					</td>
				</tr>
			</tbody>
		</table>
		<!-- table : end -->
	</div>
</body>
</html>