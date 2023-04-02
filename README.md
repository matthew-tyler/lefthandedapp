# Lefthandedapp

This app was written for an experiment, as a part of research into hand dominance in handwriting. Below is an overview of the experiment, which contains information about the app. 

### The Experiment Overview

Participants are asked to write a short sentence in a variety of configurations, on which data about their handwriting is collected and used to train a computer to classify the "quality" of handwriting. 

### Process

The iPad is calibrated for rotation against the edge of the table. Should only be needed once when the app is first run, as the reference frame will stay the same. 

The participant signs a waiver.

The vertical height is adjusted to suit the participant. 

The participant fills out the demographics.

The participant is presented with the first canvas and the first of the Latin square. 

The participant is prompted to write the sentence "Step on no pets" in comfortable handwriting, either printed or cursive, whichever they prefer. 

The participant repeats this for all variations of the Latin square. If writing horizontally, they are prompted to seat themselves comfortably and move the iPad to a comfortable writing position. 

After all 8 samples have been taken, the participant is presented with their samples and asked to order them from best to worse, when happy they submit the answer. 

Estimated time ~6 minutes. 




### Equipment

- iPad (12.9 inch) (5th Generation)  MHNK3X/A iOS 16.1.1 (20B101)
- Apple Pencil 2 A205 (Hardware Version 1100, Firmware Version: 0154.0093.0444.0060)
- Tripod
- Custom iPad Mount


The Pencil: 
![pencil](https://user-images.githubusercontent.com/101033922/229328119-df0fc20b-16cf-4925-94b3-27dbc697a8c8.jpeg)
As pictured is considered the small grip. 

![lgrip](https://user-images.githubusercontent.com/101033922/229328123-0a4b878e-a7ca-48f8-ace6-7ab66cc3f29b.jpeg)

The large grip. This is the pencil pictured above placed inside a custom-built grip. The string allows for the easy removal of the pencil when adjusting variables. 


Custom Mount: 

![customMount](https://user-images.githubusercontent.com/101033922/229328133-a1001ae4-d13b-4463-99df-286e4ab9edbe.jpeg)

Built to allow the iPad to be held firmly in a vertical position, whilst being height adjustable. 


Vertical Levelling:

The tripod allows us to quickly adjust and lock out the vertical position of the iPad.

![ruler](https://user-images.githubusercontent.com/101033922/229328153-14c8a3a8-90dc-49e8-b875-32004602b686.jpeg)
I've attached a ruler to the top of the mount, it can be easily removed so as no to distract people as the write. It can be set comfortably to sit either in line with the top of the participants head.  


### The App

The experiment is conducted mostly using a custom written app written for the iPad

![PresentationScreen](https://user-images.githubusercontent.com/101033922/229328160-40c74e43-c0b1-4cbc-befc-065a02ddfa10.jpeg)

The first view of the app simply shows the university emblem and a prompt to start the experiment. 

![CalibrationScreen](https://user-images.githubusercontent.com/101033922/229328165-bc1bd4fd-60b5-4a0e-9590-6b42410f590e.jpeg)
If the emblem is clicked you are taken to the calibration view, which allows you to set the frame of reference for the rotation of the iPad. This is done by lining the iPad up with the straight edge of the table and clicking the "Set Reference" button. 

![Demographics](https://user-images.githubusercontent.com/101033922/229328170-418a3b5f-0732-45dd-b474-1b80e3a761b3.jpeg)
The demographics view shows the list of demographics which default to withhold. 


![WritingSurface](https://user-images.githubusercontent.com/101033922/229328178-359b0e0b-58cc-4009-89ee-de0b49260c6f.jpeg)
The canvas view shows the university logo in the top left, followed by the current prompt for the user, to the right are some controls. If the user accidentally clicks QUIT it will request the user to confirm.


![OrderingView](https://user-images.githubusercontent.com/101033922/229328182-94b82408-6bb0-4c52-bb9b-ddaea8e1b5b0.jpeg)
The final view prompts the user to order their samples, which appear rendered on the left. They can be moved around by grabbing the hamburger button on the right and moving them up or down. 


### Data & Format

Demographics:
A set of questions about the demographics of the participant are asked to each participant. Every question has the option to withhold. 

Question:
[Answers...]
*{Notes}*

Sex:
["Male", "Female", "Non-Binary", "Withheld"]

Age:
["1-10", "11-20", "21-30", "31-40", "41-50", "51-60", "61-70", "71-80", "81-90", ">90", "Withheld"]

Writing Hand:
["Left", "Right", "Ambidextrous", "Withheld"]

Handedness:
["Left", "Right", "Ambidextrous", "Withheld"]
*If different from the hand they write with.*

Writing Habit:
["More than once a day", "More than once a month", "Less than once a month","Withheld"]
*This is shortened to ["Regularly", "Irregularly", "Rarely","Withheld"] for easier processing*
*The question aims to identify those who write more regularly, as handwriting habits seem to vary wildly amongst people.* 

Stylus Habit:
["More than once a day", "More than once a month", "Less than once a month","Withheld"]
*This is shortened to ["Regularly", "Irregularly", "Rarely","Withheld"] for easier processing*
*This question aims to identify those more confident with a stylus when used on a writing tablet. In practice data collecting there seemed to be a notable difference between those who used one often vs those who never had.* 

Highest Qualification: 
["School", "Bachelor", "Masters", "PhD", "Withheld"]
*This question aims to identify the population of our dataset, to determine if we have an over-representation of undergrads in our set.* 

Variables:

Orientation - Horizontal/Vertical
	The iPad is either set flat on a table (considered horizontal), where the participant is allowed to adjust it freely to a comfortable writing position. Or set vertical, in a purpose built holder atop a tripod. The height is set to approximately eye level for each participant.
	
Grip - Small/Large
	The Apple Pencil is either used as is (considered small), (length 166 mm, diameter: 8.9mm, weight 20.7g), with a small rubber ring at the tip used for the large grip mechanism. Otherwise, it is placed inside a custom-made wide grip (approximate 15mm diameter, and ~180mm (Needs to be measured, just guesses)).
	
Hand - Right/Left
	The participant is asked to write the sample using either their right and left hand for each variation of Orientation and grip.

This gives the 8 possible variations:

- "Horizontal, Small Grip, Right Hand"
- "Horizontal, Small Grip, Left Hand"
- "Horizontal, Large Grip, Right Hand"
- "Horizontal, Large Grip, Left Hand"
- "Vertical, Small Grip, Right Hand"
- "Vertical, Small Grip, Left Hand"
- "Vertical, Large Grip, Right Hand"
- "Vertical, Large Grip, Left Hand"

To avoid bias these are presented as a balanced Latin square to each participant. 

Sentence - Step On No Pets

The participant is asked to write "Step on no pets" in all of the above variations, as requested by the balanced Latin square. 

This sentence was chosen as it is a palindrome, and is sufficiently short enough to allow each participant to write on a single line without running out of space on the iPad. 

Although the participant can be instructed to do this with longer sentences, as they may be unfamiliar with writing with their non-dominant hand, it can lead to letters being bunched at one end due to bad planning, or the sentence finished on a new line which can be hard to normalise.


Writing Samples: 

Each piece of writing is represented as a set of strokes. Each Stroke is represented as a collection of points, which are sampled at approximately 240Hz (240 points per second).

Each point contains: 
		- Location: Represented in pixels up to 14 decimal places by x,y, the origin being the top left of the drawing surface. 
		- Time Offset: In seconds, up to 3 decimal places.
		- force: Unit unclear. Determined by apple, where 1.0 is the average force of a user (not user specific). Up to 3 decimal places.
		- Azimuth: In radians, up to 6 decimal places.
		- Altitude: In radians, up to 6 decimal places.
		- Size:  This property is not used.
		- Opacity: This property is not used.


Each sample is exported as a UTF8 encoded text file, with a textual representation of each stroke point provided by the default description on the PKStrokePoint object. 

The file name is a UUID, which is a 32 digit long hexadecimal number uniquely identifying each writing sample. 

The resulting output takes the structure: 

	File Name: 00000000-000-0000-0000-000000000000.txt

	Stroke
	PKStrokePoint(strokePoint: <PKStrokePoint: 0x000000000000 location=
	{000.00000000000000, 000.00000000000000} timeOffset=0.000000 size={0, 0} 
	opacity=0.000000 azimuth=0.000000 force=0.000000 altitude=0.000000>)

Where each file starts with the declaration of a Stroke and then a new line. Each new line represents a PKStrokePoint. Every stroke must contain one or more points, and every sample must contain one or more strokes. 


Rotation:
Rotation is stored for all samples, but is only relevant for samples taken horizontally. The rotation of the iPad is recorded using the inbuilt gyroscope of the iPad. The yaw is taken with reference to magnetic north using the Core Motion API. The frame of reference is set by the operator using a calibration menu under the Otago Logo on initial view, and is set by aligning the iPad with the straight edge of the table and tapping the "Set Reference" button. 

The yaw is measured from -Pi to Pi, and is converted into degrees. The measurement appears to be accurate to around .5 of a degree, so the nearest integer should be considered.


Participant List:
Each participant is represented by a UUID. A CSV is exported containing the list of all participants with their demographics and Latin order etc.

The resulting output takes the structure:

	File Name: people.csv

	id,when,age,sex,education,handedness,writing hand,writing hand,writing habit,stylus habit,latin order,1,2,3,4,5,6,7,8

Where the first line represents the column headers, then each new line after that is a row of data.

The id is the UUID of the participant.

when is a date stamp representing when the experiment was completed. The format being
dd-mm-yyyy hh:mm:ss

age to stylus habit are as mentioned in demographics.

latin order is an integer representing the order of the Latin square

1 to 8 is the UUID of each of the 8 samples, in rank order from best to worst as determined by the participant themselves. 


Image List:
A separate list of each image is exported as CSV with further attributes about each image. 

This takes the form of:

	File Name: images.csv

	id,author,orientation,grip,hand

The first line represents the column headers, then each new line after that is a row of data.

where the id is the UUID of the image, the author is the UUID of the participant, orientation is vertical/horizontal, grip is small/large and hand is right/left.

PNGs:
A rendered version of each image is exported in the form of a PNG. 

Export Output: 
The resulting files that are output when exporting are:

	00000000-000-0000-0000-000000000000.txt
	00000000-000-0000-0000-000000000000.png
	images.csv
	people.csv

Where there are 2 files representing every sample (PNG and txt).
