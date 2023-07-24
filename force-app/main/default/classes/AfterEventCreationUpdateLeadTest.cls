@isTest
private class AfterEventCreationUpdateLeadTest {
    @isTest
    static void testAfterInsertTrigger() {
        // Create a test Lead
        Lead testLead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'Test Company',
            Status = 'Open'
        );
        insert testLead;

        // Create a test Event related to the Lead
        DateTime eventDateTime = DateTime.now().addDays(1); // Set the event date and time
        Event testEvent = new Event(
            Subject = 'Test Event',
            WhoId = testLead.Id,
            DurationInMinutes = 30,
            ActivityDateTime = eventDateTime
        );
        insert testEvent;

        // Retrieve the updated Lead from the database
        Lead updatedLead = [SELECT Id, Status FROM Lead WHERE Id = :testLead.Id];

        // Verify that the Lead's status is updated to "Contacted"
        System.assertEquals('Contacted', updatedLead.Status);
    }
}