<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.batchMng.batchDetailInfo" /> -->
	
	<!-- jQuery Dynatree -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/mng/orgMng.js"></script>
	
	<script type="text/javascript">
		function directory_viewBatchMsg_onLoad() {
			DIRECTORY_CONTEXT = "<c:out value="${CONTEXT}" />";
		}
	</script>
</head>
<body onload="javascript:directory_viewBatchMsg_onLoad();">
	<input type="hidden" id="directory-batchID" value="<c:out value="${batch.ID}"/>" />
	
	<input type="hidden" id="directory-listBatchs-batchDeleteConfirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-listBatchs-batchDeleted" value="<fmt:message bundle="${messages_directory}" key="directory.delete.batchDeleted" />" />	
	<input type="hidden" id="directory-listBatchs-listType" value="<c:out value='${param.listType}'/>"/>
	
	<div id="pop_wrap" style="min-width: 300px;">
		<h1>
			<p><fmt:message bundle="${messages_directory}" key="directory.batchMng.batchDetailInfo" /></p>
		</h1>
		<!-- button : start -->
		<div class="btn_area">
			<ul class="btns">
				<li><span><a href="#"	onclick="javascript:directory_orgMng.deleteBatchMsg('<c:out value="${batch.ID}"/>')"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
				<li><span><a href="#" onclick="javascript:window.close();"><fmt:message bundle="${messages_directory}" key="directory.cancel" /></a></span></li>
			</ul>
		</div>
		<!-- button : end -->
		<div id="pop_container">
			<div class="contents">
				<!-- table : start -->
				<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
					<col width="120" />
					<col width="" />
					<tbody>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.type" /></th>
							<td>
							<c:choose>
								<c:when test="${batch.type=='0'}"><fmt:message bundle="${messages_directory}" key="directory.user" /></c:when>
								<c:when test="${batch.type=='1'}"><fmt:message bundle="${messages_directory}" key="directory.dept" /></c:when>
								<c:when test="${batch.type=='2'}"><fmt:message bundle="${messages_directory}" key="directory.position" /></c:when>
								<c:when test="${batch.type=='3'}"><fmt:message bundle="${messages_directory}" key="directory.rank" /></c:when>
								<c:when test="${batch.type=='4'}"><fmt:message bundle="${messages_directory}" key="directory.duty" /></c:when>
								<c:when test="${batch.type=='5'}"><fmt:message bundle="${messages_directory}" key="directory.auth" /></c:when>
							</c:choose>
							</td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.batchMng.work" /></th>
							<td>
							<c:choose>
								<c:when test="${batch.opType=='0'}"><fmt:message bundle="${messages_directory}" key="directory.add" /></c:when>
								<c:when test="${batch.opType=='1'}"><fmt:message bundle="${messages_directory}" key="directory.update" /></c:when>
								<c:when test="${batch.opType=='2'}"><fmt:message bundle="${messages_directory}" key="directory.delete" /></c:when>
								<c:when test="${batch.opType == '4'}"><fmt:message bundle="${messages_directory}" key="directory.add" />/<fmt:message bundle="${messages_directory}" key="directory.update" /></c:when>
							</c:choose>
							</td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.target" /></th>
							<td><c:out value="${batch.name}" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.status" /></th>
							<td>
							<c:choose>
								<c:when test="${batch.status=='0'}"><fmt:message bundle="${messages_directory}" key="directory.waitting" /></c:when>
								<c:when test="${batch.status=='1'}"><fmt:message bundle="${messages_directory}" key="directory.success" /></c:when>
								<c:when test="${batch.status=='2'}"><fmt:message bundle="${messages_directory}" key="directory.processing" /></c:when>
								<c:when test="${batch.status=='3'}"><fmt:message bundle="${messages_directory}" key="directory.fail" /></c:when>
							</c:choose>
							</td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.batchMng.changedData" /></th>
							<td><textarea rows="7" style="width: 99.8%;" readonly="readonly"><c:out value="${batch.data}" /></textarea></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.batchMng.sourceData" /></th>
							<td><textarea rows="7" style="width: 99.8%;" readonly="readonly"><c:out value="${batch.lineValue}" /></textarea></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.message" /></th>
							<td><textarea rows="10" style="width: 99.8%;" readonly="readonly"><c:out value="${batchMsg.message}" default="" /></textarea></td>
						</tr>
					</tbody>
				</table>
				<!-- table : end -->
			</div>
		</div>
	</div>
</body>
</html>