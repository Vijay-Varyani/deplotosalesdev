public with sharing class OpportunityController {
    @AuraEnabled
    public static void submitForApproval(Id oppId) {
        // Perform any necessary logic before initiating the approval process

        // Call the Approval.ProcessSubmitRequest class to initiate the approval process
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(oppId); // Set the Opportunity Id for which you want to initiate the approval process

        Approval.ProcessResult result = Approval.process(req);
        // Process the result or return it to the LWC component
    }
}