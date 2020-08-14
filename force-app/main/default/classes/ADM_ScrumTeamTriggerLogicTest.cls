@isTest
public class ADM_ScrumTeamTriggerLogicTest {
    private static final String team1Name = 'Test_Team_1';
    private static final String team1Department = 'IT';
    private static final String team2Name = 'Test_Team_2';
    private static final String team2Department = 'Marketing';
    private static final String team3Name = 'Test_Team_3';
    private static final String team4Name = 'Test_Team_4';
    private static final String team5Name = 'Test_Team_5';
    private static final String team6Name = 'Test_Team_6';
    
	@isTest static void testInsertTeam() {
        List<agf__ADM_Scrum_Team__c> teamsToInsert = new List<agf__ADM_Scrum_Team__c>();
        agf__ADM_Scrum_Team__c team3 = TestDataFactory.createTestTeam(team3Name);        
        agf__ADM_Scrum_Team__c team4 = TestDataFactory.createTestTeam(team4Name);
        
        teamsToInsert.add(team3);
        teamsToInsert.add(team4);
        
        List<CollaborationGroup> preInsertGroups = [SELECT ID, Name FROM CollaborationGroup WHERE Name=:team3Name OR Name=:team4Name];
        System.assert(preInsertGroups.isEmpty());
        
        test.startTest();
        insert teamsToInsert;
        test.stopTest();
        
        List<CollaborationGroup> createdCollabGroups = [SELECT ID, Name FROM CollaborationGroup WHERE Name=:team3Name OR Name=:team4Name];
        System.assertEquals(2, createdCollabGroups.size());
    }
    
    @isTest static void testDeleteTeam() {
        List<agf__ADM_Scrum_Team__c> teamsToDelete = new List<agf__ADM_Scrum_Team__c>();
        List<agf__ADM_Scrum_Team__c> teamsToInsert = new List<agf__ADM_Scrum_Team__c>();
        agf__ADM_Scrum_Team__c team1 = TestDataFactory.createTestTeam(team5Name);        
        agf__ADM_Scrum_Team__c team2 = TestDataFactory.createTestTeam(team6Name);        
        teamsToInsert.add(team1);
        teamsToInsert.add(team2);
        
        List<CollaborationGroup> preInsertGroups = [SELECT ID, Name FROM CollaborationGroup WHERE Name=:team5Name OR Name=:team6Name];
        System.assert(preInsertGroups.isEmpty());
        
        test.startTest();
        insert teamsToInsert;
        
        teamsToDelete.addAll(teamsToInsert);
        List<CollaborationGroup> createdCollabGroups = [SELECT ID, Name FROM CollaborationGroup WHERE Name=:team5Name OR Name=:team6Name];
        System.assertEquals(2, createdCollabGroups.size());
        
        delete teamsToDelete;
        test.stopTest();
        //perform a check to see scum team got deleted
		List<CollaborationGroup> postDeleteCollabGroups = [SELECT ID, Name FROM CollaborationGroup WHERE Name=:team5Name OR Name=:team6Name];
        System.assertEquals(2, postDeleteCollabGroups.size());
    }
}