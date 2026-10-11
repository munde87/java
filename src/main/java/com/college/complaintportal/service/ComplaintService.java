package com.college.complaintportal.service;

import com.college.complaintportal.dao.ComplaintDao;
import com.college.complaintportal.dao.ComplaintUpdateDao;
import com.college.complaintportal.dao.UserDao;
import com.college.complaintportal.model.Complaint;
import com.college.complaintportal.model.ComplaintStatus;
import com.college.complaintportal.model.ComplaintUpdate;
import com.college.complaintportal.model.User;
import com.college.complaintportal.util.ReferenceIdGenerator;
import com.college.complaintportal.util.ValidationUtil;
import org.bson.types.ObjectId;

import java.util.*;
import java.util.logging.Logger;

/**
 * Service managing complaint submissions, lifecycle status changes, and history tracking.
 */
public class ComplaintService {

    private static final Logger LOGGER = Logger.getLogger(ComplaintService.class.getName());

    private final ComplaintDao complaintDao;
    private final ComplaintUpdateDao updateDao;
    private final UserDao userDao;

    public ComplaintService() {
        this.complaintDao = new ComplaintDao();
        this.updateDao = new ComplaintUpdateDao();
        this.userDao = new UserDao();
    }

    public ComplaintService(ComplaintDao complaintDao, ComplaintUpdateDao updateDao, UserDao userDao) {
        this.complaintDao = complaintDao;
        this.updateDao = updateDao;
        this.userDao = userDao;
    }

    /**
     * Submits a new complaint for an authenticated user.
     */
    public Complaint submitComplaint(ObjectId userId, String category, String subject, String description) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID is required.");
        }
        if (!ValidationUtil.isNotEmpty(category)) {
            throw new IllegalArgumentException("Complaint category is required.");
        }
        if (!ValidationUtil.isNotEmpty(subject)) {
            throw new IllegalArgumentException("Complaint subject is required.");
        }
        if (!ValidationUtil.isNotEmpty(description)) {
            throw new IllegalArgumentException("Complaint description is required.");
        }

        // Generate a unique reference ID (check collision)
        String refId;
        int attempts = 0;
        do {
            refId = ReferenceIdGenerator.generate();
            attempts++;
            if (attempts > 5) {
                refId = "CMP-" + System.currentTimeMillis();
                break;
            }
        } while (complaintDao.findByReferenceId(refId) != null);

        Complaint complaint = new Complaint();
        complaint.setReferenceId(refId);
        complaint.setUserId(userId);
        complaint.setCategory(category.trim());
        complaint.setSubject(subject.trim());
        complaint.setDescription(description.trim());
        complaint.setStatus(ComplaintStatus.SUBMITTED.name());
        complaint.setAdminRemark(null);
        complaint.setCreatedAt(new Date());
        complaint.setUpdatedAt(new Date());

        ObjectId complaintId = complaintDao.insert(complaint);
        complaint.setId(complaintId);

        // Record initial status in audit trail
        ComplaintUpdate initialUpdate = new ComplaintUpdate();
        initialUpdate.setComplaintId(complaintId);
        initialUpdate.setPreviousStatus(null);
        initialUpdate.setNewStatus(ComplaintStatus.SUBMITTED.name());
        initialUpdate.setRemark("Complaint lodged successfully by complainant.");
        initialUpdate.setChangedBy(userId);

        User submittingUser = userDao.findById(userId);
        if (submittingUser != null) {
            initialUpdate.setChangedByName(submittingUser.getFullName());
        } else {
            initialUpdate.setChangedByName("Complainant");
        }
        initialUpdate.setChangedAt(new Date());
        updateDao.insert(initialUpdate);

        LOGGER.info("Complaint created: " + refId + " by user: " + userId);
        return complaint;
    }

    /**
     * Retrieves all complaints lodged by a specific user.
     */
    public List<Complaint> getUserComplaints(ObjectId userId) {
        if (userId == null) return Collections.emptyList();
        return complaintDao.findByUserId(userId);
    }

    /**
     * Retrieves a single complaint by MongoDB ObjectId and populates submitting user info.
     */
    public Complaint getComplaintById(ObjectId complaintId) {
        if (complaintId == null) return null;
        Complaint complaint = complaintDao.findById(complaintId);
        if (complaint != null && complaint.getUserId() != null) {
            User user = userDao.findById(complaint.getUserId());
            if (user != null) {
                complaint.setUserFullName(user.getFullName());
                complaint.setUserEmail(user.getEmail());
            }
        }
        return complaint;
    }

    /**
     * Retrieves a single complaint by human-readable reference number.
     */
    public Complaint getComplaintByReferenceId(String refId) {
        if (refId == null || refId.trim().isEmpty()) return null;
        Complaint complaint = complaintDao.findByReferenceId(refId.trim());
        if (complaint != null && complaint.getUserId() != null) {
            User user = userDao.findById(complaint.getUserId());
            if (user != null) {
                complaint.setUserFullName(user.getFullName());
                complaint.setUserEmail(user.getEmail());
            }
        }
        return complaint;
    }

    /**
     * Retrieves full chronological timeline of status updates for a complaint.
     */
    public List<ComplaintUpdate> getComplaintHistory(ObjectId complaintId) {
        if (complaintId == null) return Collections.emptyList();
        return updateDao.findByComplaintId(complaintId);
    }

    /**
     * Retrieves filtered and paginated list of complaints for administrative view.
     */
    public List<Complaint> getAllComplaints(String statusFilter, String categoryFilter, String searchTerm, int limit, int skip) {
        List<Complaint> complaints = complaintDao.findAll(statusFilter, categoryFilter, searchTerm, limit, skip);
        // Preload user details
        Map<ObjectId, User> userCache = new HashMap<>();
        for (Complaint c : complaints) {
            if (c.getUserId() != null) {
                User u = userCache.computeIfAbsent(c.getUserId(), userDao::findById);
                if (u != null) {
                    c.setUserFullName(u.getFullName());
                    c.setUserEmail(u.getEmail());
                }
            }
        }
        return complaints;
    }

    /**
     * Updates complaint status with mandatory admin remarks and records audit trail.
     */
    public boolean updateComplaintStatus(ObjectId complaintId, String newStatusStr, String adminRemark, User admin) {
        if (complaintId == null) {
            throw new IllegalArgumentException("Complaint ID is required.");
        }
        if (admin == null || !admin.isAdmin()) {
            throw new SecurityException("Only an authorized administrator can update complaint status.");
        }

        ComplaintStatus newStatus = ComplaintStatus.fromString(newStatusStr);
        if (newStatus == null) {
            throw new IllegalArgumentException("Invalid complaint status: " + newStatusStr);
        }

        if (!ValidationUtil.isNotEmpty(adminRemark)) {
            throw new IllegalArgumentException("Administrator remarks are required when updating status.");
        }

        Complaint existing = complaintDao.findById(complaintId);
        if (existing == null) {
            throw new IllegalArgumentException("Complaint not found with ID: " + complaintId);
        }

        String oldStatus = existing.getStatus();

        // Perform status update in complaints collection
        boolean updated = complaintDao.updateStatus(complaintId, newStatus.name(), adminRemark.trim());
        if (updated) {
            // Append audit update
            ComplaintUpdate audit = new ComplaintUpdate();
            audit.setComplaintId(complaintId);
            audit.setPreviousStatus(oldStatus);
            audit.setNewStatus(newStatus.name());
            audit.setRemark(adminRemark.trim());
            audit.setChangedBy(admin.getId());
            audit.setChangedByName(admin.getFullName());
            audit.setChangedAt(new Date());
            updateDao.insert(audit);

            LOGGER.info("Status of complaint " + existing.getReferenceId() + " changed from " 
                    + oldStatus + " to " + newStatus.name() + " by " + admin.getEmail());
        }
        return updated;
    }

    /**
     * Gathers aggregate metrics for the admin or user dashboard.
     */
    public Map<String, Long> getDashboardStatistics() {
        Map<String, Long> stats = new HashMap<>();
        stats.put("TOTAL", complaintDao.countTotal());
        stats.put("SUBMITTED", complaintDao.countByStatus(ComplaintStatus.SUBMITTED.name()));
        stats.put("UNDER_REVIEW", complaintDao.countByStatus(ComplaintStatus.UNDER_REVIEW.name()));
        stats.put("IN_PROGRESS", complaintDao.countByStatus(ComplaintStatus.IN_PROGRESS.name()));
        stats.put("RESOLVED", complaintDao.countByStatus(ComplaintStatus.RESOLVED.name()));
        stats.put("REJECTED", complaintDao.countByStatus(ComplaintStatus.REJECTED.name()));
        stats.put("CLOSED", complaintDao.countByStatus(ComplaintStatus.CLOSED.name()));

        // Active grievances = Submitted + Under Review + In Progress
        long active = stats.get("SUBMITTED") + stats.get("UNDER_REVIEW") + stats.get("IN_PROGRESS");
        stats.put("ACTIVE", active);

        return stats;
    }

    /**
     * Gathers personal counts for an individual user dashboard.
     */
    public Map<String, Long> getUserStatistics(ObjectId userId) {
        Map<String, Long> stats = new HashMap<>();
        List<Complaint> userComplaints = getUserComplaints(userId);
        long total = userComplaints.size();
        long active = 0;
        long resolved = 0;

        for (Complaint c : userComplaints) {
            if (ComplaintStatus.RESOLVED.name().equalsIgnoreCase(c.getStatus()) 
                    || ComplaintStatus.CLOSED.name().equalsIgnoreCase(c.getStatus())) {
                resolved++;
            } else {
                active++;
            }
        }

        stats.put("TOTAL", total);
        stats.put("ACTIVE", active);
        stats.put("RESOLVED", resolved);
        return stats;
    }
}
