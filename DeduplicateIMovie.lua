local LrFunctionContext = import 'LrFunctionContext'
local LrTasks = import 'LrTasks'
local LrDialogs = import 'LrDialogs'
local common = require 'common'

function path( photo ) return photo:getRawMetadata('path') end

local function deduplicateIMovieDialog()
    LrFunctionContext.callWithContext( "deduplicateIMovieDialog", function( context )

        local paths = LrDialogs.runOpenPanel({
            title = LOC "$$$/LrAssetLink/DialogTitleChooseIMovieLibrary=Choose iMovie library",
            canChooseFiles = true,
            canChooseDirectories = false,
            allowsMultipleSelection = false,
            fileTypes = 'imovielibrary'
        })

        if not paths then return end

        LrTasks.startAsyncTask(function( context )
            common.link(paths[1], 'f')
        end, "linkAssets")

    end)

end

deduplicateIMovieDialog()
