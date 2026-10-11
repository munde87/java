package com.college.complaintportal.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Controller rendering 403 Forbidden / Unauthorized page.
 */
@WebServlet(name = "UnauthorizedServlet", urlPatterns = {"/unauthorized"})
public class UnauthorizedServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
        req.getRequestDispatcher("/WEB-INF/views/error/403.jsp").forward(req, resp);
    }
}
