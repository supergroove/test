<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- calendar -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/js/tigra_calendar/tcal.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/tigra_calendar/tcal.js"></script>
	
	<script type="text/javascript" type="text/javascript">
		function directory_updateAbsence_onLoad() {
		<c:choose>
		<c:when test="${isReadOnly}">
			directory_updateAbsence_setDisabled(); // 종료된 부재설정은 변경할 수 없습니다.
		</c:when>
		<c:otherwise>
			f_tcalInit(); // tcal init
		</c:otherwise>
		</c:choose>
			
			$("input[name='directory-updateAbsence-msgRecipientType'][value='0']").click(function() {
				$("#directory-updateAbsence-msgRecipientName").val("");
				$("#directory-updateAbsence-msgRecipientID").val("");
			});
		}
		
		function directory_updateAbsence_setDisabled() {
			$("#directory-updateAbsence-absSDate").attr("disabled", true);
			$("#directory-updateAbsence-absSTime").attr("disabled", true);
			$("#directory-updateAbsence-absEDate").attr("disabled", true);
			$("#directory-updateAbsence-absETime").attr("disabled", true);
			$("#directory-updateAbsence-notSancID").attr("disabled", true);
			$("#directory-updateAbsence-absMsg").attr("disabled", true);
			
			$("input[name='directory-updateAbsence-msgRecipientType']").attr("disabled", true);
			$("#directory-updateAbsence-msgRecipientName").attr("disabled", true);
			$("#directory-updateAbsence-altMailUserName").attr("disabled", true);
		}
	</script>
</head>
<body onload="javascript:directory_updateAbsence_onLoad();">
	<div id="tcal"></div>
	
	<!-- button : start -->
	<div class="btn_area">
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_setAbsence_listAbsences();"><fmt:message bundle="${messages_directory}" key="directory.list" /></a></span></li>
		<c:if test="${absenceID == null}">
			<li><span><a href="#" onclick="javascript:directory_setAbsence_addAbsence();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
		</c:if>
		<c:if test="${absenceID != null}">
			<c:choose>
			<c:when test="${isReadOnly}">
				<li><span><a href="#" onclick="javascript:directory_setAbsence_viewCopyAbsence('<c:out value="${absenceID}" />');"><fmt:message bundle="${messages_directory}" key="directory.copy" /></a></span></li>
			</c:when>
			<c:otherwise>
				<li><span><a href="#" onclick="javascript:directory_setAbsence_updateAbsence('<c:out value="${absenceID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
			</c:otherwise>
			</c:choose>
			<li><span><a href="#" onclick="javascript:directory_setAbsence_deleteAbsences('<c:out value="${absenceID}" />');"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
		</c:if>
		</ul>
	</div>
	<!-- button : end -->
	<div style="padding: 5px;">
		<!-- table : start -->
		<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
			<col width="17%" />
			<col width="" />
			<tbody>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.env.period" /></th>
					<td>
						<input type="text" class="intxt tcal" id="directory-updateAbsence-absSDate" value='<fmt:formatDate value="${absence.absSDate}" type="date" pattern="yyyy.MM.dd" />' size="14" placeholder="2012.01.01" pattern="^(19|20)\d\d[.](0[1-9]|1[012])[.](0[1-9]|[12][0-9]|3[01])$" />
						<!-- TODO add the calendar -->
						<!--img src="<c:out value="${CONTEXT}" />/directory/images/CALENDAR.GIF" style="cursor: hand" width="22" height="20" align="absmiddle" onclick='popup_calendar.saveClickElement(this);popup_calendar.openCal(this, $("directory-updateAbsence-absSDate"));'-->
						<fmt:formatDate var="startTime" value="${absence.absSDate}" type="time" pattern="H" />
						<select id="directory-updateAbsence-absSTime">
						<c:forEach var="i" begin="0" end="23" step="1" varStatus="status">
							<option value="<c:out value="${status.index}" />" <c:if test="${status.index==startTime}">selected="selected"</c:if>>
								<c:out value="${status.index}" />
							</option>
						</c:forEach>
						</select>
						<fmt:message bundle="${messages_directory}" key="directory.env.hour" />
						~
						<input type="text" class="intxt tcal" id="directory-updateAbsence-absEDate" value='<fmt:formatDate value="${absence.absEDate}" type="date" pattern="yyyy.MM.dd" />' size="14" placeholder="2012.01.01" pattern="^(19|20)\d\d[.](0[1-9]|1[012])[.](0[1-9]|[12][0-9]|3[01])$" />
						<!-- TODO add the calendar -->
						<!--img src="<c:out value="${CONTEXT}" />/directory/images/CALENDAR.GIF" style="cursor: hand" width="22" height="20" align="absmiddle" OnClick='popup_calendar.saveClickElement(this);popup_calendar.openCal(this, $("directory-updateAbsence-absEDate"));'-->
						<fmt:formatDate var="endTime" value="${absence.absEDate}" type="time" pattern="H" />
						<select id="directory-updateAbsence-absETime">
						<c:forEach var="i" begin="0" end="23" step="1" varStatus="status">
							<option value="<c:out value="${status.index}" />" <c:if test="${status.index==endTime}">selected="selected"</c:if>>
								<c:out value="${status.index}" />
							</option>
						</c:forEach>
						</select>
						<fmt:message bundle="${messages_directory}" key="directory.env.hour" />
					</td>
				</tr>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.env.absence.reason" /></th>
					<td>
						<select id="directory-updateAbsence-notSancID">
							<option value='-1' <c:if test="${absence.notSancID=='-1'}">selected="selected"</c:if>>
								<fmt:message bundle="${messages_directory}" key="directory.env.select" />
							</option>
						<c:forEach var="item" items="${notSancs}" varStatus="status">
							<option value='<c:out value="${item.notSancID}" />' <c:if test="${item.notSancID==absence.notSancID}">selected="selected"</c:if>>
								<fmt:message bundle="${messages_directory}" key="directory.env.absence.reason.${item.notSancID}" />
							</option>
						</c:forEach>
						</select>
					</td>
				</tr>
			<c:if test="${!useMail}">
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.env.absence.message" /></th>
					<td><textarea id="directory-updateAbsence-absMsg" rows="4" maxlength="500" wrap="physical" style="resize: none; width: 100%;"><c:out value="${absence.absMsg}" /></textarea></td>
				</tr>
			</c:if>
			</tbody>
		</table>
		<!-- table : end -->
	<c:if test="${useMail}">
		<br />
		<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
			<col width="17%" />
			<col width="" />
			<tbody>
				<tr>
					<th colspan="2"><fmt:message bundle="${messages_directory}" key="directory.env.absence.mail.mailSet" /></th>
				</tr>
				<tr>
					<th><fmt:message bundle="${messages_directory}" key="directory.env.absence.message" /></th>
					<td><textarea id="directory-updateAbsence-absMsg" rows="4" maxlength="500" wrap="physical" style="resize: none; width: 100%;"><c:out value="${absence.absMsg}" /></textarea></td>
				</tr>
				<tr>
					<th class="btntitle">
					<c:choose>
					<c:when test="${isReadOnly}">
						<fmt:message bundle="${messages_directory}" key="directory.env.absence.mail.from" />
					</c:when>
					<c:otherwise>
						<a href="#" onclick="javascript:directory_setAbsence_selectUser($('#directory-updateAbsence-msgRecipientID'), $('#directory-updateAbsence-msgRecipientName'), true);"><fmt:message bundle="${messages_directory}" key="directory.env.absence.mail.from" /><span class="arr_r"></span></a>
					</c:otherwise>
					</c:choose>
					</th>
					<td>
						<span class="inp_raochk"><input type="radio" name="directory-updateAbsence-msgRecipientType" value="0" <c:if test="${absence.msgRecipientType != '1'}">checked="checked"</c:if>><fmt:message bundle="${messages_directory}" key="directory.env.absence.mail.allUser" /></span>
						<span class="inp_raochk"><input type="radio" name="directory-updateAbsence-msgRecipientType" value="1" <c:if test="${absence.msgRecipientType == '1'}">checked="checked"</c:if>><fmt:message bundle="${messages_directory}" key="directory.env.absence.mail.assignedUser" /></span>
						<input type="text" class="intxt" style="width: 60%;" id="directory-updateAbsence-msgRecipientName" value="<c:out value="${absence.msgRecipientName}" />" readonly="readonly" />
						<input type="hidden" id="directory-updateAbsence-msgRecipientID" value="<c:out value="${absence.msgRecipientID}" />" />
					</td>
				</tr>
				<tr>
					<th class="btntitle">
					<c:choose>
					<c:when test="${isReadOnly}">
						<fmt:message bundle="${messages_directory}" key="directory.env.absence.mail.altMailAbsRecvUser" />
					</c:when>
					<c:otherwise>
						<a href="#" onclick="javascript:directory_setAbsence_selectUser($('#directory-updateAbsence-altMailUserID'), $('#directory-updateAbsence-altMailUserName'), false);"><fmt:message bundle="${messages_directory}" key="directory.env.absence.mail.altMailAbsRecvUser" /><span class="arr_r"></span></a>
					</c:otherwise>
					</c:choose>
					</th>
					<td>
						<input type="text" class="intxt" size="45" id="directory-updateAbsence-altMailUserName" value="<c:out value="${altMailUserName}" />" readonly="readonly" />
						<input type="hidden" id="directory-updateAbsence-altMailUserID" value="<c:out value="${absence.altMailUserID}" />" />
					</td>
				</tr>
			</tbody>
		</table>
	</c:if>
	</div>
</body>
</html>