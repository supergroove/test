<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
<c:if test="${not empty detailUserSrc}">
	<script type="text/javascript" src="<c:out value="${detailUserSrc}" />"></script>
</c:if>
	
	<script type="text/javascript">
		function directory_listUnifiedSearchUsers_onLoad() {
		}
		
		function directory_listUnifiedSearchUsers_viewUserSpec(userID, event) {
		<c:choose>
		<c:when test="${not empty detailUserCmd}">
			<c:out value="${detailUserCmd}" />;
		</c:when>
		<c:otherwise>
			directory_orgView.viewUserSpec(userID);
		</c:otherwise>
		</c:choose>
			directory_listUnifiedSearchUsers_addRecentSearchUser(userID);
		}
		
		function directory_listUnifiedSearchUsers_addRecentSearchUser(userID) {
			$.ajax({
				url: "<c:out value="${CONTEXT}" />/org.do",
				type: "post",
				dataType: "json",
				data: {
					acton:			"addRecentSearchUser",
					memberID:		userID
				},
				success: function(result, status) {
					if (result.errorCode != 0) { // 0 = SUCCESS
						alert(result.errorMessage);
					} else {
						if (parent && parent.sportal_quickOrg_onLoad) { // sportal
							parent.sportal_quickOrg_onLoad("recentsearch");
						}
					}
				},
				error: function(result, status) {
					alert("ERROR : " + status);
				}
			});
		}
		
		function goListPage(page) {
			$("#directory-workspace").load("<c:out value="${CONTEXT}" />/org.do", {
				acton:			"listUnifiedSearchUsers",
				searchType:		"<c:out value="${param.searchType}" />",		// optional (default: "name") - "name, pos, rank, code, email, phone, mobile, business, dept"
				searchValue:	"<c:out value="${param.searchValue}" />",
				listPerPage:	"<c:out value="${pParam.listPerPage}" />",		// optional (default: "15")
				pageShortCut:	"<c:out value="${pParam.pageShortCut}" />",		// optional (default: "10")
				currentPage:	page || "1"										// optional (default: "1")
			}, function() {
				if (typeof(directory_listUnifiedSearchUsers_onLoad) != "undefined") {
					directory_listUnifiedSearchUsers_onLoad();
				}
			});
		}
	</script>
</head>
<body onload="directory_listUnifiedSearchUsers_onLoad()">
	<div class="member_warp">
		<h2>
			<fmt:message bundle="${messages_directory}" key="directory.unifiedSearch.result">
				<fmt:param value="${param.searchValue}" />
				<fmt:param value="${pParam.totalCount}" />
			</fmt:message>
		</h2>
		<c:forEach var="user" items="${userList}" varStatus="loop">
			<c:if test="${IS_ENGLISH}">
				<c:if test="${not empty user.nameEng}">
					<c:set target="${user}" property="name" value="${user.nameEng}" />
				</c:if>
				<c:if test="${not empty user.deptNameEng}">
					<c:set target="${user}" property="deptName" value="${user.deptNameEng}" />
				</c:if>
				<c:if test="${not empty user.positionNameEng}">
					<c:set target="${user}" property="positionName" value="${user.positionNameEng}" />
				</c:if>
			</c:if>
			<div class="member_01">
				<a href="#" onclick="directory_listUnifiedSearchUsers_viewUserSpec('<c:out value="${user.ID}" />', event);" title="<c:out value="${user.name}" /> <c:out value="${user.positionName}" />" class="member_pic">
				<c:if test="${not empty user.pictureURL}">
					<img src="<c:out value="${CONTEXT}${user.pictureURL}" />" />
				</c:if>
				</a>
				<ul>
					<li class="text"><span><fmt:message bundle="${messages_directory}" key="directory.userName" /> : </span><a href="#" onclick="directory_listUnifiedSearchUsers_viewUserSpec('<c:out value="${user.ID}" />', event);" title="<c:out value="${user.name}" /> <c:out value="${user.positionName}" />"><span><c:out value="${user.name}" /></span></a></li>
					<li class="text"><span><fmt:message bundle="${messages_directory}" key="directory.unifiedSearch.userOrgName" /> : </span><span><c:out value="${user.deptName}" /></span></li>
					<li class="text"><span><fmt:message bundle="${messages_directory}" key="directory.position" /> : </span><span><c:out value="${user.positionName}" /></span></li>
				</ul>
			</div>
		</c:forEach>
	</div>
	<div class="paginate_area">
		<jsp:include page="../common/pagination.jsp"/>
	</div>
</body>
</html>