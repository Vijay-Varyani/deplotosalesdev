trigger PreventLeadStatusManualUpdate on Lead (before update) {
    if(trigger.isbefore && trigger.isupdate){
        Event ev = new Event();
        for(Lead ld : Trigger.new){
            String s1 = String.valueOf(ev.WhoId);
            System.debug(s1);
            system.assert(s1.startsWith('00Q'));
            
            if(ev.WhoId != s1 && ld.Status == 'Contacted'){
                ld.addError('Cannot update status manually to contacted');
            }
        }
    }
}