public class ADM_ScrumTeamMemberTriggerLogic {
	Map<Id, agf__ADM_Scrum_Team_Member__c> oldMembers;
    Map<Id, agf__ADM_Scrum_Team_Member__c> newMembers;
    
    public ADM_ScrumTeamMemberTriggerLogic(Map<Id, agf__ADM_Scrum_Team_Member__c> oldTriggerTeamMembers,
                                     	   Map<Id, agf__ADM_Scrum_Team_Member__c> newTriggerTeamMembers) {
    	oldMembers = oldTriggerTeamMembers;
        newMembers = newTriggerTeamMembers;
    }
    
    private static String getTeamName(Id teamId) {
        List<agf__ADM_Scrum_Team__c> parentTeam = [SELECT ID, Name FROM agf__ADM_Scrum_Team__c WHERE ID=:teamId LIMIT 1];
        if(!parentTeam.isEmpty()) {
            return parentTeam[0].Name;
        }
        return null;
    }

    public void createCollaborationGroupMembersAfterInsert() {
        /*
         * This function is to create new CollaborationGroupMembers when Members are added to a team.
         * 
         * The function will get the name of the Team that a member was added to, then check to make
         * sure a corresponding CollaborationGroup exists with the same name. If a CollaborationGroup
         * does exist, a new group member is added with reference to the User which was added to the team.
         * */
    	List<CollaborationGroupMember> membersToAdd = new List<CollaborationGroupMember>();
        for(agf__ADM_Scrum_Team_Member__c teamMember: newMembers.values()) {
            String teamName = getTeamName(teamMember.agf__Scrum_Team__c);
            if(teamName == null) {
                return;
            }
            List<CollaborationGroup> collabGroup = [SELECT ID, Name FROM CollaborationGroup WHERE Name=:teamName LIMIT 1];
            if(!collabGroup.isEmpty()) {
                //Check to make sure that there doesn't exist a CollaborationGroupMember with the unique combination of GroupId and MemberId
                List<CollaborationGroupMember> existingMember = [SELECT CollaborationGroupId, MemberId
                                                                 FROM CollaborationGroupMember
                                                                 WHERE CollaborationGroupId=:collabGroup[0].Id AND MemberId=:teamMember.agf__Member_Name__c];
                if(existingMember.isEmpty()) {
                    CollaborationGroupMember newMember = new CollaborationGroupMember();
                    newMember.CollaborationGroupId = collabGroup[0].ID;
                    newMember.CollaborationRole = 'Standard';
                    newMember.MemberId = teamMember.agf__Member_Name__c;
                    
                    membersToAdd.add(newMember);
                }
            }
        }
        insert membersToAdd;
    }
    
    public void deleteCollaborationGroupMembersAfterDelete() {
        /*
         * This function is to remove members from a Collaboration Group once they've been
         * removed from their corresponding Team.
         * 
         * Makes sure that the CollabGroup exists, then makes sure that the CollaborationGroupMember
         * for that Group and User exists before removing it. 
         * */
    	List<CollaborationGroupMember> membersToRemove = new List<CollaborationGroupMember>();
        for(agf__ADM_Scrum_Team_Member__c teamMember: oldMembers.values()) {
            String teamName = getTeamName(teamMember.agf__Scrum_Team__c);
            if(teamName == null) {
                return;
            }
            List<CollaborationGroup> collabGroup = [SELECT ID, Name FROM CollaborationGroup WHERE Name=:teamName LIMIT 1];
            if(!collabGroup.isEmpty()) {
                List<CollaborationGroupMember> groupMembers = [SELECT CollaborationGroupId, MemberId 
                                                               FROM CollaborationGroupMember 
                                                               WHERE CollaborationGroupId=:collabGroup[0].ID AND MemberId=:teamMember.agf__Member_Name__c];
                if(!groupMembers.isEmpty()) {
                    membersToRemove.add(groupMembers[0]);
                }
            }
        }
        delete membersToRemove;
    }
}