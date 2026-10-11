package com.college.complaintportal.servlet;

import com.college.complaintportal.model.Complaint;
import com.college.complaintportal.model.User;
import com.college.complaintportal.service.ComplaintService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Controller rendering student/complainant personalized dashboard with grievance statistics.
 */
@WebServlet(name = "UserDashboardServlet", urlPatterns = {"/dashboard"})
public class UserDashboardServlet extends HttpServlet {

    private ComplaintService complaintService;

    @Override
    public void init() {
        this.complaintService = new ComplaintService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        // If admin accidentally visits /dashboard, forward them to admin dashboard
        if (loggedUser.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        Map<String, Long> stats = complaintService.getUserStatistics(loggedUser.getId());
        List<Complaint> myComplaints = complaintService.getUserComplaints(loggedUser.getId());

        req.setAttribute("stats", stats);
        req.setAttribute("complaints", myComplaints);
        req.getRequestDispatcher("/WEB-INF/views/user/dashboard.jsp").forward(req, resp);
    }
}
