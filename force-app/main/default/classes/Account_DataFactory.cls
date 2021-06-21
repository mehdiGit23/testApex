@isTest
public with sharing class Account_DataFactory {
    public static Account createAccount(String AccountName, String phone, String siret) {
        
    	Account res = new Account(
            Name = AccountName, 
            Phone = phone,
            CompanySiretNumber__c = siret,
        	BillingStreet = '00 SomeWhere',
        	BillingCity = 'SinCity',
        	BillingCountry = 'France',
        	BillingPostalcode = '75000');        

        insert res;
        
        return res;
    }
}