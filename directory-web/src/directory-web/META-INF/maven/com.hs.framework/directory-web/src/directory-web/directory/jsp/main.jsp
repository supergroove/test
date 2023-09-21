<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="./common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=8" />
	<title>Handyflow iBPMS Directory</title>
<style type="text/css">
<!--
#directory-main-workspace {
	/*height:100%;*/
}
-->
</style>
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<!-- <link rel="stylesheet" type="text/css" href="/bpa-web/css/bpm/bpm.css" />    -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/main.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/org.js"></script>

	<!-- style javascript -->
	<script type="text/javascript">
	var K = "<c:out value="${DIRECTORY_AUTHENTICATION.userKey}"/>";
	var CONTEXT = "<c:out value="${CONTEXT}"/>";
	$(document).ready(function() {
		switch_main(MENU_ID_ORGVIEW);
		toggle_menu_bg('menu_0');
	});
	var directoryOtherOfficeLogin = false;
	(function($){
		$(function(){
			directoryOtherOfficeLogin = $('#gotoMain').directoryOtherOfficeLogin(
								{
									context : CONTEXT,
									communityID: "<c:out value="${user.communityID}"/>",
									userKey: K,
									loginSuccessCallback : showResponse,
									loginFailCallback : showError
								}
							);
		});
		
		function showError (message) {
			alert("error:"+message);
		}
		
		function showResponse (K, result, loginName) {
//			alert("success:"+K);
			$("#gotoMain #K").val(K);
			$("#gotoMain").submit();
		}
	})(jQuery);
	</script>
    
    <style>
        .bpa_org_gnb {
            width: calc(100% + 40px);
            height: 34px;
            background-color: #3577cb;
            z-index: 10;
            /* box-shadow: 0 6px 8px rgb(0 0 0 / 20%); */
            position: relative;
            margin-top: -2px;
            margin-left: -20px;
            margin-bottom: 10px;
        }    
        .bpa_org_gnb ul li {
            color: #fff;
            font-size: 16px;
            font-weight: 600;
            line-height: 34px;
            padding: 0 50px;
            display: inline-block;
        }        
        .bpa_org_gnb a, .bpa_org_gnb a:link, .bpa_org_gnb a:visited {
            text-decoration: none;
            color: inherit;
        }        
        .bpa_org_gnb ul li.on {
            background-color: #2d65ad;
        }        
    </style>
    
</head>
<body style="overflow:hidden">
	<input type="hidden" id="directory-login-notFoundUserKey" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.1204.notFoundUserKey" />" />
	<input type="hidden" id="directory-login-notFoundUserID" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.6012.notFoundUserID" />" />
	<input type="hidden" id="directory-login-notFoundOtherOffice" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.6014.notFoundOtherOffice" />" />
	<input type="hidden" id="directory-login-lockedUser" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.6008.lockedUser" />" />
	<input type="hidden" id="directory-login-expiredUser" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.6009.expiredUser" />" />
	<input type="hidden" id="directory-login-notallowedip" value="<fmt:message bundle="${messages_directory}" key="directory.error.message.6013.notallowedip" />" />
	<!-- start menu -->
	<div id="wrap_menu" class="org_top_wrap" style="background-image:url("");">
		<!-- header -->
		<div id="header" style="height:58px;">
			<h1 style="border-right:none;">
				<a href="javascript:switch_main(MENU_ID_ORGVIEW)" onclick="toggle_menu_bg('menu_0')"><img src="/bpa-web/css/bpm/images/logo.png" alt="PAL"></a>
			</h1>
			<!-- nav_bar -->
			<div class="nav_area">
				<!-- menu navigation -->

				<!-- normal user menu -->
                <!--
				<ul id="normal_menu" class="menu">
					<li><a id="menu_0" href="javascript:switch_main(MENU_ID_ORGVIEW);" onclick="toggle_menu_bg(this.id)"><fmt:message bundle="${messages_directory}" key="directory.menu.orgview" /><span class="yellow" ></span></a></li>
				<c:if test="${isAdmin || isDeptAdmin}">
					<li><a id="menu_1" href="javascript:switch_main(MENU_ID_ORGMNG);" onclick="toggle_menu_bg(this.id)"><fmt:message bundle="${messages_directory}" key="directory.menu.orgmng" /></span></a></li>
				</c:if>
				<c:if test="${useDirGroup && isAdmin}">
					<li><a id="menu_2" href="javascript:switch_main(MENU_ID_DIRGROUPMNG);" onclick="toggle_menu_bg(this.id)"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.groupMng" /></span></a></li>
				</c:if>
				</ul>
                -->
				<!-- //normal user menu -->
	
				<div class="menu_right" style="border-left:none;">
                    <!--
					<div class="menu_link">
						<a href="">&nbsp;</a>
					</div>
                    -->
					<!-- my info -->
					<div class="owner_info">
						<span><c:out value="${user.deptName}" /></span>
						<span>
						<c:choose>
							<c:when test="${not empty otherOffices}">
							<select id='other_office_menu' onchange="javascript:changeAdditionalUser(this.options[this.selectedIndex].value)">
								<c:forEach var="user" items="${otherOffices}" varStatus="status">
									<option value="<c:out value="${user.ID}"/>">
										<c:out value="${user.name}"/>(<c:out value="${user.deptName}"/>)
									</option>
								</c:forEach>
							</select>
							</c:when>
							<c:otherwise>
							<c:out value="${user.name}" />
							</c:otherwise>
						</c:choose>
						</span>
					</div>
					<!-- //my info -->
					<ul class="gnb">
						<li><a href="javascript:switch_main(MENU_ID_USERENV);clear_menu_bg();" class="config" title="<fmt:message bundle="${messages_directory}" key='directory.menu.config' />"><span class="text"><fmt:message bundle="${messages_directory}" key='directory.menu.config' /></span><span class="image"><img src="<c:out value="${CONTEXT}" />/directory/images/main/btn_config.gif"></span></a></li>
						<li><a href="javascript:logout()" class="logout" title="<fmt:message bundle="${messages_directory}" key='directory.menu.logout' />"><span class="text"><fmt:message bundle="${messages_directory}" key='directory.menu.logout' /></span><span class="image"><img src="<c:out value="${CONTEXT}" />/directory/images/main/btn_logout.gif"></span></a></li>
					</ul>
				</div>
			</div>
			<!-- //nav_bar -->
		</div>
		<!-- //header -->

        <div class="bpa_org_gnb">
        		<ul id="_gnb_menus" style="margin-left:100px;">
        			<li id="menu_0" onClick="_org_chg_func(MENU_ID_ORGVIEW, this.id);" class="on"><a href="#">Organization</a></li>
                    <c:if test="${isAdmin || isDeptAdmin}"><li id="menu_1" onClick="_org_chg_func(MENU_ID_ORGMNG, this.id);" ><a href="#">Organization Management</a></li></c:if>
                    <c:if test="${useDirGroup && isAdmin}"><li id="menu_2" onClick="_org_chg_func(MENU_ID_DIRGROUPMNG, this.id);"><a href="#">UserGroup Management</a></li></c:if>
        	</ul>
        </div>            
    
	</div>
	<!-- // end menu -->
	<div id="directory-main-workspace"></div>
	<form id="gotoMain" action="<c:out value="${CONTEXT}"/>/org.do" method="POST">
	<input type="hidden" name="acton" value="main"/>
	<input type="hidden" name="K" id="K" value=""/>
	</form>
    
    <script>
        function _org_chg_func(menuName, id){
            switch_main(menuName);
            $('#_gnb_menus li').each(function(){
                $(this).removeClass('on');
            });
            console.log(id);
            $('#'+id).addClass('on');
        }
    </script>
    
</body>
</html>