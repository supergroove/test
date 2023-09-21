<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- jQuery -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/orgPopup.js"></script>
	
	<script type="text/javascript">
		$(document).ready(function() {
			onOK();
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
				document.resolvedForm.submit();
			}
		}
	</script>
</head>
<body>
	<form name="resolvedForm" method="post" action="<c:out value="${CONTEXT}" />/org.do">
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
	
	<c:forEach var="l" items="${list}" varStatus="loop1">
		<c:forEach var="o" items="${l}" varStatus="loop2">
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
		</c:forEach>
	</c:forEach>
</body>
</html>