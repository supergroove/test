<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.deptMng.add" /> -->
	
	<script type="text/javascript">
		function directory_addDept_onLoad() {
			$("#directory-addDept-deptName").focus();
		}
		
		var directory = null; // required - must exist "directory" variable
		
		function directory_addDept_openPopup(objID, objName, isMulti) {
			directory = $("#directory").directorypopup({
				context:		DIRECTORY_CONTEXT,
				checkbox:		"list",
				selectMode:		isMulti ? 2 : 1		// 1:single, 2:multi
			});
			
			var to = "";
			var idArr = objID.val().split(/[,;]/);
			var nameArr = objName.val().split(/[,;]/);
			for (var i = 0; i < idArr.length; i++) {
				if ($.trim(idArr[i])) {
					to += $.trim(idArr[i]) + "|" + $.trim(nameArr[i]) + ";";
				}
			}
			directory.init(to);
			
			directory.set(objName.val());
			directory.open(function(toList) {
				objID.val(toList.toString("id"));
				objName.val(toList.toString("name"));
			});
		}
	</script>
</head>
<body onload="directory_addDept_onLoad()">
	<div id="directory"></div> <!-- required - must exist "div" element -->
	
	<input type="hidden" id="directory-addDept-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.confirm" />" />
	<input type="hidden" id="directory-addDept-deptAdded" value="<fmt:message bundle="${messages_directory}" key="directory.add.deptAdded" />" />
	<input type="hidden" id="directory-addDept-inputDeptName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputDeptName" />" />
	<input type="hidden" id="directory-addDept-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.deptname.invalidCharacterError" />" />
	<input type="hidden" id="directory-addDept-noAuthError" value="<fmt:message bundle="${messages_directory}" key="directory.add.noAuthError" />" />
	<input type="hidden" id="directory-addDept-dupDeptCode" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupDeptCode" />" />
	<input type="hidden" id="directory-addDept-dupDeptName" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupDeptName" />" />
	<input type="hidden" id="directory-addDept-invalidEmailError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidEmailError" />" />
	<input type="hidden" id="directory-addDept-dupEmail" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupEmail" />" />
	
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-deptName" value="<fmt:message bundle="${messages_directory}" key="directory.deptName" />" />
	<input type="hidden" id="directory-deptNameEng" value="<fmt:message bundle="${messages_directory}" key="directory.deptNameEng" />" />
	<input type="hidden" id="directory-deptCode" value="<fmt:message bundle="${messages_directory}" key="directory.deptCode" />" />
	<input type="hidden" id="directory-email" value="<fmt:message bundle="${messages_directory}" key="directory.en_email" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.deptMng.add" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_history.back();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.addDept();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
		</ul>
	</div>
	<!-- button : end -->
	<div style="padding: 5px;">
		<!-- table : start -->
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<col width="49%">
			<col width="5px">
			<col width="">
			<tr>
				<td valign="top">
					<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
						<col width="35%">
						<col width="65%">
						<tbody>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.deptName" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-addDept-deptName" maxlength="200" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.deptNameEng" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="2" id="directory-addDept-deptNameEng" maxlength="200" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.targetDept" /></th>
								<td>
									<c:if test="${IS_ENGLISH}">
										<c:if test="${not empty targetDept.nameEng}">
											<c:set target="${targetDept}" property="name" value="${targetDept.nameEng}" />
										</c:if>
									</c:if>
									<input type="hidden" id="directory-addDept-targetDeptID" value="<c:out value="${targetDept.ID}" />" />
									<c:out value="${targetDept.name}" />
									<select tabindex="3" id="directory-addDept-movePosition">
										<option value="0" selected="selected"><fmt:message bundle="${messages_directory}" key="directory.move.toSub" /></option>
									<c:if test="${hasAuthParentDept}">
										<option value="1"><fmt:message bundle="${messages_directory}" key="directory.move.toAbove" /></option>
										<option value="2"><fmt:message bundle="${messages_directory}" key="directory.move.toBelow" /></option>
									</c:if>
									</select>
								</td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.deptCode" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="4" id="directory-addDept-deptCode" maxlength="20" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.auth" /></th>
								<td>
								<c:forEach var="auth" items="${authes}">
									<c:if test="${auth.type == 3}">
										<span class="inp_raochk"><input type="checkbox" tabindex="5" id="directory-addDept-ownerID-<c:out value="${auth.code}" />" value="<c:out value="${auth.code}" />" /><c:out value="${auth.name}" /></span><br />
									</c:if>
								</c:forEach>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
				<td></td>
				<td valign="top">
					<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
						<col width="35%">
						<col width="65%">
						<tbody>
						<c:forEach var="auth" items="${authes}">
							<c:if test="${auth.type != 3}">
							<tr>
								<th class="btntitle">
									<a href="#" onclick="javascript:directory_addDept_openPopup($('#directory-addDept-ownerID-<c:out value="${auth.code}" />'), $('#directory-addDept-ownerName-<c:out value="${auth.code}" />'), <c:out value="${auth.multi}" />);"><c:out value="${auth.name}" /><span class="arr_r"></span></a>
								</th>
								<td>
									<input type="hidden" id="directory-addDept-ownerID-<c:out value="${auth.code}" />" />
									<input type="text" class="intxt" style="width: 95.8%;" id="directory-addDept-ownerName-<c:out value="${auth.code}" />" readonly="readonly" />
								</td>
							</tr>
							</c:if>
						</c:forEach>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.en_email" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="6" id="directory-addDept-email" maxlength="128" value="" /></td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
		</table>
		<!-- table : end -->
	</div>
</body>
</html>