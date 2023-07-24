@isTest
public class LeadApprovalControllerTest {
    @isTest
    static void testStartApprovalProcess() {
        // Create a test Lead record
        Lead leadRecord = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'Test Company',
            Status = 'Contacted'
        );
        insert leadRecord;

        // Call the startApprovalProcess method
        Test.startTest();
        LeadApprovalController.startApprovalProcess(leadRecord.Id);
        Test.stopTest();

        // Retrieve the updated Lead record
        Lead updatedLead = [SELECT Id, SubmitforApproval__c FROM Lead WHERE Id = :leadRecord.Id];

        // Assert that the Lead was submitted for approval
        System.assertEquals(true, updatedLead.SubmitforApproval__c);
    }
}