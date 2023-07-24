@isTest
private class SendEmailToQueueMemberandTaskCreatedTest {
    @isTest
    static void testTaskCreated() {
        // Test data setup
        Case c = new Case(Subject='Test Case', Priority='High');
        insert c;

        // Call the method being tested
        SendEmailToQueueMemberandTaskCreated.taskCreated(new List<Case>{c});

        // Verify the results
        List<Task> tasks = [SELECT Id, Subject, Priority, ActivityDate,Status FROM Task WHERE WhatId = :c.Id];
        System.assertEquals(1, tasks.size());
        System.assertEquals(c.Subject, tasks[0].Subject);
        System.assertEquals(c.Priority, tasks[0].Priority);
        System.assertEquals(Date.today(), tasks[0].ActivityDate);
        System.assertEquals('Not Started', tasks[0].Status);
    }
    
    @isTest
    static void testSendEmailToQueueMembers() {
        // Test data setup
        Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User u = new User();
        u.Username = 'vrai@123.com';
        u.FirstName = 'John';
        u.LastName = 'Doe';
        u.Email = 'john.doe@example.com';
        u.Alias = 'jdoe'; // required field
        u.TimeZoneSidKey = 'America/New_York'; // required field
        u.LocaleSidKey = 'en_US'; // required field
        u.EmailEncodingKey = 'UTF-8'; // required field
        u.ProfileId = p.Id; // required field - replace with the actual Profile ID
        u.LanguageLocaleKey = 'en_US';
        insert u;
        
        Group g = new Group(Name='Test Group');
        insert g;
        
        GroupMember gm1;
        System.runAs(u) {
            gm1 = new GroupMember(UserOrGroupId=u.Id, GroupId=g.Id);
            insert gm1;
        }
        
        Case c = new Case(Subject='Test Case', OwnerId=g.Id);
        insert c;
        
        Test.startTest();
        System.runAs(u) {
            SendEmailToQueueMemberandTaskCreated.SendEmailToQueueMembers(new List<Case>{c});
        }
        Test.stopTest();
        
        // Verify the results
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        // Create a new email message
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        // Set the email fields
        email.setToAddresses(new List<String>{'test@example.com'});
        email.setSubject('Test Email');
        email.setPlainTextBody('This is a test email.');
        
        // Add the email to the list
        emailMessages.add(email);
        
        // Send the email
        Messaging.SendEmailResult[] emails = Messaging.sendEmail(emailMessages);
        System.assertEquals(2, emails.size());
    }
}