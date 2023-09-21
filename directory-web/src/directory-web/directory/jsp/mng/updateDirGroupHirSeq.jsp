<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirMng.updateSeq" /> -->
	
	<script type="text/javascript">
		function directory_updateDirGroupHirSeq_moveTop() {
			var top = null; // not selected top
			$("#directory-updateDirGroupHirSeq-hirList").find("option").each(function() {
				if (top && $(this).is(":selected")) {
					$(top).before(this);
				} else if (!top && !$(this).is(":selected")) {
					top = this;
				}
			});
		}
		
		function directory_updateDirGroupHirSeq_movePrevious() {
			var previous = null;
			$("#directory-updateDirGroupHirSeq-hirList").find("option").each(function() {
				if (previous && $(this).is(":selected")) {
					$(previous).before(this);
				} else {
					previous = this;
				}
			});
		}
		
		function directory_updateDirGroupHirSeq_moveNext() {
			var next = null; // reverse order
			$($("#directory-updateDirGroupHirSeq-hirList").find("option").get().reverse()).each(function() {
				if (next && $(this).is(":selected")) {
					$(next).after(this);
				} else {
					next = this;
				}
			});
		}
		
		function directory_updateDirGroupHirSeq_moveBottom() {
			var bottom = null; // reverse order, not selected bottom
			$($("#directory-updateDirGroupHirSeq-hirList").find("option").get().reverse()).each(function() {
				if (bottom && $(this).is(":selected")) {
					$(bottom).after(this);
				} else if (!bottom && !$(this).is(":selected")) {
					bottom = this;
				}
			});
		}
	</script>
</head>
<body>
	<input type="hidden" id="directory-updateDirGroupHirSeq-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.update.confirm" />" />
	<input type="hidden" id="directory-updateDirGroupHirSeq-sequenceUpdated" value="<fmt:message bundle="${messages_directory}" key="directory.update.sequenceUpdated" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirMng.updateSeq" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_orgMng.listDirGroupHir();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.updateDirGroupHirSeq();"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
		</ul>
	</div>
	<!-- button : end -->
	<div style="padding: 5px;">
		<!-- table : start -->
		<table border="1" cellspacing="0" cellpadding="0" class="content_lst" style="width: 50%">
			<col width="">
            <col width="86px">
            <tr>
            	<th scope="col" class="cen">
            		<fmt:message bundle="${messages_directory}" key="directory.dirGroup.hirName" />
            	</th>
            	<th scope="col" class="cen">
            	</th>
            </tr>	
			<tbody>
				<tr>
					<td>
						<select id="directory-updateDirGroupHirSeq-hirList" size="20" multiple="multiple" style="width: 100%; font-family:굴림체">
						<c:forEach var="hir" items="${hirList}" varStatus="loop">
							<option value="<c:out value="${hir.ID}" />"><c:out value="${hir.name}" /></option>
						</c:forEach>
						</select>
					</td>
					<td align="center">
						<a href="#" onclick="javascript:directory_updateDirGroupHirSeq_moveTop();"><img src="<c:out value="${CONTEXT}" />/directory/images/B_FTOP.GIF"></a><br />
						<a href="#" onclick="javascript:directory_updateDirGroupHirSeq_movePrevious();"><img src="<c:out value="${CONTEXT}" />/directory/images/B_FUP.GIF"></a><br />
						<a href="#" onclick="javascript:directory_updateDirGroupHirSeq_moveNext();"><img src="<c:out value="${CONTEXT}" />/directory/images/B_FDN.GIF"></a><br />
						<a href="#" onclick="javascript:directory_updateDirGroupHirSeq_moveBottom();"><img src="<c:out value="${CONTEXT}" />/directory/images/B_FBOT.GIF"></a><br />
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</body>
</html>