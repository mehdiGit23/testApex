trigger ContractEndDateAdapterTrigger on SBQQ__Subscription__c (before insert, before update) {
 
        SouscriptionHelper.updateDateContracts(Trigger.new);

}