public with sharing class SouscriptionHelper {
    Boolean isTerminate;
    Date terminatedDate;
    Date endDate;
    List<SBQQ__Contract__c> listcontractsToUpdate = new List<SBQQ__Contract__c>();
    List<SBQQ__Subscription__c> listSubs = new List<SBQQ__Subscription__c>(); 

    public static void updateDateContracts( List<SBQQ__Subscription__c> listSub){
        Set<Id> associatedConId = new Set<Id>() ;
        for (SBQQ__Subscription__c sub : listSub) {
            associatedConId.add(sub.SBQQ__Contract__c) ;// check null
        }
        
        listSubs = [SELECT SBQQ__Contract__c,TechAmendmentReason__c, SBQQ__TerminatedDate__c,SBQQ__EndDate__c FROM SBQQ__Subscription__c WHERE SBQQ__Contract__c IN :associatedConId];
        try {
            for (SBQQ__Subscription__c sub : listSubs) {
                isTerminate = true;
                terminatedDate = sub.SBQQ__Contract__r.EndDate; //
                endDate = sub.SBQQ__Contract__r.EndDate;//

                SBQQ__Contract__c contrat = calculDate(sub , isTerminate, terminatedDate , endDate);
                
                listcontractsToUpdate.add(contrat);
            }
            update listcontractsToUpdate;
            Logs.trace('SouscriptionHelper','updateDateContracts', 'contracts updated');
        } catch (Exception e) {
            Logs.error('SubscriptionComplianceCheck','Batch Compliance Check', e);
        }
    }
    public static SBQQ__Contract__c calculDate(SBQQ__Subscription__c sub, Boolean isTerminate, Date terminatedDate, Date endDate){
        if (sub.SBQQ__TerminatedDate__c == null) {
            isTerminate = false;
        } else if (terminatedDate < sub.SBQQ__TerminatedDate__c) {
            terminatedDate = sub.SBQQ__TerminatedDate__c;
        }
        
        if (sub.SBQQ__EndDate__c != null && endDate < sub.SBQQ__EndDate__c) {
            endDate = sub.SBQQ__EndDate__c;
        }
            
        if (isTerminate) {
            sub.SBQQ__Contract__r.EndDate = terminatedDate;
        } else {
            sub.SBQQ__Contract__r.EndDate = endDate;
        }
        Logs.trace('SouscriptionHelper','calculDate', 'Calcul endDate of contract');

        return sub.SBQQ__Contract__r;
    }

}
