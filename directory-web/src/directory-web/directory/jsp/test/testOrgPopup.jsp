<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- jQuery -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/jquery.hs.directory/jquery.hs.directory.js"></script>
	
	<script type="text/javascript">
		var directory = null; // required - must exist "directory" variable
		
		jQuery(document).ready(function() {
		/*
			// Example
			directory = jQuery("#directory").directorypopup({
				context:		"<c:out value="${CONTEXT}" />",	// required
				K:				"",			// optional (default: "")
				display:		"",			// optional (default: "") - "rootdept, subdept, group, contact, position, charger, userSingle, dirGroup"
				dutiesUsed: 	"all",		// optional (default: "all") - "lieutenant, deptmanager, documentmanager, sendreceivemanager, addressbookmanager, schedulemanager"
				checkbox:		"both",		// optional (default: "both") - "both", "tree", "list"
				selectMode:		2,			// optional (default: 2) - 1:single, 2:multi
				openerType:		"",			// optional (default: "") - "M":Mail, "T":T-Manager, "K":KMS, "A":APPR
				notUseDept:		"",			// optional (default: "")
				notUseUser:		"",			// optional (default: "")
				startDept:		"",			// optional (default: "")
				groupType:		"",			// optional (default: "")
				activeSelect:	"",			// optional (default: "1") - 1(selected on active in tree)
				useAbsent:		"",			// optional (default: "true") - true(display in userList)
				useSelectAll:	"",			// optional (default: "false") - true(checkbox selectAll in deptList)
				FRAMEWORK_DIRECTORY_LOCALE: "" // optional (default: "") - ko_KR, en_US, ja_JP
			});
		*/
		});
		
		function initDirectory(to, cc, bcc) {
			if (directory) {
				to = directory.recInfo.to;
				cc = directory.recInfo.cc;
				bcc = directory.recInfo.bcc;
			}
			directory = $("#directory").directorypopup({
				context:		"<c:out value="${CONTEXT}" />",
				K:				$("#test-K").val(),
				display:		$("#display").val(),
				dutiesUsed:		$("#dutiesUsed").val(),
				checkbox:		$("input[name='checkbox']:checked").val(),
				selectMode:		$("input[name='selectMode']:checked").val(),
				openerType:		$("#openerType").val(),
				notUseDept:		$("#notUseDept").val(),
				notUseUser:		$("#notUseUser").val(),
				startDept:		$("#startDept").val(),
				groupType:		$("#groupType").val(),
				activeSelect:	$("#activeSelect").val(),
				useAbsent:		$("input[name='useAbsent']:checked").val(),
				useSelectAll:	$("input[name='useSelectAll']:checked").val(),
				FRAMEWORK_DIRECTORY_LOCALE: ""
			});
			directory.init(to, cc, bcc);
			return true;
		}
		
		function openPopup(recType) {
			if (!initDirectory()) {
				return false;
			}
			
			directory.set($("#hwto").val(), $("#hwcc").val(), $("#hwbcc").val(), recType);
			directory.open(function(toList, ccList, bccList) {
				$("#hwto").val(toList.toString("name"));
				$("#hwcc").val(ccList.toString("name"));
				$("#hwbcc").val(bccList.toString("name"));
				
				//for (i=0; i<toList.size(); i++) {
				//	alert("to (index=" + i + ")" + " (id=" + toList.get(i).toString("id") + ") name=(" + toList.get(i).toString("name") + ")");
				//}
				alert("to (size=" + toList.size() + ") " + toList.toString("id") + "\n"
						+ "cc (size=" + ccList.size() + ") " + ccList.toString("id") + "\n"
						+ "bcc (size=" + bccList.size() + ") " + bccList.toString("id"));
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
				<tr>
					<td>display :</td>
					<td>
						<input type="text" id="display" value="rootdept, subdept, group, position, charger" size="50" />
						<span style="padding-left: 10px; color: gray;">
							ex) rootdept, subdept, group, contact, position, charger, userSingle, dirGroup - 각 옵션을 구분자(",")를 사용해 나열한다.<br />
							rootdept - 최상위부서 선택가능<br />
							subdept - "하위 부서 포함" 라디오버튼 표시<br />
							group - 그룹 탭 표시<br />
							contact - 주소록 탭 표시<br />
							position - 직위 탭 표시<br />
							charger - 사용자 검색의 검색옵션 목록에 "담당자" 표시. dutiesUsed 옵션과 함께 설정해야 함.<br />
							userSingle - selectMode 옵션이 "multi"일 때, 사용자를 "single"로 선택가능<br />
							dirGroup - 사용자그룹(계층,공용) 탭 표시
						</span>
					</td>
				</tr>
				<tr>
					<td>dutiesUsed :</td>
					<td>
						<input type="text" id="dutiesUsed" value="lieutenant, deptmanager, documentmanager, sendreceivemanager, addressbookmanager, schedulemanager" size="105" />
						<span style="padding-left: 10px; color: gray;">
							ex) "all" - 검색옵션 목록에 모든 직책을 표시<br />
							"담당자"로 사용자 검색 시, 검색옵션 목록에 표시할 직책을 설정한다.<br />
							directory 2.0에서는 "lieutenant"(부서장), "deptmanager"(부서관리자)만 검색 가능.
						</span>
					</td>
				</tr>
				<tr>
					<td>checkbox :</td>
					<td>
						<input type="radio" name="checkbox" value="both" checked="checked" />both
						<input type="radio" name="checkbox" value="tree" />tree
						<input type="radio" name="checkbox" value="list" />list
						<span style="padding-left: 10px; color: gray;">
							ex) "both" - 트리, 목록 둘 다 선택가능 &nbsp; "tree" - 트리만 선택가능 (화면에 트리만 보여짐)
						</span>
					</td>
				</tr>
				<tr>
					<td>selectMode :</td>
					<td>
						<input type="radio" name="selectMode" value="1" />single
						<input type="radio" name="selectMode" value="2" checked="checked" />multi
						<span style="padding-left: 10px; color: gray;">
							ex) "single" - 한 개만 선택가능 (라디오버튼) &nbsp; "multi" - 여러 개 선택가능 (체크박스)
						</span>
					</td>
				</tr>
				<tr>
					<td>openerType :</td>
					<td>
						<input type="text" id="openerType" value="M" />
						<span style="padding-left: 10px; color: gray;">
							ex) "M"(메일) - 받는이/참조인/숨은참조를 각각 선택할 수 있으며, E-mail이 설정되지 않은 사용자는 선택되지 않는다.<br />
							조직도 선택 창을 사용하는 각 제품의 특화 기능을 적용하기 위한 옵션이다.<br />
							directory 2.0에서는 "M"(메일)만 적용되어 있음.
						</span>
					</td>
				</tr>
				<tr>
					<td>notUseDept :</td>
					<td>
						<input type="text" id="notUseDept" value="000000101, " size="30" />
						<span style="padding-left: 10px; color: gray;">
							ex) "000000101, " - 부서ID를 구분자(",")를 사용해 나열한다. 해당 부서들은 비활성화되고 선택되지 않는다.
						</span>
					</td>
				</tr>
				<tr>
					<td>notUseUser :</td>
					<td>
						<input type="text" id="notUseUser" value="" size="30" />
						<span style="padding-left: 10px; color: gray;">
							ex) "000000001, " - 사용자ID를 구분자(",")를 사용해 나열한다. 해당 사용자들은 비활성화되고 선택되지 않는다.
						</span>
					</td>
				</tr>
				<tr>
					<td>startDept :</td>
					<td>
						<input type="text" id="startDept" value="" />
						<span style="padding-left: 10px; color: gray;">
							ex) "000000101" - 설정된 부서를 최상위 부서로 해서 부서트리를 구성한다.
						</span>
					</td>
				</tr>
				<tr>
					<td>groupType :</td>
					<td>
						<input type="text" id="groupType" value="M" />
						<span style="padding-left: 10px; color: gray;">
							ex) M(mail), S(receive), G(gongram)
						</span>
					</td>
				</tr>
				<tr>
					<td>activeSelect :</td>
					<td>
						<input type="text" id="activeSelect" value="1" />
						<span style="padding-left: 10px; color: gray;">
							ex) "1" - selectMode가 "single"일 경우, 트리에 라디오버튼이 나오지 않고, 클릭(활성화)된 부서가 선택된다.
						</span>
					</td>
				</tr>
				<tr>
					<td>useAbsent :</td>
					<td>
						<input type="radio" name="useAbsent" value="false" />false
						<input type="radio" name="useAbsent" value="true" checked="checked" />true
						<span style="padding-left: 10px; color: gray;">
							ex) "true" - 사용자 목록에서 부재 중인 사용자의 이름 뒤에 [부재]를 표시한다.
						</span>
					</td>
				</tr>
				<tr>
					<td>useSelectAll :</td>
					<td>
						<input type="radio" name="useSelectAll" value="false" checked="checked" />false
						<input type="radio" name="useSelectAll" value="true" />true
						<span style="padding-left: 10px; color: gray;">
							ex) "true" - 조직도 선택 창에서 (하위 부서 포함이 아닌 상태) 부서의 체크박스를 선택하면 자동으로 하위부서까지 선택된다.
						</span>
					</td>
				</tr>
			</table>
		</li>
	</ul>
	
	<hr />
	
	<div id="directory"></div> <!-- required - must exist "div" element -->
	
	<input type="button" value="TO" onclick="openPopup('to');" />&nbsp;<input type="text" id="hwto" size="100" /><br />
	<input type="button" value="CC" onclick="openPopup('cc');" />&nbsp;<input type="text" id="hwcc" size="100" /><br />
	<input type="button" value="BCC" onclick="openPopup('bcc');" />&nbsp;<input type="text" id="hwbcc" size="100" />
</body>
</html>