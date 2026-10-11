package com.college.complaintportal.filter;

import com.college.complaintportal.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filter ensuring that requests to protected user routes are authenticated.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {
        "/dashboard",
        "/complaints",
        "/complaints/*"
})
public class AuthFilter implements Filter {

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

        if (loggedUser == null) {
            String contextPath = req.getContextPath();
            resp.sendRedirect(contextPath + "/login?error=auth_required");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
