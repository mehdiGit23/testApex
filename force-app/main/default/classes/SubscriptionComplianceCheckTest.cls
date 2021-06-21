@isTest
private class SubscriptionComplianceCheckTest {

    @TestSetup
    static void makeData(){
        DataFactory.initBase();
    } 
    
    @isTest
    private static void testConformite() {
        
        Test.startTest();
        SubscriptionComplianceCheck batch = new SubscriptionComplianceCheck();
		Id batchId = Database.executeBatch(batch);
		Test.stopTest();
        
        System.assertNotEquals(0, [SELECT Id FROM SBQQ__Subscription__c WHERE Souscription_Conforme__c = true].size());
    }
}