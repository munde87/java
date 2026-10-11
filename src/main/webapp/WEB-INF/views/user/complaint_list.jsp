<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="My Grievances" scope="request"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp?nav=my"/>

<div class="card card-institutional border-0 shadow-sm p-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom gap-3">
        <div>
            <h4 class="fw-bold text-dark mb-1">My Submitted Grievances</h4>
            <p class="text-muted small mb-0">Complete record of your complaints and their real-time lifecycle states</p>
        </div>
        <a href="${pageContext.request.contextPath}/complaints/new" class="btn btn-institutional-primary btn-sm">
            <i class="bi bi-plus-circle me-1"></i> Lodge New Grievance
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
                            <th>Current Status</th>
                            <th>Admin Remarks</th>
                            <th>Submitted At</th>
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
                                <td class="small text-secondary">
                                    <c:choose>
                                        <c:when test="${not empty c.adminRemark}">
                                            <span class="text-truncate d-inline-block" style="max-width: 180px;" title="${c.adminRemark}">
                                                ${c.adminRemark}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted fst-italic">Pending review</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="small text-muted">
                                    <fmt:formatDate value="${c.createdAt}" pattern="dd MMM yyyy, hh:mm a"/>
                                </td>
                                <td class="text-end">
                                    <a href="${pageContext.request.contextPath}/complaints/view?id=${c.idString}" 
                                       class="btn btn-sm btn-outline-primary">
                                        View Details <i class="bi bi-chevron-right ms-1"></i>
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
                <h6 class="fw-bold text-dark">No Grievances Found</h6>
                <p class="text-muted small mb-3">You have not submitted any grievances yet.</p>
                <a href="${pageContext.request.contextPath}/complaints/new" class="btn btn-institutional-primary btn-sm">
                    <i class="bi bi-plus-circle me-1"></i> Lodge Grievance
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
