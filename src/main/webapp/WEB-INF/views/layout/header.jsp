<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    com.college.complaintportal.model.User loggedUser = 
        (com.college.complaintportal.model.User) session.getAttribute("loggedUser");
    request.setAttribute("currentUser", loggedUser);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : "Grievance Portal"} - Campus Redressal Cell</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom Application CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-institutional sticky-top py-2">
    <div class="container-fluid px-lg-4">
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/">
            <div class="brand-emblem">
                <i class="bi bi-shield-check"></i>
            </div>
            <div>
                <span class="d-block fw-bold text-primary lh-1 small text-uppercase tracking-wider">GrievanceCell</span>
                <span class="fw-bold fs-5 text-dark lh-1">Campus Portal</span>
            </div>
        </a>

        <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#portalNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="portalNav">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-2">
                <c:choose>
                    <c:when test="${not empty currentUser}">
                        <c:choose>
                            <c:when test="${currentUser.admin}">
                                <li class="nav-item">
                                    <a class="nav-link fw-semibold px-3 ${param.nav == 'dashboard' ? 'active text-primary' : ''}" 
                                       href="${pageContext.request.contextPath}/admin/dashboard">
                                        <i class="bi bi-speedometer2 me-1"></i> Admin Dashboard
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link fw-semibold px-3 ${param.nav == 'complaints' ? 'active text-primary' : ''}" 
                                       href="${pageContext.request.contextPath}/admin/complaints">
                                        <i class="bi bi-inbox-fill me-1"></i> Grievance Queue
                                    </a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="nav-item">
                                    <a class="nav-link fw-semibold px-3 ${param.nav == 'dashboard' ? 'active text-primary' : ''}" 
                                       href="${pageContext.request.contextPath}/dashboard">
                                        <i class="bi bi-columns-gap me-1"></i> Dashboard
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link fw-semibold px-3 ${param.nav == 'lodge' ? 'active text-primary' : ''}" 
                                       href="${pageContext.request.contextPath}/complaints/new">
                                        <i class="bi bi-plus-circle me-1"></i> Lodge Complaint
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link fw-semibold px-3 ${param.nav == 'my' ? 'active text-primary' : ''}" 
                                       href="${pageContext.request.contextPath}/complaints">
                                        <i class="bi bi-card-checklist me-1"></i> My Grievances
                                    </a>
                                </li>
                            </c:otherwise>
                        </c:choose>

                        <li class="nav-item dropdown ms-lg-2">
                            <a class="nav-link dropdown-toggle d-flex align-items-center gap-2 bg-light px-3 py-1 rounded-pill border" 
                               href="#" role="button" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle fs-5 text-primary"></i>
                                <span class="fw-semibold small">${currentUser.fullName}</span>
                                <span class="badge ${currentUser.admin ? 'bg-danger' : 'bg-primary'} rounded-pill" style="font-size: 0.65rem;">
                                    ${currentUser.role}
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                                <li class="px-3 py-2 border-bottom">
                                    <div class="fw-bold">${currentUser.fullName}</div>
                                    <div class="small text-muted">${currentUser.email}</div>
                                </li>
                                <li>
                                    <form action="${pageContext.request.contextPath}/logout" method="post" class="m-0">
                                        <button type="submit" class="dropdown-item text-danger py-2 d-flex align-items-center gap-2">
                                            <i class="bi bi-box-arrow-right"></i> Sign Out
                                        </button>
                                    </form>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link fw-semibold px-3" href="${pageContext.request.contextPath}/login">
                                <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-institutional-primary btn-sm px-3" href="${pageContext.request.contextPath}/register">
                                <i class="bi bi-person-plus me-1"></i> Register Account
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- Main Container -->
<main class="flex-grow-1 py-4">
    <div class="container-fluid px-lg-4">

        <!-- Flash Alert Messages -->
        <c:if test="${not empty sessionScope.flashSuccess}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-check-circle-fill fs-5"></i>
                <div>${sessionScope.flashSuccess}</div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("flashSuccess"); %>
        </c:if>

        <c:if test="${not empty sessionScope.flashError}">
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                <div>${sessionScope.flashError}</div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("flashError"); %>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                <div>${errorMessage}</div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-check-circle-fill fs-5"></i>
                <div>${successMessage}</div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
