<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=8" />
	<title>HANDY Directory</title>
	
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	
	<script type="text/javascript">
		jQuery(document).ready(function() {
			// validate JSON
			$("#test-iframe").load(function() {
				if (this.src.indexOf("resultType=json") == -1) {
					return; // xml
				}
				var json = this.contentDocument.body.innerHTML; // $("#test-iframe").contents()[0].body.innerHTML
				if (json) {
					try {
						eval("(" + json + ")"); // validate
						//alert("Valid JSON !!");
					} catch (e) {
						alert("Invalid JSON !!" + json);
					}
				}
			});
		});
		
		function test_callServer() {
			var url = $("#test-URL").val();
			$("#test-iframe").attr("src", url); // call
			
			/*$.ajax({
				url: url,
				type: "post",
				async: false,
				dataType: "json",
				success: function(result, status) {
					alert(result.id);
				},
				error: function(result, status) {
					alert("ERROR : " + status);
				}
			});*/
		}
		
		function test_setURL(index) {
			var url = "<c:out value="${CONTEXT}" />/OpenApi.do?";
			switch (index) {
				case 1: url += "target=session&todo=login&userid=&passwd=&PRE=&communityID=&FRAMEWORK_DIRECTORY_LOCALE=&resultType=json"; break; // 로그인 (userid)
				case 2: url += "target=session&todo=login&loginid=&passwd=&PRE=&communityID=&FRAMEWORK_DIRECTORY_LOCALE=&resultType=json"; break; // 로그인 (loginid)
				case 3: url += "target=session&todo=login&empcode=&passwd=&PRE=&communityID=&FRAMEWORK_DIRECTORY_LOCALE=&resultType=json"; break; // 로그인 (empcode)
				case 4: url += "target=session&todo=login&name=&passwd=&PRE=&communityID=&FRAMEWORK_DIRECTORY_LOCALE=&resultType=json"; break; // 로그인 (name)
				case 5: url += "target=session&todo=login&email=&passwd=&PRE=&communityID=&FRAMEWORK_DIRECTORY_LOCALE=&resultType=json"; break; // 로그인 (name)
				case 6: url += "target=session&todo=logout&K=&resultType=json"; break; // 로그아웃
				case 11: url += "target=org&acton=dept&todo=list&scope=all&resultType=json"; break; // 부서 트리 (all)
				case 12: url += "target=org&acton=dept&todo=list&base=000000000&scope=onelevel&resultType=json"; break; // 부서 트리 (onelevel)
				case 13: url += "target=org&acton=dept&todo=list&base=000000000&scope=subtree&resultType=json"; break; // 부서 트리 (subtree)
				case 14: url += "target=org&acton=dept&todo=path&base=000000101&resultType=json"; break; // 부서 경로
				case 21: url += "target=org&acton=user&todo=list&base=000000101&resultType=json"; break; // 사용자 목록
				case 22: url += "target=org&acton=user&todo=listByUserIDs&userIDs=000000001&resultType=json"; break; // 사용자 목록 (by userIDs)
				case 31: url += "target=env&action=user&todo=display&id=&resultType=json"; break; // 개인정보 조회
			}
			$("#test-URL").val(url);
			
			test_callServer(); // call server
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
					<td width="100">요청 :</td>
					<td>
						<textarea id="test-URL" rows="3" cols="160"></textarea>
					</td>
				</tr>
			</table>
		</li>
	</ul>
	<input type="button" value="서버호출" onclick="javascript:test_callServer();" />
	
	<hr />

	<div>
		<div style="border: 1px solid #c0c0c0; float: left; margin-right: 5px;">
			<table width="197" border="0" cellspacing="0" cellpadding="0"><tr><td>
				<ul>
					<li>
						로그인
						<ul>
							<li>&nbsp;&nbsp;&nbsp;&nbsp;
								- <a href="javascript:test_setURL(1);">로그인 (userid)</a>
							</li>
							<li>&nbsp;&nbsp;&nbsp;&nbsp;
								- <a href="javascript:test_setURL(2);">로그인 (loginid)</a>
							</li>
							<li>&nbsp;&nbsp;&nbsp;&nbsp;
								- <a href="javascript:test_setURL(3);">로그인 (empcode)</a>
							</li>
							<li>&nbsp;&nbsp;&nbsp;&nbsp;
								- <a href="javascript:test_setURL(4);">로그인 (name)</a>
							</li>
							<li>&nbsp;&nbsp;&nbsp;&nbsp;
								- <a href="javascript:test_setURL(5);">로그인 (email)</a>
							</li>
							<li>&nbsp;&nbsp;&nbsp;&nbsp;
								- <a href="javascript:test_setURL(6);">로그아웃</a>
							</li>
						</ul>
					</li>
					<li>
						조직도
						<ul>
							<li>&nbsp;&nbsp;&nbsp;&nbsp;
								- 부서트리
								<ul>
									<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										- <a href="javascript:test_setURL(11);">부서 트리 (all)</a></li>
									<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										- <a href="javascript:test_setURL(12);">부서 트리 (onelevel)</a></li>
									<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										- <a href="javascript:test_setURL(13);">부서 트리 (subtree)</a></li>
								</ul>
							</li>
							<li>&nbsp;&nbsp;&nbsp;&nbsp;
								- <a href="javascript:test_setURL(14);">부서 경로</a>
							</li>
							<li>&nbsp;&nbsp;&nbsp;&nbsp;
								- <a href="javascript:test_setURL(21);">사용자 목록</a>
							</li>
							<li>&nbsp;&nbsp;&nbsp;&nbsp;
								- <a href="javascript:test_setURL(22);">사용자 목록 (by userIDs)</a>
							</li>
						</ul>
					</li>
					<li>
						환경설정
						<ul>
							<li>&nbsp;&nbsp;&nbsp;&nbsp;
								- <a href="javascript:test_setURL(31);">개인정보 조회</a>
							</li>
						</ul>
					</li>
				</ul>
			</td></tr></table>
		</div>
		<div style="overflow: auto;">
			<iframe id="test-iframe" src="" frameborder="1" border="1" width="855" height="555"></iframe>
		</div>
	</div>
</body>
</html>