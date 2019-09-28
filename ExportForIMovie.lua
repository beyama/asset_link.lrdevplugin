local LrApplication = import 'LrApplication'
local LrFunctionContext = import 'LrFunctionContext'
local LrTasks = import 'LrTasks'
local LrDialogs = import 'LrDialogs'
local LrPathUtils = import 'LrPathUtils'
local LrFileUtils = import 'LrFileUtils'

function path( photo ) return photo:getRawMetadata('path') end

function isVideo( photo ) return photo:getRawMetadata('isVideo') end

function fileName( photo ) return photo:getFormattedMetadata('fileName') end

function uuid( photo ) return photo:getRawMetadata('uuid') end

function targetName( photo )
	local name = 'lral_' .. uuid(photo) -- lral for LrAssetLink + uuid of photo
	local extension = LrPathUtils.extension(fileName(photo))
	if extension then return LrPathUtils.addExtension(name, extension) end
	return name
end

function copyAssets( targetBasePath, assets )
	for _, asset in ipairs(assets) do
		local target = LrPathUtils.child(targetBasePath, asset.targetName)
		LrFileUtils.copy(asset.source, target)
	end
end

local function exportDialog()
	LrFunctionContext.callWithContext( "exportForIMovieDialog", function( context )

	    LrTasks.startAsyncTask(function( context )
	    	local catalog = LrApplication.activeCatalog()

	    	local selectedVideos = {}
	    	for _, photo in pairs(catalog:getTargetPhotos()) do
	    		if isVideo(photo) then
	    			table.insert(selectedVideos, { 
	    				source = path(photo),
	    				targetName = targetName(photo)
	    			})
	    		end
	    	end

	    	if #selectedVideos == 0 then
	    		LrDialogs.message(
	    			LOC "$$$/LrAssetLink/MessageTitleNoVideoSelected=No video file selected"
	    		)
	    		return
	    	end

	    	local targetPaths = LrDialogs.runOpenPanel({
	    		title = LOC "$$$/LrAssetLink/DialogTitleChooseExportPath=Choose path",
	    		canChooseFiles = false,
	    		canChooseDirectories = true,
	    		allowsMultipleSelection = false
	    	})

	    	if not targetPaths then return end

	    	copyAssets(targetPaths[1], selectedVideos)
	    end, "copyAssets")

	end)

end

exportDialog()
