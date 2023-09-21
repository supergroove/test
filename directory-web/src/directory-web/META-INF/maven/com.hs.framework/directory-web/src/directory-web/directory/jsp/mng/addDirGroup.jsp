<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupMng.add" /> -->
	
	<script type="text/javascript">
		function directory_addDirGroup_onLoad() {
			$("#directory-addDirGroup-groupName").focus();
		}
		
		var directory = null; // required - must exist "directory" variable
		
		function directory_addDirGroup_openPopup() {
			directory = $("#directory").directorypopup({
				context:		DIRECTORY_CONTEXT,
				display:		"dirGroup",
				checkbox:		"list",
				selectMode:		2	// 1:single, 2:multi
			});
			
			var to = ""; // previous resolved data
			var memberNames = "";
			$("#directory-addDirGroup-memberList").find("option").each(function() {
				to += $(this).val() + "|" + $(this).text() + ";";
				memberNames += $(this).text() + ";";
			});
			directory.init(to);
			
			directory.set(memberNames);
			directory.open(function(toList) {
				directory_addDirGroup_print(toList);
			});
		}
		
		function directory_addDirGroup_print(toList) {
			var memberList = $("#directory-addDirGroup-memberList");
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
		
		function directory_addDirGroup_delete() {
			$("#directory-addDirGroup-memberList").find("option").each(function() {
				if ($(this).is(":selected")) {
					$(this).remove();
				}
			});
		}
		
		function directory_addDirGroup_moveUp() {
			var tmp = null;
			$("#directory-addDirGroup-memberList").find("option").each(function() {
				if (tmp && $(this).is(":selected")) {
					$(tmp).before(this);
				} else {
					tmp = this;
				}
			});
		}
		
		function directory_addDirGroup_moveDown() {
			var tmp = null; // reverse order
			$($("#directory-addDirGroup-memberList").find("option").get().reverse()).each(function() {
				if (tmp && $(this).is(":selected")) {
					$(tmp).after(this);
				} else {
					tmp = this;
				}
			});
		}
	</script>
</head>
<body onload="javascript:directory_addDirGroup_onLoad();">
	<div id="directory"></div> <!-- required - must exist "div" element -->
	
	<input type="hidden" id="directory-addDirGroup-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.confirm" />" />
	<input type="hidden" id="directory-addDirGroup-added" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupMng.added" />" />
	<input type="hidden" id="directory-addDirGroup-inputGroupName" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.error.inputGroupName" />" />
	<input type="hidden" id="directory-addDirGroup-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError" />" />
	<input type="hidden" id="directory-addDirGroup-dupGroupName" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.error.dupGroupName" />" />
	
	<input type="hidden" id="directory-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-dirGroup-groupName" value="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupName" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupMng.add" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_history.back();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.addDirGroup();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
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
								<td><input type="text" class="intxt" style="width: 95.8%;" tabindex="1" id="directory-addDirGroup-groupName" maxlength="60" value="" /></td>
							</tr>
							<tr>
								<th><fmt:message bundle="${messages_directory}" key="directory.dirGroup.targetGroup" /></th>
								<td>
									<input type="hidden" id="directory-addDirGroup-targetGroupID" value="<c:out value="${targetGroup.ID}" />" />
									<c:out value="${targetGroup.name}" />
									<select tabindex="3" id="directory-addDirGroup-movePosition">
										<option value="0" selected="selected"><fmt:message bundle="${messages_directory}" key="directory.move.toSub" /></option>
									<c:if test="${targetGroup.type == 'G'}">
										<option value="1"><fmt:message bundle="${messages_directory}" key="directory.move.toAbove" /></option>
										<option value="2"><fmt:message bundle="${messages_directory}" key="directory.move.toBelow" /></option>
									</c:if>
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
									<a href="#" onclick="javascript:directory_addDirGroup_openPopup();" onfocus="blur();">
										<img src="<c:out value="${CONTEXT}" /><fmt:message bundle="${messages_directory}" key="/directory/images/ADD_ICON.GIF" />" />
									</a><br /><br />
									<a href="#" onclick="javascript:directory_addDirGroup_delete();" onfocus="blur();">
										<img src="<c:out value="${CONTEXT}" /><fmt:message bundle="${messages_directory}" key="/directory/images/DELETE_ICON.GIF" />" />
									</a><br /><br /><br />
									<a href="#" onclick="javascript:directory_addDirGroup_moveUp();" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/UPON.GIF" /></a
									><a href="#" onclick="javascript:directory_addDirGroup_moveDown();" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/DOWNON.GIF" /></a>
								</th>
								<td>
									<select id="directory-addDirGroup-memberList" size="20" multiple="multiple" style="width: 100%;">
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
</body>
</html>