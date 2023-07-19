@isTest
private class OpportunityApprovalControllerTest {
    @isTest
    static void testStartApprovalProcess() {
        // Create a test Opportunity record
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Needs Analysis',
            CloseDate = Date.today().addDays(30),
            Discount_Percentage__c = 0.2
        );
        insert testOpportunity;

        // Call the startApprovalProcess method
        Test.startTest();
        OpportunityApprovalController.startApprovalProcess(testOpportunity.Id);
        Test.stopTest();

        // Retrieve the updated Opportunity record
        Opportunity updatedOpportunity = [SELECT Id, StageName, Discount_Percentage__c FROM Opportunity WHERE Id = :testOpportunity.Id];

        // Assert the Opportunity field values
        //System.assertEquals(false, updatedOpportunity.Submit_for_Approval__c);
        // Add more assertions based on your requirements
    }
}