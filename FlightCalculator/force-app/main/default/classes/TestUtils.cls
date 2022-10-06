public with sharing class TestUtils {
    
    public static List<Airport__c> addAirports(Boolean insertToDatabase) {
        Airport__c airportKatowice = new Airport__c(
            IATA__c = 'KTW',
            Geolocation__Latitude__s = 50.270908,
            Geolocation__Longitude__s = 19.039993, 
            Name = 'Katowice'
        );

        Airport__c airportBarcelona = new Airport__c(
            IATA__c = 'BCN',
            Geolocation__Latitude__s = 41.390205,
            Geolocation__Longitude__s = 2.154007, 
            Name = 'Barcelona'
        );

        Airport__c airportNewYork = new Airport__c(
            IATA__c = 'JFK',
            Geolocation__Latitude__s = 40.73061,
            Geolocation__Longitude__s = -73.935242, 
            Name = 'New York'
        );
        List<Airport__c> airports = new List<Airport__c>{airportKatowice, airportBarcelona, airportNewYork};

        if(insertToDatabase){
            insert airports;
        }
        return airports;
    }

    public static Flight__c addFlight(Boolean insertToDatabase) {
        TestUtils.addAirports(true);
        List<Airport__c> airportsList = [SELECT Id FROM Airport__c];
        Flight__c newFlight = new Flight__c(
            Name = 'KTW-BCN',
            DepartureAirport__c = airportsList[0].Id,
            ArrivalAirport__c = airportsList[1].Id
        );

        if(insertToDatabase){
            insert newFlight; 
        }
        return newFlight;
    }
}
