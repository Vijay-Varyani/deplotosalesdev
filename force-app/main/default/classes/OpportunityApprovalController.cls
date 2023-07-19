public with sharing class OpportunityApprovalController {
    @AuraEnabled
    public static void startApprovalProcess(Id opportunityId) {
        // Query Opportunity record to perform necessary checks
        Opportunity opportunityRecord = [SELECT Id, StageName, Discount_Percentage__c FROM Opportunity WHERE Id = :opportunityId];
        
        // Perform checks or validation before starting the approval process
        if (opportunityRecord.StageName != 'Needs Analysis' || opportunityRecord.Discount_Percentage__c <= 0.1) {
            throw new AuraHandledException('Opportunity is not eligible for approval');
        }
        
        // Start the approval process
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(opportunityId);
        Approval.ProcessResult result = Approval.process(req);
        
        // Handle the result as per your requirements
        if (result.isSuccess()) {
            // Process submitted successfully
        } else {
            // Handle errors or exceptions during the approval submission
        }
    }
}