<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.batchMng.directoryInfoExport" /> -->
	
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/cals.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/cals.js"></script>
	<script type="text/javascript">
		var CONTEXT = "<c:out value="${CONTEXT}" />";
		var directory = null; // required - must exist "directory" variable
		function getDateTime(dateID, hourID, minuteID){
			var date = $("#"+dateID).val();
			if(date == ''){
				return '';
			}
			var hour = $("#"+hourID).val();
			var minute = $("#"+minuteID).val();
			//debug("date["+date+"],hour["+hour+"],minute["+minute+"]");
			//return new Date(date.split("-")[0], parseInt(date.split("-")[1],10)-1, date.split("-")[2], hour, minute, 0, 0);
			return date+" "+hour+":"+minute;
		}
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
	<div id="directory"></div> <!-- required - must exist "div" element -->
	
	<input type="hidden" id ="directory-exportBatch-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.batchMng.exportBatchConfirm" />" />
	<input type="hidden" id ="directory-exportBatch-user" value="<fmt:message bundle="${messages_directory}" key="directory.user" />" />	
	<input type="hidden" id ="directory-exportBatch-dept" value="<fmt:message bundle="${messages_directory}" key="directory.dept" />" />
	<input type="hidden" id ="directory-exportBatch-position" value="<fmt:message bundle="${messages_directory}" key="directory.position" />" />
	<input type="hidden" id ="directory-exportBatch-rank" value="<fmt:message bundle="${messages_directory}" key="directory.rank" />" />
	<input type="hidden" id ="directory-exportBatch-duty" value="<fmt:message bundle="${messages_directory}" key="directory.duty" />" />
	<input type="hidden" id ="directory-exportBatch-auth" value="<fmt:message bundle="${messages_directory}" key="directory.auth" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.batchMng.directoryInfoExport" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_orgMng.listBatchs();"><fmt:message bundle="${messages_directory}" key="directory.list" /></a></span></li>
		</ul>
	</div>
	<!-- button : end -->
	<div style="padding: 5px;">
		<!-- table : start -->
		<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
			<col width="100%">
			<tbody>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.batchMng.exportCategory" /></th>
				</tr>
				<tr>
					<td class="cen">
						<fmt:message bundle="${messages_directory}" key="directory.batchMng.export.standarddate" />&nbsp;
						<input type="text" class="intxt" id="exportDate" name="exportDate" value='<fmt:formatDate pattern="yyyy.MM.dd" value="${now}" />' onclick="calenda('exportDate')" style="cursor: pointer;" readonly="readonly" />
						<img src="<c:out value="${CONTEXT}" />/directory/images/calendar.gif" width="22px" height="20px" align="absmiddle" border="0px" onclick="calenda('exportDate')" style="cursor: pointer;"/>
						<select id="exportHour" tabindex="10" name="exportHour">
							<c:forEach var="i" begin="0" end="23" step="1" >
							<option value="<c:out value='${i}'/>"><fmt:formatNumber type="number" pattern="00" value="${i}"/></option>
							</c:forEach>
						</select>
						<span> : </span>
						<select id="exportMinute" tabindex="11" name="exportMinute">
							<c:forEach var="i" begin="0" end="59" step="30" >
							<option value="<c:out value='${i}'/>"><fmt:formatNumber type="number" pattern="00" value="${i}"/></option>
							</c:forEach>
						</select>
						<c:if test="${not empty charsetList}">
						&nbsp;
						<fmt:message bundle="${messages_directory}" key="directory.batchMng.export.charset" />
						<c:set var="defaultCharset"/>
						<select id="selectCharset" tabindex="12" name="selectCharset" onchange="onSelectCharset('selectCharset', 'selectedCharset')">
							<c:forEach var="charset" items="${charsetList}">
							<c:if test="${empty defaultCharset}"><c:set var="defaultCharset" value="${charset}"/></c:if>
							<c:set var="keyForCharset" value="directory.batchMng.export.charset.${charset}"></c:set>
							<option value="<c:out value='${charset}'/>"><fmt:message bundle="${messages_directory}" key="${keyForCharset}" /></option>
							</c:forEach>
						</select>
						<input type="text" class="intxt" id="selectedCharset" name="selectedCharset" value="<c:out value="${defaultCharset}"/>">
						</c:if>
					</td>
				</tr>
				<tr>
					<td class="cen"><a href="#" onclick="javascript:directory_orgMng.exportBatch('0', getDateTime('exportDate', 'exportHour', 'exportMinute'), getSelectedCharset('selectedCharset'));"><fmt:message bundle="${messages_directory}" key="directory.batchMng.userInfo" /></a></td>
				</tr>
				<tr>
					<td class="cen"><a href="#" onclick="javascript:directory_orgMng.exportBatch('1', getDateTime('exportDate', 'exportHour', 'exportMinute'), getSelectedCharset('selectedCharset'));"><fmt:message bundle="${messages_directory}" key="directory.batchMng.deptInfo" /></a></td>
				</tr>
				<tr>
					<td class="cen"><a href="#" onclick="javascript:directory_orgMng.exportBatch('2', getDateTime('exportDate', 'exportHour', 'exportMinute'), getSelectedCharset('selectedCharset'));"><fmt:message bundle="${messages_directory}" key="directory.batchMng.positionInfo" /></a></td>
				</tr>
			<c:if test="${useRank}">
				<tr>
					<td class="cen"><a href="#" onclick="javascript:directory_orgMng.exportBatch('3', getDateTime('exportDate', 'exportHour', 'exportMinute'), getSelectedCharset('selectedCharset'));"><fmt:message bundle="${messages_directory}" key="directory.batchMng.rankInfo" /></a></td>
				</tr>
			</c:if>
			<c:if test="${useDuty}">
				<tr>
					<td class="cen"><a href="#" onclick="javascript:directory_orgMng.exportBatch('4', getDateTime('exportDate', 'exportHour', 'exportMinute'), getSelectedCharset('selectedCharset'));"><fmt:message bundle="${messages_directory}" key="directory.batchMng.dutyInfo" /></a></td>
				</tr>
			</c:if>
				<tr>
					<td class="cen"><a href="#" onclick="javascript:directory_orgMng.exportBatch('5', getDateTime('exportDate', 'exportHour', 'exportMinute'), getSelectedCharset('selectedCharset'));"><fmt:message bundle="${messages_directory}" key="directory.batchMng.authInfo" /></a></td>
				</tr>
			</tbody>
		</table>
		<!-- table : end -->
	</div>
</body>
</html>