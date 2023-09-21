<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="CONTEXT" value="${pageContext.request.contextPath}" />

<c:choose>
	<c:when test="${not empty param.FRAMEWORK_DIRECTORY_LOCALE}">
		<c:set var="LOCALE" value="${param.FRAMEWORK_DIRECTORY_LOCALE}" />
	</c:when>
	<c:when test="${not empty sessionScope.FRAMEWORK_DIRECTORY_LOCALE}">
		<c:set var="LOCALE" value="${sessionScope.FRAMEWORK_DIRECTORY_LOCALE}" />
	</c:when>
	<c:when test="${not empty cookie.GWLANG.value}">
		<c:set var="LOCALE" value="${cookie.GWLANG.value}" />
	</c:when>
	<c:when test="${not empty pageContext.request.locale}">
		<c:set var="LOCALE" value="${pageContext.request.locale}" />
	</c:when>
	<c:otherwise>
		<c:set var="LOCALE" value="ko_KR" />
	</c:otherwise>
</c:choose>
<fmt:setLocale value="${LOCALE}" />
<fmt:setBundle basename="com.hs.framework.directory.resources.messages" />

<c:set var="IS_ENGLISH" value="false" />
<c:if test="${LOCALE == 'en' || LOCALE == 'en_US'}">
	<c:set var="IS_ENGLISH" value="true" />
</c:if>