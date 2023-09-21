<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirMng.add" /> -->
	
	<script type="text/javascript">
		function directory_addDirGroupHir_onLoad() {
			$("#directory-addDirGroupHir-hirName").focus();
		}
	</script>
</head>
<body onload="javascript:directory_addDirGroupHir_onLoad();">
	<input type="hidden" id="directory-addDirGroupHir-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.confirm" />" />
	<input type="hidden" id="directory-addDirGroupHir-added" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirMng.added" />" />
	<input type="hidden" id="directory-addDirGroupHir-inputHirName" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.error.inputHirName" />" />
	<input type="hidden" id="directory-addDirGroupHir-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-addDirGroupHir-dupHirName" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.error.dupHirName" />" />
	
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-dirGroup-hirName" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirName" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirMng.add" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_orgMng.listDirGroupHir();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.addDirGroupHir();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
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
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-addDirGroupHir-hirName" maxlength="60" value="" /></td>
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
</body>
</html>