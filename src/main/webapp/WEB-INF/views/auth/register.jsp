<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Create Account" scope="request"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="row justify-content-center py-5">
    <div class="col-md-8 col-lg-6">
        <div class="card card-institutional border-0 shadow-sm p-4 p-md-5">
            <div class="text-center mb-4">
                <div class="brand-emblem mx-auto mb-3" style="width: 48px; height: 48px; font-size: 1.5rem;">
                    <i class="bi bi-person-badge"></i>
                </div>
                <h3 class="fw-bold text-dark">Register Account</h3>
                <p class="text-muted small">Create your student or faculty profile to lodge and track grievances</p>
            </div>

            <form action="${pageContext.request.contextPath}/register" method="post" novalidate>
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">

                <div class="mb-3">
                    <label for="fullName" class="form-label fw-semibold small text-secondary">Full Name</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-person"></i></span>
                        <input type="text" class="form-control border-start-0" id="fullName" name="fullName" 
                               value="${fullName}" placeholder="e.g. Aarav Sharma" required autofocus>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label fw-semibold small text-secondary">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-envelope"></i></span>
                        <input type="email" class="form-control border-start-0" id="email" name="email" 
                               value="${email}" placeholder="student@college.edu" required>
                    </div>
                    <div class="form-text small text-muted">Use your college email if available. This email must be unique.</div>
                </div>

                <div class="row g-2 mb-4">
                    <div class="col-md-6">
                        <label for="password" class="form-label fw-semibold small text-secondary">Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control border-start-0" id="password" name="password" 
                                   placeholder="Min 6 characters" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label for="confirmPassword" class="form-label fw-semibold small text-secondary">Confirm Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-check2-circle"></i></span>
                            <input type="password" class="form-control border-start-0" id="confirmPassword" name="confirmPassword" 
                                   placeholder="Re-enter password" required>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-institutional-primary w-100 py-2 shadow-sm mb-3">
                    <i class="bi bi-person-plus-fill me-1"></i> Register Profile
                </button>
            </form>

            <div class="text-center pt-3 border-top">
                <span class="text-muted small">Already registered?</span>
                <a href="${pageContext.request.contextPath}/login" class="fw-bold text-primary small ms-1 text-decoration-none">
                    Sign In Here
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
