/**
 * Handler class for FlightTrigger
 * 
 * @author Jakub Dutkiewicz
 * @created 04.10.2022
 */
public abstract class FlightTriggerHandler {
    
    public virtual void beforeUpdate() {}

    public virtual void handle() {
        if (Trigger.isBefore) {
            if (Trigger.isUpdate) {
                beforeUpdate();
            }
        }
    }
}
