<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Internal Server Error (500)" scope="request"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="row justify-content-center py-5">
    <div class="col-md-7 col-lg-5 text-center">
        <div class="stat-icon bg-danger-subtle text-danger mx-auto mb-3" style="width: 72px; height: 72px; font-size: 2.25rem;">
            <i class="bi bi-exclamation-octagon"></i>
        </div>
        <h2 class="fw-bold text-dark mb-2">500 — Application Processing Error</h2>
        <p class="text-secondary mb-3">
            An unexpected error occurred while communicating with the database or servicing your request.
        </p>

        <c:if test="${not empty pageContext.exception}">
            <div class="alert alert-danger text-start small font-monospace mb-4">
                ${pageContext.exception.message}
            </div>
        </c:if>

        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                <i class="bi bi-house-door me-1"></i> Home
            </a>
            <a href="javascript:history.back()" class="btn btn-institutional-primary">
                <i class="bi bi-arrow-left me-1"></i> Return to Previous Page
            </a>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
