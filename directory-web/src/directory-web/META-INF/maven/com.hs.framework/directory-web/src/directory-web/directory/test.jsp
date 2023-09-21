<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="./jsp/common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/org.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/common/divPopup.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/cookie.js"></script>
	
	<script type="text/javascript">
		function popupAddExternalUser() {
			var width = 500;
			var height = 400;
			var left = screen.width / 2 - width  / 2 - 10;
			var top = screen.height / 2 - height / 2 - 33;
			
			var features = "left="+left+",top="+top+",width="+width+",height="+height+",";
			features += "toolbar=no,menubar=no,location=no,scrollbars=no,status=no,resizable=yes";
			window.open("<c:out value="${CONTEXT}" />/directory/popupAddExternalUser.jsp", "popupAddExternalUser", features);
		}
	</script>
</head>
<body>
	<%=com.hs.framework.directory.config.OrgConfigData.getProperty("directory.version.description")%>
	<br />
	<ul>
		<li>
			Test pages
			<ul><br />
				<li>
					<a href="<c:out value="${CONTEXT}" />/directory/jsp/test/testOrgPopup.jsp">testOrgPopup.jsp</a> - 조직도 선택 팝업
					<br /><br />
				</li>
				<li>
					<a href="<c:out value="${CONTEXT}" />/directory/jsp/test/testOrgView.jsp">testOrgView.jsp</a> - 조직도 조회
					<br /><br />
				</li>
				<li>
					<a href="<c:out value="${CONTEXT}" />/directory/jsp/test/testOrgMng.jsp">testOrgMng.jsp</a> - 조직도 관리
					<br /><br />
				</li>
				<li>
					<a href="<c:out value="${CONTEXT}" />/directory/jsp/test/testUserEnv.jsp">testUserEnv.jsp</a> - 사용자 환경설정
					<br /><br />
				</li>
				<li>
					<a href="<c:out value="${CONTEXT}" />/directory/jsp/test/testOpenApi.jsp">testOpenApi.jsp</a> - Open API
					<br /><br />
				</li>
				<li>
					<a href="<c:out value="${CONTEXT}" />/directory/jsp/test/testSportal.jsp">testSportal.jsp</a> - Sportal 관련 화면
					<br /><br />
				</li>
				<li>
					<a href="javascript:popupAddExternalUser();">popupAddExternalUser.jsp</a> - 외부사용자등록 팝업
					<br /><br />
				</li>
				<li>
					<%@ include file="./jsp/login/login.jsp" %>
				</li>
			</ul>
		</li>
	</ul>
</body>
</html>