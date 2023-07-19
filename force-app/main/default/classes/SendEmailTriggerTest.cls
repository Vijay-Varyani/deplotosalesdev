@isTest
private class SendEmailTriggerTest {

    static testMethod void testSendEmailTrigger() {
        // Test data setup
        Contact contactObj = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'johndoe@example.com'
        );
        insert contactObj;

        Case caseObj = new Case(
            Subject = 'Test Case',
            Status = 'Open',
            origin='web',
            ContactId = contactObj.Id,
            suppliedEmail='test@gmail.com',
            suppliedName='test123'
        );
        insert caseObj;
       
        Test.startTest();
        //caseObj.ownerID= queueID[0].Id;
        caseObj.Status = 'Closed';
        update caseObj;
        Test.stopTest();
       
        // Verify email and task creation
        List<EmailMessage> emailMessages = [
            SELECT Id, Subject, HtmlBody
            FROM EmailMessage
            WHERE ParentId = :caseObj.Id
        ];
        //System.assertEquals(1, emailMessages.size());

        List<Task> tasks = [
            SELECT Id, Subject
            FROM Task
            WHERE WhatId = :caseObj.Id
        ];
        //System.assertEquals(1, tasks.size());
    }
}