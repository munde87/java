<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Admin Review - ${complaint.referenceId}" scope="request"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp?nav=complaints"/>

<div class="row g-4">
    <!-- Complaint Information & Status Update Form -->
    <div class="col-lg-7">
        <!-- Complaint Record Card -->
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

            <!-- Complainant Identity Block -->
            <div class="p-3 bg-light rounded-3 border mb-3">
                <div class="row g-2 small">
                    <div class="col-sm-6">
                        <span class="text-secondary fw-semibold">Complainant:</span> 
                        <strong class="text-dark">${complaint.userFullName}</strong>
                    </div>
                    <div class="col-sm-6">
                        <span class="text-secondary fw-semibold">Contact Email:</span> 
                        <span class="text-dark">${complaint.userEmail}</span>
                    </div>
                    <div class="col-sm-6">
                        <span class="text-secondary fw-semibold">Date Lodged:</span> 
                        <fmt:formatDate value="${complaint.createdAt}" pattern="dd MMM yyyy, hh:mm a"/>
                    </div>
                    <div class="col-sm-6">
                        <span class="text-secondary fw-semibold">Last Modified:</span> 
                        <fmt:formatDate value="${complaint.updatedAt}" pattern="dd MMM yyyy, hh:mm a"/>
                    </div>
                </div>
            </div>

            <h4 class="fw-bold text-dark mb-2">${complaint.subject}</h4>

            <div class="mb-4">
                <label class="small fw-bold text-secondary text-uppercase tracking-wider d-block mb-1">Detailed Description</label>
                <div class="p-3 bg-light rounded-3 text-secondary lh-base" style="white-space: pre-wrap;">${complaint.description}</div>
            </div>

            <c:if test="${not empty complaint.adminRemark}">
                <div class="p-3 bg-warning-subtle border border-warning rounded-3 mb-2">
                    <div class="small fw-bold text-warning-emphasis mb-1">
                        <i class="bi bi-chat-dots-fill me-1"></i> Current Official Remark:
                    </div>
                    <div class="text-dark small">${complaint.adminRemark}</div>
                </div>
            </c:if>
        </div>

        <!-- Administrative Action Box: Update Status & Add Remarks -->
        <div class="card card-institutional border-0 shadow-sm p-4 mb-4 border-top border-4 border-primary">
            <h5 class="fw-bold text-dark mb-3 d-flex align-items-center gap-2">
                <i class="bi bi-sliders text-primary"></i> Administrative Decision & Status Transition
            </h5>
            <p class="text-muted small mb-3">
                Changing status permanently appends an entry to the audit log with your admin identity and timestamp.
            </p>

            <form action="${pageContext.request.contextPath}/admin/complaints/status" method="post" novalidate>
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <input type="hidden" name="complaintId" value="${complaint.idString}">

                <div class="mb-3">
                    <label for="newStatus" class="form-label fw-semibold small text-secondary">
                        Assign New Status <span class="text-danger">*</span>
                    </label>
                    <select class="form-select py-2" id="newStatus" name="newStatus" required>
                        <c:forEach var="st" items="${allStatuses}">
                            <option value="${st.name()}" ${complaint.status == st.name() ? 'selected' : ''}>
                                ${st.displayName} — ${st.description}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-4">
                    <label for="remark" class="form-label fw-semibold small text-secondary">
                        Action Notes / Administrator Remark <span class="text-danger">*</span>
                    </label>
                    <textarea class="form-control" id="remark" name="remark" rows="3" 
                              placeholder="Explain steps taken, department contacted, schedule for fix, or reason for closure/rejection..." required></textarea>
                    <div class="form-text small text-muted">This remark will be visible to the complainant upon tracking.</div>
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <a href="${pageContext.request.contextPath}/admin/complaints" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Back to Queue
                    </a>
                    <button type="submit" class="btn btn-institutional-primary px-4 py-2 shadow-sm">
                        <i class="bi bi-check2-all me-1"></i> Commit Status Update
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Right Column: Audit Trail Timeline -->
    <div class="col-lg-5">
        <div class="card card-institutional border-0 shadow-sm p-4">
            <h5 class="fw-bold text-dark mb-3 d-flex align-items-center gap-2 pb-2 border-bottom">
                <i class="bi bi-shield-check text-primary"></i> Tamper-Evident Audit Trail
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
                                Action by: <strong>${not empty u.changedByName ? u.changedByName : 'Officer'}</strong>
                                <c:if test="${not empty u.previousStatus}">
                                    (Transition: ${u.previousStatus} &rarr; ${u.newStatus})
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
