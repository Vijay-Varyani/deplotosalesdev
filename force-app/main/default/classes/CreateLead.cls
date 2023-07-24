global class CreateLead implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope env){
       
        Messaging.InboundEmailResult result=new Messaging.InboundEmailResult();
     	
        List<Lead> LeadsToInsert = new List<Lead>();
        
        //List<String> lstLines = new List<String>();
        Lead instanceLead = new Lead();
        
        /*String emailText = email.plainTextBody;
        String afterRequestedBy = emailText.substringAfter('Requested by:');
        String requestedBy = afterRequestedBy.substringBefore('\n');
        requestedBy = requestedBy.trim();
        
        String middleContent = afterRequestedBy.substringAfter('\n');
		lstLines = middleContent.split('\n');
        String temp;

        for(String line: lstLines) {
            if(line.contains('Company:')){
               instanceLead.Company = temp.trim();
            }
        }*/
        instanceLead.FirstName = email.fromName.substring(0,email.fromName.indexOf(''));
        instanceLead.LastName = email.fromName.substring(email.fromAddress.indexOf(''));
        instanceLead.Company = 'MindzVue';
        instanceLead.Title = email.subject;

        instanceLead.LeadSource = 'Email';
        instanceLead.Status = 'Open';
        instanceLead.Email = env.fromAddress;
        LeadsToInsert.add(instanceLead);
        insert LeadsToInsert;
        return result;
       } 
        
               
        
        /* Old Code Below*/  
        
        //String[] Name    = email.plainTextBody.split(',');
        /*String myPlainText='';
        String mySubjectText='';
        
        myPlainText = email.plainTextBody;
        mySubjectText = email.subject;
        String Company = mySubjectText.substringAfter('-');
        
        Lead led=new Lead();
        led.FirstName = email.fromname.substring(0,email.fromname.indexof(' '));
        led.LastName = email.fromName.substringAfterLast(' ');
        led.Company = email.plainTextBody.substringAfterLast(' ');
        led.LeadSource = 'Email';
        led.Title = 'Email To Lead';
        led.Email = env.fromAddress;
        insert led;
        return result;

        Old Code Ends*/
    }