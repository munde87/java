<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Lodge New Grievance" scope="request"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp?nav=lodge"/>

<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="card card-institutional border-0 shadow-sm p-4 p-md-5">
            <div class="d-flex align-items-center justify-content-between mb-4 pb-3 border-bottom">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Lodge Official Grievance</h3>
                    <p class="text-muted small mb-0">Fill in the details below. An automated tracking reference ID will be assigned immediately.</p>
                </div>
                <div class="stat-icon bg-primary-subtle text-primary d-none d-sm-flex">
                    <i class="bi bi-pencil-square"></i>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/complaints" method="post" novalidate>
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">

                <div class="mb-4">
                    <label for="category" class="form-label fw-semibold small text-secondary">
                        Grievance Category <span class="text-danger">*</span>
                    </label>
                    <select class="form-select py-2" id="category" name="category" required>
                        <option value="" disabled ${empty category ? 'selected' : ''}>-- Select Concerned Department / Area --</option>
                        <option value="Academic & Examination" ${category == 'Academic & Examination' ? 'selected' : ''}>Academic & Examination Affairs</option>
                        <option value="Hostel & Campus Infrastructure" ${category == 'Hostel & Campus Infrastructure' ? 'selected' : ''}>Hostel & Campus Infrastructure</option>
                        <option value="IT Services & WiFi Network" ${category == 'IT Services & WiFi Network' ? 'selected' : ''}>IT Services & Campus Network / WiFi</option>
                        <option value="Accounts & Scholarship" ${category == 'Accounts & Scholarship' ? 'selected' : ''}>Accounts, Fee & Scholarships</option>
                        <option value="Transport & Facilities" ${category == 'Transport & Facilities' ? 'selected' : ''}>Transport & Campus Facilities</option>
                        <option value="Library & Learning Resources" ${category == 'Library & Learning Resources' ? 'selected' : ''}>Library & Learning Resources</option>
                        <option value="General Administration" ${category == 'General Administration' ? 'selected' : ''}>General Administration</option>
                    </select>
                </div>

                <div class="mb-4">
                    <label for="subject" class="form-label fw-semibold small text-secondary">
                        Subject / Brief Title <span class="text-danger">*</span>
                    </label>
                    <input type="text" class="form-control py-2" id="subject" name="subject" 
                           value="${subject}" placeholder="e.g. Broken AC unit in Lab 304 or Delay in Grade Card dispatch" required>
                    <div class="form-text small text-muted">A clear, concise summary of the issue.</div>
                </div>

                <div class="mb-4">
                    <label for="description" class="form-label fw-semibold small text-secondary">
                        Detailed Grievance Description <span class="text-danger">*</span>
                    </label>
                    <textarea class="form-control" id="description" name="description" rows="6" 
                              placeholder="Please provide full details, including dates, exact location, roll numbers, or prior communications..." required>${description}</textarea>
                    <div class="form-text small text-muted">Be factual and specific to assist administrative review and fast redressal.</div>
                </div>

                <div class="p-3 bg-light rounded-3 border mb-4">
                    <div class="d-flex align-items-center gap-2 text-secondary small">
                        <i class="bi bi-shield-check text-primary fs-5"></i>
                        <div>
                            <strong>Institutional Accountability:</strong> Submitting this grievance records an immutable timestamp. All status changes and officer remarks are audited.
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-institutional-primary px-4 py-2 shadow-sm">
                        <i class="bi bi-send-fill me-1"></i> Submit Grievance
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
