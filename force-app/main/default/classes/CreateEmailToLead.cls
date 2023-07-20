global class CreateEmailToLead implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                           Messaging.InboundEnvelope env){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

        String myPlainText = email.plainTextBody;
        String name = '';
        String emailAddress = '';
        String phone = '';

        // Extract the name, email, and phone from the email plain text
        // You can implement your own logic to extract these values based on the email format
        // Here's a simple example assuming the name, email, and phone are on separate lines:
        String[] lines = myPlainText.split('\n');
        for (String line : lines) {
            if (line.contains('Name:')) {
                name = line.substring(line.indexOf(':') + 1).trim();
            } else if (line.contains('Email:')) {
                emailAddress = line.substring(line.indexOf(':') + 1).trim();
            } else if (line.contains('Phone:')) {
                phone = line.substring(line.indexOf(':') + 1).trim();
            }
        }

        // Check for existing leads with the captured email address
        Lead[] leads = [SELECT Id, Name, Email FROM Lead WHERE Email = :emailAddress];

        if (leads.size() == 0) {
            // Create a new Lead object with the captured values
            Lead newLead = new Lead(Email = emailAddress, LastName = name, Company = 'From Email', Phone = phone);

            // Insert the new lead
            insert newLead;

            System.debug('New Lead record: ' + newLead);
        } else {
            System.debug('Incoming email duplicates existing Lead record(s): ' + leads);
        }

        result.success = true;
        return result;
    }
}