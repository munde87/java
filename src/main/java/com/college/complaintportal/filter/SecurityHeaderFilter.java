package com.college.complaintportal.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Production Security Filter adding protective HTTP headers to all responses.
 */
@WebFilter(filterName = "SecurityHeaderFilter", urlPatterns = {"/*"})
public class SecurityHeaderFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletResponse resp = (HttpServletResponse) response;

        // Protection against Clickjacking
        resp.setHeader("X-Frame-Options", "SAMEORIGIN");
        // Protection against MIME-sniffing
        resp.setHeader("X-Content-Type-Options", "nosniff");
        // Cross-Site Scripting (XSS) filter
        resp.setHeader("X-XSS-Protection", "1; mode=block");
        // Referrer policy
        resp.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
