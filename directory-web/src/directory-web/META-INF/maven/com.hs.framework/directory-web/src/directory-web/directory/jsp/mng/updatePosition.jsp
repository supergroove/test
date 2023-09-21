<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.positionMng.update" /> -->
	
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/mng/orgMng.js"></script>
	
	<script type="text/javascript">
		function directory_updatePosition_onLoad() {
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
<body onload="javascript:directory_updatePosition_onLoad();">
	<input type="hidden" id="directory-updatePosition-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.update.confirm" />" />
	<input type="hidden" id="directory-updatePosition-positionUpdated" value="<fmt:message bundle="${messages_directory}" key="directory.update.positionUpdated" />" />
	<input type="hidden" id="directory-updatePosition-inputPositionName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputPositionName" />" />
	<input type="hidden" id="directory-updatePosition-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-updatePosition-invalidSecLevel" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidSecLevel" />" />
	<input type="hidden" id="directory-updatePosition-dupPosCode" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupPosCode" />" />
	<input type="hidden" id="directory-updatePosition-dupPosName" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupPosName" />" />
	
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-positionCode" value="<fmt:message bundle="${messages_directory}" key="directory.positionCode" />" />
	<input type="hidden" id="directory-positionName" value="<fmt:message bundle="${messages_directory}" key="directory.positionName" />" />
	<input type="hidden" id="directory-positionNameEng" value="<fmt:message bundle="${messages_directory}" key="directory.positionNameEng" />" />
	
	<div id="pop_wrap" style="min-width: 300px;">
		<h1>
			<p><fmt:message bundle="${messages_directory}" key="directory.positionMng.update" /></p>
		</h1>
		<!-- button : start -->
		<div class="btn_area">
			<ul class="btns">
				<li><span><a href="#" onclick="javascript:directory_orgMng.updatePosition('<c:out value="${position.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
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
							<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-updatePosition-positionCode" maxlength="20" value="<c:out value="${position.code}" />" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.positionName" /></th>
							<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="2" id="directory-updatePosition-positionName" maxlength="120" value="<c:out value="${position.name}" />" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.positionNameEng" /></th>
							<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="3" id="directory-updatePosition-positionNameEng" maxlength="120" value="<c:out value="${position.nameEng}" />" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.secLevel" /></th>
							<td>
								<input type="text" class="intxt" style="width: 60%;" tabindex="4" id="directory-updatePosition-secLevel" maxlength="2" value="<c:out value="${position.securityLevel}" />" /> ex) 0 ~ 99
								<span class="inp_raochk"><input type="checkbox" tabindex="5" id="directory-updatePosition-updateUserSecLevel" value="1" /><fmt:message bundle="${messages_directory}" key="directory.positionMng.updateUserSecLevel" /></span>
							</td>
						</tr>
					</tbody>
				</table>
				<!-- table : end -->
			</div>
		</div>
	</div>
</body>
</html>