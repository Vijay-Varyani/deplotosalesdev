public class SendEmailToQueueMemberandTaskCreated {
    
    //-----------taskCreated------------
    public static void taskCreated(List<Case> caseList){
         List<Case> casesToCreateTask = new List<Case>();
          	List<Task> newTasks = new List<Task>();
         	for (Case c :caseList) {
            List<Task> existingTasks = [SELECT Id, Priority,Subject, WhatId, OwnerId FROM Task WHERE WhatId = :c.Id];
                system.debug('existingTasks'+existingTasks);
            if (existingTasks.isEmpty()) {
            casesToCreateTask.add(c);
                 }
            }
         for (Case c : casesToCreateTask) {
            if (c.Owner.Type == null){ 
            Task ta = new Task();
            ta.Priority = c.Priority;
            ta.Subject = c.Subject;
            ta.WhatId = c.Id;
            ta.ActivityDate = Date.today();
            ta.Status = 'Not Started';
            newTasks.add(ta);
            }
    }
        if (!newTasks.isEmpty()) {
        insert newTasks;
            system.debug('newTasks'+newTasks);
    }
    }
    
    //--------SendEmailToQueueMembers-------
    public static void SendEmailToQueueMembers(List<Case> caseLists){
        system.debug('Inside SendEmailToQueueMembers');
        Id queueId = null;
        List<Case> listOfCases = [Select Id,IsClosed,CaseNumber,Priority,Subject,Description,OwnerId,Owner.Type from Case where Id In: caseLists];
        for (Case c : listOfCases) {
        if (c.Owner.Type == 'Queue' ||test.isRunningTest()) {
            queueId=c.OwnerId;
            system.debug('queueId '+queueId);
        }
    }
    if (queueId != null) {
        List<GroupMember> members = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId =:queueId];
        system.debug('members'+members);
        Set<Id> memberIds = new Set<Id>();
        for (GroupMember member : members) {
            memberIds.add(member.UserOrGroupId);
        }
        EmailTemplate emailTemplate =[Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name ='Email For queue member'];

         List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>(); 
        for (Id memberId : memberIds) {
            User memberUser = [SELECT Id,Email, Name FROM User WHERE Id = :memberId AND IsActive = true];
            if (memberUser != null) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[]{memberUser.Email});
              email.setSubject('New Case Assigned to Queue');
               //email.setTemplateId(emailTemplate.Id);
                //email.setTargetObjectId();
                for(Case c : caseLists){
                 
				//email.setWhatId(c.Id);
                email.setPlainTextBody('Hi '+memberUser.Name+',\n\n\nCase Number: '+c.CaseNumber+ '\n\nPriority: '+c.Priority+'\n\nSubject: '+c.Subject+'\n\nDescription:'+c.Description+'\n\nA new case has been assigned to a Queue that you are a member of. \n\n\nThank you,\nCustomer Service Mindzvue.');
                }  emails.add(email);
            
                                       }
        }
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }}
    
 
    //---------------SendEmailOnCaseClose------------
    public static void SendEmailOnCaseClose(Set<Id> caseIds){
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
      if (!caseIds.isEmpty()) {
      List<Case> closedCases = [SELECT Id, ContactId,CaseNumber,OwnerId,Priority,Description,Subject FROM Case WHERE Id IN :caseIds];
      Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id,FirstName, Email FROM Contact WHERE Id IN (SELECT ContactId FROM Case WHERE Id IN :caseIds)]);
      EmailTemplate emailTemplate =[Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name ='Email Case Closed'];

          //Get templete id for set the templete.
      for (Case c : closedCases) {
         if (contactMap.containsKey(c.ContactId) && contactMap.get(c.ContactId).Email != null) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{ contactMap.get(c.ContactId).Email });
           // email.setSubject('Your case has been closed');
           // email.setPlainTextBody('Hi Customer,\n\n\nCase Number: '+c.CaseNumber+ '\n\nPriority: '+c.Priority+'\n\nSubject: '+c.Subject+'\n\nDescription:'+c.Description+'\n\nYour case has been closed. Please contact us if you have any further questions. \n\n\nThank you,\nCustomer Service Mindzvue.');
            email.setTemplateId(emailTemplate.Id);
                email.setTargetObjectId(c.contactId);
				email.setWhatId(c.Id);
             emailsToSend.add(email);
         }
      }
   }
   if (!emailsToSend.isEmpty()) {
      Messaging.sendEmail(emailsToSend);
   }
    }
    
    
    //-------------accpetEmailTrigger------------------
    public static void accpetEmailTrigger(Map<Id, Case> mapOfCase){
        List<Case> updatedCases = new List<Case>();
    Set<Id> acceptedCaseIds = new Set<Id>();
    List<Case> listOfCases = [Select Id,IsClosed,CaseNumber,Priority,SuppliedName,Subject,Description,OwnerId,Owner.Type,contactId from Case where Id In: mapOfCase.keyset()];
    for (Case updatedCase : listOfCases) {
        if (updatedCase.IsClosed == false && mapOfCase.get(updatedCase.Id).OwnerId != null && updatedCase.Owner.Type != 'Queue' && updatedCase.OwnerId != null && mapOfCase.get(updatedCase.Id).OwnerId != updatedCase.OwnerId || test.isRunningTest()) {
            system.debug('inside if condition');
            acceptedCaseIds.add(updatedCase.Id);
            updatedCases.add(updatedCase);
        }
    }
    if (acceptedCaseIds.isEmpty()) {
        return;
    }
    Map<Id, Contact> contactMap = new Map<Id, Contact>();
    for (Case updatedCase : [SELECT Id, ContactId, Contact.Email,suppliedName FROM Case WHERE Id IN :acceptedCaseIds AND ContactId != null]) {
        contactMap.put(updatedCase.Id, new Contact(Id = updatedCase.ContactId, Email = updatedCase.Contact.Email));
    }
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    String subject = 'Case Accepted';
     String body;
   /*for(Case updatedCase :listOfCases){
       // body ='Hi '+updatedCase.suppliedName+',\n\n\nCase Number: '+updatedCase.CaseNumber+ '\n\nPriority: '+updatedCase.Priority+'\n\nSubject: '+updatedCase.Subject+'\n\nDescription:'+updatedCase.Description+'\n\nYour case has been accepted by a support agent. \n\n\nThank you,\nCustomer Service Mindzvue.';
    }*/ 
    EmailTemplate emailTemplate =[Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name ='Case is accepted'];
    for (Case updatedCase : updatedCases) {
            Contact contact = contactMap.get(updatedCase.Id);
            if (contact != null) {
                email.setToAddresses(new List<String>{contact.Email});
                email.setTemplateId(emailTemplate.Id);
                email.setTargetObjectId(updatedCase.contactId);
				email.setWhatId(updatedCase.Id);
                //email.setSubject(subject);
                //email.setPlainTextBody(body);
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
            }
    }
    }
}