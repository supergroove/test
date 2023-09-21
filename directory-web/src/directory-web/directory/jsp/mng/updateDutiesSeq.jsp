<!DOCTYPE html>
<%@page import="com.hs.framework.directory.info.Duty"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>
<%!
    public String fixedStr(String value, int minbytes)
    {
        if (value == null)
            value="";
        try
        {
            if (minbytes <= 0) return "";

            byte data[] = value.getBytes();
            if (data.length < minbytes)
            {
                byte val[] = new byte[minbytes];
                for (int i = 0; i < minbytes; i++) val[i] = (byte) ' ';
                System.arraycopy(data, 0, val, 0, data.length);
                return StringUtils.replace(new String(val, 0, minbytes), " ", "&nbsp;");
            }
            else
                return value;
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return "";
    }
%>
<html lang="utf-8">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.dutyMng.updateSeq" /> -->
	
	<script type="text/javascript">
		function directory_updateDutiesSeq_moveTop() {
			var top = null; // not selected top
			$("#directory-updateDutiesSeq-dutyList").find("option").each(function() {
				if (top && $(this).is(":selected")) {
					$(top).before(this);
				} else if (!top && !$(this).is(":selected")) {
					top = this;
				}
			});
		}
		
		function directory_updateDutiesSeq_movePrevious() {
			var previous = null;
			$("#directory-updateDutiesSeq-dutyList").find("option").each(function() {
				if (previous && $(this).is(":selected")) {
					$(previous).before(this);
				} else {
					previous = this;
				}
			});
		}
		
		function directory_updateDutiesSeq_moveNext() {
			var next = null; // reverse order
			$($("#directory-updateDutiesSeq-dutyList").find("option").get().reverse()).each(function() {
				if (next && $(this).is(":selected")) {
					$(next).after(this);
				} else {
					next = this;
				}
			});
		}
		
		function directory_updateDutiesSeq_moveBottom() {
			var bottom = null; // reverse order, not selected bottom
			$($("#directory-updateDutiesSeq-dutyList").find("option").get().reverse()).each(function() {
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
	<input type="hidden" id="directory-updateDutiesSeq-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.update.confirm" />" />
	<input type="hidden" id="directory-updateDutiesSeq-sequenceUpdated" value="<fmt:message bundle="${messages_directory}" key="directory.update.sequenceUpdated" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.dutyMng.updateSeq" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_orgMng.listDuties();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.updateDutiesSeq();"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
		</ul>
	</div>
	<!-- button : end -->
	<div style="padding: 5px;">
		<!-- table : start -->
		<table border="1" cellspacing="0" cellpadding="0" class="content_lst" style="width:786px">
			<col width="300px">
            <col width="400px">
            <col width="86px">
            <tr>
            	<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.dutyCode" /></th>
            	<th scope="col" class="cen"><fmt:message bundle="${messages_directory}" key="directory.dutyName" /></th>
            	<th scope="col" class="cen"></th>
            </tr>	
			<tbody>
				<tr>
					<td colspan="2">
						<select id="directory-updateDutiesSeq-dutyList" size="20" multiple="multiple" style="width: 100%; font-family:굴림체">
						<%
							List<Duty> dutyList = (List<Duty>) request.getAttribute("dutyList");
							if (dutyList != null) {
								for (Duty duty : dutyList) {
									out.println("<option value=\"" + duty.getID() + "\">" + fixedStr(duty.getCode(), 50) + duty.getName() + "</option>");
								}
							}
						%>
						</select>
					</td>
					<td align="center">
						<a href="#" onclick="javascript:directory_updateDutiesSeq_moveTop();"><img src="<c:out value="${CONTEXT}" />/directory/images/B_FTOP.GIF"></a><br />
						<a href="#" onclick="javascript:directory_updateDutiesSeq_movePrevious();"><img src="<c:out value="${CONTEXT}" />/directory/images/B_FUP.GIF"></a><br />
						<a href="#" onclick="javascript:directory_updateDutiesSeq_moveNext();"><img src="<c:out value="${CONTEXT}" />/directory/images/B_FDN.GIF"></a><br />
						<a href="#" onclick="javascript:directory_updateDutiesSeq_moveBottom();"><img src="<c:out value="${CONTEXT}" />/directory/images/B_FBOT.GIF"></a><br />
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</body>
</html>