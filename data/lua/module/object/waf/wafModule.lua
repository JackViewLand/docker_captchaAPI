local tool = require 'module/object/toolModule'
local captcha = require 'module/object/waf/action/captchaModule'
local bucketList = ngx.shared.bucketList
local writeLuaLog = true
local var_writeLuaLog = ngx.var.writeLuaLog or nil
if var_writeLuaLog == 'false' then writeLuaLog = false end

local _M = {}


local function captchaMode()
    --get bucketList timeout--
    ngx.ctx.bucketListTime = ngx.var.bucketListTime

    --generate user token--
    local pass = false
    local user_info = tool.getInfo()

    local args={
    "ip",
    "user-agent"
    }

    if writeLuaLog then
        tool.swrite("-------------------------------------------")
        tool.swrite("---hit access: "..ngx.var.host)
    end

    --captcha verify--
    --check bucketList
    local user_uniInfo = tool.getuniInfo(args,user_info)
    local pass = bucketList:get(user_uniInfo)
    if writeLuaLog then tool.swrite("---check bucketList---") end
    local headers = ngx.req.get_headers()

    if pass then
    --user verified
    	if writeLuaLog then
	    tool.swrite("user exist( "..pass.." )")
	    tool.swrite(tool.getTime()..": user pass("..pass..")")
	end
    else
    --first login
	local dynamic_user_token = tool.generateToken(args,user_info)
	if writeLuaLog then tool.swrite("make token: "..dynamic_user_token) end
	captcha.access(user_uniInfo,dynamic_user_token)
    end
    return nil 
end

_M.captchaMode = captchaMode

return _M
