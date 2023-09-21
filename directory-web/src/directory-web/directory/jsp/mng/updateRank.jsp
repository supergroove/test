<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.rankMng.update" /> -->
	
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/mng/orgMng.js"></script>
	
	<script type="text/javascript">
		function directory_updateRank_onLoad() {
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
<body onload="javascript:directory_updateRank_onLoad();">
	<input type="hidden" id="directory-updateRank-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.update.confirm" />" />
	<input type="hidden" id="directory-updateRank-rankUpdated" value="<fmt:message bundle="${messages_directory}" key="directory.update.rankUpdated" />" />
	<input type="hidden" id="directory-updateRank-inputRankName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputRankName" />" />
	<input type="hidden" id="directory-updateRank-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-updateRank-invalidRankLevel" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidRankLevel" />" />
	<input type="hidden" id="directory-updateRank-dupRankCode" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupRankCode" />" />
	<input type="hidden" id="directory-updateRank-dupRankName" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupRankName" />" />
	
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-rankCode" value="<fmt:message bundle="${messages_directory}" key="directory.rankCode" />" />
	<input type="hidden" id="directory-rankName" value="<fmt:message bundle="${messages_directory}" key="directory.rankName" />" />
	<input type="hidden" id="directory-rankNameEng" value="<fmt:message bundle="${messages_directory}" key="directory.rankNameEng" />" />
	
	<div id="pop_wrap" style="min-width: 300px;">
		<h1>
			<p><fmt:message bundle="${messages_directory}" key="directory.rankMng.update" /></p>
		</h1>
		<!-- button : start -->
		<div class="btn_area">
			<ul class="btns">
				<li><span><a href="#" onclick="javascript:directory_orgMng.updateRank('<c:out value="${rank.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
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
							<th><fmt:message bundle="${messages_directory}" key="directory.rankCode" /></th>
							<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-updateRank-rankCode" maxlength="40" value="<c:out value="${rank.code}" />" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.rankName" /></th>
							<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="2" id="directory-updateRank-rankName" maxlength="120" value="<c:out value="${rank.name}" />" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.rankNameEng" /></th>
							<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="3" id="directory-updateRank-rankNameEng" maxlength="120" value="<c:out value="${rank.nameEng}" />" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.rankLevel" /></th>
							<td>
								<input type="text" class="intxt" style="width: 60%;" tabindex="4" id="directory-updateRank-rankLevel" maxlength="3" value="<c:out value="${rank.level}" />" /> ex) 0 ~ 999
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