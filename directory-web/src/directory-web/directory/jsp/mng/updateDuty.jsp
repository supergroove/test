<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.dutyMng.update" /> -->
	
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/mng/orgMng.js"></script>
	
	<script type="text/javascript">
		function directory_updateDuty_onLoad() {
			DIRECTORY_CONTEXT = "<c:out value="${CONTEXT}" />";
		}
		document.onmouseover = function() {
			if(event.srcElement.tagName == "A") {
				 setTimeout("hideStatus()", 0);
			}
		}
		function hideStatus() {
			document.location = "#";	
		}
		hideStatus();
	</script>
</head>
<body onload="javascript:directory_updateDuty_onLoad();">
	<input type="hidden" id="directory-updateDuty-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.update.confirm" />" />
	<input type="hidden" id="directory-updateDuty-dutyUpdated" value="<fmt:message bundle="${messages_directory}" key="directory.update.dutyUpdated" />" />
	<input type="hidden" id="directory-updateDuty-inputDutyName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputDutyName" />" />
	<input type="hidden" id="directory-updateDuty-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-updateDuty-dupDutyCode" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupDutyCode" />" />
	<input type="hidden" id="directory-updateDuty-dupDutyName" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupDutyName" />" />
	
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-dutyCode" value="<fmt:message bundle="${messages_directory}" key="directory.dutyCode" />" />
	<input type="hidden" id="directory-dutyName" value="<fmt:message bundle="${messages_directory}" key="directory.dutyName" />" />
	
	<div id="pop_wrap" style="min-width: 300px;">
		<h1>
			<p><fmt:message bundle="${messages_directory}" key="directory.dutyMng.update" /></p>
		</h1>
		<!-- button : start -->
		<div class="btn_area">
			<ul class="btns">
				<li><span><a href="#" onclick="javascript:directory_orgMng.updateDuty('<c:out value="${duty.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
				<li><span><a href="#" onclick="javascript:window.close();"><fmt:message bundle="${messages_directory}" key="directory.cancel" /></a></span></li>
			</ul>
		</div>
		<!-- button : end -->
		<div id="pop_container">
			<div class="contents">
				<!-- table : start -->
				<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
					<col width="120" />
					<col width="" />
					<tbody>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.dutyCode" /></th>
							<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-updateDuty-dutyCode" maxlength="40" value="<c:out value="${duty.code}" />" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.dutyName" /></th>
							<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="2" id="directory-updateDuty-dutyName" maxlength="120" value="<c:out value="${duty.name}" />" /></td>
						</tr>
					</tbody>
				</table>
				<!-- table : end -->
			</div>
		</div>
	</div>
</body>
</html>