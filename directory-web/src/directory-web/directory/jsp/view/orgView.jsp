<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
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
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/view/orgView.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/common/divPopup.js"></script>
	
	<script type="text/javascript">
		function directory_orgView_onLoad() {
			DIRECTORY_CONTEXT = "<c:out value="${CONTEXT}" />";
			
			directory_orgView.createDeptTree();
			
			$("#directory-backToDeptTree").hide();
			
			$("#directory-deptSearchValue").keypress(function(event) {
				if (event.keyCode == 13) {
					event.keyCode = 0;
					$("#directory-deptSearchButton").click();
				}
			});
			$("#directory-deptSearchButton").click(function() {
				if (directory_orgView.searchDeptTree()) {
					$("#directory-backToDeptTree").show();
					if ($("#directory-allTree-area").is(":visible")) {
						$("#directory-deptTree").height($("#directory-deptTree").height() + $("#directory-allTree-area").height());
					}
					$("#directory-allTree-area").hide();
					$("#directory-deptSearchValue").css("width", "75px");
				}
			});
			$("#directory-backToDeptTree").click(function() {
				directory_orgView.initDeptTree($("#directory-baseDept").val());
				$("#directory-deptSearchValue").val("");
				$("#directory-backToDeptTree").hide();
				$("#directory-allTree-area").show();
				$("#directory-deptTree").height($("#directory-deptTree").height() - $("#directory-allTree-area").height());
				$("#directory-deptSearchValue").css("width", "120px");
			});
			
			$("#directory-allTreeClose").click(function() {
				directory_orgView.closeAllDeptTree();
			});
			$("#directory-allTreeOpen").click(function() {
				directory_orgView.initDeptTree(directory_orgView.getCurrentDeptID(), true, true);
			});
			$("#directory-allTreeClose img").hover(
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREECLOSE_ON.GIF") },
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREECLOSE.GIF") }
			);
			$("#directory-allTreeOpen img").hover(
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREEOPEN_ON.GIF") },
				function() { $(this).attr("src", "<c:out value="${CONTEXT}" />/directory/images/ALLTREEOPEN.GIF") }
			);
			
			$("#directory-listSearch-searchValue").keypress(function(event) {
				if (event.keyCode == 13) {
					event.keyCode = 0;
					$("#directory-listSearch-searchButton").click();
				}
			});
			$("#directory-listSearch-searchButton").click(function() {
				var listSearchType = $("#directory-listSearch-searchType").val();
				var listSearchValue = $("#directory-listSearch-searchValue").val();
				if(listSearchType == 'phone' || listSearchType == 'mobile'){
					listSearchValue = listSearchValue.replace(/[- \)]/g, '');
				}
				
				switch (directory_orgView_menuType) {
				case "user":
					directory_orgView.searchUser(listSearchType, listSearchValue);
					break;
				case "absentUser":
					directory_orgView.searchAbsentUser(listSearchType, listSearchValue);
					break;
				case "loginUser":
					directory_orgView.searchLoginUser(listSearchType, listSearchValue);
					break;
				}
			});
			
			<c:if test="${!display.removeCSS}">
				directory_orgView_resize();
				$(window).resize(function() {
					directory_orgView_resize();
				});
			</c:if>
		}
		
		function directory_orgView_resize() {
			if ($("#directory-deptTree").length > 0) {
				$("#directory-deptTree").height(document.documentElement.clientHeight - $("#directory-deptTree").offset().top - 1);
				$("#directory-contents").height(document.documentElement.clientHeight - $("#directory-contents").offset().top);
			}
		}
		
		/* tab menu : start */
		var directory_orgView_menuType = "user";
		
		function directory_orgView_switchMenu(menuType) {
			directory_orgView_menuType = menuType || "user";
			
			var tabName = "directory-tab-" + directory_orgView_menuType;
			
			$("li[id^='directory-tab-']").each(function() {
				if ($(this).attr("id") == tabName)
					$(this).addClass("selected");
				else
					$(this).removeClass("selected");
			});
			
			$("#directory-workspace").empty();
		}
		
		function directory_orgView_callMethod(deptID) {
			deptID = deptID || directory_orgView.getCurrentDeptID();
			
			if ( $("#directory-listUsers-listType").length > 0) {
				 $("#directory-listUsers-listType").val("");
				 $("#directory-listUsers-currentPage").val("");
				 $("#directory-listUsers-orderType").val("");
				 $("#directory-listUsers-orderField").val("");
			}
			
			if ( $("#directory-listAbsentUsers-listType").length > 0) {
				 $("#directory-listAbsentUsers-listType").val("");
				 $("#directory-listAbsentUsers-currentPage").val("");
				 $("#directory-listAbsentUsers-orderType").val("");
				 $("#directory-listAbsentUsers-orderField").val("");
			}
			
			if ( $("#directory-listLoginUsers-listType").length > 0) {
				 $("#directory-listLoginUsers-listType").val("");
				 $("#directory-listLoginUsers-currentPage").val("");
				 $("#directory-listLoginUsers-orderType").val("");
				 $("#directory-listLoginUsers-orderField").val("");
			}
			
			// call method
			switch (directory_orgView_menuType) {
			case "user":
				directory_orgView.listUsers(deptID);
				break;
			case "absentUser":
				directory_orgView.listAbsentUsers(deptID);
				break;
			case "loginUser":
				directory_orgView.listLoginUsers(deptID);
				break;
			}
			
			$("#directory-listSearch-searchValue").val("");
		}
		/* tab menu : end */
	</script>
</head>
<body onload="directory_orgView_onLoad()">
	<input type="hidden" id="directory-baseDept" value="<c:out value="${baseDept}" />" />
	
	<input type="hidden" id="directory-display" value="<c:out value="${param.display}" />" />
	<input type="hidden" id="directory-useAbsent" value="<c:out value="${param.useAbsent}" default="true" />" />
	
	<input type="hidden" id="directory-search-noneTerm" value="<fmt:message bundle="${messages_directory}" key="directory.search.noneTerm" />" />
	<input type="hidden" id="directory-search-minLength" value="<fmt:message bundle="${messages_directory}" key="directory.search.minLength" />" />
	<input type="hidden" id="directory-search-invalidValue" value="<fmt:message bundle="${messages_directory}" key="directory.search.invalidValue" />" />
	<input type="hidden" id="directory-listSearch-noneTerm" value="<fmt:message bundle="${messages_directory}" key="directory.search.noneTerm" />" />
	<input type="hidden" id="directory-listSearch-allDept" value="<fmt:message bundle="${messages_directory}" key="directory.allDept" />" />
	
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
			<div class="content_box">
				<div id="content">
					<div class="title_area">
						<h2 class="title">
							<span id="directory-orgView-title" title="HOME&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.org" />"><!-- title --></span>
						</h2>
					</div>
					<!-- tab menu : start -->
					<div class="tab_area">
						<ul class="tab_menu">
							<li id="directory-tab-user" class="selected"><a href="#" onclick="javascript:directory_orgView_switchMenu('user');directory_orgView_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.user" /></a></li>
							<li id="directory-tab-absentUser"><a href="#" onclick="javascript:directory_orgView_switchMenu('absentUser');directory_orgView_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.absentUser" /></a></li>
							<li id="directory-tab-loginUser"><a href="#" onclick="javascript:directory_orgView_switchMenu('loginUser');directory_orgView_callMethod();" onfocus="blur();"><fmt:message bundle="${messages_directory}" key="directory.loginUser" /></a></li>
						</ul>
						<!-- search : start -->
						<div class="srch_area">
							<fieldset class="search">
								<legend><fmt:message bundle="${messages_directory}" key="directory.search" /></legend>
								<select id="directory-listSearch-searchType">
									<option value="name" <c:if test="${param.searchType == 'name'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.userName" /></option>
									<option value="pos" <c:if test="${param.searchType == 'pos'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.position" /></option>
								<c:if test="${useRank}">
									<option value="rank" <c:if test="${param.searchType == 'rank'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.rank" /></option>
								</c:if>
								<c:if test="${useDuty}">
									<option value="duty" <c:if test="${param.searchType == 'duty'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.duty" /></option>
								</c:if>
									<option value="code" <c:if test="${param.searchType == 'code'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.empCode" /></option>
								<c:if test="${not cryptedUserColumnsMap.phone}">
									<option value="phone" <c:if test="${param.searchType == 'phone'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.phone" /></option>
								</c:if>
								<c:if test="${not cryptedUserColumnsMap.mobile_phone}">
									<option value="mobile" <c:if test="${param.searchType == 'mobile'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.mobilePhone" /></option>
								</c:if>
								<c:if test="${not cryptedUserColumnsMap.e_mail}">
									<option value="email" <c:if test="${param.searchType == 'email'}">selected="selected"</c:if>><fmt:message bundle="${messages_directory}" key="directory.en_email" /></option>
								</c:if>
								</select>
								<input type="text" id="directory-listSearch-searchValue" maxlength="60" value="<c:out value="${param.searchValue}" />" />
								<a class="srch_btn" href="#" id="directory-listSearch-searchButton"><fmt:message bundle="${messages_directory}" key="directory.search" /></a>
							</fieldset>
						</div>
						<!-- search : end -->
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