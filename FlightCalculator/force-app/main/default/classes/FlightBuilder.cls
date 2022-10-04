/**
 * Builder class for Flight__c sObject
 * 
 * @author Jakub Dutkiewicz
 * @created 04.10.2022
 */
global with sharing class FlightBuilder {
    
    @AuraEnabled 
    global Decimal distance;
    @AuraEnabled 
    global String name;
    @AuraEnabled
    global String departureName;
    @AuraEnabled
    global String arrivalName;

    global FlightBuilder(){}

    /**
     * @description Builder method to copy Flight__c record
     * 
     * @author Jakub Dutkiewicz
     * @created 04.10.2022
     * 
     * @param Flight__c object to be cloned
     * @return cloned Flight__c object
     */
    global FlightBuilder cloneFlight(Flight__c flight) {
        this.distance = flight.FlightDistance__c;
        this.name = flight.Name;
        return this;
    }

    /**
     * @description Builder method to set airports names
     * 
     * @author Jakub Dutkiewicz
     * @created 04.10.2022
     * 
     * @param departureName name of the departure
     * @param arrivalName name of the arrival
     * @return Flight__c object with departure and arrival names
     */
    global FlightBuilder setNamesOnFlight(String departureName, String arrivalName) {
        this.departureName = departureName;
        this.arrivalName = arrivalName;
        return this;
    }

     /**
     * @description Builder method to get FlightBuilder record
     * 
     * @author Jakub Dutkiewicz
     * @created 04.10.2022
     * 
     * @return Flight__c object
     */
    global FlightBuilder getRecord() {
        FlightBuilder flight = new FlightBuilder();
        flight.distance = this.distance;
        flight.name = this.name;
        flight.departureName = this.departureName;
        flight.arrivalName = this.arrivalName;
        return flight;
    }
}
