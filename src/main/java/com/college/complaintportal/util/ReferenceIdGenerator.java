package com.college.complaintportal.util;

import java.security.SecureRandom;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * Generates human-readable, unique complaint reference numbers.
 * Format: CMP-YYYYMMDD-XXXX (e.g. CMP-20261011-8F2K)
 */
public final class ReferenceIdGenerator {

    private static final String ALPHANUMERIC = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ"; // excludes 0/O, 1/I to prevent ambiguity
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMdd");

    private ReferenceIdGenerator() {
    }

    public static String generate() {
        String dateStr = LocalDate.now().format(DATE_FORMATTER);
        StringBuilder suffix = new StringBuilder(4);
        for (int i = 0; i < 4; i++) {
            int index = RANDOM.nextInt(ALPHANUMERIC.length());
            suffix.append(ALPHANUMERIC.charAt(index));
        }
        return "CMP-" + dateStr + "-" + suffix.toString();
    }
}
