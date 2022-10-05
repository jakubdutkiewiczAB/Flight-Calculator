/**
 * Service class for FlightTrigger
 * 
 * @author Jakub Dutkiewicz
 * @created 04.10.2022
 */
public with sharing class FlightTriggerService extends FlightTriggerHandler{
    
    private FlightTriggerService() {}

    public static FlightTriggerService instance {
        get {
            if (instance == null) {
                instance = new FlightTriggerService();
            }
            return instance;
        }
        private set;
    }

    public override void beforeUpdate() {
        FlightService.calculateFlights(Trigger.new, (Map<Id, Flight__c>) Trigger.oldMap);
    }
}