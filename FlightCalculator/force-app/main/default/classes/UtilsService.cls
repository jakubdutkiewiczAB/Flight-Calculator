/**
 * Service class for Utils
 * 
 * @author Jakub Dutkiewicz
 * @created 04.10.2022
 */
public with sharing class UtilsService {

    /**
     * Service method to check if field is changed
     * 
     * @author Jakub Dutkiewicz
     * @created 04.10.2022
     * 
     * @param sObject which should be checked
     * @param Map of Id and sObjects
     * @param Set of fields
     * @return Boolean with value if field is changed or not
     */
    public static Boolean isFieldChanged(sObject obj, Map<Id, sObject> oldSObjToSObj, Set<String> fields) {
        if (oldSObjToSObj == null) {
            return true;
        }

        sObject oldObj = oldSObjToSObj.get(obj.Id);
        if (oldObj == null) {
            return true;
        }
        for (String field : fields) {
            if (obj.get(field) != oldObj.get(field)) {
                return true;
            }
        }
        return false;
    }
}