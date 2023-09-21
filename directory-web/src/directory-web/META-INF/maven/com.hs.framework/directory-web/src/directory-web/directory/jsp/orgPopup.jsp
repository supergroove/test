<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=8" />
<!-- PAL 커스터마이징 : start -->
<!--
	<title>HANDY Directory</title>
-->
	<title>HANDY PAL</title>
	<!-- HANDY PAL -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/pal_base.css" />
<!-- PAL 커스터마이징 : end -->
	
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery-ui.custom.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.cookie.js"></script>
	
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/src/skin/ui.dynatree.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/src/jquery.dynatree.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/tabbar.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/tabbar.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/orgPopup.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/common/divPopup.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/jquery.hs.directory/jquery.hs.directory.js"></script>
	
	<!-- style javascript -->
	<script type="text/javascript">
		function directory_orgPopup_onLoad() {
			CONTEXT = "<c:out value="${CONTEXT}" />";
			
			var to = "<c:out value="${param.to}" escapeXml="false" />";
			var cc = "<c:out value="${param.cc}" escapeXml="false" />";
			var bcc = "<c:out value="${param.bcc}" escapeXml="false" />";
			
			orgPopup.onLoad(to, cc, bcc);
		}
		
		$(function() {
			/* dept : start */
			$("#directory-backToDeptTree").hide();
			
			$("#deptSearchValue").keypress(function(event) {
				if (event.keyCode == 13) {
					event.keyCode = 0;
					$("#deptSearchButton").click();
				}
			});
			$("#deptSearchButton").click(function() {
				if (orgPopup.searchDept()) {
					$("#directory-backToDeptTree").show();
					if ($("#directory-allTree-area").is(":visible")) {
						$("#orgTree").height($("#orgTree").height() + $("#directory-allTree-area").height());
					}
					$("#directory-allTree-area").hide();
				}
			});
			$("#directory-backToDeptTree").click(function() {
				orgPopup.initOrgTree();
				$("#directory-backToDeptTree").hide();
				$("#deptSearchValue").val("");
				$("#directory-allTree-area").show();
				$("#orgTree").height($("#orgTree").height() - $("#directory-allTree-area").height());
			});
			$("input[name='subdept']").click(function() {
				var list = orgPopup[($("#recType").val() || "to") + "List"];
				if ($("#selectMode").val() == "1" && list.size() == 1 && list.get(0).isDeptType()) {
					var deptType = ($("input[name='subdept']:checked").val() == "true") ? SDEPT : DEPT;
					var o = new Recipient(deptType + parseType(list.get(0).uniqueID)[1], deptType + parseType(list.get(0).name)[1]);
					orgPopup.onSelect(true, o);
					orgPopup.printRecipientList();
				}
			});
			$("#directory-allTreeClose").click(function() {
				orgPopup.closeAllOrgTree();
			});
			$("#directory-allTreeOpen").click(function() {
				orgPopup.initOrgTree(true);
			});
			$("#directory-allTreeClose img").hover(
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREECLOSE_ON.GIF") },
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREECLOSE.GIF") }
			);
			$("#directory-allTreeOpen img").hover(
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREEOPEN_ON.GIF") },
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREEOPEN.GIF") }
			);
			/* dept : end */
			
			/* dirGroup : start */
			$("#directory-backToDirGroupTree").hide();
			
			$("#directory-dirGroupSearchValue").keypress(function(event) {
				if (event.keyCode == 13) {
					event.keyCode = 0;
					$("#directory-dirGroupSearchButton").click();
				}
			});
			$("#directory-dirGroupSearchButton").click(function() {
				if (orgPopup.searchDirGroup()) {
					$("#directory-backToDirGroupTree").show();
					if ($("#directory-allDirGroupTree-area").is(":visible")) {
						$("#directory-dirGroupTree").height($("#directory-dirGroupTree").height()
								+ $("#directory-dirGroupTree-hirSelect").height() + $("#directory-allDirGroupTree-area").height());
					}
					$("#directory-dirGroupTree-hirSelect").hide();
					$("#directory-allDirGroupTree-area").hide();
				}
			});
			$("#directory-backToDirGroupTree").click(function() {
				orgPopup.initDirGroupTree();
				$("#directory-backToDirGroupTree").hide();
				$("#directory-dirGroupSearchValue").val("");
				$("#directory-dirGroupTree-hirSelect").show();
				$("#directory-allDirGroupTree-area").show();
				$("#directory-dirGroupTree").height($("#directory-dirGroupTree").height()
						- $("#directory-dirGroupTree-hirSelect").height() - $("#directory-allDirGroupTree-area").height());
			});
			$("#directory-dirGroupTree-hirID").change(function() {
				orgPopup.initDirGroupTree();
			});
			$("#directory-allDirGroupTreeClose").click(function() {
				orgPopup.closeAllDirGroupTree();
			});
			$("#directory-allDirGroupTreeOpen").click(function() {
				orgPopup.initDirGroupTree(true);
			});
			$("#directory-allDirGroupTreeClose img").hover(
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREECLOSE_ON.GIF") },
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREECLOSE.GIF") }
			);
			$("#directory-allDirGroupTreeOpen img").hover(
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREEOPEN_ON.GIF") },
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREEOPEN.GIF") }
			);
			/* dirGroup : end */
		});
		
		/* tab menu : start */
		var directory_orgPopup_menuType = "org";
		
		function directory_orgPopup_switchMenu(menuType) {
			directory_orgPopup_menuType = menuType || "org";
			
			var tabName = "directory-tab-" + directory_orgPopup_menuType;
			var workspaceName = "directory-workspace-" + directory_orgPopup_menuType;
			
			$("li[id^='directory-tab-']").each(function() {
				if ($(this).attr("id") == tabName)
					$(this).addClass("selected");
				else
					$(this).removeClass("selected");
			});
			$("div[id^='directory-workspace-']").each(function() {
				if ($(this).attr("id") == workspaceName)
					$(this).show();
				else
					$(this).hide();
			});
			
			directory_orgPopup_callMethod();
		}
		
		function directory_orgPopup_callMethod() {
			// call method
			switch (directory_orgPopup_menuType) {
			case "org":
				if ($("#orgTree:empty").length) {
					orgPopup.createOrgTree();
				}
				break;
			case "contact":
				if ($("#contactTree:empty").length) {
					orgPopup.createContactTree();
				}
				break;
			case "group":
				if ($("#groupTree:empty").length) {
					orgPopup.createGroupTree();
				}
				break;
			case "dirGroup":
				if ($("#directory-dirGroupTree:empty").length) {
					orgPopup.createDirGroupTree();
				}
				break;
			case "position":
				if ($("#positionList:empty").length) {
					orgPopup.initPositionList();
				}
				break;
			}
			
			$("#directory-listSearch-searchValue").val("");
		}
		/* tab menu : end */
		//clear popup window.status
		document.onmouseover = function() {
			if(event.srcElement.tagName == "A") {
				 setTimeout("hideStatus()", 0);
			}
		}
		function hideStatus() {
			document.location = "#";	
		}
		hideStatus();
	</script>
</head>
<body onload="directory_orgPopup_onLoad()">
	<input type="hidden" id="display" value="<c:out value="${param.display}" />" />
	<input type="hidden" id="dutiesUsed" value="<c:out value="${param.dutiesUsed}" />" />
	<input type="hidden" id="checkbox" value="<c:out value="${param.checkbox}" />" />
	<input type="hidden" id="selectMode" value="<c:out value="${param.selectMode}" />" />
	<input type="hidden" id="openerType" value="<c:out value="${param.openerType}" />" />
	<input type="hidden" id="notUseDept" value="<c:out value="${param.notUseDept}" />" />
	<input type="hidden" id="notUseUser" value="<c:out value="${param.notUseUser}" />" />
	<input type="hidden" id="startDept" value="<c:out value="${param.startDept}" />" />
	<input type="hidden" id="groupType" value="<c:out value="${param.groupType}" />" />
	<input type="hidden" id="activeSelect" value="<c:out value="${param.activeSelect}" />" />
	<input type="hidden" id="useAbsent" value="<c:out value="${param.useAbsent}" />" />
	<input type="hidden" id="useSelectAll" value="<c:out value="${param.useSelectAll}" />" />
	<input type="hidden" id="recType" value="<c:out value="${param.recType}" />" />
	
	<input type="hidden" id="baseDept" value="<c:out value="${baseDept}" />" />
	<input type="hidden" id="useRootdept" value="<c:out value="${display.rootdept}" />" />
	<input type="hidden" id="isUserSingle" value="<c:out value="${display.userSingle}" />" />
	
	<input type="hidden" id="message_noneterm" value="<fmt:message key="list.select.search.noneterm" />" />
	<input type="hidden" id="message_minLength" value="<fmt:message key="lang.org.search.minLength" />" />
	<input type="hidden" id="message_invalidvalue" value="<fmt:message key="lang.org.search.invalidvalue" />" />
	
<div> <!-- pop_wrap의 실제 높이를 구하기 위해 필요함. html, body { height: 100% } 설정 때문에 pop_wrap의 높이가 창크기의 100%로 나오는 문제. -->
	<div id="pop_wrap" style="min-width: 300px;">
		<h1>
			<p><fmt:message key="org.title" /></p>
		</h1>
		<!-- tab menu : start -->
		<div class="tab_area">
			<ul class="tab_menu">
				<li id="directory-tab-org" class="selected"><a href="#" onclick="javascript:directory_orgPopup_switchMenu('org');" onfocus="blur();"><fmt:message key="org.organogram" /></a></li>
			<c:if test="${display.contact}">
				<li id="directory-tab-contact"><a href="#" onclick="javascript:directory_orgPopup_switchMenu('contact');" onfocus="blur();"><fmt:message key="org.addressbook" /></a></li>
			</c:if>
			<c:if test="${display.group}">
				<li id="directory-tab-group"><a href="#" onclick="javascript:directory_orgPopup_switchMenu('group');" onfocus="blur();"><fmt:message key="org.group" /></a></li>
			</c:if>
			<c:if test="${display.dirGroup}">
				<li id="directory-tab-dirGroup"><DD><span><a href="#" onclick="javascript:directory_orgPopup_switchMenu('dirGroup');" onfocus="blur();"><fmt:message key="directory.dirGroup" /></a></span></DD></li>
			</c:if>
			<c:if test="${display.position}">
				<li id="directory-tab-position"><a href="#" onclick="javascript:directory_orgPopup_switchMenu('position');" onfocus="blur();"><fmt:message key="org.position" /></a></li>
			</c:if>
			</ul>
		</div>
		<!-- tab menu : end -->
		<!-- workspace : start -->
		<div style="padding: 5px;">
			<div id="directory-workspace-org">
				<div style="height: 337px; border: 1px solid #c0c0c0; float: left; margin-right: 5px;">
					<!-- dept search : start -->
					<div class="search" style="padding: 5px; float: left;">
						<input type="text" id="deptSearchValue" maxlength="60" style="width: 110px;" />
						<a class="srch_btn" href="#" id="deptSearchButton"><fmt:message key="directory.search" /></a>
						<a class="srch_btn" href="#" id="directory-backToDeptTree"><fmt:message key="directory.list" /></a>
					</div>
					<!-- dept search : end -->
					<div style="line-height: 22px; padding-left: 5px; clear: both; float: left;">
						<span class="inp_raochk"><input type="radio" name="subdept" value="false" /><fmt:message key="message.selectdept" /></span>
						<span class="inp_raochk"><input type="radio" name="subdept" value="true" /><fmt:message key="message.subdeptinclusion" /></span>
					</div>
					<div id="directory-allTree-area" style="height: 18px; padding-left: 5px; clear: both;">
						<a href="#" id="directory-allTreeClose" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/ALLTREECLOSE.GIF" border="0" /></a><a href="#" id="directory-allTreeOpen" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/ALLTREEOPEN.GIF" border="0" /></a>
					</div>
					<div id="orgTree" style="height: 265px; overflow: auto; clear: both;"></div>
				</div>
				<div id="userList" style="height: 337px; border: 1px solid #c0c0c0; overflow: auto;"></div>
			</div>
		<c:if test="${display.contact}">
			<div id="directory-workspace-contact">
				<div style="height: 337px; border: 1px solid #c0c0c0; float: left; margin-right: 5px;">
					<div id="contactTree" style="height: 335px; overflow: auto;"></div>
				</div>
				<div id="contactList" style="height: 337px; border: 1px solid #c0c0c0; overflow: auto;"></div>
			</div>
		</c:if>
		<c:if test="${display.group}">
			<div id="directory-workspace-group">
				<div style="height: 337px; border: 1px solid #c0c0c0; float: left; margin-right: 5px;">
					<div id="groupTree" style="height: 335px; overflow: auto;"></div>
				</div>
				<div id="memberList" style="height: 337px; border: 1px solid #c0c0c0; overflow: auto;"></div>
			</div>
		</c:if>
		<c:if test="${display.dirGroup}">
			<div id="directory-workspace-dirGroup">
				<div style="height: 337px; border: 1px solid #c0c0c0; float: left; margin-right: 5px;">
					<!-- dirGroup search : start -->
					<div class="search" style="padding: 5px; float: left;">
						<input type="text" id="directory-dirGroupSearchValue" maxlength="60" style="width: 110px;" />
						<a class="srch_btn" href="#" id="directory-dirGroupSearchButton"><fmt:message key="directory.search" /></a>
						<a class="srch_btn" href="#" id="directory-backToDirGroupTree"><fmt:message key="directory.list" /></a>
					</div>
					<!-- dirGroup search : end -->
					<div id="directory-dirGroupTree-hirSelect" style="line-height: 22px; padding-left: 5px; clear: both;">
						<fmt:message key="directory.dirGroup.hirStructure" />
						<select id="directory-dirGroupTree-hirID">
							<!--option value=""><fmt:message key="directory.dirGroup.selectGroup" /></option-->
						<c:forEach var="hir" items="${hirList}" varStatus="loop">
							<option value="<c:out value="${hir.ID}" />"><c:out value="${hir.name}" /></option>
						</c:forEach>
						</select>
					</div>
					<div id="directory-allDirGroupTree-area" style="height: 18px; padding-left: 5px; clear: both;">
						<a href="#" id="directory-allDirGroupTreeClose" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/ALLTREECLOSE.GIF" border="0" /></a><a href="#" id="directory-allDirGroupTreeOpen" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/ALLTREEOPEN.GIF" border="0" /></a>
					</div>
					<div id="directory-dirGroupTree" style="height: 265px; overflow: auto; clear: both;"></div>
				</div>
				<div id="directory-dirGroupMemberList" style="height: 337px; border: 1px solid #c0c0c0; overflow: auto;"></div>
			</div>
		</c:if>
		<c:if test="${display.position}">
			<div id="directory-workspace-position">
				<div id="positionList" style="height: 337px; border: 1px solid #c0c0c0; overflow: auto;"></div>
			</div>
		</c:if>
		</div>
		<!-- workspace : end -->
		<div style="padding: 0 5px;">
			<table width="100%" cellspacing="0" cellpadding="0"  style="background: #eeeeee; border: 1px solid #c0c0c0; font-size: 12px; color: #666666;">
				<tr>
					<td width="200">
						<div onclick="javascript:doClick(event);">
						<c:choose>
						<c:when test="${param.openerType == 'M'}">
							<div class="tabbar"><span id="to" class="tabbutton" style="cursor: pointer;"><fmt:message key="org.receiver" /></span></div>
							<div class="tabbar"><span id="cc" class="tabbutton" style="cursor: pointer;"><fmt:message key="org.reference" /></span></div>
							<div class="tabbar"><span id="bcc" class="tabbutton" style="cursor: pointer;"><fmt:message key="org.behindreference" /></span></div>
						</c:when>
						<c:otherwise>
							<div class="tabbar"><span id="to" class="tabbutton"><fmt:message key="org.select" /></span></div>
						</c:otherwise>
						</c:choose>
						</div>
					</td>
					<td nowrap="nowrap" width="100%">
						<div id="to-div"><textarea id="hwto" class="tabbar-textarea" readonly="readonly"></textarea></div>
					<c:if test="${param.openerType == 'M'}">
						<div id="cc-div"><textarea id="hwcc" class="tabbar-textarea" readonly="readonly"></textarea></div>
						<div id="bcc-div"><textarea id="hwbcc" class="tabbar-textarea" readonly="readonly"></textarea></div>
					</c:if>
					</td>
				</tr>
			</table>
		</div>
		<div class="footcen">
			<ul class="btns">
				<li><span><a href="#" onclick="javascript:orgPopup.onOK();"><fmt:message key="org.ok" /></a></span></li>
				<li><span><a href="#" onclick="javascript:window.close();"><fmt:message key="org.cancel" /></a></span></li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>