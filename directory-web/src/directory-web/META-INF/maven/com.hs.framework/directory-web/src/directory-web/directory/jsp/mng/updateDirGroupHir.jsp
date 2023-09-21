<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirMng.update" /> -->
</head>
<body>
	<input type="hidden" id="directory-updateDirGroupHir-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.update.confirm" />" />
	<input type="hidden" id="directory-updateDirGroupHir-updated" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirMng.updated" />" />
	<input type="hidden" id="directory-updateDirGroupHir-inputHirName" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.error.inputHirName" />" />
	<input type="hidden" id="directory-updateDirGroupHir-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-updateDirGroupHir-dupHirName" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.error.dupHirName" />" />
	
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-dirGroup-hirName" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirName" />" />
	
<c:if test="${hir != null}">
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirMng.update" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_orgMng.listDirGroupHir();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.updateDirGroupHir('<c:out value="${hir.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
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
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-updateDirGroupHir-hirName" maxlength="60" value="<c:out value="${hir.name}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.status" /></th>
								<td>
									<select tabindex="5" id="directory-updateDirGroupHir-hirStatus">
										<option value="1" <c:if test="${hir.status == '1'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.normal" /></option>
										<option value="8" <c:if test="${hir.status == '8'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.hidden" /></option>
									</select>
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