# Asset Link Lightroom Plugin

This is a Lightroom plugin that helps to use video assets which are managed in Lightroom to use in iMovie projects without duplicating them.

iMovie consolidates all your files into one opaque "library" which means you have to duplicate your video files when you manage them in Lightroom and want to use them im iMovie.

This plugin does a simple trick. It provides you with two actions to export your video assets from Lightroom to import them into iMovie and then it replaces the imported files in the iMovie library with symlinks to your original files in your Lightroom catalog.

# How To

Step 1: Select all your video files in Lightroom that you want to use in iMovie and then click in your application menu "Library -> Plug-in Extras -> Export for iMovie" and select a target dirctory.

*Don't change any video file names in your export destination, they are needed for "Step 3"*

Step 2: Import the video files from your export destination from "Step 1" into your iMovie Library.

Step 3: Click "Library -> Plug-in Extras -> Deduplicate iMovie assets" in Lightroom and select you iMovie Library.

Step 4: Delete the export target directory selected in "Step 1"
