@isTest
public with sharing class NewFlightServiceTest {
   
    @TestSetup
    static void setupData() {
        TestUtils.addAirports(true);
    }
    
    @isTest
    public static void calculateAndSaveFlightTest() {
        List<Airport__c> airports = NewFlightService.fetchAirports();

        Test.startTest();
        FlightBuilder resultFlight = NewFlightService.calculateAndSaveFlight(airports);
        Test.stopTest();

        System.assert(resultFlight.Name == 'KTW-BCN');
        System.assert(resultFlight.departureName == airports[0].Name);
        System.assert(resultFlight.arrivalName == airports[1].Name);
    }

    @isTest
    public static void calculateAndSaveFlightErrorTest() {
        List<Airport__c> airports = [SELECT Id FROM Airport__c LIMIT 1];
        FlightBuilder flight;
        Boolean flightException = false;

        Test.startTest();
        try {
            flight = NewFlightService.calculateAndSaveFlight(airports);
        } catch(Exception ex) {
            flightException = true;
        }
        Test.stopTest();

        System.assertEquals(true, flightException);
    }
}
