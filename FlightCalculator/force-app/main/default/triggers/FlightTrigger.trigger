trigger FlightTrigger on Flight__c (before update) {
    FlightTriggerService.instance.handle();
}