@isTest
private class ContactTriggerHandlerTest {
  @isTest static void autoFollowOnTest() {
	  User myUser 		      = new User();
	  myUser.FirstName 	       = 'Bob';
	  myUser.LastName 	       = 'Tester';
	  myUser.Alias 		       = 'BTester';
	  myUser.Username 	       = 'Bob.Tester@isvedition.org.dev';
	  myUser.LocaleSidKey      = 'en_US';
	  myUser.LanguageLocaleKey = 'en_US';
	  myUser.EmailEncodingKey  = 'ISO-8859-1';
	  myUser.TimezoneSidKey    = 'GMT';
	  // Make user Profile ID is still valid
	  myUser.ProfileId         = '00e2E000001xjT5QAI';	  
	  // Must have Liberty in the email !
	  myUser.Email 			   = 'curt.olin@LibertyIts.com';

      // The current user cannot execute DML for setup and non-setup objects.
      // Doing so will cause a Mixed DML Exception
      // To fix this, we set the run user as a different user than the current user
      List<User> adminUser = [select Id, alias from user where alias LIKE 'admin%'];
        
      Id currentUserId = UserInfo.getUserID();
        
      Id runAsUser;
          
      for (User usr: adminUser){
        If (usr.id <> currentUserID)
          runAsUser = usr.id;
      }
          
      System.runAs(new User(ID = runAsUser)) {
        // create the user
        Test.startTest();
        insert myUser;
        Test.stopTest();
      }      
      	        
       // create the Contact associated with the new user
      Contact ctct = New Contact(Lastname = 'Tester', user__c = myUser.id);
      System.runAs(new User(ID = UserInfo.getUserID())) {
        // create the contact
        insert ctct;     
      }                     
            
      ctct.auto_follow__c = false;
      System.runAs(new User(ID = UserInfo.getUserID())) {
        update ctct;
      }
      
      // Auto Follow was set to false, so the user value should be false.
      User userAFOff = [SELECT UserPreferencesEnableAutoSubForFeeds FROM User WHERE ID = :myUser.Id LIMIT 1];   
      system.assertEquals(false, userAFOff.UserPreferencesEnableAutoSubForFeeds, 'Value was not set to false');   
      
      // This update should have no effect on auto follow
      ctct.city__c = 'Melbourne';
      System.runAs(new User(ID = UserInfo.getUserID())) {
        update ctct;
      }
      
      userAFOff = [SELECT UserPreferencesEnableAutoSubForFeeds FROM User WHERE ID = :myUser.Id LIMIT 1];   
      system.assertEquals(false, userAFOff.UserPreferencesEnableAutoSubForFeeds, 'Value did not remain false');
      
    }
}