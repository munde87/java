package com.college.complaintportal.model;

import org.bson.types.ObjectId;
import java.io.Serializable;
import java.util.Date;

/**
 * Audit trail entry for tracking complaint status transitions and admin remarks.
 */
public class ComplaintUpdate implements Serializable {
    private static final long serialVersionUID = 1L;

    private ObjectId id;
    private ObjectId complaintId;
    private String previousStatus;
    private String newStatus;
    private String remark;
    private ObjectId changedBy;
    private String changedByName;
    private Date changedAt;

    public ComplaintUpdate() {
        this.changedAt = new Date();
    }

    public ComplaintUpdate(ObjectId complaintId, String previousStatus, String newStatus, String remark, ObjectId changedBy) {
        this.complaintId = complaintId;
        this.previousStatus = previousStatus;
        this.newStatus = newStatus;
        this.remark = remark;
        this.changedBy = changedBy;
        this.changedAt = new Date();
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

    public ObjectId getComplaintId() {
        return complaintId;
    }

    public String getComplaintIdString() {
        return complaintId != null ? complaintId.toHexString() : null;
    }

    public void setComplaintId(ObjectId complaintId) {
        this.complaintId = complaintId;
    }

    public String getPreviousStatus() {
        return previousStatus;
    }

    public void setPreviousStatus(String previousStatus) {
        this.previousStatus = previousStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public ObjectId getChangedBy() {
        return changedBy;
    }

    public String getChangedByString() {
        return changedBy != null ? changedBy.toHexString() : null;
    }

    public void setChangedBy(ObjectId changedBy) {
        this.changedBy = changedBy;
    }

    public String getChangedByName() {
        return changedByName;
    }

    public void setChangedByName(String changedByName) {
        this.changedByName = changedByName;
    }

    public Date getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(Date changedAt) {
        this.changedAt = changedAt;
    }

    public ComplaintStatus getNewStatusEnum() {
        return ComplaintStatus.fromString(this.newStatus);
    }
}
