<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- HANDY Directory -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/jquery.hs.directory/jquery.hs.directory.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/org.js"></script>
	
	<script type="text/javascript" type="text/javascript">
		var DIRECTORY_CONTEXT = "<c:out value="${CONTEXT}"/>";
		
		function directory_groupMng_onLoad() {
			directory_groupMng_listGroups();
		}
		
		function directory_groupMng_listGroups(application) {
			$("#directory-workspace").load(DIRECTORY_CONTEXT + "/org.do", {
				acton:			"listGroups",
				application:	application || ""
			}, function() {
				directory_listGroups_onLoad();
			});
		}
		
		function directory_groupMng_viewAddGroup(application) {
			$("#directory-workspace").load(DIRECTORY_CONTEXT + "/org.do", {
				acton:			"viewAddGroup",
				application:	application
			});
		}
		
		function directory_groupMng_addGroup(application) {
			var groupName = $("#directory-addGroup-groupName");
			var description = $("#directory-addGroup-description");
			var memberIDs = "";
			var memberNames = "";
			$("#directory-addGroup-memberList").find("option").each(function() {
				memberIDs += $(this).val() + ";";
				memberNames += $(this).text() + ";";
			});
			
			if ($.trim(groupName.val()).length == 0) {
				alert($("#directory-addGroup-inputGroupName").val());
				groupName.val("");
				groupName.focus();
				return;
			}
			if (directory_org.stringByteSize($.trim(groupName.val())) > 120) {
				alert($("#directory-addGroup-maxLength").val().replace("{0}", $("#directory-addGroup-msg-groupName").val()).replace("{1}", 40).replace("{2}", 120));
				groupName.focus();
				return;
			}
			if (!directory_org.isValidCharacter($.trim(groupName.val()))) {
				alert($("#directory-addGroup-invalidCharacterError").val());
				groupName.focus();
				return;
			}
			if (directory_org.stringByteSize($.trim(description.val())) > 100) {
				alert($("#directory-addGroup-maxLength").val().replace("{0}", $("#directory-addGroup-msg-description").val()).replace("{1}", 33).replace("{2}", 100));
				description.focus();
				return;
			}
			if (memberIDs.length == 0) {
				alert($("#directory-addGroup-inputMember").val());
				return;
			}
			if (!confirm($("#directory-addGroup-confirm").val())) {
				return;
			}
			
			var data = {
				acton:			"addGroup",
				application:	application,
				groupName:		$.trim(groupName.val()),
				description:	$.trim(description.val()),
				memberIDs:		memberIDs,
				memberNames:	memberNames
			};
			$.ajax({
				url: DIRECTORY_CONTEXT + "/org.do",
				type: "post",
				async: false,
				dataType: "json",
				data: data,
				success: function(result, status) {
					if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
						switch (result.errorCode) {
						case directory_orgErrorCode.ORG_GROUP_NAME_ALREADY_EXIST:
							alert($("#directory-addGroup-dupGroupName").val().replace("{0}", groupName.val()));
							break;
						default:
							alert(result.errorMessage);
						}
					} else {
						alert($("#directory-addGroup-groupAdded").val());
						// listGroups reload
						directory_groupMng_listGroups(application);
					}
				},
				error: function(result, status) {
					alert("ERROR : " + status);
				}
			});
		}
		
		function directory_groupMng_viewUpdateGroup(groupID) {
			$("#directory-workspace").load(DIRECTORY_CONTEXT + "/org.do", {
				acton:			"viewUpdateGroup",
				groupID:		groupID
			});
		}

		function directory_groupMng_updateGroup(groupID, application) {
			var groupName = $("#directory-updateGroup-groupName");
			var description = $("#directory-updateGroup-description");
			var memberIDs = "";
			var memberNames = "";
			$("#directory-updateGroup-memberList").find("option").each(function() {
				memberIDs += $(this).val() + ";";
				memberNames += $(this).text() + ";";
			});
			
			if ($.trim(groupName.val()).length == 0) {
				alert($("#directory-updateGroup-inputGroupName").val());
				groupName.val("");
				groupName.focus();
				return;
			}
			if (directory_org.stringByteSize($.trim(groupName.val())) > 120) {
				alert($("#directory-updateGroup-maxLength").val().replace("{0}", $("#directory-updateGroup-msg-groupName").val()).replace("{1}", 40).replace("{2}", 120));
				groupName.focus();
				return;
			}
			if (!directory_org.isValidCharacter($.trim(groupName.val()))) {
				alert($("#directory-updateGroup-invalidCharacterError").val());
				groupName.focus();
				return;
			}
			if (directory_org.stringByteSize($.trim(description.val())) > 100) {
				alert($("#directory-updateGroup-maxLength").val().replace("{0}", $("#directory-updateGroup-msg-description").val()).replace("{1}", 33).replace("{2}", 100));
				description.focus();
				return;
			}
			if (memberIDs.length == 0) {
				alert($("#directory-updateGroup-inputMember").val());
				return;
			}
			if (!confirm($("#directory-updateGroup-confirm").val())) {
				return;
			}
			
			var data = {
				acton:			"updateGroup",
				groupID:		groupID,
				groupName:		$.trim(groupName.val()),
				description:	$.trim(description.val()),
				memberIDs:		memberIDs,
				memberNames:	memberNames
			};
			$.ajax({
				url: DIRECTORY_CONTEXT + "/org.do",
				type: "post",
				async: false,
				dataType: "json",
				data: data,
				success: function(result, status) {
					if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
						switch (result.errorCode) {
						case directory_orgErrorCode.ORG_GROUP_NAME_ALREADY_EXIST:
							alert($("#directory-updateGroup-dupGroupName").val().replace("{0}", groupName.val()));
							break;
						default:
							alert(result.errorMessage);
						}
					} else {
						alert($("#directory-updateGroup-groupUpdated").val());
						// listGroups reload
						directory_groupMng_listGroups(application);
					}
				},
				error: function(result, status) {
					alert("ERROR : " + status);
				}
			});
		}
		
		function directory_groupMng_deleteGroups(application) {
			var groupIDs = "";
			$("input[name='directory-listGroups-check']").each(function() {
				if ($(this).is(":checked")) {
					groupIDs += $(this).val() + ";";
				}
			});
			
			if (groupIDs.length == 0) {
				alert($("#directory-listGroups-selectItem").val());
				return;
			}
			if (!confirm($("#directory-deleteGroups-confirm").val())) {
				return;
			}
			
			var data = {
				acton:			"deleteGroups",
				groupIDs:		groupIDs
			};
			$.ajax({
				url: DIRECTORY_CONTEXT + "/org.do",
				type: "post",
				async: false,
				dataType: "json",
				data: data,
				success: function(result, status) {
					if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
						switch (result.errorCode) {
						default:
							alert(result.errorMessage);
						}
					} else {
						alert($("#directory-deleteGroups-groupDeleted").val());
						// listGroups reload
						directory_groupMng_listGroups(application);
					}
				},
				error: function(result, status) {
					alert("ERROR : " + status);
				}
			});
		}
	</script>
</head>
<body>
	<div id="directory-workspace"></div>
</body>
</html>