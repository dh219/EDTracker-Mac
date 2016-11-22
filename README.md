EDTracker-Mac
=============

MacOS version of the DIY EDTracker (www.edtracker.org.uk) configuration software.
=================================================================================

Copyright (C) 2016 D Henderson. Released under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International licence.
OSRSerialPort framework (c) 2011-2012 Andrew R. Madsen. Used under the MIT Licence (MIT). 

Compatibility
=============

Please let me know if you can verify any of the below:-

* 10.12 Sierra:       Beta tested working.
* 10.11 El Capitan:   Alpha tested working.
* 10.10 Yosemite:     Alpha tested working.
* 10.9  Mavericks:    Alpha tested working.
* 10.8 Mountain Lion: No data.
* 10.7 Lion:          Not working. Runs but serial fails to connect.
* <10.6:              Not compatibile.

Quickstart Guide
================

* Select serial port of your EDTracker unit and click 'Open'.
* Output bar graphs provide feedback from the head tracking unit.
* Basic Configuration: set smoothing, yaw and pitch scales, mounting orientation and linear/exponential response mode.
* 'Recentre' is self explanatory.
* 'Autocalibrate Gyro Bias': keep EDTracker still during this phase (10-20 seconds).
* See below for Calibration.

Calibration
===========

* Place the EDTracker in its usual envionment (eg. on headphones at head height if you use it with headphones). Hit 'Clear'.
* Rotate the EDTracker around all three axes trying to draw as many points in the two point rendering windows as possible to draw two filled circles.
* Hit 'Pause' to stop errant data as you put down the EDTracker messing up our calibration.
* Hit 'Auto fit to points' to calculate a rough offset/scaling setting.
* Use the rocker switches between the two windows to manipulate x, y, z offsets and scaling parameters. Attempt to fit the yellow dots as close as possible in the circles.
* If you make a mess of it, hit 'Reset' to start again.
* Once you're happy with your circles fitting the guides, hit 'Upload Cal' to send the calibration matrix and offset data (shown) to the EDTracker.
* Place EDTracker on your head, hit 'Recentre' and try it out paying attention to the Direction Output bars. If response is laggy, or 'bounces', try manually tweaking the offset and scaling and trying again.

Reset calibration to defaults
=============================

Connect the EDTracker, Open the serial connection, hit 'Reset' and 'Upload Cal'. This is the out-of-the-box calibration defaults. You can now start calibration again from scratch.
