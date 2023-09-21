<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<script type="text/javascript">
		var directory = null; // required - must exist "directory" variable
		
		function directory_addGroup_openPopup() {
			var to = null; // previous resolved data
			if (directory) {
				to = directory.recInfo.to;
			}
			directory = $("#directory").directorypopup({
				context:		DIRECTORY_CONTEXT,
				display:		directory_addGroup_getDisplay(),	// "position, subdept"
				checkbox:		directory_addGroup_getCheckbox(),	// "both", "tree", "list"
				selectMode:		2	// 1:single, 2:multi
			});
			directory.init(to);
			
			var memberNames = "";
			$("#directory-addGroup-memberList").find("option").each(function() {
				memberNames += $(this).text() + ";";
			});
			
			directory.set(memberNames);
			directory.open(function(toList) {
				directory_addGroup_print(toList);
			});
		}
		
		function directory_addGroup_checkMemberType(type) {
			var str = $("#directory-addGroup-groupAppMemberType").val();
			var arr = str.split(/[,;]/);
			for (var i = 0; i < arr.length; i++) {
				if ($.trim(arr[i]) == type) {
					return true;
				}
			}
			return false;
		}
		
		function directory_addGroup_getDisplay() {
			var display = "rootdept";
			if (directory_addGroup_checkMemberType("3")) {
				display += ", position";
			}
			if (directory_addGroup_checkMemberType("5")) {
				display += ", subdept";
			}
			return display;
		}
		
		function directory_addGroup_getCheckbox() {
			var checkbox = "";
			if (directory_addGroup_checkMemberType("0")
					&& directory_addGroup_checkMemberType("1")) {
				checkbox = "both";
			} else if (directory_addGroup_checkMemberType("1")) {
				checkbox = "tree";
			} else {
				checkbox = "list";
			}
			return checkbox;
		}
		
		function directory_addGroup_print(toList) {
			var memberList = $("#directory-addGroup-memberList");
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
		
		function directory_addGroup_delete() {
			$("#directory-addGroup-memberList").find("option").each(function() {
				if ($(this).is(":selected")) {
					$(this).remove();
				}
			});
		}
		
		function directory_addGroup_moveUp() {
			var tmp = null;
			$("#directory-addGroup-memberList").find("option").each(function() {
				if (tmp && $(this).is(":selected")) {
					$(tmp).before(this);
				} else {
					tmp = this;
				}
			});
		}
		
		function directory_addGroup_moveDown() {
			var tmp = null; // reverse order
			$($("#directory-addGroup-memberList").find("option").get().reverse()).each(function() {
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
	
	<input type="hidden" id="directory-addGroup-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.add.confirm" />" />
	<input type="hidden" id="directory-addGroup-groupAdded" value="<fmt:message bundle="${messages_directory}" key="directory.env.group.groupAdded" />" />
	<input type="hidden" id="directory-addGroup-inputGroupName" value="<fmt:message bundle="${messages_directory}" key="directory.env.group.inputGroupName" />" />
	<input type="hidden" id="directory-addGroup-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError"><fmt:param><fmt:message bundle="${messages_directory}" key="directory.env.group.groupName" /></fmt:param></fmt:message>" />
	<input type="hidden" id="directory-addGroup-inputMember" value="<fmt:message bundle="${messages_directory}" key="directory.env.group.inputMember" />" />
	<input type="hidden" id="directory-addGroup-dupGroupName" value="<fmt:message bundle="${messages_directory}" key="directory.env.group.dupGroupName" />" />
	
	<input type="hidden" id="directory-addGroup-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-addGroup-msg-groupName" value="<fmt:message bundle="${messages_directory}" key="directory.env.group.groupName" />" />
	<input type="hidden" id="directory-addGroup-msg-description" value="<fmt:message bundle="${messages_directory}" key="directory.env.group.description" />" />
	
	<div>
		<div>
			<div class="title_area">
				<h2 class="title"><span title="HOME&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.title" />&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.group.title" />"><fmt:message bundle="${messages_directory}" key="directory.env.group.add" /></span></h2>
			</div>
			<!-- button : start -->
			<div class="btn_area">
				<ul class="btns">
					<li><span><a href="#" onclick="javascript:directory_groupMng_addGroup('<c:out value="${groupApp.application}" />');"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
					<li><span><a href="#" onclick="javascript:directory_groupMng_listGroups('<c:out value="${groupApp.application}" />');"><fmt:message bundle="${messages_directory}" key="directory.cancel" /></a></span></li>
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
							<th><fmt:message bundle="${messages_directory}" key="directory.env.group.application" /></th>
							<td><input type="hidden" id="directory-addGroup-groupAppMemberType" value="<c:out value="${groupApp.memberType}" />" /><c:out value="${groupApp.name}" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.env.group.groupName" /></th>
							<td><input type="text" class="intxt" style="width: 98.8%;" tabindex="1" id="directory-addGroup-groupName" maxlength="120" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.env.group.description" /></th>
							<td><input type="text" class="intxt" style="width: 98.8%;" tabindex="2" id="directory-addGroup-description" maxlength="100" /></td>
						</tr>
						<tr>
							<th>
								<a href="#" onclick="javascript:directory_addGroup_openPopup('<c:out value="${groupApp.application}" />');" onfocus="blur();">
									<img src="<c:out value="${CONTEXT}" /><fmt:message bundle="${messages_directory}" key="/directory/images/ADD_ICON.GIF" />" />
								</a><br /><br />
								<a href="#" onclick="javascript:directory_addGroup_delete();" onfocus="blur();">
									<img src="<c:out value="${CONTEXT}" /><fmt:message bundle="${messages_directory}" key="/directory/images/DELETE_ICON.GIF" />" />
								</a><br /><br /><br />
								<a href="#" onclick="javascript:directory_addGroup_moveUp();" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/UPON.GIF" /></a
								><a href="#" onclick="javascript:directory_addGroup_moveDown();" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/DOWNON.GIF" /></a>
							</th>
							<td>
								<select id="directory-addGroup-memberList" size="20" multiple="multiple" style="width: 100%;"></select>
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