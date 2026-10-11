package com.college.complaintportal.dao;

import com.college.complaintportal.config.MongoConfig;
import com.college.complaintportal.model.User;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;

import java.util.Date;

/**
 * Data Access Object for User entities in MongoDB.
 */
public class UserDao {

    private static final String COLLECTION_NAME = "users";

    private MongoCollection<Document> getCollection() {
        MongoDatabase db = MongoConfig.getDatabase();
        return db.getCollection(COLLECTION_NAME);
    }

    public ObjectId insert(User user) {
        Document doc = new Document()
                .append("fullName", user.getFullName())
                .append("email", user.getEmail() != null ? user.getEmail().toLowerCase().trim() : null)
                .append("passwordHash", user.getPasswordHash())
                .append("role", user.getRole())
                .append("active", user.isActive())
                .append("createdAt", user.getCreatedAt() != null ? user.getCreatedAt() : new Date())
                .append("updatedAt", user.getUpdatedAt() != null ? user.getUpdatedAt() : new Date());

        getCollection().insertOne(doc);
        ObjectId generatedId = doc.getObjectId("_id");
        user.setId(generatedId);
        return generatedId;
    }

    public User findById(ObjectId id) {
        if (id == null) return null;
        Document doc = getCollection().find(Filters.eq("_id", id)).first();
        return mapDocumentToUser(doc);
    }

    public User findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) return null;
        Document doc = getCollection().find(Filters.eq("email", email.toLowerCase().trim())).first();
        return mapDocumentToUser(doc);
    }

    public boolean emailExists(String email) {
        if (email == null || email.trim().isEmpty()) return false;
        long count = getCollection().countDocuments(Filters.eq("email", email.toLowerCase().trim()));
        return count > 0;
    }

    public boolean update(User user) {
        if (user.getId() == null) return false;
        Bson filter = Filters.eq("_id", user.getId());
        Bson updates = Updates.combine(
                Updates.set("fullName", user.getFullName()),
                Updates.set("active", user.isActive()),
                Updates.set("updatedAt", new Date())
        );
        return getCollection().updateOne(filter, updates).getModifiedCount() > 0;
    }

    public long countUsers() {
        return getCollection().countDocuments(Filters.eq("role", User.ROLE_USER));
    }

    public long countAdmins() {
        return getCollection().countDocuments(Filters.eq("role", User.ROLE_ADMIN));
    }

    private User mapDocumentToUser(Document doc) {
        if (doc == null) return null;
        User user = new User();
        user.setId(doc.getObjectId("_id"));
        user.setFullName(doc.getString("fullName"));
        user.setEmail(doc.getString("email"));
        user.setPasswordHash(doc.getString("passwordHash"));
        user.setRole(doc.getString("role"));
        user.setActive(doc.getBoolean("active", true));
        user.setCreatedAt(doc.getDate("createdAt"));
        user.setUpdatedAt(doc.getDate("updatedAt"));
        return user;
    }
}
