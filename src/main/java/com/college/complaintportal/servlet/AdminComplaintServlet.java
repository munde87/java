package com.college.complaintportal.servlet;

import com.college.complaintportal.model.Complaint;
import com.college.complaintportal.model.ComplaintStatus;
import com.college.complaintportal.model.ComplaintUpdate;
import com.college.complaintportal.model.User;
import com.college.complaintportal.service.ComplaintService;
import com.college.complaintportal.util.CsrfUtil;
import org.bson.types.ObjectId;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller handling administrator grievance operations:
 * - Viewing all complaints with search and filtering
 * - Inspecting full complaint details
 * - Updating complaint status with remarks and audit history
 */
@WebServlet(name = "AdminComplaintServlet", urlPatterns = {
        "/admin/complaints",
        "/admin/complaints/view",
        "/admin/complaints/status"
})
public class AdminComplaintServlet extends HttpServlet {

    private ComplaintService complaintService;

    @Override
    public void init() {
        this.complaintService = new ComplaintService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/admin/complaints/view".equals(path)) {
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/complaints");
                return;
            }

            try {
                ObjectId id = new ObjectId(idStr.trim());
                Complaint complaint = complaintService.getComplaintById(id);
                if (complaint == null) {
                    req.setAttribute("errorMessage", "Complaint not found.");
                    req.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(req, resp);
                    return;
                }

                List<ComplaintUpdate> history = complaintService.getComplaintHistory(id);
                req.setAttribute("complaint", complaint);
                req.setAttribute("history", history);
                req.setAttribute("allStatuses", ComplaintStatus.values());

                // CSRF Token for status update form
                CsrfUtil.getToken(req);
                req.getRequestDispatcher("/WEB-INF/views/admin/complaint_detail.jsp").forward(req, resp);
            } catch (IllegalArgumentException e) {
                req.setAttribute("errorMessage", "Invalid Complaint ID format.");
                req.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(req, resp);
            }
            return;
        }

        // Default: /admin/complaints list with search and filter
        String status = req.getParameter("status");
        String category = req.getParameter("category");
        String search = req.getParameter("q");

        List<Complaint> complaints = complaintService.getAllComplaints(status, category, search, 100, 0);

        req.setAttribute("complaints", complaints);
        req.setAttribute("currentStatus", status != null ? status : "ALL");
        req.setAttribute("currentCategory", category != null ? category : "ALL");
        req.setAttribute("searchQuery", search != null ? search : "");
        req.setAttribute("allStatuses", ComplaintStatus.values());

        req.getRequestDispatcher("/WEB-INF/views/admin/complaint_list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/admin/complaints/status".equals(path)) {
            String csrfToken = req.getParameter("csrfToken");
            if (!CsrfUtil.isValidToken(req, csrfToken)) {
                req.getSession().setAttribute("flashError", "Security session expired. Please try again.");
                resp.sendRedirect(req.getContextPath() + "/admin/complaints");
                return;
            }

            String idStr = req.getParameter("complaintId");
            String newStatus = req.getParameter("newStatus");
            String remark = req.getParameter("remark");

            HttpSession session = req.getSession(false);
            User admin = (User) session.getAttribute("loggedUser");

            try {
                ObjectId complaintId = new ObjectId(idStr.trim());
                complaintService.updateComplaintStatus(complaintId, newStatus, remark, admin);
                session.setAttribute("flashSuccess", "Complaint status successfully updated to " + newStatus + ".");
                resp.sendRedirect(req.getContextPath() + "/admin/complaints/view?id=" + idStr);
            } catch (Exception e) {
                session.setAttribute("flashError", "Failed to update complaint status: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/admin/complaints/view?id=" + idStr);
            }
        }
    }
}
