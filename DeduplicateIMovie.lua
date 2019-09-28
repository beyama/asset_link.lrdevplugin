local LrApplication = import 'LrApplication'
local LrFunctionContext = import 'LrFunctionContext'
local LrTasks = import 'LrTasks'
local LrDialogs = import 'LrDialogs'
local LrLogger = import 'LrLogger'
local LrFileUtils = import 'LrFileUtils'

function path( photo ) return photo:getRawMetadata('path') end

function popen( cmd )
	local file = assert(io.popen(cmd))
	local output = file:read('*all')
	file:close()
	return output
end

function lines( str )
	result = {}
	for s in str:gmatch("[^\r\n]+") do
    	table.insert(result, s)
	end
	return result
end

local function deduplicateIMovieDialog()
	LrFunctionContext.callWithContext( "deduplicateIMovieDialog", function( context )

		local catalog = LrApplication.activeCatalog()

    	local paths = LrDialogs.runOpenPanel({
    		title = LOC "$$$/LrAssetLink/DialogTitleChooseIMovieLibrary=Choose iMovie library",
    		canChooseFiles = true,
    		canChooseDirectories = false,
    		allowsMultipleSelection = false,
    		fileTypes = 'imovielibrary'
    	})

    	if not paths then return end

	    local iMovieLibrary = paths[1]

	    LrTasks.startAsyncTask(function( context )

	    	local assets = popen('find "' .. iMovieLibrary .. '" -iname "lral_*" -type f')

	    	for _, assetPath in ipairs(lines(assets)) do
	    		for uuid in assetPath:gmatch("lral_(%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x)") do
	    			local photo = catalog:findPhotoByUuid(uuid)

	    			if photo then
	    				LrFileUtils.delete(assetPath)
	    				popen('ln -s "' .. path(photo) .. '" "' .. assetPath .. '"')
	    			end
	    		end
	    	end

	    end, "linkAssets")

	end)

end

deduplicateIMovieDialog()
