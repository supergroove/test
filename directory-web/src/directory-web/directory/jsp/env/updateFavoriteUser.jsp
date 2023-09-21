<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- HANDY Directory -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/jquery.hs.directory/jquery.hs.directory.js"></script>
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/org.js"></script>
	
	<script type="text/javascript">
		function directory_updateFavoriteUser_updateFavoriteUser() {
			var memberIDs = "";
			$("#directory-updateFavoriteUser-memberList").find("option").each(function() {
				memberIDs += $(this).val() + ";";
			});
			
			var data = {
				acton:			"updateFavoriteUser",
				memberIDs:		memberIDs
			};
			$.ajax({
				url: "<c:out value="${CONTEXT}" />/org.do",
				type: "post",
				async: false,
				dataType: "json",
				data: data,
				success: function(result, status) {
					if (result.errorCode != directory_orgErrorCode.SUCCESS_SUCCESS) {
						switch (result.errorCode) {
						default:
							alert(result.errorMessage);
						}
					} else {
						alert($("#directory-updateFavoriteUser-updated").val());
						
						if (parent && parent.sportal_quickOrg_onLoad) { // sportal
							parent.sportal_quickOrg_onLoad("favorite");
						}
					}
				},
				error: function(result, status) {
					alert("ERROR : " + status);
				}
			});
		}
		
		var directory = null; // required - must exist "directory" variable
		
		function directory_updateFavoriteUser_openPopup() {
			directory = $("#directory").directorypopup({
				context:		"<c:out value="${CONTEXT}" />",
				checkbox:		"list",
				selectMode:		2	// 1:single, 2:multi
			});
			
			var to = ""; // previous resolved data
			var memberNames = "";
			$("#directory-updateFavoriteUser-memberList").find("option").each(function() {
				to += $(this).val() + "|" + $(this).text() + ";";
				memberNames += $(this).text() + ";";
			});
			directory.init(to);
			
			directory.set(memberNames);
			directory.open(function(toList) {
				directory_updateFavoriteUser_print(toList);
			});
		}
		
		function directory_updateFavoriteUser_print(toList) {
			var memberList = $("#directory-updateFavoriteUser-memberList");
			// delete
			memberList.find("option").each(function() {
				var isDelete = true;
				for (var i = 0; i < toList.size(); i++) {
					if ($(this).val() == toList.get(i).toString("id")) {
						isDelete = false;
						break;
					}
				}
				if (isDelete) {
					$(this).remove();
				}
			});
			// add
			for (var i = 0; i < toList.size(); i++) {
				var isAdd = true;
				memberList.find("option").each(function() {
					if ($(this).val() == toList.get(i).toString("id")) {
						isAdd = false;
						return;
					}
				});
				if (isAdd) {
					memberList.append("<option value='" + toList.get(i).toString("id") + "'>" + toList.get(i).toString("name") + "</option>");
				}
			}
		}
		
		function directory_updateFavoriteUser_delete() {
			$("#directory-updateFavoriteUser-memberList").find("option").each(function() {
				if ($(this).is(":selected")) {
					$(this).remove();
				}
			});
		}
		
		function directory_updateFavoriteUser_moveUp() {
			var tmp = null;
			$("#directory-updateFavoriteUser-memberList").find("option").each(function() {
				if (tmp && $(this).is(":selected")) {
					$(tmp).before(this);
				} else {
					tmp = this;
				}
			});
		}
		
		function directory_updateFavoriteUser_moveDown() {
			var tmp = null; // reverse order
			$($("#directory-updateFavoriteUser-memberList").find("option").get().reverse()).each(function() {
				if (tmp && $(this).is(":selected")) {
					$(tmp).after(this);
				} else {
					tmp = this;
				}
			});
		}
	</script>
</head>
<body>
	<div id="directory"></div> <!-- required - must exist "div" element -->
	
	<input type="hidden" id="directory-updateFavoriteUser-updated" value="<fmt:message bundle="${messages_directory}" key="directory.env.favoriteUser.updated" />" />
	
	<div>
		<div>
			<div class="title_area">
				<h2 class="title"><span title="HOME&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.title" />&nbsp;&gt;&nbsp;<fmt:message bundle="${messages_directory}" key="directory.env.favoriteUser.title" />"><fmt:message bundle="${messages_directory}" key="directory.env.favoriteUser.title" /></span></h2>
			</div>
			<!-- button : start -->
			<div class="btn_area">
				<ul class="btns">
					<li><span><a href="#" onclick="javascript:directory_updateFavoriteUser_updateFavoriteUser();"><fmt:message bundle="${messages_directory}" key="directory.ok" /></a></span></li>
				</ul>
			</div>
			<!-- button : end -->
			<div style="padding: 5px;">
				<!-- table : start -->
				<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
					<col width="17%" />
					<col width="" />
					<tbody>
						<tr>
							<th>
								<a href="#" onclick="javascript:directory_updateFavoriteUser_openPopup();" onfocus="blur();">
									<img src="<c:out value="${CONTEXT}" /><fmt:message bundle="${messages_directory}" key="/directory/images/ADD_ICON.GIF" />" />
								</a><br /><br />
								<a href="#" onclick="javascript:directory_updateFavoriteUser_delete();" onfocus="blur();">
									<img src="<c:out value="${CONTEXT}" /><fmt:message bundle="${messages_directory}" key="/directory/images/DELETE_ICON.GIF" />" />
								</a><br /><br /><br />
								<a href="#" onclick="javascript:directory_updateFavoriteUser_moveUp();" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/UPON.GIF" /></a
								><a href="#" onclick="javascript:directory_updateFavoriteUser_moveDown();" onfocus="blur();"><img src="<c:out value="${CONTEXT}" />/directory/images/DOWNON.GIF" /></a>
							</th>
							<td>
								<select id="directory-updateFavoriteUser-memberList" size="20" multiple="multiple" style="width: 100%;">
								<c:forEach var="member" items="${memberList}">
									<c:if test="${IS_ENGLISH}">
										<c:if test="${not empty member.nameEng}">
											<c:set target="${member}" property="name" value="${member.nameEng}" />
										</c:if>
									</c:if>
									<option value="<c:out value="${member.ID}" />"><c:out value="${member.name}" /></option>
								</c:forEach>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
				<!-- table : end -->
			</div>
		</div>
	</div>
</body>
</html>