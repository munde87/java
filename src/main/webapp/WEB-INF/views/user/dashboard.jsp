<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="User Dashboard" scope="request"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp?nav=dashboard"/>

<!-- Student/Complainant Hero Card -->
<div class="card card-institutional border-0 bg-primary-subtle p-4 mb-4 position-relative overflow-hidden">
    <div class="row align-items-center">
        <div class="col-md-8">
            <div class="d-inline-flex align-items-center gap-2 mb-2">
                <span class="badge bg-success rounded-pill p-1"><i class="bi bi-circle-fill" style="font-size: 6px;"></i></span>
                <span class="small fw-bold text-uppercase tracking-wider text-secondary">Active Student Session</span>
            </div>
            <h2 class="fw-bold text-dark mb-1">${currentUser.fullName}</h2>
            <div class="text-secondary small mb-2">
                <i class="bi bi-envelope me-1"></i> ${currentUser.email} &bull; 
                <span class="badge bg-light text-primary border ms-1">Role: ${currentUser.role}</span>
            </div>
        </div>
        <div class="col-md-4 text-md-end mt-3 mt-md-0">
            <a href="${pageContext.request.contextPath}/complaints/new" class="btn btn-institutional-primary shadow-sm">
                <i class="bi bi-plus-circle me-1"></i> Lodge New Grievance
            </a>
        </div>
    </div>
</div>

<!-- Metrics Counters -->
<div class="row g-3 mb-4">
    <div class="col-sm-6 col-lg-4">
        <div class="stat-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <span class="small fw-bold text-secondary text-uppercase tracking-wider">Total Grievances</span>
                <div class="stat-icon bg-primary-subtle text-primary">
                    <i class="bi bi-receipt"></i>
                </div>
            </div>
            <div class="d-flex align-items-baseline justify-content-between">
                <span class="fs-2 fw-bold text-dark lh-1">${stats['TOTAL'] != null ? stats['TOTAL'] : 0}</span>
                <span class="badge bg-light text-primary border">All Time</span>
            </div>
        </div>
    </div>

    <div class="col-sm-6 col-lg-4">
        <div class="stat-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <span class="small fw-bold text-secondary text-uppercase tracking-wider">In Progress & Review</span>
                <div class="stat-icon bg-warning-subtle text-warning">
                    <i class="bi bi-hourglass-split"></i>
                </div>
            </div>
            <div class="d-flex align-items-baseline justify-content-between">
                <span class="fs-2 fw-bold text-dark lh-1">${stats['ACTIVE'] != null ? stats['ACTIVE'] : 0}</span>
                <span class="badge bg-warning-subtle text-warning-emphasis border border-warning">Active Queue</span>
            </div>
        </div>
    </div>

    <div class="col-sm-6 col-lg-4">
        <div class="stat-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <span class="small fw-bold text-secondary text-uppercase tracking-wider">Resolved Grievances</span>
                <div class="stat-icon bg-success-subtle text-success">
                    <i class="bi bi-check2-circle"></i>
                </div>
            </div>
            <div class="d-flex align-items-baseline justify-content-between">
                <span class="fs-2 fw-bold text-dark lh-1">${stats['RESOLVED'] != null ? stats['RESOLVED'] : 0}</span>
                <span class="badge bg-success-subtle text-success border border-success">Completed</span>
            </div>
        </div>
    </div>
</div>

<!-- Fast Track Action Banner -->
<div class="banner-fasttrack mb-4 shadow-sm">
    <div class="row align-items-center position-relative z-1">
        <div class="col-lg-8">
            <div class="d-flex align-items-center gap-2 mb-2">
                <i class="bi bi-lightning-charge-fill text-warning"></i>
                <span class="small text-uppercase fw-bold text-warning tracking-wider">Zero Friction Filing</span>
            </div>
            <h4 class="fw-bold mb-2">Need Help or Facing Campus Infrastructure Issues?</h4>
            <p class="mb-0 text-white-50">
                Submit an official ticket directly to the concerned department nodal officer. You will immediately receive a tracking reference code.
            </p>
        </div>
        <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
            <a href="${pageContext.request.contextPath}/complaints/new" class="btn btn-light text-primary fw-bold px-4 py-2 shadow-sm">
                <i class="bi bi-pencil-square me-1"></i> File Grievance Now
            </a>
        </div>
    </div>
</div>

<!-- Recent Personal Complaints -->
<div class="card card-institutional border-0 shadow-sm p-4">
    <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
        <div>
            <h5 class="fw-bold text-dark mb-0">My Grievances</h5>
            <div class="small text-muted">Recent tickets submitted from your profile</div>
        </div>
        <a href="${pageContext.request.contextPath}/complaints" class="btn btn-sm btn-outline-primary">
            View All (${stats['TOTAL']}) <i class="bi bi-arrow-right ms-1"></i>
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty complaints}">
            <div class="table-responsive">
                <table class="table table-institutional align-middle">
                    <thead>
                        <tr>
                            <th>Reference ID</th>
                            <th>Category</th>
                            <th>Subject</th>
                            <th>Status</th>
                            <th>Lodge Date</th>
                            <th class="text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${complaints}" begin="0" end="4">
                            <tr>
                                <td>
                                    <span class="badge-ref">${c.referenceId}</span>
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
                                    <a href="${pageContext.request.contextPath}/complaints/view?id=${c.idString}" 
                                       class="btn btn-sm btn-outline-primary">
                                        Track <i class="bi bi-box-arrow-up-right ms-1"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5">
                <div class="stat-icon bg-light text-secondary mx-auto mb-3" style="width: 56px; height: 56px; font-size: 1.75rem;">
                    <i class="bi bi-inbox"></i>
                </div>
                <h6 class="fw-bold text-dark">No Grievances Recorded Yet</h6>
                <p class="text-muted small mb-3">You have not submitted any complaints yet. If you have an issue, file your first grievance now.</p>
                <a href="${pageContext.request.contextPath}/complaints/new" class="btn btn-institutional-primary btn-sm">
                    <i class="bi bi-plus-circle me-1"></i> Lodge Complaint
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
