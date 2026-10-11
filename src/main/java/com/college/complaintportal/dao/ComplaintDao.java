package com.college.complaintportal.dao;

import com.college.complaintportal.config.MongoConfig;
import com.college.complaintportal.model.Complaint;
import com.college.complaintportal.model.ComplaintStatus;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Sorts;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Data Access Object for Complaint entities in MongoDB.
 */
public class ComplaintDao {

    private static final String COLLECTION_NAME = "complaints";

    private MongoCollection<Document> getCollection() {
        MongoDatabase db = MongoConfig.getDatabase();
        return db.getCollection(COLLECTION_NAME);
    }

    public ObjectId insert(Complaint complaint) {
        Document doc = new Document()
                .append("referenceId", complaint.getReferenceId())
                .append("userId", complaint.getUserId())
                .append("category", complaint.getCategory())
                .append("subject", complaint.getSubject())
                .append("description", complaint.getDescription())
                .append("status", complaint.getStatus() != null ? complaint.getStatus() : ComplaintStatus.SUBMITTED.name())
                .append("adminRemark", complaint.getAdminRemark())
                .append("createdAt", complaint.getCreatedAt() != null ? complaint.getCreatedAt() : new Date())
                .append("updatedAt", complaint.getUpdatedAt() != null ? complaint.getUpdatedAt() : new Date());

        getCollection().insertOne(doc);
        ObjectId generatedId = doc.getObjectId("_id");
        complaint.setId(generatedId);
        return generatedId;
    }

    public Complaint findById(ObjectId id) {
        if (id == null) return null;
        Document doc = getCollection().find(Filters.eq("_id", id)).first();
        return mapDocumentToComplaint(doc);
    }

    public Complaint findByReferenceId(String referenceId) {
        if (referenceId == null || referenceId.trim().isEmpty()) return null;
        Document doc = getCollection().find(Filters.eq("referenceId", referenceId.trim().toUpperCase())).first();
        return mapDocumentToComplaint(doc);
    }

    public List<Complaint> findByUserId(ObjectId userId) {
        List<Complaint> list = new ArrayList<>();
        if (userId == null) return list;

        for (Document doc : getCollection().find(Filters.eq("userId", userId)).sort(Sorts.descending("createdAt"))) {
            list.add(mapDocumentToComplaint(doc));
        }
        return list;
    }

    public List<Complaint> findAll(String statusFilter, String categoryFilter, String searchTerm, int limit, int skip) {
        List<Complaint> list = new ArrayList<>();
        List<Bson> filters = new ArrayList<>();

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            filters.add(Filters.eq("status", statusFilter.trim().toUpperCase()));
        }

        if (categoryFilter != null && !categoryFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(categoryFilter)) {
            filters.add(Filters.eq("category", categoryFilter.trim()));
        }

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            Pattern pattern = Pattern.compile(Pattern.quote(searchTerm.trim()), Pattern.CASE_INSENSITIVE);
            filters.add(Filters.or(
                    Filters.regex("referenceId", pattern),
                    Filters.regex("subject", pattern),
                    Filters.regex("description", pattern),
                    Filters.regex("category", pattern)
            ));
        }

        Bson query = filters.isEmpty() ? new Document() : Filters.and(filters);

        var cursor = getCollection().find(query)
                .sort(Sorts.descending("createdAt"));
        if (skip > 0) {
            cursor = cursor.skip(skip);
        }
        if (limit > 0) {
            cursor = cursor.limit(limit);
        }

        for (Document doc : cursor) {
            list.add(mapDocumentToComplaint(doc));
        }
        return list;
    }

    public boolean updateStatus(ObjectId complaintId, String newStatus, String adminRemark) {
        if (complaintId == null) return false;
        Bson filter = Filters.eq("_id", complaintId);
        Bson updates = Updates.combine(
                Updates.set("status", newStatus.toUpperCase()),
                Updates.set("adminRemark", adminRemark),
                Updates.set("updatedAt", new Date())
        );
        return getCollection().updateOne(filter, updates).getModifiedCount() > 0;
    }

    public long countTotal() {
        return getCollection().countDocuments();
    }

    public long countByStatus(String status) {
        if (status == null) return 0;
        return getCollection().countDocuments(Filters.eq("status", status.toUpperCase()));
    }

    public long countByUserId(ObjectId userId) {
        if (userId == null) return 0;
        return getCollection().countDocuments(Filters.eq("userId", userId));
    }

    private Complaint mapDocumentToComplaint(Document doc) {
        if (doc == null) return null;
        Complaint c = new Complaint();
        c.setId(doc.getObjectId("_id"));
        c.setReferenceId(doc.getString("referenceId"));
        c.setUserId(doc.getObjectId("userId"));
        c.setCategory(doc.getString("category"));
        c.setSubject(doc.getString("subject"));
        c.setDescription(doc.getString("description"));
        c.setStatus(doc.getString("status"));
        c.setAdminRemark(doc.getString("adminRemark"));
        c.setCreatedAt(doc.getDate("createdAt"));
        c.setUpdatedAt(doc.getDate("updatedAt"));
        return c;
    }
}
