<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.batchMng.add" /> -->
	
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/jquery.form/jquery.form.js"></script>
	<script type="text/javascript">
		function onSelectCharset(selectCharsetID, selectedCharsetID){
			var charset = $("#"+selectCharsetID).val();
			$("#"+selectedCharsetID).val(charset);
		}
		function getSelectedCharset(selectedCharsetID){
			return $("#"+selectedCharsetID).val();
		}
	</script>
</head>
<body>
<form id="directory-addBatch-addBatchform" method="post" enctype="multipart/form-data">
	<input type="hidden" id="directory-addBatch-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.confirm" />" />
	<input type="hidden" id="directory-addBatch-batchAdded" value="<fmt:message bundle="${messages_directory}" key="directory.add.batchAdded" />" />
	<input type="hidden" id="directory-addBatch-fileReadError" value="<fmt:message bundle="${messages_directory}" key="directory.add.fileReadError" />" />
	<input type="hidden" id="directory-addBatch-unknownOrgType" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.10110.unknownOrgType" />" />
	<input type="hidden" id="directory-addBatch-unknwonOpType" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.10111.unknownOpType" />" />
	<input type="hidden" id="directory-addBatch-notExistOrgType" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.10112.notExistOrgType" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.batchMng.add" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_orgMng.listBatchs();"><fmt:message bundle="${messages_directory}" key="directory.list" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.addBatch(getSelectedCharset('selectedCharset'));"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
		</ul>
	</div>
	<!-- button : end -->
	<div style="padding: 5px;">
		<!-- table : start -->
		<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
			<col width="17%">
			<col width="">
			<tbody>
				<c:if test="${not empty charsetList}">
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.batchMng.export.charset" /></th>
					<td>
						<c:set var="defaultCharset"/>
						<select id="selectCharset" tabindex="12" name="selectCharset" onchange="onSelectCharset('selectCharset', 'selectedCharset')">
							<c:forEach var="charset" items="${charsetList}">
							<c:if test="${empty defaultCharset}"><c:set var="defaultCharset" value="${charset}"/></c:if>
							<c:set var="keyForCharset" value="directory.batchMng.export.charset.${charset}"></c:set>
							<option value="<c:out value='${charset}'/>"><fmt:message bundle="${messages_directory}" key="${keyForCharset}" /></option>
							</c:forEach>
						</select>
						<input type="text" class="intxt" id="selectedCharset" name="selectedCharset" value="<c:out value="${defaultCharset}"/>">
					</td>
				</tr>
				</c:if>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.user" /> csv <fmt:message bundle="${messages_directory}" key="directory.file" /></th>
					<td><input type="file" size="50" id="directory-addBatch-type-user" name="userFile" /></td>
				</tr>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.dept" /> csv <fmt:message bundle="${messages_directory}" key="directory.file" /></th>
					<td><input type="file" size="50" id="directory-addBatch-type-dept" name="deptFile" /></td>
				</tr>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.position" /> csv <fmt:message bundle="${messages_directory}" key="directory.file" /></th>
					<td><input type="file" size="50" id="directory-addBatch-type-position" name="positionFile" /></td>
				</tr>
			<c:if test="${useRank}">
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.rank" /> csv <fmt:message bundle="${messages_directory}" key="directory.file" /></th>
					<td><input type="file" size="50" id="directory-addBatch-type-rank" name="rankFile" /></td>
				</tr>
			</c:if>
			<c:if test="${useDuty}">
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.duty" /> csv <fmt:message bundle="${messages_directory}" key="directory.file" /></th>
					<td><input type="file" size="50" id="directory-addBatch-type-duty" name="dutyFile" /></td>
				</tr>
			</c:if>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.auth" /> csv <fmt:message bundle="${messages_directory}" key="directory.file" /></th>
					<td><input type="file" size="50" id="directory-addBatch-type-auth" name="authFile" /></td>
				</tr>
			</tbody>
		</table>
		<!-- table : end -->
	</div>
</form>
</body>
</html>