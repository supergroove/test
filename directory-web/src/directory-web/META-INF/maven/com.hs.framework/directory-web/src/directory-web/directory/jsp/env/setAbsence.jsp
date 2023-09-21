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
		
		function directory_setAbsence_onLoad() {
			directory_setAbsence_listAbsences();
		}
		
		/**
		 * 지정한 사용자의 부재설정을 변경할 권한이 있는지 검사한다.
		 */
		function directory_setAbsence_checkSetAbsence(userID) {
			var haveAuth = false;
			
			var data = {
				acton:			"checkSetAbsence",
				userID:			userID
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
						case directory_orgErrorCode.ORG_NO_AUTHORIZATION:
							alert($("#directory-setAbsence-noAuth").val());
							break;
						default:
							alert(result.errorMessage);
						}
					} else {
						haveAuth = true;
					}
				},
				error: function(result, status) {
					alert("ERROR : " + status);
				}
			});
			
			return haveAuth;
		}
		
		/**
		 * 목록
		*/
		function directory_setAbsence_listAbsences() {
			$("#directory-setAbsence-workspace").load(DIRECTORY_CONTEXT + "/org.do", {
				acton:			"listAbsences",
				userID:			$("#directory-setAbsence-userID").val()
			}, function() {
				if (typeof(directory_listAbsences_onLoad) != "undefined") {
					directory_listAbsences_onLoad();
				}
			});
		}
		
		/**
		 * 복사
		*/
		function directory_setAbsence_viewCopyAbsence(absenceID) {
			directory_setAbsence_viewUpdateAbsence(absenceID, true);
		}
		/**
		 * 추가
		*/
		function directory_setAbsence_viewAddAbsence() {
			directory_setAbsence_viewUpdateAbsence();
		}
		function directory_setAbsence_addAbsence() {
			directory_setAbsence_updateAbsence();
		}
		/**
		 * 변경
		*/
		function directory_setAbsence_viewUpdateAbsence(absenceID, isCopy) {
			$("#directory-setAbsence-workspace").load(DIRECTORY_CONTEXT + "/org.do", {
				acton:			"viewUpdateAbsence",
				userID:			$("#directory-setAbsence-userID").val(),
				absenceID:		absenceID || "",
				isCopy:			isCopy ? "1" : "0"
			}, function() {
				if (typeof(directory_updateAbsence_onLoad) != "undefined") {
					directory_updateAbsence_onLoad();
				}
			});
		}
		function directory_setAbsence_updateAbsence(absenceID) {
			var absSDate = $("#directory-updateAbsence-absSDate").val();
			var absSTime = $("#directory-updateAbsence-absSTime option:selected").val();
			var absEDate = $("#directory-updateAbsence-absEDate").val();
			var absETime = $("#directory-updateAbsence-absETime option:selected").val();
			var notSancID = $("#directory-updateAbsence-notSancID option:selected").val();
			var absMsg = $("#directory-updateAbsence-absMsg").val();
			
			var msgRecipientType = $.trim($("input[name='directory-updateAbsence-msgRecipientType']:checked").val());
			var msgRecipientName = $.trim($("#directory-updateAbsence-msgRecipientName").val());
			var msgRecipientID = $.trim($("#directory-updateAbsence-msgRecipientID").val());
			var altMailUserID = $.trim($("#directory-updateAbsence-altMailUserID").val());
			
			if (!absSDate || !absSTime || !absEDate || !absETime) {
				alert($("#directory-setAbsence-not-date").val());
				return;
			}
			
			var redate = /^\d{4}\.\d{1,2}\.\d{1,2}$/;
			if (!absSDate.match(redate)) {
				alert($("#directory-setAbsence-dateformat").val());
				$("#directory-updateAbsence-absSDate").focus();
				return;
			}
			if (!absEDate.match(redate)) {
				alert($("#directory-setAbsence-dateformat").val());
				$("#directory-updateAbsence-absEDate").focus();
				return;
			}
			
			if (notSancID == '-1') {
				alert($("#directory-setAbsence-select-reason").val());
				$("#directory-updateAbsence-notSancID").focus();
				return;
			}
			if (absMsg.length < 1) {
				alert($("#directory-setAbsence-input-message").val());
				$("#directory-updateAbsence-absMsg").focus();
				return;
			}
			if (directory_org.stringByteSize(absMsg) > 500) {
				alert($("#directory-setAbsence-maxLength").val().replace("{0}", $("#directory-setAbsence-message").val()).replace("{1}", 166).replace("{2}", 500));
				return;
			}
			if (directory_setAbsence_getDate(absSDate, absSTime).getTime() >= directory_setAbsence_getDate(absEDate, absETime).getTime()) {
				alert($("#directory-setAbsence-earlier-enddate").val());
				return;
			}
			if ((new Date()).getTime() >= directory_setAbsence_getDate(absEDate, absETime).getTime()) {
				alert($("#directory-setAbsence-current-enddate").val());
				return;
			}
			
			if (msgRecipientType == "1" && msgRecipientID == "") {
				alert($("#directory-setAbsence-mail-noAltRecvMailUser").val());
				return;
			}
			if (msgRecipientID.indexOf($("#directory-setAbsence-userID").val()) > -1) {
				alert($("#directory-setAbsence-mail-assignToSelfAbsenceError").val());
				return;
			}
			if (directory_org.stringByteSize(msgRecipientID) > 1000
					|| directory_org.stringByteSize(msgRecipientName) > 2000) {
				alert($("#directory-setAbsence-mail-assignedUserTooMany").val());
				return;
			}
			if (altMailUserID.indexOf($("#directory-setAbsence-userID").val()) > -1) {
				alert($("#directory-setAbsence-mail-altRecvAssignToSelfError").val());
				$("#directory-updateAbsence-altMailUserName").val("");
				$("#directory-updateAbsence-altMailUserID").val("");
				return;
			}
			
			var data = {
				acton:			"updateAbsence",
				userID:			$("#directory-setAbsence-userID").val(),
				absenceID:		absenceID || "",
				absSDate:		absSDate + " " + absSTime + ":00:00",
				absEDate:		absEDate + " " + absETime + ":00:00",
				notSancID:		notSancID,
				absMsg:			absMsg,
				altMailUserID:		altMailUserID,
				msgRecipientID:		msgRecipientID,
				msgRecipientName:	msgRecipientName,
				msgRecipientType:	msgRecipientType
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
						case directory_orgErrorCode.ORG_NO_AUTHORIZATION:
							alert($("#directory-setAbsence-noAuth").val());
							break;
						case directory_orgErrorCode.ORG_ABSENCE_DUPLICATED_PERIOD:
							alert($("#directory-setAbsence-duplicatedPeriod").val());
							break;
						case directory_orgErrorCode.ORG_ABSENCE_ALTMAILUSER_ABS:
							alert($("#directory-setAbsence-altMailUserAbs").val());
							break;
						default:
							alert(result.errorMessage);
						}
					} else {
						if (!absenceID) {
							alert($("#directory-setAbsence-added").val());
						} else {
							alert($("#directory-setAbsence-updated").val());
						}
						// listAbsences reload
						directory_setAbsence_listAbsences();
					}
				},
				error: function(result, status) {
					alert("ERROR : " + status);
				}
			});
		}
		
		/**
		 * 삭제
		*/
		function directory_setAbsence_deleteAbsences(absenceIDs) {
			if (!absenceIDs) {
				absenceIDs = "";
				$("input[name='directory-listAbsences-check']").each(function() {
					if ($(this).is(":checked")) {
						absenceIDs += $(this).val() + ";";
					}
				});
			}
			
			if (absenceIDs.length == 0) {
				alert($("#directory-setAbsence-selectItem").val());
				return;
			}
			if (!confirm($("#directory-setAbsence-confirmDelete").val())) {
				return;
			}
			
			var data = {
				acton:			"deleteAbsences",
				userID:			$("#directory-setAbsence-userID").val(),
				absenceIDs:		absenceIDs
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
						case directory_orgErrorCode.ORG_NO_AUTHORIZATION:
							alert($("#directory-setAbsence-noAuth").val());
							break;
						default:
							alert(result.errorMessage);
						}
					} else {
						alert($("#directory-setAbsence-deleted").val());
						// listAbsences reload
						directory_setAbsence_listAbsences();
					}
				},
				error: function(result, status) {
					alert("ERROR : " + status);
				}
			});
		}
		
		function directory_setAbsence_getDate(ctrl, hours) {
			var t = ctrl.split(".");
			return (t.length == 3) ? new Date(t[0], t[1] - 1, t[2], hours) : null;
		}
		
		var directory = null; // required - must exist "directory" variable
		
		function directory_setAbsence_selectUser(objID, objName, isMulti) {
			directory = $("#directory-setAbsence-popup").directorypopup({
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
				if (objID.attr("id") == "directory-setAbsence-userID") {
					if (toList.size() == 0) {
						alert($("#directory-setAbsence-selectUserMsg").val());
						return;
					} else if (!directory_setAbsence_checkSetAbsence(toList.get(0).toString("id"))) {
						return;
					}
				}
				
				if (toList.size() == 1) {
					objID.val(toList.get(0).toString("id"));
					objName.val(toList.get(0).toString("name"));
				} else {
					objID.val(toList.toString("id"));
					objName.val(toList.toString("name"));
				}
				
				switch (objID.attr("id")) {
				case "directory-setAbsence-userID":
					// listAbsences reload
					directory_setAbsence_listAbsences();
					break;
				case "directory-updateAbsence-msgRecipientID":
					var type = (toList.size() == 0) ? "0" : "1";
					$("input[name='directory-updateAbsence-msgRecipientType'][value='" + type + "']").attr("checked", true);
					break;
				}
			});
		}
	</script>
</head>
<body onload="javascript:directory_setAbsence_onLoad();">
	<div id="directory-setAbsence-popup"></div> <!-- required - must exist "div" element -->
	
	<input type="hidden" id="directory-setAbsence-userID" value="<c:out value="${user.ID}" />" />
	
	<input type="hidden" id="directory-setAbsence-added" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.added" />" />
	<input type="hidden" id="directory-setAbsence-updated" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.updated" />" />
	<input type="hidden" id="directory-setAbsence-deleted" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.deleted" />" />
	<input type="hidden" id="directory-setAbsence-select-reason" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.select.reason" />" />
	<input type="hidden" id="directory-setAbsence-input-message" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.input.message" />" />
	<input type="hidden" id="directory-setAbsence-earlier-enddate" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.earlier.enddate" />" />
	<input type="hidden" id="directory-setAbsence-current-enddate" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.current.enddate" />" />
	<input type="hidden" id="directory-setAbsence-not-proxapprover" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.not.proxapprover" />" />
	<input type="hidden" id="directory-setAbsence-not-date" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.not.date" />" />
	<input type="hidden" id="directory-setAbsence-dateformat" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.dateformat" />" />
	
	<input type="hidden" id="directory-setAbsence-mail-assignedUserTooMany" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.mail.assignedUserTooMany" />" />
	<input type="hidden" id="directory-setAbsence-mail-noAltRecvMailUser" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.mail.noAltRecvMailUser" />" />
	<input type="hidden" id="directory-setAbsence-mail-assignToSelfAbsenceError" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.mail.assignToSelfAbsenceError" />" />
	<input type="hidden" id="directory-setAbsence-mail-altRecvAssignToSelfError" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.mail.altRecvAssignToSelfError" />" />
	
	<input type="hidden" id="directory-setAbsence-confirmDelete" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-setAbsence-selectItem" value="<fmt:message bundle="${messages_directory}" key="directory.selectItem" />" />
	<input type="hidden" id="directory-setAbsence-selectUserMsg" value="<fmt:message bundle="${messages_directory}" key="directory.selectUserMsg" />" />
	
	<input type="hidden" id="directory-setAbsence-noAuth" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.5006.setAbsence" />" />
	<input type="hidden" id="directory-setAbsence-duplicatedPeriod" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.9102.duplicatedPeriod" />" />
	<input type="hidden" id="directory-setAbsence-altMailUserAbs" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.9105.altMailUserAbs" />" />
	
	<input type="hidden" id="directory-setAbsence-maxLength" value="<fmt:message bundle="${messages_directory}" key="directory.maxLength" />" />
	<input type="hidden" id="directory-setAbsence-message" value="<fmt:message bundle="${messages_directory}" key="directory.env.absence.message" />" />
	
	<div>
		<!-- title : start -->
		<div class="title_area">
			<h2 class="title"><span title="HOME&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.title" />&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.setabsence" />"><fmt:message bundle="${messages_directory}" key="directory.env.setabsence" /></span></h2>
		</div>
		<!-- title : end -->
	<c:if test="${isAdmin || isDeptAdmin}">
		<div id="pop_container">
			<table class="basic_table" border="0" cellSpacing="0" cellPadding="0" width="100%">
				<col width="16%">
				<col>
				<tbody>
					<tr>
						<th class="btntitle">
							<a href="javascript:directory_setAbsence_selectUser($('#directory-setAbsence-userID'), $('#directory-setAbsence-userName'), false);"><fmt:message bundle="${messages_directory}" key="directory.selectUser" /><span class="arr_r"></span></a>
						</th>
						<td>
							<div class="search">
								<input type="text" id="directory-setAbsence-userName" value="<c:out value="${user.name}" />" readonly="readonly" />
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</c:if>
		<!-- workspace : start -->
		<div id="directory-setAbsence-workspace"></div>
		<!-- workspace : end -->
	</div>
</body>
</html>