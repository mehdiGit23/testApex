public with sharing class Subsription_Compliance_Pub_check implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext cnx) { 
        return Database.getQueryLocator(
                'SELECT Id, ComplianceProcess__c, EffectiveEndDate__c, MissingInformations__c FROM SBQQ__Subscription__c WHERE ComplianceProcess__c = '+Constants.CONFORMITE_PUB);
    }
    global void execute(Database.BatchableContext cnx, List<SBQQ__Subscription__c> scope) {
        for(SBQQ__Subscription__c sub : scope) {
            if(sub.EffectiveEndDate__c <= Date.Today()){
               // sub.EffectiveEndDate__c.addError('La date doit être supérieur à la date du jour');
            }
            if(isBlank(sub.MissingInformations__c)){
                //
            }
        }
    }
    global void finish(Database.BatchableContext cnx) {}
}
