<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Sign In" scope="request"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="row justify-content-center py-5">
    <div class="col-md-7 col-lg-5">
        <div class="card card-institutional border-0 shadow-sm p-4 p-md-5">
            <div class="text-center mb-4">
                <div class="brand-emblem mx-auto mb-3" style="width: 48px; height: 48px; font-size: 1.5rem;">
                    <i class="bi bi-shield-lock"></i>
                </div>
                <h3 class="fw-bold text-dark">Portal Sign In</h3>
                <p class="text-muted small">Enter your institutional credentials to access your dashboard</p>
            </div>

            <form action="${pageContext.request.contextPath}/login" method="post" novalidate>
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">

                <div class="mb-3">
                    <label for="email" class="form-label fw-semibold small text-secondary">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-envelope"></i></span>
                        <input type="email" class="form-control border-start-0" id="email" name="email" 
                               value="${email}" placeholder="student@college.edu or admin@college.edu" required autofocus>
                    </div>
                </div>

                <div class="mb-4">
                    <label for="password" class="form-label fw-semibold small text-secondary">Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-key"></i></span>
                        <input type="password" class="form-control border-start-0" id="password" name="password" 
                               placeholder="••••••••" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-institutional-primary w-100 py-2 shadow-sm mb-3">
                    <i class="bi bi-box-arrow-in-right me-1"></i> Sign In to Portal
                </button>
            </form>

            <div class="text-center pt-3 border-top">
                <span class="text-muted small">Don't have an account yet?</span>
                <a href="${pageContext.request.contextPath}/register" class="fw-bold text-primary small ms-1 text-decoration-none">
                    Register Here
                </a>
            </div>

            <div class="mt-4 p-3 bg-light rounded-3 border">
                <div class="small fw-bold text-secondary mb-1"><i class="bi bi-key-fill text-warning me-1"></i> Quick Demo Admin:</div>
                <div class="small text-muted font-monospace">Email: <strong>admin@college.edu</strong></div>
                <div class="small text-muted font-monospace">Password: <strong>Admin@1234</strong></div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
