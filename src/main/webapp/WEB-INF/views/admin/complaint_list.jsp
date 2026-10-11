<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Manage Complaints Queue" scope="request"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp?nav=complaints"/>

<div class="card card-institutional border-0 shadow-sm p-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom gap-3">
        <div>
            <h4 class="fw-bold text-dark mb-1">Grievance Central Queue</h4>
            <p class="text-muted small mb-0">Search, filter, and inspect complaints across all departments</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-speedometer2 me-1"></i> Dashboard
            </a>
        </div>
    </div>

    <!-- Filter & Search Bar -->
    <form action="${pageContext.request.contextPath}/admin/complaints" method="get" class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="input-group">
                <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-search"></i></span>
                <input type="text" class="form-control border-start-0" name="q" value="${searchQuery}" 
                       placeholder="Search by ID, keyword, or subject...">
            </div>
        </div>

        <div class="col-md-3">
            <select name="status" class="form-select">
                <option value="ALL" ${currentStatus == 'ALL' ? 'selected' : ''}>-- All Statuses --</option>
                <c:forEach var="st" items="${allStatuses}">
                    <option value="${st.name()}" ${currentStatus == st.name() ? 'selected' : ''}>
                        ${st.displayName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <select name="category" class="form-select">
                <option value="ALL" ${currentCategory == 'ALL' ? 'selected' : ''}>-- All Categories --</option>
                <option value="Academic & Examination" ${currentCategory == 'Academic & Examination' ? 'selected' : ''}>Academic & Examination</option>
                <option value="Hostel & Campus Infrastructure" ${currentCategory == 'Hostel & Campus Infrastructure' ? 'selected' : ''}>Hostel & Campus Infrastructure</option>
                <option value="IT Services & WiFi Network" ${currentCategory == 'IT Services & WiFi Network' ? 'selected' : ''}>IT Services & WiFi</option>
                <option value="Accounts & Scholarship" ${currentCategory == 'Accounts & Scholarship' ? 'selected' : ''}>Accounts & Scholarship</option>
                <option value="Transport & Facilities" ${currentCategory == 'Transport & Facilities' ? 'selected' : ''}>Transport & Facilities</option>
                <option value="Library & Learning Resources" ${currentCategory == 'Library & Learning Resources' ? 'selected' : ''}>Library Resources</option>
                <option value="General Administration" ${currentCategory == 'General Administration' ? 'selected' : ''}>General Administration</option>
            </select>
        </div>

        <div class="col-md-2 d-flex gap-2">
            <button type="submit" class="btn btn-institutional-primary w-100">
                <i class="bi bi-funnel-fill me-1"></i> Filter
            </button>
            <a href="${pageContext.request.contextPath}/admin/complaints" class="btn btn-outline-secondary" title="Reset Filters">
                <i class="bi bi-arrow-counterclockwise"></i>
            </a>
        </div>
    </form>

    <c:choose>
        <c:when test="${not empty complaints}">
            <div class="table-responsive">
                <table class="table table-institutional align-middle">
                    <thead>
                        <tr>
                            <th>Reference ID</th>
                            <th>Complainant Details</th>
                            <th>Category</th>
                            <th>Subject</th>
                            <th>Current Status</th>
                            <th>Date Lodged</th>
                            <th class="text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${complaints}">
                            <tr>
                                <td>
                                    <span class="badge-ref">${c.referenceId}</span>
                                </td>
                                <td>
                                    <div class="fw-semibold text-dark">${not empty c.userFullName ? c.userFullName : 'User'}</div>
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
                                        Review & Update <i class="bi bi-arrow-right ms-1"></i>
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
                    <i class="bi bi-search"></i>
                </div>
                <h6 class="fw-bold text-dark">No Grievances Match Criteria</h6>
                <p class="text-muted small mb-3">No complaint records match your current filter or query parameters.</p>
                <a href="${pageContext.request.contextPath}/admin/complaints" class="btn btn-outline-secondary btn-sm">
                    Reset Filters
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
