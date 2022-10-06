/**
 * Selector class for Flight__c sObject
 * 
 * @author Jakub Dutkiewicz
 * @created 05.10.2022
 */
global inherited sharing class FlightSelector {
    
    private static final List<String> coreFields = new List<String>{
        'Id', 
        'Name',
        'DepartureAirport__c', 
        'ArrivalAirport__c', 
        'FlightDistance__c'
    };

    /**
     * @description Selector method to define populate predefined fields
     * 
     * @author Jakub Dutkiewicz
     * @created 05.10.2022
     * 
     * @return List with field names
     */
    global static List<String> getFlightFields() {
        return coreFields;
    }

    /**
     * @description Selector method to execute query to get all Flight__c sObjects in database
     * 
     * @author Jakub Dutkiewicz
     * @created 05.10.2022
     * 
     * @return List with all Flight__c sObjects
     */
    global static List<Flight__c> getAllFlights() {
        String query = 'SELECT ' + String.join(getFlightFields(), ',') +
            ' FROM Flight__c';
        return Database.query(String.escapeSingleQuotes(query));
    }
}
