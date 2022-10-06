/**
 * Service class for NewFlight component
 * 
 * @author Jakub Dutkiewicz
 * @created 04.10.2022
 */
public class NewFlightService {

    /**
     * Service method to fetch all available Airports
     * 
     * @author Jakub Dutkiewicz
     * @created 04.10.2022
     * 
     * @return List of Airport sObjects
     */
    @AuraEnabled(cacheable=true)
    public static List<Airport__c> fetchAirports() {
        return AirportSelector.getAllAirports();
    }

    /**
     * Service method to calculate and save Flight__c record 
     * 
     * @author Jakub Dutkiewicz
     * @created 04.10.2022
     * 
     * @param List of Airport sObjects
     * @return FlightBuilder constructor for Flight__c sObject
     */
    @AuraEnabled
    public static FlightBuilder calculateAndSaveFlight(List<Airport__c> airports) {
        try {
            Flight__c newFlight = new Flight__c (
                DepartureAirport__c = airports.get(0).Id,
                ArrivalAirport__c = airports.get(1).Id,
                FlightDistance__c = FlightService.calculateDistance(
                    airports.get(0).Geolocation__Latitude__s,
                    airports.get(0).Geolocation__Longitude__s,
                    airports.get(1).Geolocation__Latitude__s,
                    airports.get(1).Geolocation__Longitude__s
                ),
                Name = airports.get(0).IATA__c + '-' + airports.get(1).IATA__c
            );
            insert newFlight;
            
            FlightBuilder flight = new FlightBuilder();
            return flight.cloneFlight(newFlight).setNamesOnFlight(airports.get(0).Name, airports.get(1).Name).getRecord();
        } catch(DmlException ex) {
            throw new AuraHandledException(System.Label.UnexpectedError + ' ' + ex.getMessage());
        }
    }

    /**
     * Service method to find Airport__c sObjects by search key
     * 
     * @author Jakub Dutkiewicz
     * @created 05.10.2022
     * 
     * @param searchKey to find IATA__c code in database
     * @return List of Airport__c by search key
     */
    @AuraEnabled(cacheable=true)
    public static List<Airport__c> getAllAirports(String searchKey){
        try {
            String searchWord = '%'+searchKey+'%';
            return [SELECT Id, IATA__c FROM Airport__c WHERE IATA__c like:searchWord];
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}
