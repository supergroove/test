<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirMng" /> -->
	
	<script type="text/javascript" type="text/javascript">
		function directory_listDirGroupHir_onLoad() {
			//
		}
	</script>
</head>
<body onload="directory_listDirGroupHir_onLoad()">
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirMng" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewAddDirGroupHir();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewUpdateDirGroupHirSeq();"><fmt:message bundle="${messages_directory}" key="directory.sequence" /></a></span></li>
		</ul>
	</div>
	<!-- button : end -->
	<!-- table : start -->
	<table class="content_lst" border="0" cellspacing="0" cellpadding="0">
		<col width="300px">
		<col width="">
		<tr>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirName" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.currentStatus" /></th>
		</tr>
		<tbody>
		<c:forEach var="hir" items="${hirList}">
			<tr>
				<td title="<c:out value="${hir.name}" />">
					<a href="#" onclick="javascript:directory_orgMng.viewDirGroupHir('<c:out value="${hir.ID}" />');"><c:out value="${hir.name}" /></a>
				</td>
				<td>
				<c:choose>
					<c:when test="${hir.status == '1'}"><fmt:message bundle="${messages_directory}" key="directory.normal" /></c:when>
					<c:when test="${hir.status == '8'}"><fmt:message bundle="${messages_directory}" key="directory.hidden" /></c:when>
					<c:otherwise><fmt:message bundle="${messages_directory}" key="directory.unknownStatus" /></c:otherwise>
				</c:choose>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<!-- table : end -->
	<div class="paginate_area"></div>
</body>
</html>