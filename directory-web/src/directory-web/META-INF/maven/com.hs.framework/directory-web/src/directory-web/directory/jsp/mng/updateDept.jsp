<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.deptMng.update" /> -->
	
	<script type="text/javascript">
		var directory = null; // required - must exist "directory" variable
		
		function directory_updateDept_openPopup(objID, objName, isMulti) {
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
<body>
	<div id="directory"></div> <!-- required - must exist "div" element -->
	
	<input type="hidden" id="directory-updateDept-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.update.confirm" />" />
	<input type="hidden" id="directory-updateDept-deptUpdated" value="<fmt:message bundle="${messages_directory}" key="directory.update.deptUpdated" />" />
	<input type="hidden" id="directory-updateDept-inputDeptName" value="<fmt:message bundle="${messages_directory}" key="directory.add.inputDeptName" />" />
	<input type="hidden" id="directory-updateDept-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.deptname.invalidCharacterError" />" />
	<input type="hidden" id="directory-updateDept-dupDeptCode" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupDeptCode" />" />
	<input type="hidden" id="directory-updateDept-dupDeptName" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupDeptName" />" />
	<input type="hidden" id="directory-updateDept-invalidEmailError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidEmailError" />" />
	<input type="hidden" id="directory-updateDept-dupEmail" value="<fmt:message bundle="${messages_directory}" key="directory.add.dupEmail" />" />
	
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-deptName" value="<fmt:message bundle="${messages_directory}" key="directory.deptName" />" />
	<input type="hidden" id="directory-deptNameEng" value="<fmt:message bundle="${messages_directory}" key="directory.deptNameEng" />" />
	<input type="hidden" id="directory-deptCode" value="<fmt:message bundle="${messages_directory}" key="directory.deptCode" />" />
	<input type="hidden" id="directory-email" value="<fmt:message bundle="${messages_directory}" key="directory.en_email" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.deptMng.update" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_history.back();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.updateDept('<c:out value="${dept.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
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
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-updateDept-deptName" maxlength="200" value="<c:out value="${dept.name}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.deptNameEng" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="2" id="directory-updateDept-deptNameEng" maxlength="200" value="<c:out value="${dept.nameEng}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.deptCode" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="3" id="directory-updateDept-deptCode" maxlength="20" value="<c:out value="${dept.deptCode}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.auth" /></th>
								<td>
								<c:forEach var="auth" items="${authes}">
									<c:if test="${auth.type == 3}">
										<c:set var="isChecked" value="" />
										<c:forEach var="userauth" items="${userAuthes}">
											<c:if test="${auth.code == userauth.auth && userauth.userID == dept.ID && userauth.relID == dept.ID}">
												<c:set var="isChecked" value="checked=\"checked\"" />
											</c:if>
										</c:forEach>
										<span class="inp_raochk"><input type="checkbox" tabindex="4" id="directory-updateDept-ownerID-<c:out value="${auth.code}" />" value="<c:out value="${dept.ID}" />" <c:out value="${isChecked}" /> /><c:out value="${auth.name}" /></span><br/>
									</c:if>
								</c:forEach>
								</td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.status" /></th>
								<td>
									<select tabindex="5" id="directory-updateDept-deptStatus">
										<option value="1" <c:if test="${dept.status == '1'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.normal" /></option>
										<option value="8" <c:if test="${dept.status == '8'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.hidden" /></option>
									</select>
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
									<a href="#" onclick="javascript:directory_updateDept_openPopup($('#directory-updateDept-ownerID-<c:out value="${auth.code}" />'), $('#directory-updateDept-ownerName-<c:out value="${auth.code}" />'), <c:out value="${auth.multi}" />);"><c:out value="${auth.name}" /><span class="arr_r"></span></a>
								</th>
								<td>
									<c:set var="ownerIDs" value="" />
									<c:set var="ownerNames" value="" />
									<c:forEach var="userauth" items="${userAuthes}">
										<c:if test="${auth.code == userauth.auth}">
											<c:if test="${IS_ENGLISH}">
												<c:if test="${not empty userMap[userauth.userID].nameEng}">
													<c:set target="${userMap[userauth.userID]}" property="name" value="${userMap[userauth.userID].nameEng}" />
												</c:if>
											</c:if>
											<c:set var="ownerIDs" value="${userauth.userID};${ownerIDs}" />
											<c:set var="ownerNames" value="${userMap[userauth.userID].name};${ownerNames}" />
										</c:if>
									</c:forEach>
									<input type="hidden" id="directory-updateDept-ownerID-<c:out value="${auth.code}" />" value="<c:out value="${ownerIDs}" />" />
									<input type="text" class="intxt" style="width: 95.8%;" id="directory-updateDept-ownerName-<c:out value="${auth.code}" />" readonly="readonly" value="<c:out value="${ownerNames}" />" />
								</td>
							</tr>
							</c:if>
						</c:forEach>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.en_email" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="6" id="directory-updateDept-email" maxlength="128" value="<c:out value="${dept.email}" />" /></td>
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