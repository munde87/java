package com.college.complaintportal.config;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.logging.Logger;

/**
 * Web application lifecycle listener that initializes and gracefully cleans up
 * resources like MongoDB connection pools.
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(AppContextListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("Application starting: initializing MongoDB client and indexes...");
        try {
            MongoConfig.init();
            LOGGER.info("MongoDB client successfully initialized on application startup.");
        } catch (Exception e) {
            LOGGER.warning("Could not eagerly connect to MongoDB on startup: " + e.getMessage());
            // Allow app to boot; operations will attempt reconnection or report friendly error
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("Application stopping: shutting down MongoDB client...");
        MongoConfig.close();
    }
}
