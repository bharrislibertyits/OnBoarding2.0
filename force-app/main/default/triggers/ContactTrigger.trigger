trigger ContactTrigger on Contact (before insert, before update) {
  
  ContactTriggerHandler handler = new ContactTriggerHandler(Trigger.isexecuting);
    
  /* Before Update */
  if(Trigger.isUpdate && Trigger.isBefore){
    ContactTriggerHandler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap);
  }
}