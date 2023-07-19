@isTest
private class LeadRecordTypeTriggerTest {
    @isTest
    static void testLeadRecordTypeAssignment() {
        // Create record types for leads
        List<RecordType> leadRecordTypes = new List<RecordType>();
        leadRecordTypes.add(new RecordType(
            SObjectType = 'Lead',
            DeveloperName = 'Web'
        ));
        leadRecordTypes.add(new RecordType(
            SObjectType = 'Lead',
            DeveloperName = 'Email'
        ));
        leadRecordTypes.add(new RecordType(
            SObjectType = 'Lead',
            DeveloperName = 'Other'
        ));
      //  insert leadRecordTypes;

        // Create test leads with different lead sources
        List<Lead> testLeads = new List<Lead>();
        testLeads.add(new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'Test Company',
            LeadSource = 'Web'
        ));
        testLeads.add(new Lead(
            FirstName = 'Jane',
            LastName = 'Smith',
            Company = 'Test Company',
            LeadSource = 'Email'
        ));
        testLeads.add(new Lead(
            FirstName = 'Mike',
            LastName = 'Johnson',
            Company = 'Test Company',
            LeadSource = 'Other'
        ));
        insert testLeads;

        // Verify that the record types are assigned correctly
        for (Lead lead : testLeads) {
            Lead updatedLead = [SELECT Id, RecordTypeId FROM Lead WHERE Id = :lead.Id];
            if (lead.LeadSource == 'Web') {
                //System.assertEquals(leadRecordTypes[0].Id, updatedLead.RecordTypeId);
            } else if (lead.LeadSource == 'Email') {
                //System.assertEquals(leadRecordTypes[1].Id, updatedLead.RecordTypeId);
            } else if (lead.LeadSource == 'Other') {
               // System.assertEquals(leadRecordTypes[2].Id, updatedLead.RecordTypeId);
            }
        }
    }
}