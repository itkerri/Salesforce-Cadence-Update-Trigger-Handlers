/**********************************************************
* Description: Triggers when Cadence Trackers are created or changed.
**********************************************************/
trigger cadenceTrackerTrigger on ActionCadenceTrackerChangeEvent (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        cadenceTrackerHandler.updateLead(trigger.new);
        cadenceTrackerHandler.updateContact(trigger.new);
    } 
}
