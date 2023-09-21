<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<script type="text/javascript">
		var directory = null; // required - must exist "directory" variable
		
		function directory_updateGroup_openPopup() {
			directory = $("#directory").directorypopup({
				context:		DIRECTORY_CONTEXT,
				display:		directory_updateGroup_getDisplay(),		// "position, subdept"
				checkbox:		directory_updateGroup_getCheckbox(),	// "both", "tree", "list"
				selectMode:		2	// 1:single, 2:multi
			});
			
			var to = ""; // previous resolved data
			var memberNames = "";
			$("#directory-updateGroup-memberList").find("option").each(function() {
				to += $(this).val() + "|" + $(this).text() + ";";
				memberNames += $(this).text() + ";";
			});
			directory.init(to);
			
			directory.set(memberNames);
			directory.open(function(toList) {
				directory_updateGroup_print(toList);
			});
		}
		
		function directory_updateGroup_checkMemberType(type) {
			var str = $("#directory-updateGroup-groupAppMemberType").val();
			var arr = str.split(/[,;]/);
			for (var i = 0; i < arr.length; i++) {
				if ($.trim(arr[i]) == type) {
					return true;
				}
			}
			return false;
		}
		
		function directory_updateGroup_getDisplay() {
			var display = "rootdept";
			if (directory_updateGroup_checkMemberType("3")) {
				display += ", position";
			}
			if (directory_updateGroup_checkMemberType("5")) {
				display += ", subdept";
			}
			return display;
		}
		
		function directory_updateGroup_getCheckbox() {
			var checkbox = "";
			if (directory_updateGroup_checkMemberType("0")
					&& directory_updateGroup_checkMemberType("1")) {
				checkbox = "both";
			} else if (directory_updateGroup_checkMemberType("1")) {
				checkbox = "tree";
			} else {
				checkbox = "list";
			}
			return checkbox;
		}
		
		function directory_updateGroup_print(toList) {
			var memberList = $("#directory-updateGroup-memberList");
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
		
		function directory_updateGroup_delete() {
			$("#directory-updateGroup-memberList").find("option").each(function() {
				if ($(this).is(":selected")) {
					$(this).remove();
				}
			});
		}
		
		function directory_updateGroup_moveUp() {
			var tmp = null;
			$("#directory-updateGroup-memberList").find("option").each(function() {
				if (tmp && $(this).is(":selected")) {
					$(tmp).before(this);
				} else {
					tmp = this;
				}
			});
		}
		
		function directory_updateGroup_moveDown() {
			var tmp = null; // reverse order
			$($("#directory-updateGroup-memberList").find("option").get().reverse()).each(function() {
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
	
	<input type="hidden" id="directory-updateGroup-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.update.confirm" />" />
	<input type="hidden" id="directory-updateGroup-groupUpdated" value="<fmt:message bundle="${messages_directory}" key="directory.env.group.groupUpdated" />" />
	<input type="hidden" id="directory-updateGroup-inputGroupName" value="<fmt:message bundle="${messages_directory}" key="directory.env.group.inputGroupName" />" />
	<input type="hidden" id="directory-updateGroup-invalidCharacterError" value="<fmt:message bundle="${messages_directory}" key="directory.add.invalidCharacterError"><fmt:param><fmt:message bundle="${messages_directory}" key="directory.env.group.groupName" /></fmt:param></fmt:message>" />
	<input type="hidden" id="directory-updateGroup-inputMember" value="<fmt:message bundle="${messages_directory}" key="directory.env.group.inputMember" />" />
	<input type="hidden" id="directory-updateGroup-dupGroupName" value="<fmt:message bundle="${messages_directory}" key="directory.env.group.dupGroupName" />" />
	
	<input type="hidden" id="directory-updateGroup-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-updateGroup-msg-groupName" value="<fmt:message bundle="${messages_directory}" key="directory.env.group.groupName" />" />
	<input type="hidden" id="directory-updateGroup-msg-description" value="<fmt:message bundle="${messages_directory}" key="directory.env.group.description" />" />
	
	<div>
		<div>
			<div class="title_area">
				<h2 class="title"><span title="HOME&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.title" />&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.group.title" />"><fmt:message bundle="${messages_directory}" key="directory.env.group.update" /></span></h2>
			</div>
			<!-- button : start -->
			<div class="btn_area">
				<ul class="btns">
					<li><span><a href="#" onclick="javascript:directory_groupMng_updateGroup('<c:out value="${group.ID}" />', '<c:out value="${groupApp.application}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
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
							<td><input type="hidden" id="directory-updateGroup-groupAppMemberType" value="<c:out value="${groupApp.memberType}" />" /><c:out value="${groupApp.name}" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.env.group.groupName" /></th>
							<td><input type="text" class="intxt" style="width: 98.8%;" tabindex="1" id="directory-updateGroup-groupName" maxlength="120" value="<c:out value="${group.name}" />" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.env.group.description" /></th>
							<td><input type="text" class="intxt" style="width: 98.8%;" tabindex="2" id="directory-updateGroup-description" maxlength="100" value="<c:out value="${group.description}" />" /></td>
						</tr>
						<tr>
							<th>
								<a href="#" onclick="javascript:directory_updateGroup_openPopup();" onfocus="blur();">
									<img src="<c:out value="${CONTEXT}" /><fmt:message bundle="${messages_directory}" key="/directory/images/ADD_ICON.GIF" />" />
								</a><br /><br />
								<a href="#" onclick="javascript:directory_updateGroup_delete();" onfocus="blur();">
									<img src="<c:out value="${CONTEXT}" /><fmt:message bundle="${messages_directory}" key="/directory/images/DELETE_ICON.GIF" />" />
								</a><br /><br /><br />
								<a href="#" onclick="javascript:directory_updateGroup_moveUp();" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/UPON.GIF" /></a
								><a href="#" onclick="javascript:directory_updateGroup_moveDown();" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/DOWNON.GIF" /></a>
							</th>
							<td>
								<select id="directory-updateGroup-memberList" size="20" multiple="multiple" style="width: 100%;">
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
				<!-- table : end -->
			</div>
		</div>
	</div>
</body>
</html>