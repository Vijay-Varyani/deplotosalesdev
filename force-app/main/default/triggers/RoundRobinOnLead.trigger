trigger RoundRobinOnLead on Lead (before insert, before update) {
      
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
        //Get the Queue user details.
        List<Group> queues = [SELECT id, (SELECT id, UserOrGroupId FROM GroupMembers Order By ID ASC)
                                FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Technology_Queue']; 
        
        // Get the index of the last lead assigned user in the queue
        // getOrgDegaults() returns the record data
        Lead_Round_Robin_Assignment__c lrr = Lead_Round_Robin_Assignment__c.getOrgDefaults();
        Integer userIndex = (lrr.get('User_Index__c') == null || Integer.valueOf(lrr.get('User_Index__c'))< -1)
                             ? -1 : Integer.valueOf(lrr.get('User_Index__c'));
        
        if(queues.size() > 0 && queues.get(0).GroupMembers.size() > 0){
            Id queueId = queues.get(0).id;
            Integer groupMemberSize = queues.get(0).GroupMembers.size();
            for(lead le : Trigger.new){
                if(le.ownerId == queueId){
                    Integer leadUserIndex = (userIndex + 1) >= groupMemberSize ? 0 : userIndex + 1;
                     le.OwnerId = queues.get(0).GroupMembers.get(leadUserIndex).UserOrGroupId;
                     userIndex = leadUserIndex;
                }
            }
            // Update the custom settings user index with the last lead assigned user
            lrr.User_Index__c = userIndex;
            update lrr;
        }
    }
}