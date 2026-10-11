<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Grievance ${complaint.referenceId}" scope="request"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="row g-4">
    <!-- Complaint Information Main Card -->
    <div class="col-lg-7">
        <div class="card card-institutional border-0 shadow-sm p-4 mb-4">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 pb-3 border-bottom gap-2">
                <div>
                    <span class="badge-ref fs-6">${complaint.referenceId}</span>
                    <span class="badge bg-light text-dark border ms-2">${complaint.category}</span>
                </div>
                <div>
                    <span class="badge-status badge-${complaint.status} fs-6">
                        <i class="bi bi-circle-fill" style="font-size: 8px;"></i> ${complaint.statusEnum.displayName}
                    </span>
                </div>
            </div>

            <h4 class="fw-bold text-dark mb-3">${complaint.subject}</h4>

            <div class="mb-4">
                <label class="small fw-bold text-secondary text-uppercase tracking-wider d-block mb-1">Grievance Description</label>
                <div class="p-3 bg-light rounded-3 text-secondary lh-base" style="white-space: pre-wrap;">${complaint.description}</div>
            </div>

            <div class="row g-3 small text-muted pt-2 border-top">
                <div class="col-sm-6">
                    <strong>Lodged On:</strong> 
                    <fmt:formatDate value="${complaint.createdAt}" pattern="dd MMMM yyyy, hh:mm a"/>
                </div>
                <div class="col-sm-6">
                    <strong>Last Updated:</strong> 
                    <fmt:formatDate value="${complaint.updatedAt}" pattern="dd MMMM yyyy, hh:mm a"/>
                </div>
            </div>
        </div>

        <!-- Latest Administrative Remarks (If any) -->
        <c:if test="${not empty complaint.adminRemark}">
            <div class="card card-institutional border-0 shadow-sm p-4 mb-4 border-start border-4 border-primary">
                <div class="d-flex align-items-center gap-2 mb-2">
                    <i class="bi bi-chat-left-quote-fill text-primary fs-5"></i>
                    <h6 class="fw-bold text-dark mb-0">Official Administrative Remark</h6>
                </div>
                <p class="text-secondary mb-0 bg-light p-3 rounded-2 fst-italic">
                    "${complaint.adminRemark}"
                </p>
            </div>
        </c:if>

        <a href="${pageContext.request.contextPath}/complaints" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i> Back to My Grievances
        </a>
    </div>

    <!-- Right Side: Tracking Audit Timeline -->
    <div class="col-lg-5">
        <div class="card card-institutional border-0 shadow-sm p-4">
            <h5 class="fw-bold text-dark mb-3 d-flex align-items-center gap-2 pb-2 border-bottom">
                <i class="bi bi-clock-history text-primary"></i> Lifecycle Audit Timeline
            </h5>

            <div class="timeline-track mt-3">
                <c:forEach var="u" items="${history}">
                    <div class="timeline-item">
                        <div class="timeline-node ${u.newStatus == 'RESOLVED' ? 'node-resolved' : (u.newStatus == 'REJECTED' ? 'node-rejected' : '')}"></div>
                        <div class="timeline-content shadow-none">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="badge-status badge-${u.newStatus}">
                                    ${u.newStatusEnum.displayName}
                                </span>
                                <span class="small text-muted" style="font-size: 0.75rem;">
                                    <fmt:formatDate value="${u.changedAt}" pattern="dd MMM, hh:mm a"/>
                                </span>
                            </div>
                            <div class="small text-secondary mt-2">
                                ${u.remark}
                            </div>
                            <div class="small text-muted mt-1 fst-italic" style="font-size: 0.75rem;">
                                Logged by: <strong>${not empty u.changedByName ? u.changedByName : 'System Officer'}</strong>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
