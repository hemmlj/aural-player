# Aural Player

![App demo](/Documentation/Demos/newDemo.gif?raw=true "App demo")

## Overview

Aural Player is a free and open source audio player application for the macOS platform. Inspired by the classic Winamp player for Windows, it is designed to be to-the-point, easy to use, and highly customizable, with some sound tuning capabilities for audio enthusiasts.

## Download

Download the disk image file [Aural.dmg](https://github.com/maculateConception/aural-player/blob/master/Aural.dmg?raw=true). Just mount it and run the app !

NOTE - This project is currently under heavy development as of 10/07/2018. So, please expect frequent updates/releases, and perhaps the occasional bug or two. I might switch to doing Git releases once the code is more stable, after most major updates have been rolled out and tested.

### Compatibility

**User**: Running Aural Player requires OS X 10.10 (Yosemite) or later macOS versions.

**Developer**: To develop Aural Player with Swift 4.2 (master branch) requires macOS 10.13.4 or later (High Sierra) and XCode 10. The old "swift2" branch has been deleted.

## Features

* **Supported file types:**
   * Audio files: MP3, AAC, AIFF/AIFC, WAV, and CAF
   * Playlist files: M3U/M3U8

* **Playback:**
  * Bookmarking, so you can mark a specific position within a track and come back to it later with one click, which is great for long tracks like audiobooks
   * Track segment looping, to allow you to define and loop your favorite parts of a track. Save your loops and play them back at any time with one click **(New!)**
   * Specify two different custom seek lengths so you can perform both fine-grained and coarse-grained seeking simultaneously **(New!)**
   * Insert timed gaps of silence (up to 24 hours) before or after individual tracks or set a global preference to implicitly insert a gap between all tracks during playback **(New!)**
   * Delayed track playback function, with up to a 24 hour delay. Set a time interval or choose a "Start at" time. Useful for setup before a track plays (e.g. for a live performance), or if you need time to get to the dance floor **(New!)**
  * Option to remember last playback position, either on a per-track basis or for all tracks, so you can resume listening to a track without needing to remember where you left off **(New!)**
  * "Jump to time" function to quickly skip to a specific position within a track **(New!)**
   * Configurable autoplay (on app startup and/or when tracks are added)

* **Effects:**
   * Graphic equalizer, Pitch shift, Time stretch, Reverb, Delay, Filter, and a Master unit to switch on/off all effects from one place
   * Effects unit controls dynamically change their colors to intuitively inform you of the state of the unit (active/bypassed)
   * Option to remember sound settings, either on a per-track basis or for all tracks, so you can tailor the soundscape for each of your tracks without having to manually re-apply any settings when they begin playing. Adjust the settings once and Aural will remember and automatically apply them the next time that track plays. **(New!)**
   * Save your effects settings as presets, either per individual effects unit or all effects as a whole, so you can use them later without having to remember them. **(New!)**
   * Recording of clips in AAC/ALAC/AIFF formats, so you can capture your applied sound effects and create a customized version of your track.

* **Information:**
   * Display of ID3 and iTunes metadata, including artwork (when available)
   * Display of file system information and audio information

* **Playlist:**
   * Grouping of tracks by artist/album/genre for convenient browsing
   * Searching and sorting
   * Type selection: Just start typing the name of a track to try to find it within the playlist
   * Functions to conveniently crop/invert track selection, reorder tracks, and scroll through the playlist view
   
* **History:**
   * Favorites list and chronologically ordered recent items lists for added convenience. Find tracks you recently added/played or favorited, and add or play them with one click.

* **View:**
   * Multiple compact and flexible view options - several built-in window layout presets, window snapping with configurable spacing, collapsible views. 
   * Save your customized window layouts as presets so you can use them again at any time. **(New!)**
   * Hide individual UI components, such as album art or toolbars, per your preference, to get the UI looking more like you want it.

* **Usability:**
   * Gesture recognition for essential player/playlist controls (trackpad/MagicMouse). Examples:
      * Two finger vertical scroll for volume control
   	  * Two finger horizontal scroll for seeking 
   	  * Three finger horizontal swipe to change tracks
   	  * Three finger vertical swipe to scroll to top/bottom of playlist

   * Extensive set of keyboard shortcuts and menu items for quick and convenient access to functionality. Examples:
      * Simply press the < / > keys to quickly adjust playback rate (i.e. Time stretch effects unit)
   	  * Simply press + / - keys to quickly adjust pitch (i.e. Pitch shift effects unit)
   	  * Press Shift/Alt+1 to increase/decrease Equalizer bass

* **Customization:**
   * Numerous preferences to allow user to highly customize functionality. Examples:
   
      * Configure two independent seek lengths to your liking, used by two independent sets of seek controls … either as a constant value or a percentage of track duration. For instance, set one to a short interval and set the other to a longer interval to quickly skip through large audiobooks while also being able to perform more fine-grained seeking to get to exactly where you want within the track.
      * Click on the track time labels around the seek bar to change the display format to either hh:mm:ss or number of seconds or percentage of track duration
   	  * Configure how you want the app to look/behave on startup: Autoplay, volume and effects settings on startup, window layout on startup, remembered or default playlist on startup, etc.
      * Configure the increment/decrement for volume/pan and effects unit adjustments
   	  * Configure window snapping behavior, mouse sensitivity for gestures, and more …
      * Editors to manage all your saved custom app state, such as effects presets, bookmarks, favorites, window layouts, etc, so you can edit your saved data and delete unwanted or old data to prevent clutter

## Screenshots

### Default view

![App screenshot](/Documentation/Screenshots/Default.png?raw=true "App screenshot")

### Track segment loop playback (red segment on seek bar)

![App screenshot](/Documentation/Screenshots/SegmentLoop.png?raw=true "Track segment loop playback")

### Using the Effects panel to disable/enable effects

![App screenshot2](/Documentation/Demos/UsingFXUnit.gif?raw=true "Using the FX panel")

### Delayed track playback

![App screenshot2](/Documentation/Demos/delayedPlayback.gif?raw=true "Delayed playback")

### Insertings gaps of silence around tracks

![App screenshot2](/Documentation/Demos/gaps.gif?raw=true "Playback gaps")

### Detailed track info popover

![App screenshot w/ more info view](/Documentation/Screenshots/DetailedInfo.png?raw=true "More Info")

### Bookmarking

![App screenshot w/ more info view](/Documentation/Screenshots/Bookmarking.png?raw=true "Bookmarking")

### Saving an effects unit preset

![App screenshot w/ more info view](/Documentation/Screenshots/FXPreset.png?raw=true "Saving an effects preset")

### Previewing and managing effects presets

![App screenshot w/ effects presets editor](/Documentation/Screenshots/FXPresetsEditor.png?raw=true "Previewing and managing effects presets")

### Changing the window layout with one click

![App screenshot2](/Documentation/Demos/WindowLayout.gif?raw=true "Choosing a window layout")

### Compact view

![App screenshot4](/Documentation/Screenshots/Compact.png?raw=true "App screenshot4")

### Equalizer effects unit

![EQ](/Documentation/Screenshots/EQ.png?raw=true "Equalizer")

### Time stretch effects unit

![Time](/Documentation/Screenshots/Time.png?raw=true "Time Stretch")

### Filter effects unit

![Filter](/Documentation/Screenshots/Filter.png?raw=true "Filter")

### Delay effects unit

![Delay](/Documentation/Screenshots/Delay.png?raw=true "Delay")

### Playlist search

![Playlist search](/Documentation/Screenshots/Search.png?raw=true "Delay")

### Playlist sort

![Playlist sort](/Documentation/Screenshots/Sort.png?raw=true "Delay")

### Preferences (Playback tab selected)

![Preferences](/Documentation/Screenshots/Preferences-Playback.png?raw=true "Delay")

## Recent updates

- **10/17/2018: New release:**

  * New features:

    * **Playback gaps**: Added option to insert gaps of silence before/after/between tracks and configure them (duration and scope)
    * **Delayed playback**: Added delayed playback function with 2 options: 1 - Start after delay, 2 - Start at time
    * **Jump to time function**: Seek to a specific location quickly
    * **Stop function**: Stops all playback and ends the playback sequence (wasn't there before)
    * **Time remaining / Duration display**: User can now click the "Time remaining" label of the Now Playing box and switch to displaying duration instead of time remaining. Can toggle between the two displays. State is remembered across app launches.
    * **Playlist move to top/bottom**: New playlist functions - move items to top/bottom

  * Bug fixes:
    * Loop rendering on seek bar was offset before
    * Volume per-track setting would not be remembered properly
    * Sound settings were not being remembered properly

  * Improvements:
    * More accurate and prompt detection of end of track playback (PlaybackScheduler)
    * Nicer looking Effects unit bypass buttons

- **10/09/2018: New release:**
    
  * Bug fixes:
    * **Crash when shuffling / moving tracks**: When a new shuffle sequence is started or tracks are moved up/down within the playlist, app crashes. This has been fixed.
    * **System beep when scrolling through playlist**: When scrolling through the playlist with the arrow keys, the app produces annoying system beeps. This has been fixed.
    * **Modal dialogs unable to use Shift key**: When modal dialogs such as file browsing dialogs are open, hitting the Cmd/Shift key along with arrows invokes corresponding menu items, instead of acting on the dialog. This has been fixed.
    * **Playing track selection**: When double-clicking a playlist file, it plays but does not select it (when the option to show it everytime a track plays is selected, it should do this). This has been fixed.


- **10/05/2018: New release:**
    
  * Bug fixes:
    * **Headphones/speakers plugged in crash**: When headphones/speakers are plugged in/out, the app stops playing audio. This problem has been fixed.  
    
  * Improvements:
    * **Removed custom buffer scheduling (playback)**: Complex custom code that was used to schedule audio buffers for playback has been decommissioned, in favor of much simpler code that uses higher level AVFoundation functions.

- **10/05/2018: Swift 4.2 port:** All source code has been ported to Swift v4.2 ! Also, the old "swift2" branch has been deleted.

## Planned updates

- A new status bar player mode
- A new "floating" miniature player view that stays on top and can be used when working on other apps and Aural Player is intended to be kept in the background
- New color schemes

## Known issues/bugs

The following bugs are known and fixes are planned. If you find any additional bugs, please feel free to report them in  the "Issues" section right here on GitHub.

- On very rare conditions, the app crashes on startup due to an array indexing being performed out of range. This is due to a very subtle sneaky race condition in the playlist loading code.

## Third party code and contributor attributions

Aural Player makes use of (a modified version of) a reusable UI control called [RangeSlider](https://github.com/matthewreagan/RangeSlider).

Fellow GitHub member [Dunkeeel](https://github.com/Dunkeeel) made significant contributions towards this project - performance optimizations, UX improvements, etc.

## Background

Aural Player was written by an audio enthusiast learning to program on OS X, coming to Swift programming from many years of Java programming. This project was inspired by the developer’s desire to create a Winamp-like substitute for the macOS platform. No feature bloat or unnecessary annoyances like iTunes.
