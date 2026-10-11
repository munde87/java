package com.college.complaintportal.servlet;

import com.college.complaintportal.model.User;
import com.college.complaintportal.service.AuthService;
import com.college.complaintportal.util.CsrfUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller handling user and administrator login authentication.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() {
        this.authService = new AuthService();
        // Provision default admin account on startup if absent
        authService.provisionDefaultAdminIfNoneExists();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            User user = (User) session.getAttribute("loggedUser");
            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }
            return;
        }

        String errorParam = req.getParameter("error");
        if ("auth_required".equals(errorParam)) {
            req.setAttribute("errorMessage", "Please log in to access this page.");
        } else if ("admin_required".equals(errorParam)) {
            req.setAttribute("errorMessage", "Administrator privileges required. Please sign in as an admin.");
        }

        String logoutParam = req.getParameter("logout");
        if ("1".equals(logoutParam)) {
            req.setAttribute("successMessage", "You have been logged out successfully.");
        }

        String regParam = req.getParameter("registered");
        if ("1".equals(regParam)) {
            req.setAttribute("successMessage", "Registration complete! You may now sign in.");
        }

        // Initialize CSRF token
        CsrfUtil.getToken(req);
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String csrfToken = req.getParameter("csrfToken");
        if (!CsrfUtil.isValidToken(req, csrfToken)) {
            req.setAttribute("errorMessage", "Security session expired. Please refresh and try again.");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            User user = authService.login(email, password);

            // Regenerate session to protect against session fixation attacks
            HttpSession oldSession = req.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("loggedUser", user);

            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }
        } catch (IllegalArgumentException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Authentication failed: " + e.getMessage());
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
        }
    }
}
