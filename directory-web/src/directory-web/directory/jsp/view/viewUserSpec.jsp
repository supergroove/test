<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

	<c:if test="${IS_ENGLISH}">
		<c:if test="${not empty user.nameEng}">
			<c:set target="${user}" property="name" value="${user.nameEng}" />
		</c:if>
		<c:if test="${not empty user.deptNameEng}">
			<c:set target="${user}" property="deptName" value="${user.deptNameEng}" />
		</c:if>
		<c:if test="${not empty user.positionNameEng}">
			<c:set target="${user}" property="positionName" value="${user.positionNameEng}" />
		</c:if>
	</c:if>
	<div id="pop_wrap" style="width: 500px; min-width: 300px;">
		<h1>
			<p><fmt:message bundle="${messages_directory}" key="directory.userInfo" /></p>
		</h1>
		<div id="pop_container">
			<div class="contents">
				<!-- table : start -->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<col width="125px">
					<col width="">
					<tr>
						<td valign="top" align="left">
							<img src="<c:choose><c:when test="${empty user.pictureURL}"><c:out value="${CONTEXT}" /><fmt:message bundle="${messages_directory}" key="/directory/images/NOIMAGE.GIF" /></c:when><c:otherwise><c:out value="${CONTEXT}${user.pictureURL}" /></c:otherwise></c:choose>" width="120" />
						</td>
						<td valign="top">
							<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%" style="word-break: break-all;">
								<col width="110" />
								<col width="" />
								<tbody>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.userName" /></th>
										<td><c:out value="${user.name}" /></td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.position" /></th>
										<td><c:out value="${user.positionName}" /></td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.userDeptName" /></th>
										<td><c:out value="${user.deptName}" /></td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.phone" /></th>
										<td><c:out value="${user.phone}" /></td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.mobilePhone" /></th>
										<td><c:out value="${user.mobilePhone}" /></td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.fax" /></th>
										<td><c:out value="${user.fax}" /></td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.en_email" /></th>
										<td><c:out value="${user.email}" /></td>
									</tr>
									<tr>
										<th><fmt:message bundle="${messages_directory}" key="directory.business" /></th>
										<td><c:out value="${user.business}" /></td>
									</tr>
								</tbody>
							</table>
						</td>
					</tr>
				</table>
				<!-- table : end -->
			</div>
			<div class="footcen" style="padding-bottom: 0;">
				<ul class="btns">
					<li><span><a href="#" onclick="directory_divPopup.close();"><fmt:message bundle="${messages_directory}" key="directory.ok"/></a></span></li>
				</ul>
			</div>
		</div>
	</div>