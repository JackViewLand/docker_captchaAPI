local _M = {}
local concat = table.concat

local function reset_bucketList()
	local bucketList = ngx.shared.bucketList
	bucketList:flush_all()
	bucketList:flush_expired(0)
end

local function isTableEmpty(tbl)
    for _ in pairs(tbl) do
	return false
    end
    return true
end


local function swrite(msg)
    local path = "/usr/local/openresty/nginx/logs/lua.log"
    local file = io.open(path,'a+')
    if file then
        file:write(msg..'\n')
        file:close()
    end

end

local function getTime()
    local ngx = ngx
    local os_date = os.date
    local current_timestamp = ngx.now() + (8 * 3600)
    local formatted_datetime = os_date("%Y-%m-%d %H:%M:%S", current_timestamp)
    return formatted_datetime
end

local function getInfo()
    local info={}
    info.ip=ngx.var.remote_addr
    info.url=ngx.var.uri
    info.method=ngx.var.request_method
    info.request_port=ngx.var.server_port
    info.http_status_code=ngx.HTTP_OK
    info.http_version=ngx.req.http_version()

    local request_headers = ngx.req.get_headers()
    for k,v in pairs(request_headers) do
        info[k] = v
    end
    return info
end

local function getuniInfo(argsTable,infoTable)
        local info_concat = ""
        if argsTable and infoTable then
            for _,arg in pairs(argsTable) do
                info_concat = info_concat..infoTable[arg]
            end
        end
        return info_concat
end

local function generateToken(argsTable,infoTable)
    if type(argsTable)=="table" and type(infoTable) == "table" then
        --[[local info_concat = ""
        for _,arg in pairs(argsTable) do
            info_concat = info_concat..infoTable[arg]
        end
        --]]
        local info_concat = getuniInfo(argsTable,infoTable)
        --ngx.say(info_concat)
        local md5_sha = ngx.md5(info_concat)
        return md5_sha
    else
        ngx.say("generate")
    end
    return nil
end

local function getmode(arg)
    local mode = nil
    local arg = ngx.var.arg
    if arg == 'true' then mode = true 
    elseif arg == 'false' then mode = false end
	    
    return arg
end

_M.reset_bucketList=reset_bucketList
_M.isTableEmpty=isTableEmpty
_M.swrite = swrite
_M.getTime = getTime
_M.getFileSize = getFileSize
_M.getInfo = getInfo
_M.getuniInfo = getuniInfo
_M.generateToken = generateToken
_M.getmode = getmode

return _M
