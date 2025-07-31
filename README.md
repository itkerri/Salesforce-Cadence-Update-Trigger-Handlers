# Cadences

Cadence automation mostly only support changes at the Platform level (Change Events) and the Apex doesn’t behave normally, so I had to set the test class and handlers up following these guides:
- [Feed Item Detail](https://trailhead.salesforce.com/trailblazer-community/feed/0D54V00007ifojhSAA)
- [Test Coverage for trigger on ActionCadeneSteptracker CDC](https://trailhead.salesforce.com/trailblazer-community/feed/0D54V00007ifojhSAA)

From <strong>Setup</strong> > <strong>Change Data Capture</strong>, I added Cadence Tracker and Cadence Step Tracker objects in order to run Apex on Cadence Change Events ***(this is the only way track Cadence progress on a related record)***.</br>

I created new Apex to process the Cadence Step Tracker and Cadence Tracker Change Events:
</br>

<strong>Apex Triggers:</strong>
- cadenceStepTrackerTrigger
- cadenceTrackerTrigger

<strong>Apex Classes:</strong>
- cadenceStepTrackerHandler
- cadenceTrackerTriggerHandler
- cadenceStepTrackerHandlerTEST
