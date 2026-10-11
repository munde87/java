package com.college.complaintportal.model;

import org.bson.types.ObjectId;
import java.io.Serializable;
import java.util.Date;

/**
 * Model representing a registered portal user or administrator.
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String ROLE_USER = "USER";
    public static final String ROLE_ADMIN = "ADMIN";

    private ObjectId id;
    private String fullName;
    private String email;
    private String passwordHash;
    private String role; // "USER" or "ADMIN"
    private boolean active = true;
    private Date createdAt;
    private Date updatedAt;

    public User() {
    }

    public User(String fullName, String email, String passwordHash, String role) {
        this.fullName = fullName;
        this.email = email != null ? email.toLowerCase().trim() : null;
        this.passwordHash = passwordHash;
        this.role = role != null ? role.toUpperCase().trim() : ROLE_USER;
        this.active = true;
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

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email != null ? email.toLowerCase().trim() : null;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
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

    public boolean isAdmin() {
        return ROLE_ADMIN.equalsIgnoreCase(this.role);
    }
}
