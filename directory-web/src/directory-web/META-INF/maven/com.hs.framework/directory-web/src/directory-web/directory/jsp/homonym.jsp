<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=8" />
	<title>HANDY Directory</title>
	
	<!-- jQuery -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/orgPopup.js"></script>
	
	<script type="text/javascript">
		$(document).ready(function() {
			$("option").each(function() {
				var arr = parseType($(this).text());
				$(this).text(arr[1]);
			});
			
			resizePopup(700, $("#pop_wrap").height());
		});
		
		function onOK() {
			var recipients = ["", "", ""];
			for (var i = 1; i <= 3; i++) {
				for (var j = 1;; j++) {
					if (!$("#rec_" + i + "_" + j).val()) {
						break;
					}
					recipients[i - 1] += $("#rec_" + i + "_" + j).val() + ";";
				}
			}
			$("#to").val(recipients[0]);
			$("#cc").val(recipients[1]);
			$("#bcc").val(recipients[2]);
			
			if ($("#todo").val() == "resolve") {
				if (opener.directory) {
					$(window).bind("beforeunload", function() {
						orgPopup.load($("#to").val(), $("#cc").val(), $("#bcc").val());
						opener.directory.success(orgPopup.toList, orgPopup.ccList, orgPopup.bccList);
					});
				} else {
					alert("[object Error] opener.directory");
				}
				window.close();
			} else {
				document.homonymForm.submit();
			}
		}
	</script>
</head>
<body>
	<form name="homonymForm" method="post" action="<c:out value="${CONTEXT}" />/org.do">
		<input type="hidden" name="acton" value="popup" />
		<input type="hidden" name="display" value="<c:out value="${param.display}" />" />
		<input type="hidden" name="dutiesUsed" value="<c:out value="${param.dutiesUsed}" />" />
		<input type="hidden" name="checkbox" value="<c:out value="${param.checkbox}" />" />
		<input type="hidden" name="selectMode" value="<c:out value="${param.selectMode}" />" />
		<input type="hidden" name="openerType" value="<c:out value="${param.openerType}" />" />
		<input type="hidden" name="notUseDept" value="<c:out value="${param.notUseDept}" />" />
		<input type="hidden" name="notUseUser" value="<c:out value="${param.notUseUser}" />" />
		<input type="hidden" name="startDept" value="<c:out value="${param.startDept}" />" />
		<input type="hidden" name="groupType" value="<c:out value="${param.groupType}" />" />
		<input type="hidden" name="activeSelect" value="<c:out value="${param.activeSelect}" />" />
		<input type="hidden" name="useAbsent" value="<c:out value="${param.useAbsent}" />" />
		<input type="hidden" name="useSelectAll" value="<c:out value="${param.useSelectAll}" />" />
		<input type="hidden" name="recType" value="<c:out value="${param.recType}" />" />
		<input type="hidden" id="todo" name="todo" value="<c:out value="${param.todo}" />" />
		<input type="hidden" id="to" name="to" />
		<input type="hidden" id="cc" name="cc" />
		<input type="hidden" id="bcc" name="bcc" />
	</form>
	
<div> <!-- clear : html, body { height: 100% } -->
	<div id="pop_wrap" style="min-width: 300px;">
		<h1>
			<p><fmt:message key="message.homonymtitle" /></p>
		</h1>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td align="center" style="line-height: 25px;">
					<fmt:message key="dir.recipients.homonymexist" /><br />
					<fmt:message key="dir.recipients.homonymselect" />
				</td>
			</tr>
		</table>
		<!-- table : start -->
		<c:choose>
		<c:when test="${param.selectMode == 1}">
			<c:forEach var="l" items="${list}" varStatus="loop1">
				<c:forEach var="o" items="${l}" varStatus="loop2">
					<c:choose>
					<c:when test="${not empty o.homonyms}">
						<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
							<col width="20%">
							<col width="">
							<tbody>
								<tr>
									<th><fmt:message key="user.name" /></th>
									<td><c:out value="${o.resolvingName}" /></td>
								</tr>
								<tr>
									<th><fmt:message key="org.select" /></th>
									<td>
										<select size="3" style="width:100%;" id="rec_<c:out value="${loop1.count}" />_<c:out value="${loop2.count}" />">
										<c:forEach var="p" items="${o.homonyms}" varStatus="loop3">
											<c:if test="${IS_ENGLISH}">
												<c:if test="${not empty p.nameEng}">
													<c:set target="${p}" property="name" value="${p.nameEng}" />
												</c:if>
												<c:if test="${not empty p.deptNameEng}">
													<c:set target="${p}" property="deptName" value="${p.deptNameEng}" />
												</c:if>
											</c:if>
											<option value="<c:out value="${p.uniqueID}|${p.name}|${p.deptID}|${p.deptName}" />" <c:if test="${loop3.first}">selected="selected"</c:if>>
												<c:out value="${p.name}" />
											</option>
										</c:forEach>
										</select>
									</td>
								</tr>
							</tbody>
						</table>
					</c:when>
					<c:otherwise>
						<c:if test="${o.item != null}">
							<c:if test="${IS_ENGLISH}">
								<c:if test="${not empty o.item.nameEng}">
									<c:set target="${o.item}" property="name" value="${o.item.nameEng}" />
								</c:if>
								<c:if test="${not empty o.item.deptNameEng}">
									<c:set target="${o.item}" property="deptName" value="${o.item.deptNameEng}" />
								</c:if>
							</c:if>
							<input type="hidden" id="rec_<c:out value="${loop1.count}" />_<c:out value="${loop2.count}" />" value="<c:out value="${o.item.uniqueID}|${o.item.name}|${o.item.deptID}|${o.item.deptName}" />">
						</c:if>
					</c:otherwise>
					</c:choose>
				</c:forEach>
			</c:forEach>
		</c:when>
		<c:otherwise>
			<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
				<col width="20%">
				<col width="">
				<tbody>
					<tr>
						<th><fmt:message key="user.name" /></th>
						<th><fmt:message key="org.select" /></th>
					</tr>
				<c:forEach var="l" items="${list}" varStatus="loop1">
					<c:forEach var="o" items="${l}" varStatus="loop2">
						<c:choose>
						<c:when test="${not empty o.homonyms}">
							<tr>
								<td><c:out value="${o.resolvingName}" /></td>
								<td>
									<select style="width:100%;" id="rec_<c:out value="${loop1.count}" />_<c:out value="${loop2.count}" />">
									<c:forEach var="p" items="${o.homonyms}" varStatus="loop3">
										<c:if test="${IS_ENGLISH}">
											<c:if test="${not empty p.nameEng}">
												<c:set target="${p}" property="name" value="${p.nameEng}" />
											</c:if>
											<c:if test="${not empty p.deptNameEng}">
												<c:set target="${p}" property="deptName" value="${p.deptNameEng}" />
											</c:if>
										</c:if>
										<option value="<c:out value="${p.uniqueID}|${p.name}|${p.deptID}|${p.deptName}" />" <c:if test="${loop3.first}">selected="selected"</c:if>>
											<c:out value="${p.name}" />
										</option>
									</c:forEach>
									</select>
								</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:if test="${o.item != null}">
								<c:if test="${IS_ENGLISH}">
									<c:if test="${not empty o.item.nameEng}">
										<c:set target="${o.item}" property="name" value="${o.item.nameEng}" />
									</c:if>
									<c:if test="${not empty o.item.deptNameEng}">
										<c:set target="${o.item}" property="deptName" value="${o.item.deptNameEng}" />
									</c:if>
								</c:if>
								<input type="hidden" id="rec_<c:out value="${loop1.count}" />_<c:out value="${loop2.count}" />" value="<c:out value="${o.item.uniqueID}|${o.item.name}|${o.item.deptID}|${o.item.deptName}" />">
							</c:if>
						</c:otherwise>
						</c:choose>
					</c:forEach>
				</c:forEach>
				</tbody>
			</table>
		</c:otherwise>
		</c:choose>
		<!-- table : end -->
		<div class="footcen">
			<ul class="btns">
				<li><span><a href="#" onclick="javascript:onOK();"><fmt:message key="org.ok" /></a></span></li>
				<li><span><a href="#" onclick="javascript:window.close();"><fmt:message key="org.cancel" /></a></span></li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>