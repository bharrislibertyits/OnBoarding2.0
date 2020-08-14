@isTest
private class RemindContacts90DaysTest {
	public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void testScheduledJob() {
      User myUser 		      = new User();
	  myUser.FirstName 	       = 'QA';
	  myUser.LastName 	       = 'Tester';
	  myUser.Alias 		       = 'QATester';
	  myUser.Username 	       = 'Qa.Tester@isvedition.org.dev';
	  myUser.LocaleSidKey      = 'en_US';
	  myUser.LanguageLocaleKey = 'en_US';
	  myUser.EmailEncodingKey  = 'ISO-8859-1';
	  myUser.TimezoneSidKey    = 'GMT';
	  // Make user Profile ID is still valid
	  myUser.ProfileId         = '00e2E000001xjT5QAI';	  
	  // Must have Liberty in the email !
	  myUser.Email 			   = 'salesforce.admin@libertyits.com';

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
//        Test.stopTest();
      }      
      	        
       // create the Contact associated with the new user
      Contact ctct = New Contact(Lastname = 'Tester', Email = 'salesforce.admin@libertyits.com', user__c = myUser.id);
      System.runAs(new User(ID = UserInfo.getUserID())) {
        // create the contact
        insert ctct;     
      }               
       
//        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
                                      CRON_EXP,
                                      new RemindContacts90Days());
        
        Test.stopTest();
        
        Contact lc2 = [SELECT Id, Notification_90_Day_Send__c, Notification_90_Day_Sent_Date__c
              FROM Contact WHERE Id = :ctct.Id];
        System.assertEquals(False, lc2.Notification_90_Day_Send__c, '90 Day Send was true');
        
    }
}