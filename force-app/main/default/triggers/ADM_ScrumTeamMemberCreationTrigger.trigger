trigger ADM_ScrumTeamMemberCreationTrigger on agf__ADM_Scrum_Team_Member__c (after insert, after delete) {
    List<CollaborationGroupMember> membersToAdd = new List<CollaborationGroupMember>();
    List<CollaborationGroupMember> membersToRemove = new List<CollaborationGroupMember>();
    
    if(Trigger.isBefore) {
        if(Trigger.isInsert) { }
        if(Trigger.isUpdate) { }
        if(Trigger.isDelete) { }
    }
    if(Trigger.isAfter) {
        ADM_ScrumTeamMemberTriggerLogic triggerLogic = new ADM_ScrumTeamMemberTriggerLogic(Trigger.oldMap, Trigger.newMap);
        if(Trigger.isInsert) {
            triggerLogic.createCollaborationGroupMembersAfterInsert();
        }
        if(Trigger.isUpdate) { 
        }
        if(Trigger.isDelete) {
            triggerLogic.deleteCollaborationGroupMembersAfterDelete();
        }
    }
}