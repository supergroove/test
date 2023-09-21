<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupMng.update" /> -->
	
	<script type="text/javascript">
		var directory = null; // required - must exist "directory" variable
		
		function directory_updateDirGroup_openPopup() {
			directory = $("#directory").directorypopup({
				context:		DIRECTORY_CONTEXT,
				display:		"dirGroup",
				checkbox:		"list",
				selectMode:		2	// 1:single, 2:multi
			});
			
			var to = ""; // previous resolved data
			var memberNames = "";
			$("#directory-updateDirGroup-memberList").find("option").each(function() {
				to += $(this).val() + "|" + $(this).text() + ";";
				memberNames += $(this).text() + ";";
			});
			directory.init(to);
			
			directory.set(memberNames);
			directory.open(function(toList) {
				directory_updateDirGroup_print(toList);
			});
		}
		
		function directory_updateDirGroup_print(toList) {
			var memberList = $("#directory-updateDirGroup-memberList");
			// delete
			memberList.find("option").each(function() {
				var isDelete = true;
				for (var i = 0; i < toList.size(); i++) {
					if ($(this).val() == toList.get(i).toString("id")) {
						isDelete = false;
						break;
					}
				}
				if (isDelete) {
					$(this).remove();
				}
			});
			// add
			for (var i = 0; i < toList.size(); i++) {
				var isAdd = true;
				memberList.find("option").each(function() {
					if ($(this).val() == toList.get(i).toString("id")) {
						isAdd = false;
						return;
					}
				});
				if (isAdd) {
					memberList.append("<option value='" + toList.get(i).toString("id") + "'>" + toList.get(i).toString("name") + "</option>");
				}
			}
		}
		
		function directory_updateDirGroup_delete() {
			$("#directory-updateDirGroup-memberList").find("option").each(function() {
				if ($(this).is(":selected")) {
					$(this).remove();
				}
			});
		}
		
		function directory_updateDirGroup_moveUp() {
			var tmp = null;
			$("#directory-updateDirGroup-memberList").find("option").each(function() {
				if (tmp && $(this).is(":selected")) {
					$(tmp).before(this);
				} else {
					tmp = this;
				}
			});
		}
		
		function directory_updateDirGroup_moveDown() {
			var tmp = null; // reverse order
			$($("#directory-updateDirGroup-memberList").find("option").get().reverse()).each(function() {
				if (tmp && $(this).is(":selected")) {
					$(tmp).after(this);
				} else {
					tmp = this;
				}
			});
		}
	</script>
</head>
<body>
	<div id="directory"></div> <!-- required - must exist "div" element -->
	
	<input type="hidden" id="directory-updateDirGroup-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.update.confirm" />" />
	<input type="hidden" id="directory-updateDirGroup-updated" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupMng.updated" />" />
	<input type="hidden" id="directory-updateDirGroup-inputGroupName" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.error.inputGroupName" />" />
	<input type="hidden" id="directory-updateDirGroup-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-updateDirGroup-dupGroupName" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.error.dupGroupName" />" />
	
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-dirGroup-groupName" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupName" />" />
	
<c:if test="${group != null}">
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupMng.update" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_history.back();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.updateDirGroup('<c:out value="${group.ID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
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
								<th><fmt:message bundle="${messages_directory}" key="directory.dirGroup.hir" /></th>
								<td><c:out value="${hir.name}" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupName" /></th>
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-updateDirGroup-groupName" maxlength="60" value="<c:out value="${group.name}" />" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.status" /></th>
								<td>
									<select tabindex="5" id="directory-updateDirGroup-groupStatus">
										<option value="1" <c:if test="${group.status == '1'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.normal" /></option>
										<option value="8" <c:if test="${group.status == '8'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.hidden" /></option>
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
							<tr>
								<th>
									<a href="#" onclick="javascript:directory_updateDirGroup_openPopup();" onfocus="blur();">
										<img src="<c:out value="${CONTEXT}" /><fmt:message bundle="${messages_directory}" key="/directory/images/ADD_ICON.GIF" />" />
									</a><br /><br />
									<a href="#" onclick="javascript:directory_updateDirGroup_delete();" onfocus="blur();">
										<img src="<c:out value="${CONTEXT}" /><fmt:message bundle="${messages_directory}" key="/directory/images/DELETE_ICON.GIF" />" />
									</a><br /><br /><br />
									<a href="#" onclick="javascript:directory_updateDirGroup_moveUp();" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/UPON.GIF" /></a
									><a href="#" onclick="javascript:directory_updateDirGroup_moveDown();" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/DOWNON.GIF" /></a>
								</th>
								<td>
									<select id="directory-updateDirGroup-memberList" size="20" multiple="multiple" style="width: 100%;">
									<c:forEach var="member" items="${memberList}">
										<c:if test="${IS_ENGLISH}">
											<c:if test="${not empty member.nameEng}">
												<c:set target="${member}" property="name" value="${member.nameEng}" />
											</c:if>
										</c:if>
										<option value="<c:out value="${member.ID}" />"><c:out value="${member.name}" /></option>
									</c:forEach>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
		</table>
		<!-- table : end -->
	</div>
</c:if>
<c:if test="${group == null}">
	<div style="padding: 5px;">
		<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="cen"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.error.notExistGroup" /></td>
			</tr>
		</table>
	</div>
</c:if>
</body>
</html>