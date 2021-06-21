/**
 * updated by Mohamed Mehdi on 20/06/2021
 *
 */
global class SubscriptionComplianceCheck implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext cnx) { 
        return Database.getQueryLocator(
                'SELECT Id, CompanyAddressCity__c, OrderNumber__c, CompanyAddressCountry__c, CompanyPhone__c, ContactGender__c, ContactLastName__c,'+ 
                 'ContactFirstName__c, Companyindustry__c, CompanyName__c, PrintVolume__c, BroadcastSoftware__c, PromoterDescription__c, SBQQ__RequiredById__c,'+ 
                 'FlowType__c, BroadcastPartner__c, PostalCode__c, Souscription_Conforme__c, ComplianceProcess__c, Status__c, AccessStoreState__c, '+ 
                 'ProductWorkflow__c, AccessUserId__c, KilometerRadius__c, AccessStoreId__c, CompanyAddressStreet__c, CompanyAddressZipcode__c, LeadPhone__c,'+ 
                 'ContractEmail__c, CompanySegment__c, CompanySiret__c,'+ 
                 'SBQQ__Subscription__r.Souscription_Conforme__c, SBQQ__Subscription__r.Status__c'+ 
                  'FROM SBQQ__Subscription__c WHERE Status__c = '+Constants.ELEMENTS_MANQUANTS+ 
                 ' AND Souscription_Conforme__c = false');
    }
    
    global void execute(Database.BatchableContext cnx, List<SBQQ__Subscription__c> scope) {
        // Liste qui contient les souscriptions --> utilisée afin de modifier Souscription_Conforme__c
        List<SBQQ__Subscription__c> listSubscriptionToUpdate = new List<SBQQ__Subscription__c>();

        try {
            List<SBQQ__Subscription__c> subs = new List<SBQQ__Subscription__c>();
            for(SBQQ__Subscription__c sub : scope) {
               if (sub.ComplianceProcess__c == Constants.IMMO_NEUF) {
                    //Modification de la conformité
                    sub.Souscription_Conforme__c = true;
                    
                    listSubscriptionToUpdate.add(sub);
                }
            }
            Logs.trace('SubscriptionComplianceCheck','updating subscription', 'Begin of updating subscription');
            //Modification des souscriptions

            Utils_Subscription.updateListeSubscription(listSubscriptionToUpdate);
       
        } catch(Exception e) {
            Logs.error('SubscriptionComplianceCheck','Batch Compliance Check', e);
        }
    }
    
    global void finish(Database.BatchableContext cnx) {
            Logs.trace('SubscriptionComplianceCheck','finish batch ', 'sending email to the Apex job s submitter');

            // le corps de cette methode je l'ai copié depuis la doc de SF ça permet d envoyer par mail les erreurs de batch

           // Get the ID of the AsyncApexJob representing this batch job
            // from Database.BatchableContext.
            // Query the AsyncApexJob object to retrieve the current job's information.
            AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =
            :BC.getJobId()];
            // Send an email to the Apex job's submitter notifying of job completion.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Apex Sharing Recalculation ' + a.Status);
            mail.setPlainTextBody
            ('The batch Apex job processed ' + a.TotalJobItems +
            ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}
