return {
	
	LrSdkVersion = 3.0,
	LrSdkMinimumVersion = 1.3,

	LrToolkitIdentifier = 'io.jentz.lrassetlink',

	LrPluginName = LOC "$$$/LrAssetLink/PluginName=Asset Link",
	
	LrLibraryMenuItems = {
	    {
		    title = LOC "$$$/LrAssetLink/MenuItemIMovieExport=Export for iMovie",
		    file = "ExportForIMovie.lua",
		},
		{
		    title = LOC "$$$/LrAssetLink/MenuItemDeduplicateIMovie=Deduplicate iMovie assets",
		    file = "DeduplicateIMovie.lua",
		}

	}

}
