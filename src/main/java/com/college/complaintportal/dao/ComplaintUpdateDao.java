package com.college.complaintportal.dao;

import com.college.complaintportal.config.MongoConfig;
import com.college.complaintportal.model.ComplaintUpdate;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Sorts;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Data Access Object for ComplaintUpdate audit history entries in MongoDB.
 */
public class ComplaintUpdateDao {

    private static final String COLLECTION_NAME = "complaint_updates";

    private MongoCollection<Document> getCollection() {
        MongoDatabase db = MongoConfig.getDatabase();
        return db.getCollection(COLLECTION_NAME);
    }

    public ObjectId insert(ComplaintUpdate update) {
        Document doc = new Document()
                .append("complaintId", update.getComplaintId())
                .append("previousStatus", update.getPreviousStatus())
                .append("newStatus", update.getNewStatus())
                .append("remark", update.getRemark())
                .append("changedBy", update.getChangedBy())
                .append("changedByName", update.getChangedByName())
                .append("changedAt", update.getChangedAt() != null ? update.getChangedAt() : new Date());

        getCollection().insertOne(doc);
        ObjectId generatedId = doc.getObjectId("_id");
        update.setId(generatedId);
        return generatedId;
    }

    public List<ComplaintUpdate> findByComplaintId(ObjectId complaintId) {
        List<ComplaintUpdate> list = new ArrayList<>();
        if (complaintId == null) return list;

        for (Document doc : getCollection().find(Filters.eq("complaintId", complaintId)).sort(Sorts.ascending("changedAt"))) {
            ComplaintUpdate u = new ComplaintUpdate();
            u.setId(doc.getObjectId("_id"));
            u.setComplaintId(doc.getObjectId("complaintId"));
            u.setPreviousStatus(doc.getString("previousStatus"));
            u.setNewStatus(doc.getString("newStatus"));
            u.setRemark(doc.getString("remark"));
            u.setChangedBy(doc.getObjectId("changedBy"));
            u.setChangedByName(doc.getString("changedByName"));
            u.setChangedAt(doc.getDate("changedAt"));
            list.add(u);
        }
        return list;
    }
}
