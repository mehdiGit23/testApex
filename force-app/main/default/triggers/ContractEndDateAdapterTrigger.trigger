trigger ContractEndDateAdapterTrigger on SBQQ__Subscription__c (before insert, before update) {

    if(Trigger.isUpdate || Trigger.isInsert) {
        SouscriptionHelper.updateDateContracts(Trigger.new);
    } 
}