<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Administrator Dashboard" scope="request"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp?nav=dashboard"/>

<!-- Admin Welcome Banner -->
<div class="card card-institutional border-0 bg-dark text-white p-4 mb-4 position-relative overflow-hidden" 
     style="background: linear-gradient(135deg, #0F2744, #1E56A0) !important;">
    <div class="row align-items-center position-relative z-1">
        <div class="col-md-8">
            <div class="d-inline-flex align-items-center gap-2 mb-2">
                <span class="badge bg-danger rounded-pill px-2 py-1 small">
                    <i class="bi bi-shield-lock-fill me-1"></i> ADMIN ACCESS
                </span>
                <span class="small text-white-50">Central Grievance Nodal Desk</span>
            </div>
            <h2 class="fw-bold mb-1">Administrative Control Center</h2>
            <p class="text-white-50 mb-0 small">
                Monitor live student grievances, execute status transitions, and add verifiable resolution remarks.
            </p>
        </div>
        <div class="col-md-4 text-md-end mt-3 mt-md-0">
            <a href="${pageContext.request.contextPath}/admin/complaints" class="btn btn-light fw-bold shadow-sm">
                <i class="bi bi-inbox-fill me-1 text-primary"></i> Open Grievance Queue
            </a>
        </div>
    </div>
</div>

<!-- Key Metric Counters Grid -->
<div class="row g-3 mb-4">
    <!-- Total Grievances -->
    <div class="col-sm-6 col-xl-2">
        <div class="stat-card">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <span class="small fw-bold text-secondary text-uppercase" style="font-size: 0.7rem;">Total Lodged</span>
                <div class="stat-icon bg-primary-subtle text-primary" style="width: 32px; height: 32px; font-size: 1rem;">
                    <i class="bi bi-receipt"></i>
                </div>
            </div>
            <div class="fs-3 fw-bold text-dark lh-1">${stats['TOTAL'] != null ? stats['TOTAL'] : 0}</div>
            <div class="small text-muted mt-2">Recorded</div>
        </div>
    </div>

    <!-- Submitted / New -->
    <div class="col-sm-6 col-xl-2">
        <div class="stat-card">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <span class="small fw-bold text-secondary text-uppercase" style="font-size: 0.7rem;">Submitted</span>
                <div class="stat-icon bg-primary-subtle text-primary" style="width: 32px; height: 32px; font-size: 1rem;">
                    <i class="bi bi-envelope"></i>
                </div>
            </div>
            <div class="fs-3 fw-bold text-primary lh-1">${stats['SUBMITTED'] != null ? stats['SUBMITTED'] : 0}</div>
            <div class="small text-muted mt-2">Needs triage</div>
        </div>
    </div>

    <!-- Under Review -->
    <div class="col-sm-6 col-xl-2">
        <div class="stat-card">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <span class="small fw-bold text-secondary text-uppercase" style="font-size: 0.7rem;">Under Review</span>
                <div class="stat-icon bg-warning-subtle text-warning" style="width: 32px; height: 32px; font-size: 1rem;">
                    <i class="bi bi-search"></i>
                </div>
            </div>
            <div class="fs-3 fw-bold text-warning lh-1">${stats['UNDER_REVIEW'] != null ? stats['UNDER_REVIEW'] : 0}</div>
            <div class="small text-muted mt-2">Being assessed</div>
        </div>
    </div>

    <!-- In Progress -->
    <div class="col-sm-6 col-xl-2">
        <div class="stat-card">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <span class="small fw-bold text-secondary text-uppercase" style="font-size: 0.7rem;">In Progress</span>
                <div class="stat-icon bg-info-subtle text-info" style="width: 32px; height: 32px; font-size: 1rem;">
                    <i class="bi bi-gear-wide-connected"></i>
                </div>
            </div>
            <div class="fs-3 fw-bold text-info lh-1">${stats['IN_PROGRESS'] != null ? stats['IN_PROGRESS'] : 0}</div>
            <div class="small text-muted mt-2">Under action</div>
        </div>
    </div>

    <!-- Resolved -->
    <div class="col-sm-6 col-xl-2">
        <div class="stat-card">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <span class="small fw-bold text-secondary text-uppercase" style="font-size: 0.7rem;">Resolved</span>
                <div class="stat-icon bg-success-subtle text-success" style="width: 32px; height: 32px; font-size: 1rem;">
                    <i class="bi bi-check-circle"></i>
                </div>
            </div>
            <div class="fs-3 fw-bold text-success lh-1">${stats['RESOLVED'] != null ? stats['RESOLVED'] : 0}</div>
            <div class="small text-muted mt-2">Redressed</div>
        </div>
    </div>

    <!-- Rejected / Closed -->
    <div class="col-sm-6 col-xl-2">
        <div class="stat-card">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <span class="small fw-bold text-secondary text-uppercase" style="font-size: 0.7rem;">Rejected / Closed</span>
                <div class="stat-icon bg-secondary-subtle text-secondary" style="width: 32px; height: 32px; font-size: 1rem;">
                    <i class="bi bi-slash-circle"></i>
                </div>
            </div>
            <div class="fs-3 fw-bold text-secondary lh-1">
                ${(stats['REJECTED'] != null ? stats['REJECTED'] : 0) + (stats['CLOSED'] != null ? stats['CLOSED'] : 0)}
            </div>
            <div class="small text-muted mt-2">Dismissed / Closed</div>
        </div>
    </div>
</div>

<!-- Recent Queue Preview Table -->
<div class="card card-institutional border-0 shadow-sm p-4">
    <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
        <div>
            <h5 class="fw-bold text-dark mb-0">Active Grievance Queue</h5>
            <div class="small text-muted">Latest submissions requiring administrative triage or updates</div>
        </div>
        <a href="${pageContext.request.contextPath}/admin/complaints" class="btn btn-sm btn-outline-primary">
            View All Grievances <i class="bi bi-arrow-right ms-1"></i>
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty recentComplaints}">
            <div class="table-responsive">
                <table class="table table-institutional align-middle">
                    <thead>
                        <tr>
                            <th>Reference ID</th>
                            <th>Complainant</th>
                            <th>Category</th>
                            <th>Subject</th>
                            <th>Status</th>
                            <th>Date Lodged</th>
                            <th class="text-end">Manage</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${recentComplaints}">
                            <tr>
                                <td>
                                    <span class="badge-ref">${c.referenceId}</span>
                                </td>
                                <td>
                                    <div class="fw-semibold text-dark">${not empty c.userFullName ? c.userFullName : 'Student'}</div>
                                    <div class="small text-muted">${c.userEmail}</div>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border">${c.category}</span>
                                </td>
                                <td>
                                    <div class="fw-semibold text-dark">${c.subject}</div>
                                </td>
                                <td>
                                    <span class="badge-status badge-${c.status}">
                                        <i class="bi bi-circle-fill" style="font-size: 6px;"></i> ${c.statusEnum.displayName}
                                    </span>
                                </td>
                                <td class="small text-muted">
                                    <fmt:formatDate value="${c.createdAt}" pattern="dd MMM yyyy, hh:mm a"/>
                                </td>
                                <td class="text-end">
                                    <a href="${pageContext.request.contextPath}/admin/complaints/view?id=${c.idString}" 
                                       class="btn btn-sm btn-institutional-primary">
                                        Review <i class="bi bi-arrow-up-right ms-1"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5 text-muted">
                <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                No complaints recorded in the system yet.
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
