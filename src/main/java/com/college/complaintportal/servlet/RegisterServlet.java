package com.college.complaintportal.servlet;

import com.college.complaintportal.model.User;
import com.college.complaintportal.service.AuthService;
import com.college.complaintportal.util.CsrfUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Controller handling user registration requests.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() {
        this.authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // If already logged in, redirect to dashboard
        if (req.getSession(false) != null && req.getSession().getAttribute("loggedUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        // Generate CSRF token
        CsrfUtil.getToken(req);
        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String csrfToken = req.getParameter("csrfToken");
        if (!CsrfUtil.isValidToken(req, csrfToken)) {
            req.setAttribute("errorMessage", "Security validation failed (invalid CSRF token). Please try again.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        if (password != null && !password.equals(confirmPassword)) {
            req.setAttribute("errorMessage", "Passwords do not match.");
            req.setAttribute("fullName", fullName);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        try {
            User user = authService.register(fullName, email, password, User.ROLE_USER);
            req.getSession().setAttribute("flashSuccess", "Registration successful! You can now log in with your credentials.");
            resp.sendRedirect(req.getContextPath() + "/login?registered=1");
        } catch (IllegalArgumentException | IllegalStateException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("fullName", fullName);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("errorMessage", "An unexpected system error occurred: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
        }
    }
}
