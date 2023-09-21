<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirMng.view" /> -->
</head>
<body>
	<input type="hidden" id="directory-deleteDirGroupHir-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-deleteDirGroupHir-deleted" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirMng.deleted" />" />
	<input type="hidden" id="directory-deleteDirGroupHir-notDeleteHirWithChild" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.error.notDeleteHirWithChild" />" />
	
<c:if test="${hir != null}">
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirMng.view" /></div>
		<ul class="btns">
			<li id="directory-viewDirGroupHir-historyBack"><span><a href="#" onclick="javascript:directory_orgMng.listDirGroupHir();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewUpdateDirGroupHir('<c:out value="${hir.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.deleteDirGroupHir('<c:out value="${hir.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
		</ul>
	</div>
	<!-- button : end -->
	<div style="padding: 5px;">
		<!-- table : start -->
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<col width="49%">
			<col width="5px">
			<col width="">
			<tr>
				<td valign="top">
					<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
						<col width="35%">
						<col width="65%">
						<tbody>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirName" /></th>
								<td><c:out value="${hir.name}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.currentStatus" /></th>
								<td>
								<c:choose>
									<c:when test="${hir.status == '1'}"><fmt:message bundle="${messages_directory}" key="directory.normal" /></c:when>
									<c:when test="${hir.status == '8'}"><fmt:message bundle="${messages_directory}" key="directory.hidden" /></c:when>
									<c:otherwise><fmt:message bundle="${messages_directory}" key="directory.unknownStatus" /></c:otherwise>
								</c:choose>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
				<td></td>
				<td valign="top">
				</td>
			</tr>
		</table>
		<!-- table : end -->
	</div>
</c:if>
<c:if test="${hir == null}">
	<div style="padding: 5px;">
		<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="cen"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.error.notExistHir" /></td>
			</tr>
		</table>
	</div>
</c:if>
</body>
</html>