package com.college.complaintportal.filter;

import com.college.complaintportal.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filter enforcing strict server-side role-based authorization for admin endpoints.
 */
@WebFilter(filterName = "AdminFilter", urlPatterns = {
        "/admin",
        "/admin/*"
})
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User loggedUser = session != null ? (User) session.getAttribute("loggedUser") : null;

        String contextPath = req.getContextPath();

        if (loggedUser == null) {
            resp.sendRedirect(contextPath + "/login?error=admin_required");
            return;
        }

        if (!loggedUser.isAdmin()) {
            resp.sendRedirect(contextPath + "/unauthorized");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
