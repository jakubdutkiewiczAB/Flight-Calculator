/**
 * Service class for Flight__c sObject
 * 
 * @author Jakub Dutkiewicz
 * @created 04.10.2022
 */
public with sharing class FlightService {

    private static final Set<String> fieldToCheck = new Set<String>{
        'DepartureAirport__c', 
        'ArrivalAirport__c'
    };

    /**
     * Service method to calculate distance between two airports for flights
     * 
     * @author Jakub Dutkiewicz
     * @created 04.10.2022
     * 
     * @param List of Flight__c sObjects
     * @param Map of Id and Flight__c sObjects
     */
    public static void calculateFlights(List<Flight__c> flights, Map<Id, Flight__c> oldFlightIdToFlight) {
        try {
            List<Flight__c> changedFlights = new List<Flight__c>();
            Set<Id> airportIds = new Set<Id>();
            for (Flight__c flight : flights) {
                if (UtilsService.isFieldChanged(flight, oldFlightIdToFlight, fieldToCheck)) {
                    airportIds.add(flight.ArrivalAirport__c);
                    airportIds.add(flight.DepartureAirport__c);
                    changedFlights.add(flight);
                }
            }

            Map<Id, Airport__c> airportsMap = AirportSelector.getAirportsByIds(airportIds);

            for (Flight__c flight : changedFlights) {
                if (airportsMap.containsKey(flight.ArrivalAirport__c) && airportsMap.containsKey(flight.DepartureAirport__c)) {
                    flight.FlightDistance__c = calculateDistance(
                        airportsMap.get(flight.ArrivalAirport__c).Geolocation__Latitude__s,
                        airportsMap.get(flight.ArrivalAirport__c).Geolocation__Longitude__s,
                        airportsMap.get(flight.DepartureAirport__c).Geolocation__Latitude__s,
                        airportsMap.get(flight.DepartureAirport__c).Geolocation__Longitude__s
                    );
                    flight.Name = airportsMap.get(flight.ArrivalAirport__c).IATA__c + '-' + airportsMap.get(flight.DepartureAirport__c).IATA__c;
                }
            }
        } catch(Exception ex) {
            System.debug(System.Label.UnexpectedError + ' ' + ex.getMessage());
        }
    }

    /**
     * @description Service method to calculate flight distance using the Haversine formula between two airports for flights
     * 
     * @author Jakub Dutkiewicz
     * @created 04.10.2022
     * 
     * @param Decimal first airport latitude
     * @param Decimal first airport longitude
     * @param Decimal second airport latitude
     * @param Decimal second airport longitude
     * @return Decimal distance between airports
     */
    public static Decimal calculateDistance(Decimal latitude1, Decimal longitude1, Decimal latitude2, Decimal longitude2) {
        Integer earthRadius = 6371; // in kilometers
        // Transform coordinates from degrees to radians
        Decimal latitudeRadians1 = latitude1 * Math.PI/180;
        Decimal latitudeRadians2 = latitude2 * Math.PI/180;
        // Latitude and longitude differences in radians
        Decimal latitudeDelta = (latitude2 - latitude1) * Math.PI/180;
        Decimal longitudeDelta = (longitude2 - longitude1) * Math.PI/180;
        Decimal a = Math.sin(latitudeDelta/2) * Math.sin(latitudeDelta/2) +
            Math.cos(latitudeRadians1) * Math.cos(latitudeRadians2) *
            Math.sin(longitudeDelta/2) * Math.sin(longitudeDelta/2);
        Decimal arc = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        Decimal distance = earthRadius * arc; // in kilometers
        return distance.setScale(3);
    }
}