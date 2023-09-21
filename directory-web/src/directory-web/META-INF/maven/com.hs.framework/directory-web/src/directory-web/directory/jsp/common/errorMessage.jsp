<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<style type = 'text/css'>
		th.ErrBox
		{
			background-color: #FAF9F9;
			border-color: #666666;
			border-style: solid solid solid none;
			border-width: 1px;
			text-align: left
		}
		.ErrTypeFont
		{
			color: #9E0B0E;
			font-size: 9pt;
		}
		.ErrMsgFont
		{
			color: #044DA5;
			font-size: 9pt;
		}
		.ErrMsgTable
		{
			width:475px;
			background: '<c:out value="${CONTEXT}"/>/directory/images/ERRORIMG.GIF';
			height:252px;
			border: 0;
			cellpadding:0;
			borderspace:0;
			cellspacing:0;
			align:center;
		}
		.ErrBtnTable
		{
			width:475px;
			border: 0;
			cellpadding:0;
			borderspace:0;
			cellspacing:0;
			align:center;
		}
	</style>
<body>
	<table id="ErrMsgTable">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width='10'>&nbsp;&nbsp;</td>
			<td valign='top' align='left'>
			<br />
			<font class='ErrTypeFont' id="ETYPE"><fmt:message bundle="${messages_directory}" key="directory.error.title.systemError" /></font>
			<br /><br />
			<font class='ErrMsgFont' id="EMSG">
			<c:choose>
			<c:when test="${errorCode == 5006}">
				<fmt:message bundle="${messages_directory}" key="directory.error.message.5006.notAuthorizedUser" />
			</c:when>
			<c:otherwise>
				<fmt:message bundle="${messages_directory}" key="directory.error.message.3000.errorMessage" />
				<br /><br />
				<c:out value="${errorMessage}" />
			</c:otherwise>
			</c:choose>
			</font>
			</td>
			<td width='10'>&nbsp;&nbsp;</td>
		</tr>
	</table>
	<br />
	<!--table id="ErrBtnTable">
	<tr id="CLOSE" style="display:none;">
		<td align=center>
		<a href='javascript:history.back();'><IMG src="<c:out value="${CONTEXT}"/>/directory/images/BUTTONPREV.GIF" border="0"></a>
		</td>
	</tr>
	</table-->
</body>
</html>