package com.college.complaintportal.config;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.IndexOptions;
import com.mongodb.client.model.Indexes;
import org.bson.Document;

import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Reusable application-level MongoDB client configuration and index initializer.
 * Encapsulates connection pooling, credentials management, and collection indexes.
 */
public final class MongoConfig {

    private static final Logger LOGGER = Logger.getLogger(MongoConfig.class.getName());

    private static final String DEFAULT_DATABASE = "complaint_portal";
    private static final String DEFAULT_LOCAL_URI = "mongodb://localhost:27017";

    private static volatile MongoClient mongoClient;
    private static volatile MongoDatabase database;

    private MongoConfig() {
        // Private constructor for utility class
    }

    /**
     * Initializes the MongoDB client and connection pool.
     */
    public static synchronized void init() {
        if (mongoClient != null) {
            return;
        }

        // 1. Try process environment variable
        String uri = System.getenv("MONGODB_URI");
        String dbName = System.getenv("MONGODB_DATABASE");

        // 2. Try system properties
        if (uri == null || uri.trim().isEmpty()) {
            uri = System.getProperty("MONGODB_URI");
        }
        if (dbName == null || dbName.trim().isEmpty()) {
            dbName = System.getProperty("MONGODB_DATABASE");
        }

        // 3. Fallback: load from .env file if available
        if (uri == null || uri.trim().isEmpty()) {
            java.util.Map<String, String> envMap = loadEnvFile();
            if (envMap.containsKey("MONGODB_URI")) {
                uri = envMap.get("MONGODB_URI");
            }
            if (dbName == null && envMap.containsKey("MONGODB_DATABASE")) {
                dbName = envMap.get("MONGODB_DATABASE");
            }
        }

        if (uri == null || uri.trim().isEmpty()) {
            LOGGER.warning("MONGODB_URI not found in environment, system properties, or .env. Using fallback default: " + DEFAULT_LOCAL_URI);
            uri = DEFAULT_LOCAL_URI;
        }

        if (dbName == null || dbName.trim().isEmpty()) {
            dbName = DEFAULT_DATABASE;
        }

        try {
            ConnectionString connectionString = new ConnectionString(uri);
            MongoClientSettings settings = MongoClientSettings.builder()
                    .applyConnectionString(connectionString)
                    .applicationName("ComplaintManagementPortal")
                    .applyToSocketSettings(builder -> {
                        builder.connectTimeout(10, TimeUnit.SECONDS);
                        builder.readTimeout(15, TimeUnit.SECONDS);
                    })
                    .applyToConnectionPoolSettings(builder -> {
                        builder.maxSize(50);
                        builder.minSize(5);
                        builder.maxWaitTime(5, TimeUnit.SECONDS);
                    })
                    .build();

            mongoClient = MongoClients.create(settings);
            database = mongoClient.getDatabase(dbName);

            LOGGER.info("Successfully initialized MongoDB connection pool for database: " + dbName);

            // Create necessary indexes asynchronously in background so app starts immediately
            Thread indexThread = new Thread(MongoConfig::initIndexes, "mongo-index-init");
            indexThread.setDaemon(true);
            indexThread.start();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize MongoDB client: " + e.getMessage(), e);
            throw new RuntimeException("MongoDB initialization failure", e);
        }
    }

    /**
     * Initializes required indexes across collections.
     */
    public static void initIndexes() {
        if (database == null) {
            return;
        }

        try {
            // 1. users: unique index on normalized email
            database.getCollection("users")
                    .createIndex(Indexes.ascending("email"), new IndexOptions().unique(true));

            // 2. complaints: unique index on referenceId, compound/single indexes for queries
            database.getCollection("complaints")
                    .createIndex(Indexes.ascending("referenceId"), new IndexOptions().unique(true));
            database.getCollection("complaints")
                    .createIndex(Indexes.ascending("userId"));
            database.getCollection("complaints")
                    .createIndex(Indexes.ascending("status"));
            database.getCollection("complaints")
                    .createIndex(Indexes.descending("createdAt"));

            // 3. complaint_updates: index on complaintId and changedAt
            database.getCollection("complaint_updates")
                    .createIndex(Indexes.ascending("complaintId"));
            database.getCollection("complaint_updates")
                    .createIndex(Indexes.ascending("changedAt"));

            LOGGER.info("MongoDB collections and indexes successfully verified.");
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Warning while creating MongoDB indexes: " + e.getMessage(), e);
        }
    }

    public static MongoDatabase getDatabase() {
        if (database == null) {
            init();
        }
        return database;
    }

    public static MongoClient getMongoClient() {
        if (mongoClient == null) {
            init();
        }
        return mongoClient;
    }

    public static synchronized void close() {
        if (mongoClient != null) {
            LOGGER.info("Closing MongoDB connection pool...");
            mongoClient.close();
            mongoClient = null;
            database = null;
            LOGGER.info("MongoDB connection pool closed.");
        }
    }

    private static java.util.Map<String, String> loadEnvFile() {
        java.util.Map<String, String> map = new java.util.HashMap<>();
        String[] candidatePaths = {
                ".env",
                "../.env",
                "../../.env",
                "C:/Users/Dell/OneDrive/Desktop/java app/.env"
        };

        for (String p : candidatePaths) {
            java.io.File file = new java.io.File(p);
            if (file.exists() && file.isFile()) {
                try (java.io.BufferedReader reader = new java.io.BufferedReader(new java.io.FileReader(file))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        line = line.trim();
                        if (!line.isEmpty() && !line.startsWith("#") && line.contains("=")) {
                            int idx = line.indexOf('=');
                            String key = line.substring(0, idx).trim();
                            String val = line.substring(idx + 1).trim();
                            map.put(key, val);
                        }
                    }
                    LOGGER.info("Loaded MongoDB configuration from .env file at: " + file.getAbsolutePath());
                    return map;
                } catch (Exception e) {
                    LOGGER.warning("Could not parse .env file at " + file.getAbsolutePath() + ": " + e.getMessage());
                }
            }
        }
        return map;
    }
}
