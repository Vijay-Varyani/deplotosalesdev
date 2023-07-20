@isTest
private class CreateEmailToLeadTest {
    @isTest
    static void testHandleInboundEmail() {
        // Create a test InboundEmail and InboundEnvelope
        Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
        testEmail.plainTextBody = 'Name: John Doe\nEmail: john.doe@example.com\nPhone: 1234567890';

        Messaging.InboundEnvelope testEnvelope = new Messaging.InboundEnvelope();
        testEnvelope.fromAddress = 'john.doe@example.com';

        // Call the handleInboundEmail method
        CreateEmailToLead createEmailToLeadHandler = new CreateEmailToLead();
        Messaging.InboundEmailResult result = createEmailToLeadHandler.handleInboundEmail(testEmail, testEnvelope);

        // Assert the outcome
        System.assertEquals(true, result.success);

        // Query the created Lead record
        List<Lead> leads = [SELECT Id, LastName, Email, Company, Phone FROM Lead];
        System.assertEquals(1, leads.size());

        Lead createdLead = leads[0];

        // Assert the Lead field values
        System.assertEquals('John Doe', createdLead.LastName);
        System.assertEquals('john.doe@example.com', createdLead.Email);
        System.assertEquals('From Email', createdLead.Company);
        System.assertEquals('1234567890', createdLead.Phone);
    }
}