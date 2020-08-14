trigger ADM_ScrumTeamCreationTrigger on agf__ADM_Scrum_Team__c (before insert, before update, before delete,
                                                                after insert, after update, after delete) {
    
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            ADM_ScrumTeamTriggerLogic triggerLogic = new ADM_ScrumTeamTriggerLogic(Trigger.oldMap, Trigger.newMap, Trigger.new);
            triggerLogic.createCollaborationGroupBeforeInsert();
        }
        if(Trigger.isUpdate) { }
        if(Trigger.isDelete) { }
    }
    if(Trigger.isAfter) {
        if(Trigger.isInsert) { }
        if(Trigger.isUpdate) { }
        if(Trigger.isDelete) { }
    }
}