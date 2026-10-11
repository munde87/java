package com.college.complaintportal.servlet;

import com.college.complaintportal.model.Complaint;
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
 * Controller handling user complaints: listing personal complaints, submitting new complaints,
 * and viewing complaint details & timeline.
 */
@WebServlet(name = "ComplaintServlet", urlPatterns = {
        "/complaints",
        "/complaints/new",
        "/complaints/view"
})
public class ComplaintServlet extends HttpServlet {

    private ComplaintService complaintService;

    @Override
    public void init() {
        this.complaintService = new ComplaintService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        if ("/complaints/new".equals(path)) {
            // Render lodge complaint form
            CsrfUtil.getToken(req);
            req.getRequestDispatcher("/WEB-INF/views/user/complaint_form.jsp").forward(req, resp);
            return;
        }

        if ("/complaints/view".equals(path)) {
            String idStr = req.getParameter("id");
            String refStr = req.getParameter("ref");

            Complaint complaint = null;
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    complaint = complaintService.getComplaintById(new ObjectId(idStr.trim()));
                } catch (IllegalArgumentException e) {
                    // Invalid ObjectId format
                }
            } else if (refStr != null && !refStr.trim().isEmpty()) {
                complaint = complaintService.getComplaintByReferenceId(refStr.trim());
            }

            if (complaint == null) {
                req.setAttribute("errorMessage", "Complaint ticket not found.");
                req.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(req, resp);
                return;
            }

            // CRITICAL SECURITY CHECK:
            // Ensure complainant can only access complaints that belong to their account!
            if (!loggedUser.isAdmin() && !loggedUser.getId().equals(complaint.getUserId())) {
                req.setAttribute("errorMessage", "Access Denied: You do not have permission to view this complaint.");
                req.getRequestDispatcher("/WEB-INF/views/error/403.jsp").forward(req, resp);
                return;
            }

            List<ComplaintUpdate> history = complaintService.getComplaintHistory(complaint.getId());
            req.setAttribute("complaint", complaint);
            req.setAttribute("history", history);
            req.getRequestDispatcher("/WEB-INF/views/user/complaint_detail.jsp").forward(req, resp);
            return;
        }

        // Default: /complaints (My Complaints List)
        List<Complaint> myComplaints = complaintService.getUserComplaints(loggedUser.getId());
        req.setAttribute("complaints", myComplaints);
        req.getRequestDispatcher("/WEB-INF/views/user/complaint_list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        String csrfToken = req.getParameter("csrfToken");
        if (!CsrfUtil.isValidToken(req, csrfToken)) {
            req.setAttribute("errorMessage", "Security validation failed. Please submit the form again.");
            req.getRequestDispatcher("/WEB-INF/views/user/complaint_form.jsp").forward(req, resp);
            return;
        }

        String category = req.getParameter("category");
        String subject = req.getParameter("subject");
        String description = req.getParameter("description");

        try {
            Complaint complaint = complaintService.submitComplaint(
                    loggedUser.getId(), category, subject, description
            );
            session.setAttribute("flashSuccess", "Complaint successfully lodged! Reference ID: " + complaint.getReferenceId());
            resp.sendRedirect(req.getContextPath() + "/complaints/view?id=" + complaint.getIdString());
        } catch (IllegalArgumentException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("category", category);
            req.setAttribute("subject", subject);
            req.setAttribute("description", description);
            req.getRequestDispatcher("/WEB-INF/views/user/complaint_form.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Failed to submit complaint: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/user/complaint_form.jsp").forward(req, resp);
        }
    }
}
