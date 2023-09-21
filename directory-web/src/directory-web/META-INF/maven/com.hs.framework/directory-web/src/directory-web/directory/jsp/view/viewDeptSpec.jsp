<!DOCTYPE html>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="../common/include.jsp" %>

	<c:if test="${IS_ENGLISH}">
		<c:if test="${not empty dept.nameEng}">
			<c:set target="${dept}" property="name" value="${dept.nameEng}" />
		</c:if>
	</c:if>
	<div id="pop_wrap" style="width: 500px; min-width: 300px;">
		<h1>
			<p><fmt:message bundle="${messages_directory}" key="directory.deptInfo" /></p>
		</h1>
		<div id="pop_container">
			<div class="contents">
				<!-- table : start -->
				<table class="basic_table" border="0" cellspacing="0" cellpadding="0" width="100%">
					<col width="110" />
					<col width="" />
					<col width="110" />
					<col width="" />
					<tbody>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.deptName" /></th>
							<td><c:out value="${dept.name}" /></td>
							<th><fmt:message bundle="${messages_directory}" key="directory.deptCode" /></th>
							<td><c:out value="${dept.deptCode}" /></td>
						</tr>
						<tr>
							<th><fmt:message bundle="${messages_directory}" key="directory.auth" /></th>
							<td colspan="3">
							<c:forEach var="auth" items="${authes}">
								<c:if test="${auth.type == 3}">
									<c:set var="isChecked" value="" />
									<c:forEach var="userauth" items="${userAuthes}">
										<c:if test="${auth.code == userauth.auth && userauth.userID == dept.ID && userauth.relID == dept.ID}">
											<c:set var="isChecked" value="checked=\"checked\"" />
										</c:if>
									</c:forEach>
									<span class="inp_raochk"><input type="checkbox" disabled="disabled" value="<c:out value="${dept.ID}" />" <c:out value="${isChecked}" /> /><c:out value="${auth.name}" /></span><br />
								</c:if>
							</c:forEach>
							</td>
						</tr>
					<c:forEach var="auth" items="${authes}">
						<c:if test="${auth.type != 3}">
						<tr>
							<th><c:out value="${auth.name}" /></th>
							<td colspan="3">
							<c:forEach var="userauth" items="${userAuthes}">
								<c:if test="${auth.code == userauth.auth}">
									<c:if test="${IS_ENGLISH}">
										<c:if test="${not empty userMap[userauth.userID].nameEng}">
											<c:set target="${userMap[userauth.userID]}" property="name" value="${userMap[userauth.userID].nameEng}" />
										</c:if>
									</c:if>
									<c:out value="${userMap[userauth.userID].name}" />;
								</c:if>
							</c:forEach>
							</td>
						</tr>
						</c:if>
					</c:forEach>
					</tbody>
				</table>
				<!-- table : end -->
			</div>
			<div class="footcen">
				<ul class="btns">
					<li><span><a href="#" onclick="directory_divPopup.close();"><fmt:message bundle="${messages_directory}" key="directory.ok"/></a></span></li>
				</ul>
			</div>
		</div>
	</div>