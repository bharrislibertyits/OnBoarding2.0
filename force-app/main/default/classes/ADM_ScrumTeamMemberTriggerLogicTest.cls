@isTest
public class ADM_ScrumTeamMemberTriggerLogicTest {
    private static final String team1Name = 'Test_Team_1';
    private static final String team1Department = 'IT';
    
	@isTest static void testAddTeamMember() {
        List<User> usersToInsert = new List<User>();
        List<agf__ADM_Scrum_Team__c> teamsToInsert = new List<agf__ADM_Scrum_Team__c>();
        List<agf__ADM_Scrum_Team_Member__c> teamMembersToInsert = new List<agf__ADM_Scrum_Team_Member__c>();
        agf__ADM_Scrum_Team__c team1 = TestDataFactory.createTestTeam(team1Name);        
        teamsToInsert.add(team1);
        insert teamsToInsert;
        
        for(agf__ADM_Scrum_Team__c team: teamsToInsert){
            String user1FirstName = 'TestFirst1_' + team.Name + '_User';
            String user1LastName = 'TestLast1_' + team.Name + '_User';            
        	User testUser1 = TestDataFactory.createTestUser(user1FirstName, user1LastName);
            usersToInsert.add(testUser1);
            
            String user2FirstName = 'TestFirst2_' + team.Name + '_User';
            String user2LastName = 'TestLast2_' + team.Name + '_User';
            User testUser2 = TestDataFactory.createTestUser(user2FirstName, user2LastName);
            usersToInsert.add(testUser2);
            
            insert usersToInsert;
                
			agf__ADM_Scrum_Team_Member__c teamMember1 = TestDataFactory.createTestTeamMember(user1FirstName, user1LastName, testUser1.Id, team.Id);
			agf__ADM_Scrum_Team_Member__c teamMember2 = TestDataFactory.createTestTeamMember(user2FirstName, user2LastName, testUser2.Id, team.Id);
            
            teamMembersToInsert.add(teamMember1);
            teamMembersToInsert.add(teamMember2);
        }
        insert teamMembersToInsert;
        
        for(agf__ADM_Scrum_Team__c team: teamsToInsert) {
            List<agf__ADM_Scrum_Team__c> parentTeam = [SELECT ID, Name FROM agf__ADM_Scrum_Team__c WHERE ID=:team.Id LIMIT 1];
            System.assert(!parentTeam.isEmpty());
            String teamName = parentTeam[0].Name;
                
            List<CollaborationGroup> collabGroup = [SELECT ID, Name FROM CollaborationGroup WHERE Name=:teamName LIMIT 1];
            System.assert(!collabGroup.isEmpty());
            List<CollaborationGroupMember> collabGroupMembers = [SELECT ID, CollaborationGroupId from CollaborationGroupMember WHERE CollaborationGroupId=:collabGroup[0].Id];
            System.assert(!collabGroupMembers.isEmpty());
            
            //This will result in 3 because of the 2 members we added and the admin user which is added by default
            System.assertEquals(3, collabGroupMembers.size());
        }
    }
    
    @isTest static void testDeleteTeamMember() {
        List<User> usersToInsert = new List<User>();
        List<agf__ADM_Scrum_Team__c> teamsToInsert = new List<agf__ADM_Scrum_Team__c>();
        List<agf__ADM_Scrum_Team_Member__c> teamMembersToInsert = new List<agf__ADM_Scrum_Team_Member__c>();
        List<agf__ADM_Scrum_Team_Member__c> teamMembersToDelete = new List<agf__ADM_Scrum_Team_Member__c>();
        agf__ADM_Scrum_Team__c team1 = TestDataFactory.createTestTeam(team1Name);        
        teamsToInsert.add(team1);
        insert teamsToInsert;
        
        for(agf__ADM_Scrum_Team__c team: teamsToInsert){
            String user1FirstName = 'TestFirst1_' + team.Name + '_User';
            String user1LastName = 'TestLast1_' + team.Name + '_User';            
        	User testUser1 = TestDataFactory.createTestUser(user1FirstName, user1LastName);
            usersToInsert.add(testUser1);
            
            String user2FirstName = 'TestFirst2_' + team.Name + '_User';
            String user2LastName = 'TestLast2_' + team.Name + '_User';
            User testUser2 = TestDataFactory.createTestUser(user2FirstName, user2LastName);
            usersToInsert.add(testUser2);
            
            insert usersToInsert;
                
			agf__ADM_Scrum_Team_Member__c teamMember1 = TestDataFactory.createTestTeamMember(user1FirstName, user1LastName, testUser1.Id, team.Id);
			agf__ADM_Scrum_Team_Member__c teamMember2 = TestDataFactory.createTestTeamMember(user2FirstName, user2LastName, testUser2.Id, team.Id);
            
            teamMembersToInsert.add(teamMember1);
            teamMembersToInsert.add(teamMember2);
        }
        insert teamMembersToInsert;
        
        teamMembersToDelete.addAll(teamMembersToInsert);
        
        for(agf__ADM_Scrum_Team__c team: teamsToInsert) {
            List<agf__ADM_Scrum_Team__c> parentTeam = [SELECT ID, Name FROM agf__ADM_Scrum_Team__c WHERE ID=:team.Id LIMIT 1];
            System.assert(!parentTeam.isEmpty());
            String teamName = parentTeam[0].Name;
                
            List<CollaborationGroup> collabGroup = [SELECT ID, Name FROM CollaborationGroup WHERE Name=:teamName LIMIT 1];
            System.assert(!collabGroup.isEmpty());
            List<CollaborationGroupMember> collabGroupMembers = [SELECT ID, CollaborationGroupId from CollaborationGroupMember WHERE CollaborationGroupId=:collabGroup[0].Id];
            System.assert(!collabGroupMembers.isEmpty());
            
            //This will result in 3 because of the 2 members we added and the admin user which is added by default
            System.assertEquals(3, collabGroupMembers.size());
        }
        
        delete teamMembersToDelete;
        for(agf__ADM_Scrum_Team__c team: teamsToInsert) {
            List<agf__ADM_Scrum_Team__c> parentTeam = [SELECT ID, Name FROM agf__ADM_Scrum_Team__c WHERE ID=:team.Id LIMIT 1];
            System.assert(!parentTeam.isEmpty());
            String teamName = parentTeam[0].Name;
                
            List<CollaborationGroup> collabGroup = [SELECT ID, Name FROM CollaborationGroup WHERE Name=:teamName LIMIT 1];
            System.assert(!collabGroup.isEmpty());
            List<CollaborationGroupMember> collabGroupMembers = [SELECT ID, CollaborationGroupId from CollaborationGroupMember WHERE CollaborationGroupId=:collabGroup[0].Id];
            System.assert(!collabGroupMembers.isEmpty());
            
            //after deletion should result in just the admin user remaining
            System.assertEquals(1, collabGroupMembers.size());
        }
    }
    
    @isTest static void testDeleteTeamMemberNoCollabGroup() {
        List<User> usersToInsert = new List<User>();
        List<agf__ADM_Scrum_Team__c> teamsToInsert = new List<agf__ADM_Scrum_Team__c>();
        List<agf__ADM_Scrum_Team_Member__c> teamMembersToInsert = new List<agf__ADM_Scrum_Team_Member__c>();
        List<agf__ADM_Scrum_Team_Member__c> teamMembersToDelete = new List<agf__ADM_Scrum_Team_Member__c>();
        agf__ADM_Scrum_Team__c team1 = TestDataFactory.createTestTeam(team1Name);        
        teamsToInsert.add(team1);
        insert teamsToInsert;
        
        for(agf__ADM_Scrum_Team__c team: teamsToInsert){
            String user1FirstName = 'TestFirst1_' + team.Name + '_User';
            String user1LastName = 'TestLast1_' + team.Name + '_User';            
        	User testUser1 = TestDataFactory.createTestUser(user1FirstName, user1LastName);
            usersToInsert.add(testUser1);
            
            String user2FirstName = 'TestFirst2_' + team.Name + '_User';
            String user2LastName = 'TestLast2_' + team.Name + '_User';
            User testUser2 = TestDataFactory.createTestUser(user2FirstName, user2LastName);
            usersToInsert.add(testUser2);
            
            insert usersToInsert;
                
			agf__ADM_Scrum_Team_Member__c teamMember1 = TestDataFactory.createTestTeamMember(user1FirstName, user1LastName, testUser1.Id, team.Id);
			agf__ADM_Scrum_Team_Member__c teamMember2 = TestDataFactory.createTestTeamMember(user2FirstName, user2LastName, testUser2.Id, team.Id);
            
            teamMembersToInsert.add(teamMember1);
            teamMembersToInsert.add(teamMember2);
        }
        insert teamMembersToInsert;
        
        teamMembersToDelete.addAll(teamMembersToInsert);
        
        for(agf__ADM_Scrum_Team__c team: teamsToInsert) {
            List<agf__ADM_Scrum_Team__c> parentTeam = [SELECT ID, Name FROM agf__ADM_Scrum_Team__c WHERE ID=:team.Id LIMIT 1];
            System.assert(!parentTeam.isEmpty());
            String teamName = parentTeam[0].Name;
                
            List<CollaborationGroup> collabGroup = [SELECT ID, Name FROM CollaborationGroup WHERE Name=:teamName LIMIT 1];
            System.assert(!collabGroup.isEmpty());
            List<CollaborationGroupMember> collabGroupMembers = [SELECT ID, CollaborationGroupId from CollaborationGroupMember WHERE CollaborationGroupId=:collabGroup[0].Id];
            System.assert(!collabGroupMembers.isEmpty());
            
            //This will result in 3 because of the 2 members we added and the admin user which is added by default
            System.assertEquals(3, collabGroupMembers.size());
        }
        
        List<CollaborationGroup> collabGroupsToDelete = new List<CollaborationGroup>();
        for(agf__ADM_Scrum_Team__c team: teamsToInsert) {
            List<agf__ADM_Scrum_Team__c> parentTeam = [SELECT ID, Name FROM agf__ADM_Scrum_Team__c WHERE ID=:team.Id LIMIT 1];
            System.assert(!parentTeam.isEmpty());
            String teamName = parentTeam[0].Name;
                
            List<CollaborationGroup> collabGroup = [SELECT ID, Name FROM CollaborationGroup WHERE Name=:teamName LIMIT 1];
            if(!collabGroup.isEmpty()) {
            	collabGroupsToDelete.add(collabGroup[0]);
            }
        }
        delete collabGroupsToDelete;
        
        delete teamMembersToDelete;
        for(agf__ADM_Scrum_Team__c team: teamsToInsert) {
            List<agf__ADM_Scrum_Team__c> parentTeam = [SELECT ID, Name FROM agf__ADM_Scrum_Team__c WHERE ID=:team.Id LIMIT 1];
            System.assert(!parentTeam.isEmpty());
            String teamName = parentTeam[0].Name;
                
            List<CollaborationGroup> collabGroup = [SELECT ID, Name FROM CollaborationGroup WHERE Name=:teamName LIMIT 1];
            System.assert(collabGroup.isEmpty());
        }
        
    }
}