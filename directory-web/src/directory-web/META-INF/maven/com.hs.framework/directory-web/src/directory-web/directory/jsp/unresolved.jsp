<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title>
	
	<!-- jQuery -->
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/dynatree-1.2.4/jquery/jquery.js"></script>
	
	<!-- HANDY Directory -->
	<link rel="stylesheet" type="text/css" href="<c:out value="${CONTEXT}" />/directory/css/basic80.css" />
	<script type="text/javascript" src="<c:out value="${CONTEXT}" />/directory/js/orgPopup.js"></script>
	
	<script type="text/javascript">
		$(document).ready(function() {
			$("span[name='unresolved']").each(function() {
				var arr = parseType($(this).text());
				if (arr[0] == EMP) {
					$(this).text("<fmt:message key="dir.empcode.notexist" />".replace(/\{0\}/, arr[1]));
				} else {
					$(this).text("<fmt:message key="dir.recipients.notexist" />".replace(/\{0\}/, arr[1]));
				}
			});
			
			resizePopup(700, $("#pop_wrap").height());
		});
	</script>
</head>
<body>
<div> <!-- clear : html, body { height: 100% } -->
	<div id="pop_wrap" style="min-width: 300px;">
		<h1>
			<p><fmt:message key="message.addrinputerror" /></p>
		</h1>
		<!-- table : start -->
		<table border="0" cellspacing="0" cellpadding="0" width="100%" style="margin-top: 10px;">
		<c:forEach var="l" items="${list}">
			<c:forEach var="o" items="${l}">
				<c:if test="${o.item == null && empty o.homonyms}">
					<tr>
						<td align="center" style="line-height: 22px;">
							<img src="<c:out value="${CONTEXT}" />/directory/images/WARNING.GIF" />
							<span name="unresolved"><c:out value="${o.resolvingName}" /></span>
						</td>
					</tr>
				</c:if>
			</c:forEach>
		</c:forEach>
		</table>
		<!-- table : end -->
		<div class="footcen">
			<ul class="btns">
				<li><span><a href="#" onclick="javascript:window.close();"><fmt:message key="org.ok" /></a></span></li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>