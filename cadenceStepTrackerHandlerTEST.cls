/**********************************************************
* Related Apex: cadenceStepTrackerTrigger, cadenceStepTrackerTriggerHandler, cadenceTrackerTrigger, cadenceTrackerTriggerHandler
**********************************************************/
@isTest
public class cadenceStepTrackerHandlerTEST {
    
    @isTest static void testActionCadenceStepTrackerEvent() {
        Test.enableChangeDataCapture();
        
        // Create mock CREATE ActionCadenceStepTrackerChangeEvent
        EventBus.ChangeEventHeader createHeader = new EventBus.ChangeEventHeader();
        createHeader.recordIds = new List<String>{ '8HFR00000005BfAOAU' }; // Mock Id
        createHeader.changeType='CREATE';
        createHeader.entityName='ActionCadence';
        createHeader.changeOrigin='user1-wsl';
        createHeader.transactionKey = 'key';
        createHeader.commitUser = 'user1';
        ActionCadenceStepTrackerChangeEvent createEvent = new ActionCadenceStepTrackerChangeEvent();
        createEvent.changeEventHeader = createHeader;
        createEvent.put('ActionCadenceId', '000000000000000000'); // Enter a Action Cadence Id 
        createEvent.put('ActionCadenceStepId', '000000000000000000'); // Enter a Action Cadence Step Id 
        createEvent.put('State', 'Active');
        createEvent.put('StepType', 'SendAnEmail');
        createEvent.put('StepTitle', 'Email');
        EventBus.publish(createEvent);
        Test.getEventBus().deliver();
        
        // Create mock UPDATE ActionCadenceStepTrackerChangeEvent
        EventBus.ChangeEventHeader updateHeader = new EventBus.ChangeEventHeader();
        updateHeader.recordIds = new List<String>{ '8HFR00000005BfAOAU' }; // Mock Id
        updateHeader.changeType='UPDATE';
        updateHeader.entityName='ActionCadence';
        updateHeader.changeOrigin='user1-wsl';
        updateHeader.transactionKey = 'key';
        updateHeader.commitUser = 'user1';
        ActionCadenceStepTrackerChangeEvent updateEvent = new ActionCadenceStepTrackerChangeEvent();
        updateEvent.changeEventHeader = updateHeader;
        updateEvent.put('State', 'Running');
        EventBus.publish(updateEvent);
        System.debug('ActionCadenceStepTrackerChangeEvent Id: ' + updateEvent.Id);
        Test.getEventBus().deliver();
        
        // Create mock CREATE ActionCadenceStepTracker
        EventBus.ChangeEventHeader mockHeader = new EventBus.ChangeEventHeader();
        mockHeader.recordIds = new List<String>{ '8HFR00000005BfAOAU' }; // Mock Id
        mockHeader.changeType='CREATE';
        mockHeader.entityName='ActionCadenceStepTracker';
        mockHeader.changeOrigin='user1-wsl';
        mockHeader.transactionKey = 'key';
        mockHeader.commitUser = 'user1';
        ActionCadenceStepTracker mockEvent = new ActionCadenceStepTracker();
        
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
        insert acc;

        /********** Create test records ***************************/
        List<Contact> contacts = new List<Contact>();
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
            Most_Recent_Cadence_Due_Date__c = datetime.now()
        );
        contacts.add(con);
        insert con;
        update con;
        update contacts;
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Co',
            Status = 'Open',
            Email = 'lead@test.com',
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
        insert lead;
        update lead;
        update leads;
        
        Test.startTest();
        cadenceStepTrackerHandler.testStepTrackers = new List<ActionCadenceStepTracker>{new ActionCadenceStepTracker(Id = mockEvent.Id)};
            cadenceStepTrackerHandler.updateContact(new List<ActionCadenceStepTrackerChangeEvent> {updateEvent});
        cadenceStepTrackerHandler.updateLead(new List<ActionCadenceStepTrackerChangeEvent> {updateEvent});
        Test.stopTest();        
        
        con = [SELECT Id, Most_Recent_Cadence_Id__c, Most_Recent_Cadence_Name__c, Most_Recent_Cadence_Step__c, Most_Recent_Cadence_Due_Date__c FROM Contact WHERE Id = :con.Id];
        System.assertEquals('Email', con.Most_Recent_Cadence_Step__c);
        lead = [SELECT Id, Most_Recent_Cadence_Id__c, Most_Recent_Cadence_Name__c FROM Lead WHERE Id = :lead.Id];
        System.assertEquals('Test Cadence', lead.Most_Recent_Cadence_Name__c);
    }
    
     @isTest static void testActionCadenceTrackerEvent() {
        Test.enableChangeDataCapture();
        
        // Create mock CREATE ActionCadenceTrackerChangeEvent
        EventBus.ChangeEventHeader createHeader = new EventBus.ChangeEventHeader();
        createHeader.recordIds = new List<String>{ '8HFR00000005BfAOAU' }; // Mock Id
        createHeader.changeType='CREATE';
        createHeader.entityName='ActionCadence';
        createHeader.changeOrigin='user1-wsl';
        createHeader.transactionKey = 'key';
        createHeader.commitUser = 'user1';
        ActionCadenceTrackerChangeEvent createEvent = new ActionCadenceTrackerChangeEvent();
        createEvent.changeEventHeader = createHeader;
        createEvent.put('ActionCadenceId', '77CR0000000ENXAMA4');
        createEvent.put('State', 'Active');
        EventBus.publish(createEvent);
        Test.getEventBus().deliver();
        
        // Create mock UPDATE ActionCadenceTrackerChangeEvent
        EventBus.ChangeEventHeader updateHeader = new EventBus.ChangeEventHeader();
        updateHeader.recordIds = new List<String>{ '8HFR00000005BfAOAU' }; // Mock Id
        updateHeader.changeType='UPDATE';
        updateHeader.entityName='ActionCadence';
        updateHeader.changeOrigin='user1-wsl';
        updateHeader.transactionKey = 'key';
        updateHeader.commitUser = 'user1';
        ActionCadenceTrackerChangeEvent updateEvent = new ActionCadenceTrackerChangeEvent();
        updateEvent.changeEventHeader = updateHeader;
        updateEvent.put('State', 'Running');
        EventBus.publish(updateEvent);
        System.debug('ActionCadenceTrackerChangeEvent Id: ' + updateEvent.Id);
        Test.getEventBus().deliver();
        
        // Create mock CREATE ActionCadenceTracker
        EventBus.ChangeEventHeader mockHeader = new EventBus.ChangeEventHeader();
        mockHeader.recordIds = new List<String>{ '8HFR00000005BfAOAU' }; // Mock Id
        mockHeader.changeType='CREATE';
        mockHeader.entityName='ActionCadenceTracker';
        mockHeader.changeOrigin='user1-wsl';
        mockHeader.transactionKey = 'key';
        mockHeader.commitUser = 'user1';
        ActionCadenceTracker mockEvent = new ActionCadenceTracker();

        /********** Create test records ***************************/
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
        insert acc;
        
        List<Contact> contacts = new List<Contact>();
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
            Most_Recent_Cadence_Due_Date__c = datetime.now()
        );
        contacts.add(con);
        insert con;
        update con;
        update contacts;
        
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Co',
            Status = 'Open',
            Email = 'lead@test.com',
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
        insert lead;
        update lead;
        update leads;
        
        Test.startTest();
        cadenceTrackerHandler.testStepTrackers = new List<ActionCadenceStepTracker>{new ActionCadenceStepTracker(Id = mockEvent.Id)};
            cadenceTrackerHandler.updateContact(new List<ActionCadenceTrackerChangeEvent> {updateEvent});
        cadenceTrackerHandler.updateLead(new List<ActionCadenceTrackerChangeEvent> {updateEvent});
        Test.stopTest();        
        
        con = [SELECT Id, Most_Recent_Cadence_Id__c, Most_Recent_Cadence_Name__c, Most_Recent_Cadence_Step__c, Most_Recent_Cadence_Due_Date__c FROM Contact WHERE Id = :con.Id];
        System.assertEquals('Email', con.Most_Recent_Cadence_Step__c);
        lead = [SELECT Id, Most_Recent_Cadence_Id__c, Most_Recent_Cadence_Name__c FROM Lead WHERE Id = :lead.Id];
        System.assertEquals('Test Cadence', lead.Most_Recent_Cadence_Name__c);
    }
}
