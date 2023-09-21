<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

<script>
	function _goListPage(page) {
		var totalPage = "<c:out value="${pParam.totalPage}" />";
		
		if (!/^[0-9]+$/.test(page)
				|| eval(page) < 1
				|| eval(page) > eval(totalPage)) {
			alert("<fmt:message bundle="${messages_directory}" key="directory.pagination.inputError" />".replace("{0}", "1").replace("{1}", totalPage));
			$('#target_page').val('');
			$('#target_page').focus();
			return;
		}
		
		//need to declare this method as goListPage(page) in the page which intend to use pagenavigator
		goListPage(page);
	}
</script>

<div class="Paginate">
<c:if test="${pParam.startPageIndex > pParam.pageShortCut}">
	<a href="#" onclick="javascript:_goListPage(1);"><span class="num txt"><fmt:message bundle="${messages_directory}" key="directory.first" /></span></a>
	<a href="#" onclick="javascript:_goListPage(<c:out value="${pParam.startPageIndex - pParam.pageShortCut}" />);" class="css_arr"><span class="arr_l"></span></a>
</c:if>
<c:if test="${pParam.startPageIndex <= pParam.pageShortCut}">
	<span class="num txt"><fmt:message bundle="${messages_directory}" key="directory.first" /></span>
	<span class="css_arr"><span class="arr_l"></span></span>
</c:if>

<c:forEach var="i" begin="${pParam.startPageIndex}" end="${pParam.startPageIndex + pParam.pageShortCut - 1}">
<c:if test="${i <= pParam.totalPage}">
	<c:if test="${i == pParam.currentPage}">
		<span class="num now"><c:out value="${i}" /></span>
	</c:if>
	<c:if test="${i != pParam.currentPage}">
		<a href="#" onclick="javascript:_goListPage(<c:out value="${i}" />);"><span class="num"><c:out value="${i}" /></span></a>
	</c:if>
</c:if>
</c:forEach>

<c:if test="${pParam.startPageIndex + pParam.pageShortCut <= pParam.totalPage}">
	<a href="#" onclick="javascript:_goListPage(<c:out value="${pParam.startPageIndex + pParam.pageShortCut}" />);" class="css_arr"><span class="arr_r"></span></a>
	<a href="#" onclick="javascript:_goListPage(<c:out value="${pParam.totalPage}" />);"><span class="num txt"><fmt:message bundle="${messages_directory}" key="directory.last" /></span></a>
</c:if>
<c:if test="${pParam.startPageIndex + pParam.pageShortCut > pParam.totalPage}">
	<span class="css_arr"><span class="arr_r"></span></span>
	<span class="num txt"><fmt:message bundle="${messages_directory}" key="directory.last" /></span>
</c:if>

<c:if test="${pParam.totalPage > 1}">
	<input id="target_page" class="inp_txt" value="<c:out value="${pParam.currentPage}" />" onkeypress="javascript:if(event.keyCode == 13){_goListPage(this.value);}" />
	<span class="page_all">/ <c:out value="${pParam.totalPage}" /></span>
	<a href="#" onclick="javascript:_goListPage($('#target_page').val());"><span class="num"><fmt:message bundle="${messages_directory}" key="directory.move" /></span></a>
</c:if>
<c:if test="${pParam.totalPage <= 1}">
	<input id="target_page" class="inp_txt" value="<c:out value="${pParam.currentPage}" />" disabled="disabled" />
	<span class="page_all">/ <c:out value="${pParam.totalPage}" /></span>
	<span class="num"><fmt:message bundle="${messages_directory}" key="directory.move" /></span>
</c:if>
</div>