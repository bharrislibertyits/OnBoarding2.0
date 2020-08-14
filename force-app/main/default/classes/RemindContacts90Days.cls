global class RemindContacts90Days implements Schedulable {
    global void execute(SchedulableContext ctx) {
        recordType recTypeId = [SELECT ID from recordtype where name = 'Employee' LIMIT 1];
        // Only Active Employee contacts that have null or > 90 days old changes and not notified in last 90 days already, should be notified
        List<Contact> conts = [SELECT Id, Notification_90_Day_Send__c, Notification_90_Day_Sent_Date__c FROM Contact 
                               WHERE (Last_Project_Role_Date__c = NULL OR Last_Project_Role_Date__c < LAST_90_DAYS)
                               	AND (Last_Contact_Certification_Date__c = NULL OR Last_Contact_Certification_Date__c < LAST_90_DAYS)
        						AND (Last_Skill_Date__c = NULL OR Last_Skill_Date__c < LAST_90_DAYS)
        						AND (Last_User_Badge_Date__c = NULL OR Last_User_Badge_Date__c < LAST_90_DAYS)
                                AND (Notification_90_Day_Sent_Date__c = NULL OR Notification_90_Day_Sent_Date__c < LAST_90_DAYS)
                                AND User__c != NULL AND RecordTypeId = :recTypeId.Id
                                AND User__c in (Select Id FROM User WHERE IsActive = TRUE)];
        //update each contact in loop to kick off process builder to send email
        for (Contact c : conts) {
            c.Notification_90_Day_Send__c = TRUE;
        }
    	update conts;
    }
}