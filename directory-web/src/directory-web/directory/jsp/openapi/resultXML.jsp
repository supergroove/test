<%@ page language="java" pageEncoding="utf-8" contentType="text/xml; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% out.clearBuffer(); %><c:out value="${data}" escapeXml="false" />