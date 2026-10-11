<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Campus Grievance Redressal Portal" scope="request"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="row align-items-center py-5">
    <div class="col-lg-7 pe-lg-5">
        <div class="d-inline-flex align-items-center gap-2 px-3 py-1 bg-primary-subtle text-primary rounded-pill small fw-bold mb-3">
            <i class="bi bi-patch-check-fill"></i> Official Institutional Grievance System
        </div>
        <h1 class="display-5 fw-bold text-dark lh-sm mb-3">
            Online Complaint Management & Redressal Portal
        </h1>
        <p class="lead text-secondary mb-4">
            A transparent, accountable platform for students, faculty, and campus members to register grievances, 
            receive unique tracking IDs, and monitor resolution timelines in real time.
        </p>
        <div class="d-flex flex-wrap gap-3">
            <c:choose>
                <c:when test="${not empty sessionScope.loggedUser}">
                    <c:choose>
                        <c:when test="${sessionScope.loggedUser.admin}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-institutional-primary btn-lg shadow-sm">
                                <i class="bi bi-speedometer2 me-2"></i> Go to Admin Dashboard
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/complaints/new" class="btn btn-institutional-primary btn-lg shadow-sm">
                                <i class="bi bi-plus-circle me-2"></i> Lodge New Grievance
                            </a>
                            <a href="${pageContext.request.contextPath}/complaints" class="btn btn-institutional-secondary btn-lg">
                                <i class="bi bi-clock-history me-2"></i> Track My Grievances
                            </a>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-institutional-primary btn-lg shadow-sm">
                        <i class="bi bi-person-plus-fill me-2"></i> Register Account
                    </a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-institutional-secondary btn-lg">
                        <i class="bi bi-box-arrow-in-right me-2"></i> Sign In to Portal
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="row mt-5 pt-3 g-3">
            <div class="col-sm-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="stat-icon bg-primary-subtle text-primary">
                        <i class="bi bi-fingerprint"></i>
                    </div>
                    <div>
                        <div class="fw-bold">Unique Reference</div>
                        <div class="small text-muted">Tamper-proof IDs</div>
                    </div>
                </div>
            </div>
            <div class="col-sm-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="stat-icon bg-success-subtle text-success">
                        <i class="bi bi-hourglass-split"></i>
                    </div>
                    <div>
                        <div class="fw-bold">Live Status</div>
                        <div class="small text-muted">Audited timeline</div>
                    </div>
                </div>
            </div>
            <div class="col-sm-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="stat-icon bg-warning-subtle text-warning">
                        <i class="bi bi-shield-lock"></i>
                    </div>
                    <div>
                        <div class="fw-bold">Role Security</div>
                        <div class="small text-muted">BCrypt + Auth</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-5 mt-4 mt-lg-0">
        <div class="card card-institutional border-0 shadow-lg p-4 bg-white">
            <h5 class="fw-bold text-dark mb-3 d-flex align-items-center gap-2">
                <i class="bi bi-info-circle text-primary"></i> Grievance Categories Handled
            </h5>
            <ul class="list-group list-group-flush mb-4">
                <li class="list-group-item px-0 py-2 d-flex justify-content-between align-items-center">
                    <span><i class="bi bi-mortarboard me-2 text-primary"></i> Academic & Examination</span>
                    <span class="badge bg-light text-primary border">Fast-Track</span>
                </li>
                <li class="list-group-item px-0 py-2 d-flex justify-content-between align-items-center">
                    <span><i class="bi bi-building me-2 text-secondary"></i> Hostel & Campus Infrastructure</span>
                    <span class="badge bg-light text-secondary border">Maintenance</span>
                </li>
                <li class="list-group-item px-0 py-2 d-flex justify-content-between align-items-center">
                    <span><i class="bi bi-wifi me-2 text-info"></i> IT Services & WiFi Network</span>
                    <span class="badge bg-light text-info border">Technical</span>
                </li>
                <li class="list-group-item px-0 py-2 d-flex justify-content-between align-items-center">
                    <span><i class="bi bi-credit-card me-2 text-success"></i> Accounts & Scholarship</span>
                    <span class="badge bg-light text-success border">Finance</span>
                </li>
                <li class="list-group-item px-0 py-2 d-flex justify-content-between align-items-center">
                    <span><i class="bi bi-bus-front me-2 text-warning"></i> Transport & Canteen Services</span>
                    <span class="badge bg-light text-warning border">General</span>
                </li>
            </ul>

            <div class="p-3 bg-light rounded-3 border">
                <div class="small fw-semibold text-secondary mb-1">Demonstration Credentials:</div>
                <div class="small text-dark font-monospace">Admin: admin@college.edu / Admin@1234</div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
