local LrApplication = import 'LrApplication'
local LrFileUtils = import 'LrFileUtils'
local LrDialogs = import 'LrDialogs'
local LrPathUtils = import 'LrPathUtils'

local common = {}

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

function popen( cmd )
    local file = assert(io.popen(cmd))
    local output = file:read('*all')
    file:close()
    return output
end

-- split string into lines
function lines( str )
    result = {}
    for s in str:gmatch("[^\r\n]+") do
        table.insert(result, s)
    end
    return result
end

function common.link( library, findType )
	local catalog = LrApplication.activeCatalog()

	local assets = popen('find "' .. library .. '" -iname "lral_*" -type ' .. findType)

    for _, assetPath in ipairs(lines(assets)) do
        for uuid in assetPath:gmatch("lral_(%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x)") do
            local photo = catalog:findPhotoByUuid(uuid)

            if photo then
                LrFileUtils.delete(assetPath)
                popen('ln -s "' .. path(photo) .. '" "' .. assetPath .. '"')
            end
        end
    end
end

function common.copyAssets( targetBasePath, assets )
    for _, asset in ipairs(assets) do
        local target = LrPathUtils.child(targetBasePath, asset.targetName)
        LrFileUtils.copy(asset.source, target)
    end
end

function common.linkAssets( targetBasePath, assets )
    for _, asset in ipairs(assets) do
        local target = LrPathUtils.child(targetBasePath, asset.targetName)
        popen('ln -s "' .. asset.source .. '" "' .. target .. '"')
    end
end

function common.export( exportFunction )
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

	exportFunction(targetPaths[1], selectedVideos)
end

return common
