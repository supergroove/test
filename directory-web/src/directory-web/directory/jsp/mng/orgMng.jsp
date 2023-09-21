<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.orgMng" /> -->
	
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery-ui.custom.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.cookie.js"></script>
	
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/src/skin/ui.dynatree.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/src/jquery.dynatree.js"></script>
	
	<!-- HANDY Directory -->
<c:if test="${!display.removeCSS}">
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
</c:if>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/jquery.hs.directory/jquery.hs.directory.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/mng/orgMng.js"></script>
	
	<script type="text/javascript">
		function directory_orgMng_onLoad() {
			DIRECTORY_CONTEXT = "<c:out value="${CONTEXT}" />";
			
			directory_orgMng.createDeptTree();
			
			$("#directory-backToDeptTree").hide();
			
			$("#directory-deptSearchValue").keypress(function(event) {
				if (event.keyCode == 13) {
					event.keyCode = 0;
					$("#directory-deptSearchButton").click();
				}
			});
			$("#directory-deptSearchButton").click(function() {
				if (directory_orgMng.searchDeptTree()) {
					$("#directory-backToDeptTree").show();
					if ($("#directory-allTree-area").is(":visible")) {
						$("#directory-deptTree").height($("#directory-deptTree").height() + $("#directory-allTree-area").height());
					}
					$("#directory-allTree-area").hide();
					$("#directory-deptSearchValue").css("width", "75px");
				}
			});
			$("#directory-backToDeptTree").click(function() {
				directory_orgMng.initDeptTree($("#directory-baseDept").val());
				$("#directory-deptSearchValue").val("");
				$("#directory-backToDeptTree").hide();
				$("#directory-allTree-area").show();
				$("#directory-deptTree").height($("#directory-deptTree").height() - $("#directory-allTree-area").height());
				$("#directory-deptSearchValue").css("width", "120px");
			});
			
			$("#directory-allTreeClose").click(function() {
				directory_orgMng.closeAllDeptTree();
			});
			$("#directory-allTreeOpen").click(function() {
				directory_orgMng.initDeptTree(directory_orgMng.getCurrentDeptID(), true, true);
			});
			$("#directory-allTreeClose img").hover(
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREECLOSE_ON.GIF") },
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREECLOSE.GIF") }
			);
			$("#directory-allTreeOpen img").hover(
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREEOPEN_ON.GIF") },
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREEOPEN.GIF") }
			);
			
			<c:if test="${!display.removeCSS}">
				directory_orgMng_resize();
				$(window).resize(function() {
					directory_orgMng_resize();
				});
			</c:if>
		}
		
		function directory_orgMng_resize() {
			if ($("#directory-deptTree").length > 0) {
				$("#directory-deptTree").height(document.documentElement.clientHeight - $("#directory-deptTree").offset().top - 1);
				$("#directory-contents").height(document.documentElement.clientHeight - $("#directory-contents").offset().top);
			}
		}
		
		/* tab menu : start */
		var directory_orgMng_menuType = "dept";
		
		function directory_orgMng_switchMenu(menuType) {
			directory_orgMng_menuType = menuType || "dept";
			
			var tabName = "directory-tab-" + directory_orgMng_menuType;
			
			$("li[id^='directory-tab-']").each(function() {
				if ($(this).attr("id") == tabName)
					$(this).addClass("selected");
				else
					$(this).removeClass("selected");
			});
			
			$("#directory-workspace").empty();
		}
		
		function directory_orgMng_callMethod() {
			directory_history.removeAll(); // history remove all
			
			var deptID = directory_orgMng.getCurrentDeptID();
			// call method
			switch (directory_orgMng_menuType) {
			case "dept":
				directory_orgMng.viewDept(deptID);
				break;
			case "user":
				directory_orgMng.listUsers(deptID);
				break;
			case "position":
				directory_orgMng.listPositions();
				break;
			case "rank":
				directory_orgMng.listRanks();
				break;
			case "duty":
				directory_orgMng.listDuties();
				break;
			case "auth":
				directory_orgMng.listAuthes();
				break;
			case "search":
				directory_orgMng.listSearch();
				break;
			case "batch":
				directory_orgMng.listBatchs();
				break;
			case "community":
				directory_orgMng.listCommunities();
				break;
			case "externalUser":
				directory_orgMng.listExternalUsers(deptID);
				break;
			}
		}
		/* tab menu : end */
	</script>
</head>
<body onload="directory_orgMng_onLoad()">
	<input type="hidden" id="directory-baseDept" value="<c:out value="${baseDept}" />" />
	
	<input type="hidden" id="directory-display" value="<c:out value="${param.display}" />" />
	<input type="hidden" id="directory-useAbsent" value="<c:out value="${param.useAbsent}" default="true" />" />
	
	<input type="hidden" id="directory-search-noneTerm" value="<fmt:message bundle="${messages_directory}" key="directory.search.noneTerm" />" />
	<input type="hidden" id="directory-search-minLength" value="<fmt:message bundle="${messages_directory}" key="directory.search.minLength" />" />
	<input type="hidden" id="directory-search-invalidValue" value="<fmt:message bundle="${messages_directory}" key="directory.search.invalidValue" />" />
	
	<input type="hidden" id="directory-notAuthorizedUser" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.5006.notAuthorizedUser" />" />
	
	<div>
		<div id="directory-left" class="directory_main_left">
			<!--<img src="<c:out value="${CONTEXT}" />/directory/images/IMG_ORG.GIF" height="40" width="206" />-->
			<!-- dept search : start -->
			<div class="search" style="padding: 5px; float: left;">
				<input type="text" id="directory-deptSearchValue" maxlength="60" />
				<a class="srch_btn" href="#" id="directory-deptSearchButton"><fmt:message bundle="${messages_directory}" key="directory.search" /></a>
				<a class="srch_btn" href="#" id="directory-backToDeptTree"><fmt:message bundle="${messages_directory}" key="directory.list" /></a>
			</div>
			<!-- dept search : end -->
			<!-- dept tree : start -->
			<div id="directory-allTree-area" style="height: 18px; padding-left: 5px; clear: both;">
				<a href="#" id="directory-allTreeClose" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/ALLTREECLOSE.GIF" border="0" /></a><a href="#" id="directory-allTreeOpen" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/ALLTREEOPEN.GIF" border="0" /></a>
			</div>
			<div id="directory-deptTree" class="directory_main_tree"></div>
			<!-- dept tree : end -->
		</div>
		<div id="directory-contents" class="directory_main_contents">
			<div class="content_box"
				<c:choose>
					<c:when test="${isAdmin && isSysAdmin && useExternalUser && isExternalUserMng}">style="min-width: 1080px;"</c:when>
					<c:when test="${isAdmin && isSysAdmin}">style="min-width: 943px;"</c:when>
					<c:when test="${isAdmin && useExternalUser && isExternalUserMng}">style="min-width: 970px;"</c:when>
					<c:when test="${isSysAdmin && useExternalUser && isExternalUserMng}">style="min-width: 944px;"</c:when>
					<c:otherwise>style="min-width: 850px;"</c:otherwise>
				</c:choose>
			>
				<div id="content">
					<div class="title_area">
						<h2 class="title">
							<span title="<fmt:message bundle="${messages_directory}" key="directory.orgMng.path" />"><fmt:message bundle="${messages_directory}" key="directory.orgMng" /></span>
						</h2>
					</div>
					<!-- tab menu : start -->
					<div class="tab_area">
						<ul class="tab_menu">
							<li id="directory-tab-dept" class="selected"><a href="#" onclick="javascript:directory_orgMng_switchMenu('dept');directory_orgMng_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.dept" /></a></li>
							<li id="directory-tab-user"><a href="#" onclick="javascript:directory_orgMng_switchMenu('user');directory_orgMng_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.user" /></a></li>
							<li id="directory-tab-position"><a href="#" onclick="javascript:directory_orgMng_switchMenu('position');directory_orgMng_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.position" /></a></li>
						<c:if test="${useRank}">
							<li id="directory-tab-rank"><a href="#" onclick="javascript:directory_orgMng_switchMenu('rank');directory_orgMng_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.rank" /></a></li>
						</c:if>
						<c:if test="${useDuty}">
							<li id="directory-tab-duty"><a href="#" onclick="javascript:directory_orgMng_switchMenu('duty');directory_orgMng_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.duty" /></a></li>
						</c:if>
							<li id="directory-tab-auth"><a href="#" onclick="javascript:directory_orgMng_switchMenu('auth');directory_orgMng_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.auth" /></a></li>
							<li id="directory-tab-search"><a href="#" onclick="javascript:directory_orgMng_switchMenu('search');directory_orgMng_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.search" /></a></li>
						<c:if test="${isAdmin}">
							<li id="directory-tab-batch"><a href="#" onclick="javascript:directory_orgMng_switchMenu('batch');directory_orgMng_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.batchProcess" /></a></li>
						</c:if>
						<c:if test="${isSysAdmin}">
							<li id="directory-tab-community"><a href="#" onclick="javascript:directory_orgMng_switchMenu('community');directory_orgMng_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.community" /></a></li>
						</c:if>
						<c:if test="${useExternalUser && isExternalUserMng}">
							<li id="directory-tab-externalUser"><a href="#" onclick="javascript:directory_orgMng_switchMenu('externalUser');directory_orgMng_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.externalUser" /></a></li>
						</c:if>
						</ul>
					</div>
					<!-- tab menu : end -->
					<!-- workspace : start -->
					<div id="directory-workspace"></div>
					<!-- workspace : end -->
				</div>
			</div>
		</div>
	</div>
</body>
</html>