<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>

<script>


    jQuery.support.cors = true;
	jQuery.ajax({
		type : "get",
		url : '<%=request.getParameter("externalAddress")%>/bms/logout.cmmn?K=<%=request.getParameter("key")%>',
		xhrFields : {withCredentials : true },	
		cache:false,
		async:false		
	});

		
	jQuery.ajax({
		type : "get",
		url : '<%=request.getParameter("externalAddress")%>/wma/wma.do?acton=session&todo=logout&key=<%=request.getParameter("key")%>',
		xhrFields : {withCredentials : true },	
		cache:false,
		async:false		
	});

	document.location.href='<%=request.getParameter("url")%>';

</script>