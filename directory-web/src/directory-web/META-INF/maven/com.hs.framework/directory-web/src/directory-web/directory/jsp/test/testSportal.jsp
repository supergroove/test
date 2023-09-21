<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/main.css" />
	
	<script type="text/javascript">
		function test_load(index) {
			switch (index) {
				case 0: test_load0(); break;
				case 1: test_load1(); break;
				case 2: test_load2(); break;
			}
		}
		
		function test_load0() {
			$("#test-div").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"viewFavoriteUser",
				K:				$("#test-K").val()
			});
		}
		function test_load1() {
			$("#test-div").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"viewRecentSearchUser",
				K:				$("#test-K").val()
			});
		}
		function test_load2() {
			$("#test-div").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"unifiedSearch",
				K:				$("#test-K").val(),
				searchType:		"name, pos, email, phone, mobile, business, dept",	// optional (default: "name") - "name, pos, rank, code, email, phone, mobile, business, dept"
				searchValue:	$("#test-searchValue").val(),
				listPerPage:	"20",	// optional (default: "15")
				pageShortCut:	"10"	// optional (default: "10")
			}, function() {
				if (typeof(directory_unifiedSearch_onLoad) != "undefined") {
					directory_unifiedSearch_onLoad();
				}
			});
		}
		
		function show_user_info(userID, event) {
			$("head").append($('<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/view/orgView.js"></script'+'>'));
			$("head").append($('<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/common/divPopup.js"></script'+'>'));
			
			directory_orgView.viewUserSpec(userID);
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
								<a href="javascript:test_load(0);">즐겨찾는 사용자</a>
							</li>
							<li>
								<a href="javascript:test_load(1);">최근 검색한 사용자</a>
							</li>
							<li>
								<a href="javascript:test_load(2);">인물검색</a>&nbsp;&nbsp;<input type="text" id="test-searchValue" onkeydown="if (event.keyCode == 13) {test_load(2);}" value="김" />
							</li>
						</ul>
					</td>
				</tr>
			</table>
		</div>
		<div style="overflow: auto;">
			<div id="test-div"></div> <!-- required - must exist "div" element -->
		</div>
	</div>
</body>
</html>