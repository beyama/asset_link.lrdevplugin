local LrFunctionContext = import 'LrFunctionContext'
local LrTasks = import 'LrTasks'
local LrDialogs = import 'LrDialogs'
local common = require 'common'

function path( photo ) return photo:getRawMetadata('path') end

local function deduplicateIMovieDialog()
    LrFunctionContext.callWithContext( "deduplicateIMovieDialog", function( context )

        local paths = LrDialogs.runOpenPanel({
            title = LOC "$$$/LrAssetLink/DialogTitleChooseReLinkFolder=Choose iMovie library or asset folder",
            canChooseFiles = true,
            canChooseDirectories = true,
            allowsMultipleSelection = false,
            fileTypes = 'imovielibrary'
        })

        if not paths then return end

        LrTasks.startAsyncTask(function( context )
            common.link(paths[1], 'l')
        end, "linkAssets")

    end)

end

deduplicateIMovieDialog()
