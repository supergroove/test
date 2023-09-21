<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- jQuery Dynatree -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/js/jquery/css/jquery-ui.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery-ui.custom.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/org.js"></script>
	
	<script type="text/javascript">
		jQuery(document).ready(function() {
			test_loadUserEnv(4);
		});
		
		function test_loadUserEnv(index) {
			switch (index) {
				case 0: test_load0(); break;
				case 1: test_load1(); break;
				case 2: test_load2(); break;
				case 3: test_load3(); break;
				case 4: test_load4(); break;
				case 5: test_load5(); break;
				case 9: test_load9(); break;
			}
		}
		
		function test_load0() {
			viewChangePasswordDialog($("#test-K").val(), "<c:out value="${CONTEXT}" />"); // org.js
		}
		function test_load1() {
			$("#test-userEnv").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"viewChangePassword",
				K:				$("#test-K").val()
			}, function() {
				if (typeof(directory_changePassword_onLoad) != "undefined") {
					directory_changePassword_onLoad();
				}
			});
		}
		function test_load2() {
			$("#test-userEnv").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"viewSetAbsence",
				K:				$("#test-K").val()
			}, function() {
				if (typeof(directory_setAbsence_onLoad) != "undefined") {
					directory_setAbsence_onLoad();
				}
			});
		}
		function test_load3() {
			$("#test-userEnv").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"groupMng",
				K:				$("#test-K").val()
			}, function() {
				if (typeof(directory_groupMng_onLoad) != "undefined") {
					directory_groupMng_onLoad();
				}
			});
		}
		function test_load4() {
			$("#test-userEnv").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"viewUpdateUserInfo",
				K:				$("#test-K").val()
			}, function() {
				if (typeof(directory_updateUserInfo_onLoad) != "undefined") {
					directory_updateUserInfo_onLoad();
				}
			});
		}
		function test_load5() {
			$("#test-userEnv").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"viewUpdateNotify",
				K:				$("#test-K").val()
			}, function() {
				if (typeof(directory_updateNotify_onLoad) != "undefined") {
					directory_updateNotify_onLoad();
				}
			});
		}
		function test_load9(groupID) {
			$("#test-userEnv").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"viewUpdateFavoriteUser",
				K:				$("#test-K").val()
			});
		}
	</script>
</head>
<body>
	<a href="<c:out value="${CONTEXT}" />/directory/test.jsp">back</a><br /><br />
	<ul>
		<li>
			Test options<br />
			<table border="0">
				<tr>
					<td width="100">K :</td>
					<td><input type="text" id="test-K" value="" /></td>
				</tr>
			</table>
		</li>
	</ul>
	
	<hr />

	<div>
		<div style="border: 1px solid #c0c0c0; float: left; margin-right: 5px;">
			<table width="197" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<ul>
							<li>
								<a href="javascript:test_loadUserEnv(0);">암호설정(dialog)</a>
							</li>
							<li>
								<a href="javascript:test_loadUserEnv(1);">암호설정</a>
							</li>
							<li>
								<a href="javascript:test_loadUserEnv(2);">부재설정</a>
							</li>
							<li>
								<a href="javascript:test_loadUserEnv(3);">그룹관리</a>
							</li>
							<li>
								<a href="javascript:test_loadUserEnv(4);">개인정보설정</a>
							</li>
							<li>
								<a href="javascript:test_loadUserEnv(5);">알림설정</a>
							</li>
							<li>
								<a href="javascript:test_loadUserEnv(9);">즐겨찾는 사용자 설정</a>
							</li>
						</ul>
					</td>
				</tr>
			</table>
		</div>
		<div style="overflow: auto;">
			<div id="test-userEnv"></div> <!-- required - must exist "div" element -->
		</div>
	</div>
</body>
</html>