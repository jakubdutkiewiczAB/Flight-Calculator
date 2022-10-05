@isTest
public with sharing class FlightServiceTest {
    
    @TestSetup
    static void setupData() {
        TestUtils.addFlight();
    }
    
    @isTest
    public static void calculateFlightTest() {
        List<Flight__c> flightList = [SELECT Id, Name, DepartureAirport__c, ArrivalAirport__c, FlightDistance__c FROM Flight__c];
        List<Airport__c> airportsList = [SELECT Id FROM Airport__c];
        Map<Id, Flight__c> oldFlightIdToFlight = new Map<Id, Flight__c>();

        Decimal startDistance = flightList[0].FlightDistance__c;
        oldFlightIdToFlight.put(flightList[0].Id, flightList[0]);
        flightList[0].DepartureAirport__c = airportsList[2].Id;
        update flightList;

        Test.startTest();
        FlightService.calculateFlights(flightList, oldFlightIdToFlight);
        Test.stopTest();

        List<Flight__c> flightListAfterUpdate = [SELECT Id, Name, DepartureAirport__c, ArrivalAirport__c, FlightDistance__c FROM Flight__c];
        Decimal finalDistance = flightListAfterUpdate[0].FlightDistance__c;

        System.assertNotEquals(finalDistance, startDistance);
    }
}
