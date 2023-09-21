<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.batchMng" /> -->
	
	<script type="text/javascript">
		function directory_listBatchs_onLoad() {
			$("#directory-listBatchs-checkAll").click(function() {
				directory_listBatchs_toggleAll();
			});
			$("input[name='directory-listBatchs-check']").click(function() {
				directory_listBatchs_toggle($(this));
			});
		}
		
		function directory_listBatchs_toggleAll() {
			if ($("#directory-listBatchs-checkAll").is(":checked")) {
				$("input[name='directory-listBatchs-check']").each(function() {
					if (!$(this).is(":disabled") && !$(this).is(":checked")) {
						$(this).attr("checked", true);
					}
				});
			} else {
				$("input[name='directory-listBatchs-check']").each(function() {
					if (!$(this).is(":disabled") && $(this).is(":checked")) {
						$(this).attr("checked", false);
					}
				});
			}
		}
		
		function directory_listBatchs_toggle(obj) {
			if ($("#directory-listBatchs-checkAll").is(":checked") && !obj.is(":checked")) {
				$("#directory-listBatchs-checkAll").attr("checked", false);
			}
		}
		
		function directory_listBatchsByType(listType) {
			$("#directory-listBatchs-listType").val(listType);
			$("#directory-listBatchs-currentPage").val(1);
			directory_orgMng.listBatchs();
		}
		
		function goListPage(page) {
			directory_orgMng.listBatchs(page);
		}
		
	</script>
</head>
<body onload="directory_listBatchs_onLoad()">
	<input type="hidden" id="directory-listBatchs-batchRetryConfirm" value="<fmt:message bundle="${messages_directory}" key="directory.update.batchRetryConfirm" />" />
	<input type="hidden" id="directory-listBatchs-batchIsWaited" value="<fmt:message bundle="${messages_directory}" key="directory.update.batchIsWaited" />" />
	<input type="hidden" id="directory-listBatchs-batchDeleteConfirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.confirm" />" />
	<input type="hidden" id="directory-listBatchs-batchDeleted" value="<fmt:message bundle="${messages_directory}" key="directory.delete.batchDeleted" />" />
	<input type="hidden" id="directory-listBatchs-batchDeleteAllConfirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.batchDeleteAllConfirm"/>" />
	<input type="hidden" id="directory-listBatchs-batchDeleteSuccessAllConfirm" value="<fmt:message bundle="${messages_directory}" key="directory.delete.batchDeleteSuccessAllConfirm" />" />	
	<input type="hidden" id="directory-listBatchs-batchDeletedAll" value="<fmt:message bundle="${messages_directory}" key="directory.delete.batchDeleted" />" />
	<input type="hidden" id="directory-listBatchs-selectItem" value="<fmt:message bundle="${messages_directory}" key="directory.selectItem" />" />
	
	<input type="hidden" id="directory-listBatchs-runBatchProcess-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.batchMng.runBatchProcess.confirm" />" />
	<input type="hidden" id="directory-listBatchs-runBatchProcess-success" value="<fmt:message bundle="${messages_directory}" key="directory.batchMng.runBatchProcess.success" />" />
	
	<input type="hidden" id="directory-listBatchs-listType" value="<c:out value='${param.listType}'/>"/>
	<input type="hidden" id="directory-listBatchs-currentPage" value="<c:out value='${param.currentPage}'/>"/>
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.batchMng" /></div>
		<ul class="btns">
		<c:choose>
		<c:when test = "${param.listType == 'success'}">
			<li><span><a href="#" onclick="javascript:directory_listBatchsByType('all');"><fmt:message bundle="${messages_directory}" key="directory.list" /></a></span></li>
		</c:when>
		<c:otherwise>
			<li><span><a href="#" onclick="javascript:directory_listBatchsByType('success');"><fmt:message bundle="${messages_directory}" key="directory.batchMng.completed" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewAddBatch();"><fmt:message bundle="${messages_directory}" key="directory.add" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.viewExportBatch();"><fmt:message bundle="${messages_directory}" key="directory.batchMng.export" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.retryBatch();"><fmt:message bundle="${messages_directory}" key="directory.batchMng.retry" /></a></span></li>
		</c:otherwise>
		</c:choose>
			<li><span><a href="#" onclick="javascript:directory_orgMng.deleteBatch();"><fmt:message bundle="${messages_directory}" key="directory.delete" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.deleteAllBatchs();"><fmt:message bundle="${messages_directory}" key="directory.batchMng.deleteAll" /></a></span></li>
		<c:if test="${param.listType != 'success' && isSysAdmin}">
			<li><span><a href="#" onclick="javascript:directory_orgMng.runBatchProcess();"><fmt:message bundle="${messages_directory}" key="directory.batchMng.runBatchProcess" /></a></span></li>
		</c:if>
		</ul>
		<div class="section_r">
		<c:choose>
		<c:when test = "${param.listType == 'success'}">
			<fmt:message bundle="${messages_directory}" key="directory.batchMng.completedCount"/>:<c:out value="${pParam.totalCount}" />
		</c:when>
		<c:otherwise>
			<fmt:message bundle="${messages_directory}" key="directory.batchMng.waitCount"/>:<c:out value="${pParam.totalCount}" />
		</c:otherwise>
		</c:choose>
		</div>
	</div>
	<!-- button : end -->
	<!-- table : start -->
	<table class="content_lst" border="0" cellspacing="0" cellpadding="0">
		<colgroup>
		<col style="width:3%">
		<col style="width:10%">
		<col style="width:10%">
		<col style="width:15%">
		<col style="width:10%">
		<col style="width:20%">
		<c:if test="${param.listType ne 'success'}"><col style="width:*"></c:if>
		</colgroup>
		<thead>
		<tr>
			<th scope="col" class="input_chk"><input type="checkbox" class="inchk" id="directory-listBatchs-checkAll" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.type" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.batchMng.work" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.target" /></th>
			<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.status" /></th>
			<th scope="col" class="cen">Date</th>
			<c:if test="${param.listType ne 'success'}"><th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.message" /></th></c:if>
		</tr>
		</thead>
		<tbody>
		<c:set var="count" value="0" scope="page" />
		<c:forEach var="batch" items="${batchList}" varStatus="loop">
			<tr>
				<td class="input_chk"><input type="checkbox" class="inchk" name="directory-listBatchs-check" value="<c:out value="${batch.BATCH_ID}" />" /></td>
				<td>
				<c:choose>
					<c:when test="${batch.TYPE == '0'}"><fmt:message bundle="${messages_directory}" key="directory.user" /></c:when>
					<c:when test="${batch.TYPE == '1'}"><fmt:message bundle="${messages_directory}" key="directory.dept" /></c:when>
					<c:when test="${batch.TYPE == '2'}"><fmt:message bundle="${messages_directory}" key="directory.position" /></c:when>
					<c:when test="${batch.TYPE == '3'}"><fmt:message bundle="${messages_directory}" key="directory.rank" /></c:when>
					<c:when test="${batch.TYPE == '4'}"><fmt:message bundle="${messages_directory}" key="directory.duty" /></c:when>
					<c:when test="${batch.TYPE == '5'}"><fmt:message bundle="${messages_directory}" key="directory.auth" /></c:when>
				</c:choose>
				</td>
				<td>
				<c:choose>
					<c:when test="${batch.OP_TYPE == '0'}"><fmt:message bundle="${messages_directory}" key="directory.add" /></c:when>
					<c:when test="${batch.OP_TYPE == '1'}"><fmt:message bundle="${messages_directory}" key="directory.update" /></c:when>
					<c:when test="${batch.OP_TYPE == '2'}"><fmt:message bundle="${messages_directory}" key="directory.delete" /></c:when>
					<%-- <c:when test="${batch.OP_TYPE == '3'}"><fmt:message bundle="${messages_directory}" key="directory." /></c:when> --%>
					<c:when test="${batch.OP_TYPE == '4'}"><fmt:message bundle="${messages_directory}" key="directory.add" />/<fmt:message bundle="${messages_directory}" key="directory.update" /></c:when>
				</c:choose>
				</td>
				<td title="<c:out value="${batch.NAME}" />"><a href="#" onclick="javascript:directory_orgMng.viewBatchMsg('<c:out value="${batch.BATCH_ID}"/>');" onfocus="blur();"><c:out value="${batch.NAME}" /></a></td>
				<td class="cen">
				<c:choose>
					<c:when test="${batch.STATUS == '0'}"><fmt:message bundle="${messages_directory}" key="directory.waitting" /></c:when>
					<c:when test="${batch.STATUS == '1'}"><fmt:message bundle="${messages_directory}" key="directory.success" /></c:when>
					<c:when test="${batch.STATUS == '2'}"><fmt:message bundle="${messages_directory}" key="directory.processing" /></c:when>
					<c:when test="${batch.STATUS == '3'}"><fmt:message bundle="${messages_directory}" key="directory.fail" /></c:when>
				</c:choose>
				</td>
				<c:if test="${empty batch.PROCESS_DATE}"><td class="cen" title="<fmt:formatDate value="${batch.MSG_DATE}" pattern="yyyy-MM-dd a h:mm:ss" />"><fmt:formatDate value="${batch.MSG_DATE}" pattern="yyyy-MM-dd a h:mm:ss" /></td></c:if>
				<c:if test="${not empty batch.PROCESS_DATE}"><td class="cen" title="<fmt:formatDate value="${batch.PROCESS_DATE}" pattern="yyyy-MM-dd a h:mm:ss" />"><fmt:formatDate value="${batch.PROCESS_DATE}" pattern="yyyy-MM-dd a h:mm:ss" /></td></c:if>
				<c:if test="${param.listType ne 'success'}"><td title="<c:out value="${batch.SUMMARY}" />"><c:out value="${batch.SUMMARY}" /></td></c:if>
			</tr>
			<c:if test="${loop.last}">
				<c:set var="count" value="${loop.count}" />
			</c:if>
		</c:forEach>
		<c:forEach var="i" begin="${count}" end="9">
			<tr>
			<c:choose>
			<c:when test="${count == 0 && i == 1}">
				<c:if test="${param.listType ne 'success'}"><td colspan="7" class="cen"><fmt:message bundle="${messages_directory}" key="directory.search.noData" /></td></c:if>
				<c:if test="${param.listType eq 'success'}"><td colspan="6" class="cen"><fmt:message bundle="${messages_directory}" key="directory.search.noData" /></td></c:if>
			</c:when>
			<c:otherwise>
				<c:if test="${param.listType ne 'success'}"><td colspan="7"></td></c:if>
				<c:if test="${param.listType eq 'success'}"><td colspan="6"></td></c:if>
			</c:otherwise>
			</c:choose>
			</tr>
		</c:forEach>
		<c:remove var="count" scope="page" />
		</tbody>
	</table>
	<!-- table : end -->
	<div class="paginate_area">
		<jsp:include page="../common/pagination.jsp"/>
	</div>
</body>
</html>