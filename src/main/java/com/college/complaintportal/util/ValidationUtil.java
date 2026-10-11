package com.college.complaintportal.util;

import java.util.regex.Pattern;

/**
 * Validation and sanitization utility for inputs.
 */
public final class ValidationUtil {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );

    private ValidationUtil() {
    }

    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        String trimmed = email.trim();
        return !trimmed.isEmpty() && EMAIL_PATTERN.matcher(trimmed).matches();
    }

    public static boolean isValidPassword(String password) {
        if (password == null) return false;
        return password.trim().length() >= 6;
    }

    public static String sanitize(String input) {
        if (input == null) return "";
        return input.trim();
    }

    public static boolean isNotEmpty(String input) {
        return input != null && !input.trim().isEmpty();
    }
}
