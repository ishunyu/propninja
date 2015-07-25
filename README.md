# propninja
Java Properties Inspector for Mac OS X

## Requirements
* Python 2.7.* or higher (not compatible with Python 3.*)
* Xcode

## Description
* Menubar application for Mac OS X.
* Enables quick Java Properties file navigation/editing.
* Initiated through a hotkey combination (default is alt+cmd+.).

## Installation
1. Open propninja.xcworkspace using Xcode.
2. Press the "Run" button or go to Product > Run to test it out.
3. To export to Applications folder, go to Product > Archive.
4. Select "propninja", then click "Export...".
5. Select "Export as a Mac Application", and choose "/Applications" folder.

## Configuration
1. Once the application is running, click on the menubar icon, select Preferences.
2. Enter one or more .properties files into the Preferences.
3. Tag is a tag name for the file, which will appear in the search result column, path is the path of the .properties file.

## Running
1. Press the configured hotkey combination or go to the menubar icon and select "Properties".
2. Start typing and the results should show up.
3. Use navigation keys to select a result, then press Tab key to start editing.
4. Once editing is done, press Enter to save the new property or Esc to cancel editing.

## Note
* Multi-line property formats are not fully supported. When editing other properties, the multi-line property formatting will be preserved, however, when actually editing the multi-line property, that property will turn into a single line.
