<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Access Forbidden (403)" scope="request"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="row justify-content-center py-5">
    <div class="col-md-7 col-lg-5 text-center">
        <div class="stat-icon bg-danger-subtle text-danger mx-auto mb-3" style="width: 72px; height: 72px; font-size: 2.25rem;">
            <i class="bi bi-shield-x"></i>
        </div>
        <h2 class="fw-bold text-dark mb-2">403 — Unauthorized Access</h2>
        <p class="text-secondary mb-4">
            ${errorMessage != null ? errorMessage : "You do not possess the necessary administrative privileges or ownership authorization to view or manipulate this resource."}
        </p>
        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                <i class="bi bi-house-door me-1"></i> Home
            </a>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-institutional-primary">
                <i class="bi bi-box-arrow-in-right me-1"></i> Sign In with Admin Account
            </a>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
