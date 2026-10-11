package com.college.complaintportal.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility for generating and validating CSRF tokens across sessions.
 */
public final class CsrfUtil {

    private static final String CSRF_TOKEN_ATTR = "CSRF_TOKEN";
    private static final SecureRandom RANDOM = new SecureRandom();

    private CsrfUtil() {
    }

    public static String getToken(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        String token = (String) session.getAttribute(CSRF_TOKEN_ATTR);
        if (token == null) {
            byte[] bytes = new byte[24];
            RANDOM.nextBytes(bytes);
            token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
            session.setAttribute(CSRF_TOKEN_ATTR, token);
        }
        return token;
    }

    public static boolean isValidToken(HttpServletRequest request, String clientToken) {
        if (clientToken == null || clientToken.trim().isEmpty()) {
            return false;
        }
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        String sessionToken = (String) session.getAttribute(CSRF_TOKEN_ATTR);
        return sessionToken != null && sessionToken.equals(clientToken.trim());
    }
}
