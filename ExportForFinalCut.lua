local LrFunctionContext = import 'LrFunctionContext'
local LrTasks = import 'LrTasks'
local common = require 'common'

local function exportDialog()
    LrFunctionContext.callWithContext( "exportForIMovieDialog", function( context )

        LrTasks.startAsyncTask(function( context )
            common.export(common.linkAssets)
        end, "copyAssets")

    end)

end

exportDialog()
