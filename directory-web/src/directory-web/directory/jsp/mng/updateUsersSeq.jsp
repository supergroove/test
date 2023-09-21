<!DOCTYPE html>
<%@page import="com.hs.framework.directory.info.User"%>
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
	<title>HANDY Directory</title><!-- <fmt:message bundle="${messages_directory}" key="directory.userMng.updateSeq" /> -->
	
	<script type="text/javascript">
		var userOrder = "<c:out value="${usersOrder}"/>"; 
		function directory_updateUsersSeq_moveTop() {
			var top = null; // not selected top
			var differentPositions = false;
			$("#directory-updateUsersSeq-userList").find("option").each(function() {
				if(differentPositions) return;
				if (top && $(this).is(":selected")) {
					if("seq" != userOrder && ($(top).val().split(":")[1] != $(this).val().split(":")[1])){
						differentPositions = true;
						return;
					}
					$(top).before(this);
				} else if (!top && !$(this).is(":selected")) {
					top = this;
				}
			});
			if ("seq" != userOrder && differentPositions){
				alert($("#directory-updateUsersSeq-differentPositions").val());
				return;
			}
		}
		
		function directory_updateUsersSeq_movePrevious() {
			var previous = null;
			var differentPositions = false;
			$("#directory-updateUsersSeq-userList").find("option").each(function() {
				if(differentPositions) return;
				if (previous && $(this).is(":selected")) {
					if("seq" != userOrder && ($(previous).val().split(":")[1] != $(this).val().split(":")[1])){
						differentPositions = true;
						return;
					}
					$(previous).before(this);
				} else {
					previous = this;
				}
			});
			if ("seq" != userOrder && differentPositions){
				alert($("#directory-updateUsersSeq-differentPositions").val());
				return;
			}
		}
		
		function directory_updateUsersSeq_moveNext() {
			var next = null; // reverse order
			var differentPositions = false;
			$($("#directory-updateUsersSeq-userList").find("option").get().reverse()).each(function() {
				if(differentPositions) return;
				if (next && $(this).is(":selected")) {
					if("seq" != userOrder && ($(next).val().split(":")[1] != $(this).val().split(":")[1])){
						differentPositions = true;
						return;
					}
					$(next).after(this);
				} else {
					next = this;
				}
			});
			if ("seq" != userOrder && differentPositions){
				alert($("#directory-updateUsersSeq-differentPositions").val());
				return;
			}
		}
		
		function directory_updateUsersSeq_moveBottom() {
			var bottom = null; // reverse order, not selected bottom
			var differentPositions = false;
			$($("#directory-updateUsersSeq-userList").find("option").get().reverse()).each(function() {
				if(differentPositions) return;
				if (bottom && $(this).is(":selected")) {
					if("seq" != userOrder && ($(bottom).val().split(":")[1] != $(this).val().split(":")[1])){
						differentPositions = true;
						return;
					}
					$(bottom).after(this);
				} else if (!bottom && !$(this).is(":selected")) {
					bottom = this;
				}
			});
			if ("seq" != userOrder && differentPositions){
				alert($("#directory-updateUsersSeq-differentPositions").val());
				return;
			}
		}
	</script>
</head>
<body>
	<input type="hidden" id="directory-updateUsersSeq-confirm" value="<fmt:message bundle="${messages_directory}" key="directory.update.confirm" />" />
	<input type="hidden" id="directory-updateUsersSeq-sequenceUpdated" value="<fmt:message bundle="${messages_directory}" key="directory.update.sequenceUpdated" />" />
	<input type="hidden" id="directory-updateUsersSeq-differentPositions" value="<fmt:message bundle="${messages_directory}" key="directory.update.usersseq.differentPositions" />" />
	
	<!-- button : start -->
	<div class="btn_area with_tab">
		<div class="h_semi"><fmt:message bundle="${messages_directory}" key="directory.userMng.updateSeq" /></div>
		<ul class="btns">
			<li><span><a href="#" onclick="javascript:directory_history.back();"><fmt:message bundle="${messages_directory}" key="directory.back" /></a></span></li>
			<li><span><a href="#" onclick="javascript:directory_orgMng.updateUsersSeq('<c:out value="${param.deptID}" />');"><fmt:message bundle="${messages_directory}" key="directory.update" /></a></span></li>
		</ul>
	</div>
	<!-- button : end -->
	<div style="padding: 5px;">
		<!-- table : start -->
		<table border="1" cellspacing="0" cellpadding="0" class="content_lst" style="width:949px">
			<col width="282px">
            <col width="282px">
            <col width="282px">
            <col width="86px">
            <tr>
            	<th scope="col" class="cen" style="width:282px">
            		<fmt:message bundle="${messages_directory}" key="directory.positionName" />
            	</th>
            	<th scope="col" class="cen" style="width:282px">
            		<fmt:message bundle="${messages_directory}" key="directory.userName" />
            	</th>
            	<th scope="col" class="cen" style="width:282px">
            		<fmt:message bundle="${messages_directory}" key="directory.empCode" />
            	</th>
            	<th scope="col" class="cen" style="width:86px">			            		
            	</th>
            </tr>	
			<tbody>
				<tr>
					<td colspan="3">
						<select id="directory-updateUsersSeq-userList" size="20" multiple="multiple" style="width: 100%; font-family:굴림체">
						<%
						List userList = (List)request.getAttribute("userList");
						boolean isEnglish = request.getAttribute("IS_ENGLISH") == null ? false : (Boolean)request.getAttribute("IS_ENGLISH");
						if(userList != null){
							int size = userList.size();
							for(int i=0; i<size; i++){
								User user = (User)userList.get(i);
								String posName = null;
								if(isEnglish && !StringUtils.isEmpty(user.getPositionNameEng())){
									posName = user.getPositionNameEng();
								}else{
									posName = user.getPositionName();
								}
								posName = fixedStr(posName, 50);
								String name = null;
								if(isEnglish && !StringUtils.isEmpty(user.getNameEng())){
									name = user.getNameEng();	
								}else{
									name = user.getName();
								}
								name = fixedStr(name, 50);
								String empCode = StringUtils.rightPad(user.getEmpCode() == null ? "" : user.getEmpCode(), 5, " ");
								empCode = fixedStr(empCode, 5);
								
								out.println("<option value=\""+user.getID()+":"+user.getSecurityLevel()+"\">");
								out.println(posName + name + empCode);
								out.println("</option>");
							}
						}
						%>
						</select>
					</td>
					<td align="center">
						<a href="#" onclick="javascript:directory_updateUsersSeq_moveTop();"><img src="<c:out value="${CONTEXT}" />/directory/images/B_FTOP.GIF"></a><br />
						<a href="#" onclick="javascript:directory_updateUsersSeq_movePrevious();"><img src="<c:out value="${CONTEXT}" />/directory/images/B_FUP.GIF"></a><br />
						<a href="#" onclick="javascript:directory_updateUsersSeq_moveNext();"><img src="<c:out value="${CONTEXT}" />/directory/images/B_FDN.GIF"></a><br />
						<a href="#" onclick="javascript:directory_updateUsersSeq_moveBottom();"><img src="<c:out value="${CONTEXT}" />/directory/images/B_FBOT.GIF"></a><br />
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</body>
</html>