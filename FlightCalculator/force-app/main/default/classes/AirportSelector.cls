/**
 * Selector class for Airport__c sObject
 * 
 * @author Jakub Dutkiewicz
 * @created 04.10.2022
 */
global inherited sharing class AirportSelector {

    private static final List<String> coreFields = new List<String>{
        'Id',
        'Name',
        'Geolocation__Latitude__s', 
        'Geolocation__Longitude__s', 
        'IATA__c'
    };

    /**
     * @description Selector method to define populate predefined fields
     * 
     * @author Jakub Dutkiewicz
     * @created 04.10.2022
     * 
     * @return List with field names
     */
    global static List<String> getAirportFields() {
        return coreFields;
    }

    /**
     * @description Selector method to execute query to get all Airport__c sObjects in database
     * 
     * @author Jakub Dutkiewicz
     * @created 04.10.2022
     * 
     * @return List with all Airport__c sObjects
     */
    global static List<Airport__c> getAllAirports() {
        String query = 'SELECT ' + String.join(getAirportFields(), ',') +
            ' FROM Airport__c';
        return Database.query(String.escapeSingleQuotes(query));
    }
    
    /**
     * @description Selector method to execute query to get Airport__c sObjects by Ids
     * 
     * @author Jakub Dutkiewicz
     * @created 04.10.2022
     * 
     * @param Set of Airport__c sObjects ids
     * @return Map of Ids and Airport__c sObjects
     */
    global static Map<Id, Airport__c> getAirportsByIds(Set<Id> airportIds) {
        String query = 'SELECT ' + String.join(getAirportFields(), ',') +
            ' FROM Airport__c ' +
            ' WHERE Id IN :airportIds ';
        return new Map<Id, Airport__c>((List<Airport__c>) Database.query(String.escapeSingleQuotes(query)));
    }
}
