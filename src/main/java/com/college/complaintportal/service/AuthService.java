package com.college.complaintportal.service;

import com.college.complaintportal.dao.UserDao;
import com.college.complaintportal.model.User;
import com.college.complaintportal.util.PasswordUtil;
import com.college.complaintportal.util.ValidationUtil;

import java.util.logging.Logger;

/**
 * Service handling user registration, authentication, and admin provisioning.
 */
public class AuthService {

    private static final Logger LOGGER = Logger.getLogger(AuthService.class.getName());
    private final UserDao userDao;

    public AuthService() {
        this.userDao = new UserDao();
    }

    public AuthService(UserDao userDao) {
        this.userDao = userDao;
    }

    /**
     * Registers a new user.
     * @throws IllegalArgumentException on validation failure
     * @throws IllegalStateException if email already exists
     */
    public User register(String fullName, String email, String password, String role) {
        if (!ValidationUtil.isNotEmpty(fullName)) {
            throw new IllegalArgumentException("Full name is required.");
        }
        if (!ValidationUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("A valid email address is required.");
        }
        if (!ValidationUtil.isValidPassword(password)) {
            throw new IllegalArgumentException("Password must be at least 6 characters long.");
        }

        String normalizedEmail = email.toLowerCase().trim();
        if (userDao.emailExists(normalizedEmail)) {
            throw new IllegalStateException("An account with this email address already exists.");
        }

        String assignedRole = User.ROLE_ADMIN.equalsIgnoreCase(role) ? User.ROLE_ADMIN : User.ROLE_USER;
        String passwordHash = PasswordUtil.hashPassword(password);

        User user = new User(fullName.trim(), normalizedEmail, passwordHash, assignedRole);
        userDao.insert(user);
        LOGGER.info("Successfully registered user: " + normalizedEmail + " with role: " + assignedRole);
        return user;
    }

    /**
     * Authenticates a user by email and password.
     * @return User object if authentication is successful
     * @throws IllegalArgumentException on invalid credentials
     */
    public User login(String email, String password) {
        if (!ValidationUtil.isValidEmail(email) || password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Invalid email or password.");
        }

        User user = userDao.findByEmail(email.toLowerCase().trim());
        if (user == null) {
            throw new IllegalArgumentException("Invalid email or password.");
        }

        if (!user.isActive()) {
            throw new IllegalArgumentException("This account is currently deactivated. Please contact support.");
        }

        boolean valid = PasswordUtil.checkPassword(password, user.getPasswordHash());
        if (!valid) {
            throw new IllegalArgumentException("Invalid email or password.");
        }

        LOGGER.info("Successful login for user: " + user.getEmail() + " (" + user.getRole() + ")");
        return user;
    }

    /**
     * Provisions a default system administrator if no administrator account exists.
     */
    public void provisionDefaultAdminIfNoneExists() {
        try {
            if (userDao.countAdmins() == 0) {
                String adminEmail = System.getenv("DEFAULT_ADMIN_EMAIL");
                if (adminEmail == null || adminEmail.trim().isEmpty()) {
                    adminEmail = "admin@college.edu";
                }

                String adminPass = System.getenv("DEFAULT_ADMIN_PASSWORD");
                if (adminPass == null || adminPass.trim().isEmpty()) {
                    adminPass = "Admin@1234";
                }

                register("System Administrator", adminEmail, adminPass, User.ROLE_ADMIN);
                LOGGER.info("Initial administrator provisioned successfully: " + adminEmail);
            }
        } catch (Exception e) {
            LOGGER.warning("Could not auto-provision default admin: " + e.getMessage());
        }
    }
}
