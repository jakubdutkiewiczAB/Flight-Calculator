@isTest
public with sharing class FlightServiceTest {
    
    @TestSetup
    static void setupData() {
        TestUtils.addFlight(true);
    }
    
    @isTest
    public static void calculateFlightTest() {
        List<Flight__c> flightList = FlightSelector.getAllFlights();
        List<Airport__c> airportsList = AirportSelector.getAllAirports();
        Map<Id, Flight__c> oldFlightIdToFlight = new Map<Id, Flight__c>();

        Decimal startDistance = flightList[0].FlightDistance__c;
        oldFlightIdToFlight.put(flightList[0].Id, flightList[0]);
        flightList[0].DepartureAirport__c = airportsList[2].Id;
        update flightList;

        Test.startTest();
        FlightService.calculateFlights(flightList, oldFlightIdToFlight);
        Test.stopTest();

        List<Flight__c> flightListAfterUpdate = FlightSelector.getAllFlights();
        Decimal finalDistance = flightListAfterUpdate[0].FlightDistance__c;

        System.assertNotEquals(finalDistance, startDistance);
    }
}
