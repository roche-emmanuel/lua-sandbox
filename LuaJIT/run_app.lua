local args = {...}
local appfile = args[1]

-- print('Running app file '.. appfile)
-- 
-- Retrieve the local path to be able to load vstruct:
local scriptFile = debug.getinfo(1).short_src
-- print("Scritpfile: ",scriptFile)

-- print("Getting path...")
getPath=function(str,sep)
    sep=sep or'\\'
    return str:match("(.*"..sep..")")
end

local path = getPath(scriptFile)
-- print("Using path: ",path)

package.path = path.."?.lua;"..path.."?/init.lua;"..path.."packages/?.lua;"..package.path
package.cpath = path.."modules/?.dll;"..package.cpath

require(appfile)

print("Done.")

