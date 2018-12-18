## GreenLine

A hobby project to create an iOS app showing accurate predictions for [MBTA Green Line](https://en.wikipedia.org/wiki/Green_Line_(MBTA)) trolleys.

Created by [Harrison Wong](https://github.com/harrisonjwong) and [Benjamin Chan](https://github.com/bchan1298).

**Why?** You want to know when your train is coming, but you are at one of the stations that either (a) only shows the next 2 trains when there are 4 possible trains or (b) you are at one of the B, C, or E surface stops without countdown clocks.
Additionally, it attempts to be an very lightweight app that has the information you want... but nothing else.

Uses the [MBTA v3-API](https://mbta.com/developers/v3-api).

### TODO

* Table View
  * Remove T logo from front? -- if we ever submit the app, it makes it look like it's endorsed by them
  * Make sure the images are high-res
  * Auto-layout the images properly
 
* Icon
  * Not sure right now, but maybe a geographically accurate image of green lines
 
* Predictions Model
  * !!! Trains looping downtown now have time estimates instead of "stops away" estimates, which are currently being filtered out because they don't have a train ID.
  * Figure out if they can be matched to a train car/current location. if not, just put time and tbd for rest
  * Predictions need to be discarded and removed from the table once the train has left the station

* View and Model
  * Auto refresh
  * Pull down to refresh
  * Add table selector to choose station to see predictions for
  * Favorite stations (or nearby??)

* Unit tests
  * Figure out how they work and add them
  
* Expansion possibilities
  * Make it work for other rapid transit lines and silver line
  * Add handicap accessibility warnings (show stations that have raised platforms/underground stations with elevators/show which car is type 8/9)
  * Add generic green line warnings (meh... text alerts are enough)
