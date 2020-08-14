global class TaskRemindContacts90Days implements Schedulable {
    global void execute(SchedulableContext ctx) {
        recordType recTypeId = [SELECT ID from recordtype where name = 'Employee' LIMIT 1];
        // Only Active Employee contacts that have null or > 90 days old changes and not notified in last 90 days already, should be notified
        List<Contact> conts = [SELECT Id, Task_90_Day_Send__c, Task_90_Day_Sent_Date__c FROM Contact 
                               WHERE (Task_90_Day_Sent_Date__c = NULL OR Task_90_Day_Sent_Date__c < LAST_90_DAYS)
                               AND User__c != NULL AND RecordTypeId = :recTypeId.Id
                               AND User__c in (SELECT Id FROM User WHERE IsActive = TRUE)];
        //update each contact in loop to kick off process builder to send email
        for (Contact c : conts) {
            c.Task_90_Day_Send__c = TRUE;
        }
    	update conts;
    }
}