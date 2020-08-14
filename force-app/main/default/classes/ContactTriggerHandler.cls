public with sharing class ContactTriggerHandler {

    private boolean m_isExecuting = false;

    public ContactTriggerHandler(boolean isExecuting){
        m_isExecuting = isExecuting;
    }

    public static void OnBeforeUpdate(Contact[] oldObjects, Contact[] updatedObjects, Map<Id, Contact> oldContactMap){
        // BEFORE UPDATE LOGIC
      Set<Id> UserIds = new Set<Id>();
      Map<Id,Boolean> UsrAF = new Map<Id, Boolean>();        

      // This should either be someone changing this value for themselves or an Admin
      for (Contact c : updatedObjects) {
          if (c.User_Id__c != null & c.Auto_Follow__c <> oldContactMap.get(c.id).Auto_Follow__c) {
            UserIds.add(c.User_Id__c);
            UsrAF.put(c.User_Id__c, c.Auto_Follow__c);
          }
      }

      if (UserIds.size() > 0) {
        List<User> users = [select id, UserPreferencesEnableAutoSubForFeeds from User where Id in :UserIds];
        for (User u : users) {
          u.UserPreferencesEnableAutoSubForFeeds = UsrAF.get(u.id);
        }        
        update users;
      }        
    }     
}