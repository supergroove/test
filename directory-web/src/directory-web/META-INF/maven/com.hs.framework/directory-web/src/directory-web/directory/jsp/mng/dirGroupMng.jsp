<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupMng" /> -->
	
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
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/view/orgView.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/common/divPopup.js"></script>
	
	<script type="text/javascript">
		function directory_dirGroupMng_onLoad() {
			DIRECTORY_CONTEXT = "<c:out value="${CONTEXT}" />";
			
			directory_orgMng.createDirGroupTree();
			
			$("#directory-dirGroupMng-backToTree").hide();
			
			$("#directory-dirGroupMng-searchValue").keypress(function(event) {
				if (event.keyCode == 13) {
					event.keyCode = 0;
					$("#directory-dirGroupMng-searchButton").click();
				}
			});
			$("#directory-dirGroupMng-searchButton").click(function() {
				if (directory_orgMng.searchDirGroup()) {
					$("#directory-dirGroupMng-backToTree").show();
					if ($("#directory-dirGroupMng-allTree-area").is(":visible")) {
						$("#directory-dirGroupMng-tree").height($("#directory-dirGroupMng-tree").height()
								+ $("#directory-dirGroupMng-hirSelect").height() + $("#directory-dirGroupMng-allTree-area").height());
					}
					$("#directory-dirGroupMng-hirSelect").hide();
					$("#directory-dirGroupMng-allTree-area").hide();
					$("#directory-dirGroupMng-searchValue").css("width", "75px");
				}
			});
			$("#directory-dirGroupMng-backToTree").click(function() {
				directory_orgMng.initDirGroupTree();
				$("#directory-dirGroupMng-backToTree").hide();
				$("#directory-dirGroupMng-searchValue").val("");
				$("#directory-dirGroupMng-hirSelect").show();
				$("#directory-dirGroupMng-allTree-area").show();
				$("#directory-dirGroupMng-tree").height($("#directory-dirGroupMng-tree").height()
						- $("#directory-dirGroupMng-hirSelect").height() - $("#directory-dirGroupMng-allTree-area").height());
				$("#directory-dirGroupMng-searchValue").css("width", "120px");
			});
			
			$("#directory-dirGroupMng-hirID").change(function() {
				directory_history.removeAll(); // history remove all
				directory_orgMng.initDirGroupTree();
			});
			$("#directory-dirGroupMng-allTreeClose").click(function() {
				directory_orgMng.closeAllDirGroupTree();
			});
			$("#directory-dirGroupMng-allTreeOpen").click(function() {
				directory_orgMng.initDirGroupTree(true);
			});
			
			$("#directory-dirGroupMng-allTreeClose img").hover(
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREECLOSE_ON.GIF") },
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREECLOSE.GIF") }
			);
			$("#directory-dirGroupMng-allTreeOpen img").hover(
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREEOPEN_ON.GIF") },
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREEOPEN.GIF") }
			);
			
			<c:if test="${!display.removeCSS}">
				directory_dirGroupMng_resize();
				$(window).resize(function() {
					directory_dirGroupMng_resize();
				});
			</c:if>
		}
		
		function directory_dirGroupMng_resize() {
			if ($("#directory-dirGroupMng-tree").length > 0) {
				$("#directory-dirGroupMng-tree").height(document.documentElement.clientHeight - $("#directory-dirGroupMng-tree").offset().top - 1);
				$("#directory-contents").height(document.documentElement.clientHeight - $("#directory-contents").offset().top);
			}
		}
		
		/* tab menu : start */
		var directory_dirGroupMng_menuType = "dirGroup";
		
		function directory_dirGroupMng_switchMenu(menuType) {
			directory_dirGroupMng_menuType = menuType || "dirGroup";
			
			var tabName = "directory-dirGroupMng-tab-" + directory_dirGroupMng_menuType;
			
			$("li[id^='directory-dirGroupMng-tab-']").each(function() {
				if ($(this).attr("id") == tabName)
					$(this).addClass("selected");
				else
					$(this).removeClass("selected");
			});
			
			$("#directory-dirGroupMng-workspace").empty();
		}
		
		function directory_dirGroupMng_callMethod() {
			directory_history.removeAll(); // history remove all
			
			// call method
			switch (directory_dirGroupMng_menuType) {
			case "dirGroup":
				var tree = $("#directory-dirGroupMng-tree").dynatree("getTree");
				var groupID = (tree.getActiveNode() != null) ? tree.getActiveNode().data.key : "";
				
				directory_orgMng.viewDirGroup(groupID, $("#directory-dirGroupMng-hirID").val());
				break;
			case "dirGroupHir":
				directory_orgMng.listDirGroupHir();
				break;
			}
		}
		/* tab menu : end */
	</script>
</head>
<body onload="directory_dirGroupMng_onLoad()">
	<input type="hidden" id="directory-dirGroupMng-display" value="<c:out value="${param.display}" />" />
	
	<input type="hidden" id="directory-dirGroupMng-search-noneTerm" value="<fmt:message bundle="${messages_directory}" key="directory.search.noneTerm" />" />
	<input type="hidden" id="directory-dirGroupMng-search-minLength" value="<fmt:message bundle="${messages_directory}" key="directory.search.minLength" />" />
	<input type="hidden" id="directory-dirGroupMng-search-invalidValue" value="<fmt:message bundle="${messages_directory}" key="directory.search.invalidValue" />" />
	
	<input type="hidden" id="directory-dirGroupMng-notAuthorizedUser" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.5006.notAuthorizedUser" />" />
	
	<div>
		<div id="directory-left" class="directory_main_left">
			<!--<img src="<c:out value="${CONTEXT}" />/directory/images/IMG_ORG.GIF" height="40" width="206" />-->
			<!-- dirGroup search : start -->
			<div class="search" style="padding: 5px; float: left;">
				<input type="text" id="directory-dirGroupMng-searchValue" maxlength="60" />
				<a class="srch_btn" href="#" id="directory-dirGroupMng-searchButton"><fmt:message bundle="${messages_directory}" key="directory.search" /></a>
				<a class="srch_btn" href="#" id="directory-dirGroupMng-backToTree"><fmt:message bundle="${messages_directory}" key="directory.list" /></a>
			</div>
			<!-- dirGroup search : end -->
			<div id="directory-dirGroupMng-hirSelect" style="line-height: 22px; padding-left: 5px; clear: both;">
				<fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirStructure" />
				<select id="directory-dirGroupMng-hirID">
					<!--option value=""><fmt:message bundle="${messages_directory}" key="directory.dirGroup.selectGroup" /></option-->
				<c:forEach var="hir" items="${hirList}" varStatus="loop">
					<option value="<c:out value="${hir.ID}" />"><c:out value="${hir.name}" /></option>
				</c:forEach>
				</select>
			</div>
			<!-- dirGroup tree : start -->
			<div id="directory-dirGroupMng-allTree-area" style="height: 18px; padding-left: 5px; clear: both;">
				<a href="#" id="directory-dirGroupMng-allTreeClose" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/ALLTREECLOSE.GIF" border="0" /></a><a href="#" id="directory-dirGroupMng-allTreeOpen" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/ALLTREEOPEN.GIF" border="0" /></a>
			</div>
			<div id="directory-dirGroupMng-tree" class="directory_main_tree"></div>
			<!-- dirGroup tree : end -->
		</div>
		<div id="directory-contents" class="directory_main_contents">
			<div class="content_box">
				<div id="content">
					<div class="title_area">
						<h2 class="title">
							<span title="<fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupMng.path" />"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupMng" /></span>
						</h2>
					</div>
					<!-- tab menu : start -->
					<div class="tab_area">
						<ul class="tab_menu">
							<li id="directory-dirGroupMng-tab-dirGroup" class="selected"><a href="#" onclick="javascript:directory_dirGroupMng_switchMenu('dirGroup');directory_dirGroupMng_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.dirGroup" /></a></li>
							<li id="directory-dirGroupMng-tab-dirGroupHir" class="selected"><a href="#" onclick="javascript:directory_dirGroupMng_switchMenu('dirGroupHir');directory_dirGroupMng_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.hir" /></a></li>
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