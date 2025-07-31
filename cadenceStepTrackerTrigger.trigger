/**********************************************************
* Description: Triggers when Cadence Step Trackers are created or changed.
**********************************************************/
trigger cadenceStepTrackerTrigger on ActionCadenceStepTrackerChangeEvent (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        cadenceStepTrackerHandler.updateLead(trigger.new);
        cadenceStepTrackerHandler.updateContact(trigger.new);
    } 
}
