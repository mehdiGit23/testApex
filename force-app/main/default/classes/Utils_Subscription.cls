/**
 * Created by Mohamed Mehdi ABDALLAOUI on 21/06/2021
 *
 * Cette classe contient les methodes necessaire pour modifier les souscriptions avec leurs parents.
 */
public with sharing class Utils_Subscription {
   
    public static void updateListeSubscription(List<SBQQ__Subscription__c> listSubs){
        // cette liste a pour but de modifier les parents
        List<SBQQ__Subscription__c> listSubscriptionToUpdate_parents = new List<SBQQ__Subscription__c>();
        Database.SaveResult [] updateResult = Database.update(listSubs, false);
        Logs.trace('Utils_Subscription','Update subscription chekc', 'update subscription');
            for (Database.SaveResult sub : updateResult)
            {
                // si la modification est un succes -> Construire la liste des souscriptions parents pour les modifier
                if (sub.isSuccess()  && isSubscribtionFieldsNotBlanck(sub) && sub.SBQQ__RequiredById__c != null && sub.SBQQ__Subscription__r.Status__c == Constants.ELEMENTS_MANQUANTS)
                {
                    sub.SBQQ__Subscription__r.Souscription_Conforme__c = true;
                    listSubscriptionToUpdate_parents.add(sub.SBQQ__Subscription__r);
                }
            }
        
        try{
            update listSubscriptionToUpdate_parents; 
        }catch(DmlException e){
            Logs.error('Utils_Subscription','update subscription parents', e);
        }
    }

    public  Boolean isSubscribtionFieldsNotBlanck(SBQQ__Subscription__c sub){
        return (sub.PromoterDescription__c != null && sub.FlowType__c != null && sub.ProductWorkflow__c != null
            && sub.ContractEmail__c != null && sub.CompanySiret__c != null && sub.CompanyName__c != null
            && sub.CompanyAddressStreet__c != null && sub.CompanyAddressZipcode__c != null && sub.CompanyAddressCity__c != null
            && sub.CompanyPhone__c != null && sub.ContactGender__c != null && sub.ContactFirstName__c != null 
            && sub.ContactLastName__c != null && sub.LeadPhone__c != null);
    }
}
