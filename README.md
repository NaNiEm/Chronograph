# Chronograph

**An iOS application that utilizes the Google Maps API which allows users to set destination based alarms. This application’s is aimed towards public transportation goers. It’s main purpose is to alert the traveler when they’re nearing their stop, allowing the traveler to spend their travel time napping, playing, or anything besides constantly checking if they’ve arrived.  

## User Stories
The following are **core** user stories:

- [ ] User can see a map.
- [ ] User can set a designated location by dropping a pin.
- [ ] User can set a designated location by typing in an address.
- [ ] User can receive a sound notification as default or when necessary.
- [ ] User can change the type of alarm they would receive (vibrate, sound, banner).
- [ ] User can have my phone set to silent and still have the alarm go off.


The following are **optional** user stories:

- [ ] User can pick a sound file as their alarm.
- [ ] User can check weather of end-destination.
- [ ] User can allow for alarm notifications to be sent to their phone’s messenger.
- [ ] User can have more than one destination set on the app.

## Video Walkthrough

A walkthrough of our project will be viewable here.

<img src='http://i.imgur.com/link/to/your/gif/file.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />


# Considerations
* What is your product pitch?
    * Have you ever wanted to nap while on a long trip on a train? Well we've got you covered! With this destination based alarm clock, you can nap away all your concerns and we'll wake you before your stop!
* Who are the key stakeholders for this app?
    * Public transportation users (trains).  They will use this to keep track of their route and view updates on their estimated time of arrival.
* What are the core flows?
    * Viewing a map, setting a destination, viewing the route in progress.
* What will your final demo look like?
    * Users are greeted with a map on their current location. They will see several pins around them based on the type of public transportation they are using. The user can click on a pin to set it as the destination.
* What mobile features do you leverage?
    * We are using location, and potentially background tracking to provide convenient usage for our app. We are using maps but we chose to use Google Maps and Google Places, we might also need a Caltrain API / Bart API.
* What are your technical concerns?
    * We aren't sure we can use google maps to create a route for a destination. Geofencing may get messy, or perhaps offline mode may be difficult to design. 
