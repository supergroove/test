<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.positionMng.add" /> -->
	
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/mng/orgMng.js"></script>
	
	<script type="text/javascript">
		function directory_addPosition_onLoad() {
			DIRECTORY_CONTEXT = "<c:out value="${CONTEXT}" />";
			
			$("#directory-addPosition-positionCode").focus();
		}
		//clear popup window.status
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
<body onload="javascript:directory_addPosition_onLoad();">
	<input type="hidden" id="directory-addPosition-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.confirm" />" />
	<input type="hidden" id="directory-addPosition-positionAdded" value="<fmt:message bundle="${messages_directory}" key="directory.add.positionAdded" />" />
	<input type="hidden" id="directory-addPosition-inputPositionName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputPositionName" />" />
	<input type="hidden" id="directory-addPosition-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-addPosition-invalidSecLevel" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidSecLevel" />" />
	<input type="hidden" id="directory-addPosition-dupPosCode" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupPosCode" />" />
	<input type="hidden" id="directory-addPosition-dupPosName" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupPosName" />" />
	
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-positionCode" value="<fmt:message bundle="${messages_directory}" key="directory.positionCode" />" />
	<input type="hidden" id="directory-positionName" value="<fmt:message bundle="${messages_directory}" key="directory.positionName" />" />
	<input type="hidden" id="directory-positionNameEng" value="<fmt:message bundle="${messages_directory}" key="directory.positionNameEng" />" />
	
	<div id="pop_wrap" style="min-width: 300px;">
		<h1>
			<p><fmt:message bundle="${messages_directory}" key="directory.positionMng.add" /></p>
		</h1>
		<!-- button : start -->
		<div class="btn_area">
			<ul class="btns">
				<li><span><a href="#" onclick="javascript:directory_orgMng.addPosition();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
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
							<th><fmt:message bundle="${messages_directory}" key="directory.positionCode" /></th>
							<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-addPosition-positionCode" maxlength="20" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.positionName" /></th>
							<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="2" id="directory-addPosition-positionName" maxlength="120" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.positionNameEng" /></th>
							<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="3" id="directory-addPosition-positionNameEng" maxlength="120" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.secLevel" /></th>
							<td><input type="text" class="intxt" style="width: 60%;" tabindex="4" id="directory-addPosition-secLevel" maxlength="2" value="10" /> ex) 0 ~ 99</td>
						</tr>
					</tbody>
				</table>
				<!-- table : end -->
			</div>
		</div>
	</div>
</body>
</html>