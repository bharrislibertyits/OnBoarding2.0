@isTest
public class TestDataFactory {
	
    public static User createTestUser(String firstName, String lastName) {
        Profile p = [SELECT ID FROM Profile WHERE Name='Standard User'];
        User newUser = new User();
        newUser.FirstName = firstName;
        newUser.LastName = lastName;
        newUser.IsActive = True;
        String testEmail = firstName + lastName + 'TEST@TEST.com';
        newUser.Username = testEmail;
        newUser.Email = testEmail;
        newUser.Alias = 'testuser';
        newUser.ProfileId = P.Id;
        newUser.LanguageLocaleKey = 'en_US';
        newUser.LocaleSidKey = 'en_US';
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.EmailEncodingKey = 'ISO-8859-1';
        
        return newUser;
    }
    
    public static agf__ADM_Scrum_Team__c createTestTeam(String teamName) {
        agf__ADM_Scrum_Team__c team1 = new agf__ADM_Scrum_Team__c();
        team1.Name = teamName;
        team1.agf__Active__c = True;
        
        return team1;
    }
    
    public static agf__ADM_Scrum_Team_Member__c createTestTeamMember(String firstName, String lastName, Id testUser, Id teamId) {
		agf__ADM_Scrum_Team_Member__c teamMember = new agf__ADM_Scrum_Team_Member__c();
        User testUser1 = createTestUser(firstName, lastName);
        teamMember.agf__Member_Name__c = testUser;
        teamMember.agf__Scrum_Team__c = teamId;
        
        return teamMember;
    }
}