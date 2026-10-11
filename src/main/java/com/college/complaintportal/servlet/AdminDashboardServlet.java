package com.college.complaintportal.servlet;

import com.college.complaintportal.model.Complaint;
import com.college.complaintportal.service.ComplaintService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Controller rendering the administrative monitoring dashboard with platform-wide grievance metrics.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private ComplaintService complaintService;

    @Override
    public void init() {
        this.complaintService = new ComplaintService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Long> stats = complaintService.getDashboardStatistics();
        List<Complaint> recentComplaints = complaintService.getAllComplaints(null, null, null, 10, 0);

        req.setAttribute("stats", stats);
        req.setAttribute("recentComplaints", recentComplaints);
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}
