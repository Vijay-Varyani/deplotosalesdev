public with sharing class LeadApprovalController {
    @AuraEnabled
    public static Boolean isContactedStatus(Id leadId) {
        Lead leadRecord = [SELECT Id, Status FROM Lead WHERE Id = :leadId];
        return (leadRecord.Status == 'Contacted');
    }
    
    @AuraEnabled
    public static void startApprovalProcess(Id leadId) {
        // Query the lead record to ensure it exists and is in a state that can be submitted for approval
        Lead lead = [SELECT Id, Status, SubmitforApproval__c FROM Lead WHERE Id = :leadId];
        
        if (lead.Status == 'Contacted') {
            // Submit the lead for approval
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(leadId);
            Approval.ProcessResult result = Approval.process(req);
            
            // Perform any necessary actions based on the approval submission result
            // For example, you can check if the submission was successful and handle any errors
            if (result.isSuccess()) {
                lead.SubmitforApproval__c = true;
                update lead;
            } else {
                // Handle any errors or exceptions during the approval submission
            }
        }
    }
}