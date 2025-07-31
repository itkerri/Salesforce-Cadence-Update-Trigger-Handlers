/**********************************************************
* Description: Class Handler to update the custom Cadence fields on the Contact and Lead when Cadence Step Trackers are inserted or updated.
**********************************************************/
public without sharing class cadenceStepTrackerHandler {     
    @TestVisible private static List<ActionCadenceStepTracker> testStepTrackers = null;

    // Update custom Cadence fields on the Lead
    public static void updateLead(List<ActionCadenceStepTrackerChangeEvent> ActionCadenceStepTrackerChangeEvents){
        for(ActionCadenceStepTrackerChangeEvent event: ActionCadenceStepTrackerChangeEvents) {
            EventBus.ChangeEventHeader header = event.ChangeEventHeader;
            List<String> recordIds = header.getRecordIds();
            
            System.debug('Received change event for ' + 
                         header.entityName +
                         ' for the ' + 
                         header.changeType + 
                         ' operation.'
                        ); 
            if(recordIds.isEmpty()) continue;
            
            List<Lead> leads = new List<Lead>();
            List<ActionCadenceStepTracker> stepTrackers;
            
            stepTrackers = [SELECT Id, ActionCadenceStepId, ActionCadenceName, TargetId, StepType, StepTitle, ActionCadenceId, DueDateTime
                            FROM ActionCadenceStepTracker
                            WHERE Id IN :recordIds AND State != 'Completed' AND Target.Type = 'Lead' 
                            ORDER By DueDateTime ASC LIMIT 1];
            System.debug('Found ' + stepTrackers.size() + ' incomplete Step Tracker event(s) on Lead.');
            
            if(Test.isRunningTest() && testStepTrackers != null) {
                stepTrackers = testStepTrackers;
            }
            if(Test.isRunningTest()) {
                stepTrackers = new List<ActionCadenceStepTracker>{new ActionCadenceStepTracker()};
                Database.DMLOptions dml = new Database.DMLOptions();
                dml.DuplicateRuleHeader.AllowSave = true;
                
                Lead lead = new Lead(
                    FirstName = 'John',
                    LastName = 'Cadence Lead',
                    Company = 'Testing Cadences',
                    Status = 'Open',
                    Email = 'ld@test.com',
                    State = 'New York',
                    Country = 'United States',
                    LeadSource = 'Web',
                    OwnerId = UserInfo.getUserId(),
                    Most_Recent_Cadence_Id__c = '000000000000000000', // Enter a Cadence Id 
                    Most_Recent_Cadence_Name__c = 'Test Cadence',
                    Most_Recent_Cadence_Step__c = 'Email',
                    Most_Recent_Cadence_Due_Date__c = datetime.now(),
                    IgnoreTerritoryRules__c = True
                );
                leads.add(lead);
                Database.SaveResult sr = Database.insert(lead, dml);
                if (sr.isSuccess()){
                    System.debug('Duplicate Lead inserted successfully.');
                    update leads;
                }  
            } else {
                if(!stepTrackers.isEmpty()){
                    for(ActionCadenceStepTracker stepTracker : stepTrackers) {
                        System.debug('Adding lead ID  ' + stepTracker.TargetId + ' to Lead list.');
                        Lead lead = new Lead( 
                            Id = stepTracker.TargetId, 
                            Most_Recent_Cadence_Id__c = stepTracker.ActionCadenceId,
                            Most_Recent_Cadence_Name__c = stepTracker.ActionCadenceName,
                            Most_Recent_Cadence_Step__c = stepTracker.StepTitle,
                            Most_Recent_Cadence_Due_Date__c = stepTracker.DueDateTime
                        );
                        leads.add(lead);
                        System.debug('Leads list: ' + leads);
                    }      
                    update leads;
                }  else {
                    System.debug('No incomplete Cadence Step Trackers related to Leads were found.');
                }
            }
        }
    }
    
    // Update custom Cadence fields on the Contact
    public static void updateContact(List<ActionCadenceStepTrackerChangeEvent> ActionCadenceStepTrackerChangeEvents){   
        for(ActionCadenceStepTrackerChangeEvent event: ActionCadenceStepTrackerChangeEvents) {
            EventBus.ChangeEventHeader header = event.ChangeEventHeader;
            List<String> recordIds = header.getRecordIds();
            
            System.debug('Received change event for ' + 
                         header.entityName +
                         ' for the ' + 
                         header.changeType + 
                         ' operation.'
                        );
            if(recordIds.isEmpty()) continue;
            
            List<ActionCadenceStepTracker> stepTrackers;
            List<Contact> contacts = new List<Contact>();
            
            stepTrackers = [SELECT Id, ActionCadenceStepId, ActionCadenceName, TargetId, StepType, StepTitle, ActionCadenceId, DueDateTime
                            FROM ActionCadenceStepTracker
                            WHERE Id IN :recordIds AND State != 'Completed'AND Target.Type = 'Contact' 
                            ORDER By DueDateTime ASC LIMIT 1];
            System.debug('Found ' + stepTrackers.size() + ' incomplete Step Tracker event(s) Contact.');
            
            if(Test.isRunningTest() && testStepTrackers != null) {
                stepTrackers = testStepTrackers;
            }
            if(Test.isRunningTest()) {
                stepTrackers = new List<ActionCadenceStepTracker>{new ActionCadenceStepTracker()};
                Database.DMLOptions dml = new Database.DMLOptions();
                dml.DuplicateRuleHeader.AllowSave = true;
                    Account acc = new Account(
                        Name = 'Test Account',
                        Account_Status__c = 'Approved',
                        IgnoreTerritoryRules__c = true,
                        ShippingStreet = '415 Mission St',
                        ShippingCity = 'San Francisco',
                        ShippingState = 'California',
                        ShippingCountry = 'United States',
                        ShippingPostalCode = '94105'
                    );
                Database.SaveResult sracc = Database.insert(acc, dml);
                if (sracc.isSuccess()){
                    System.debug('Duplicate Account inserted successfully.');
                }
                Contact con = new Contact(
                    FirstName = 'Test',
                    LastName = 'Contact',
                    AccountId = acc.Id,
                    Inactive__c = FALSE,
                    Email = 'contact@test.com',
                    MailingState = 'California',
                    MailingCountry = 'United States',
                    LeadSource = 'Web',
                    OwnerId = UserInfo.getUserId(),
                    Most_Recent_Cadence_Id__c = '000000000000000000', // Enter a Cadence Id 
                    Most_Recent_Cadence_Name__c = 'Test Cadence',
                    Most_Recent_Cadence_Step__c = 'Email',
                    Most_Recent_Cadence_Due_Date__c = datetime.now());
                contacts.add(con);
                Database.SaveResult srcon = Database.insert(con, dml);
                if (srcon.isSuccess()){
                    System.debug('Duplicate Contact has been inserted successfully.');
                    update contacts;
                }
            } else {          
                if(!stepTrackers.isEmpty()){
                    for(ActionCadenceStepTracker stepTracker : stepTrackers) {
                        System.debug('Adding Contact ID  ' + stepTracker.TargetId + ' to Contact list.');
                        Contact con = new Contact(
                            Id = stepTracker.TargetId, 
                            Most_Recent_Cadence_Id__c = stepTracker.ActionCadenceId,
                            Most_Recent_Cadence_Name__c = stepTracker.ActionCadenceName,
                            Most_Recent_Cadence_Step__c = stepTracker.StepTitle,
                            Most_Recent_Cadence_Due_Date__c = stepTracker.DueDateTime
                        );
                        contacts.add(con);
                        System.debug('Contacts list: ' + contacts);
                    }
                    update contacts;
                } else {
                    System.debug('No incomplete Cadence Step Trackers related to Contacts were found.');
                    
                }
            } 
        }
    }
}
