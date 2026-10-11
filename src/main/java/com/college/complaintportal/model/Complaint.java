package com.college.complaintportal.model;

import org.bson.types.ObjectId;
import java.io.Serializable;
import java.util.Date;

/**
 * Model representing a complaint lodged by a user.
 */
public class Complaint implements Serializable {
    private static final long serialVersionUID = 1L;

    private ObjectId id;
    private String referenceId; // e.g. CMP-20261011-A8B9
    private ObjectId userId;
    private String category;
    private String subject;
    private String description;
    private String status; // SUBMITTED, UNDER_REVIEW, IN_PROGRESS, RESOLVED, REJECTED, CLOSED
    private String adminRemark;
    private Date createdAt;
    private Date updatedAt;

    // Transient or populated presentation fields
    private String userFullName;
    private String userEmail;

    public Complaint() {
        this.status = ComplaintStatus.SUBMITTED.name();
        this.createdAt = new Date();
        this.updatedAt = new Date();
    }

    public ObjectId getId() {
        return id;
    }

    public String getIdString() {
        return id != null ? id.toHexString() : null;
    }

    public void setId(ObjectId id) {
        this.id = id;
    }

    public String getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(String referenceId) {
        this.referenceId = referenceId;
    }

    public ObjectId getUserId() {
        return userId;
    }

    public String getUserIdString() {
        return userId != null ? userId.toHexString() : null;
    }

    public void setUserId(ObjectId userId) {
        this.userId = userId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAdminRemark() {
        return adminRemark;
    }

    public void setAdminRemark(String adminRemark) {
        this.adminRemark = adminRemark;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getUserFullName() {
        return userFullName;
    }

    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public ComplaintStatus getStatusEnum() {
        ComplaintStatus s = ComplaintStatus.fromString(this.status);
        return s != null ? s : ComplaintStatus.SUBMITTED;
    }
}
