package com.college.complaintportal.model;

/**
 * Standard lifecycle statuses for complaints.
 */
public enum ComplaintStatus {
    SUBMITTED("Submitted", "primary", "The grievance has been submitted and awaits review."),
    UNDER_REVIEW("Under Review", "warning", "The grievance is actively being reviewed by an officer."),
    IN_PROGRESS("In Progress", "info", "Investigation and resolution actions are currently underway."),
    RESOLVED("Resolved", "success", "The issue has been resolved. Please review the officer remarks."),
    REJECTED("Rejected", "danger", "The grievance could not be processed. Reason provided in remarks."),
    CLOSED("Closed", "secondary", "The grievance record is officially closed.");

    private final String displayName;
    private final String badgeColor;
    private final String description;

    ComplaintStatus(String displayName, String badgeColor, String description) {
        this.displayName = displayName;
        this.badgeColor = badgeColor;
        this.description = description;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getBadgeColor() {
        return badgeColor;
    }

    public String getDescription() {
        return description;
    }

    public static ComplaintStatus fromString(String text) {
        if (text == null) {
            return null;
        }
        for (ComplaintStatus s : ComplaintStatus.values()) {
            if (s.name().equalsIgnoreCase(text.trim())) {
                return s;
            }
        }
        return null;
    }
}
