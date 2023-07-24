trigger LeadRecordTypeTrigger on Lead (before insert) {
    // Get the record type IDs for leads
    Map<String, Id> recordTypeIds = new Map<String, Id>();
    for (RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead']) {
        recordTypeIds.put(rt.DeveloperName, rt.Id);
    }

    // Iterate through the new leads
    for (Lead lead : Trigger.new) {
        if (lead.LeadSource == 'Web') {
            // Assign the Web-to-Lead record type
            Id recordTypeId = recordTypeIds.get('Web');
            if (recordTypeId != null) {
                lead.RecordTypeId = recordTypeId;
            }
        } else if (lead.LeadSource == 'Email') {
            // Assign the Email-to-Lead record type
            Id recordTypeId = recordTypeIds.get('Email');
            if (recordTypeId != null) {
                lead.RecordTypeId = recordTypeId;
            }
             } else if (lead.LeadSource == 'Other') {
            // Assign the Email-to-Lead record type
            Id recordTypeId = recordTypeIds.get('Other');
            if (recordTypeId != null) {
                lead.RecordTypeId = recordTypeId;
            }
        }
    }
}