public class ADM_ScrumTeamTriggerLogic {
    private static final String COLLABORATION_GROUP_TYPE = 'Public';
    
    Map<Id, agf__ADM_Scrum_Team__c> oldTeams;
    Map<Id, agf__ADM_Scrum_Team__c> newTeams;
    List<agf__ADM_Scrum_Team__c> newTeamsList;
    
    public ADM_ScrumTeamTriggerLogic(Map<Id, agf__ADM_Scrum_Team__c> oldTriggerTeams,
                                     Map<Id, agf__ADM_Scrum_Team__c> newTriggerTeams,
                                     List<agf__ADM_Scrum_Team__c> newList) {
    	oldTeams = oldTriggerTeams;
        newTeams = newTriggerTeams;
        newTeamsList = newList;
    }

    public void createCollaborationGroupBeforeInsert() {
        /*
         * Function to create a corresponding collaboration (chatter) group when a team is created.
         * The collaboration group will have a matching name to that of the team which was created.
        **/
    	List<CollaborationGroup> groupsToCreate = new List<CollaborationGroup>();
        for(agf__ADM_Scrum_Team__c team: newTeamsList) {
            String teamName = team.name;
            List<CollaborationGroup> existingGroup = [SELECT ID, Name FROM CollaborationGroup WHERE Name=:teamName LIMIT 1];
            
            if(existingGroup.isEmpty()) {
                CollaborationGroup newGroup = new CollaborationGroup ();
                newGroup.Name = teamName;
                newGroup.CollaborationType = COLLABORATION_GROUP_TYPE;
                
                groupsToCreate.add(newGroup);
            }
        }
        insert groupsToCreate;
    }
}