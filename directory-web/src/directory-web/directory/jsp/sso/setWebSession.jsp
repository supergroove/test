<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>

<script>

	jQuery.support.cors = true;
	jQuery.ajax({
		type : "post",
		url : '<%=request.getParameter("externalAddress")%>/bms/login.cmmn?K=<%=request.getParameter("key")%>',
		xhrFields : {withCredentials : true },
		cache:false,
		async:false
	});
<%-- 	
	jQuery.ajax({
		type : "post",
		url : '<%=request.getParameter("externalAddress")%>/jsp/org/init/IntegLogin.jsp?K=<%=request.getParameter("key")%>',
		xhrFields : {withCredentials : true },	
		cache:false,
		async:true		
	}); --%>
		

	document.location.href='<%=request.getParameter("url")%>';

</script>

