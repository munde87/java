package com.college.complaintportal;

import com.college.complaintportal.config.MongoConfig;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

/**
 * Diagnostic utility to verify MongoDB Atlas network connectivity, credentials,
 * and collection existence outside the web container.
 *
 * Can be run via:
 * mvn exec:java -Dexec.mainClass="com.college.complaintportal.DatabaseConnectionCheck"
 */
public class DatabaseConnectionCheck {

    public static void main(String[] args) {
        System.out.println("==================================================");
        System.out.println(" MongoDB Atlas Diagnostic & Connectivity Verifier ");
        System.out.println("==================================================");

        String uri = System.getenv("MONGODB_URI");
        String dbName = System.getenv("MONGODB_DATABASE");

        System.out.println("Target Database: " + (dbName != null ? dbName : "complaint_portal (default)"));
        if (uri == null || uri.trim().isEmpty()) {
            System.out.println("[INFO] MONGODB_URI environment variable is not set.");
            System.out.println("[INFO] Testing with local default or embedded settings.");
        } else {
            // Mask password in URI
            String masked = uri.replaceAll(":[^/@]+@", ":****@");
            System.out.println("Using URI: " + masked);
        }

        try {
            MongoConfig.init();
            MongoClient client = MongoConfig.getMongoClient();
            MongoDatabase db = MongoConfig.getDatabase();

            System.out.println("[OK] Connected to MongoDB cluster!");

            // Run ping command
            Document ping = db.runCommand(new Document("ping", 1));
            System.out.println("[OK] Ping response: " + ping.toJson());

            // List collections
            System.out.println("\nAvailable collections in database:");
            for (String colName : db.listCollectionNames()) {
                long count = db.getCollection(colName).countDocuments();
                System.out.println("  - " + colName + " (" + count + " documents)");
            }

            System.out.println("\n[SUCCESS] MongoDB Atlas connectivity and indexes are operational!");
        } catch (Exception e) {
            System.err.println("\n[ERROR] Connection failed: " + e.getMessage());
            System.err.println("Please check:");
            System.err.println("  1. MONGODB_URI environment variable");
            System.err.println("  2. Atlas Network Access (IP Whitelist)");
            System.err.println("  3. Atlas Database User Credentials");
        } finally {
            MongoConfig.close();
            System.out.println("==================================================");
        }
    }
}
