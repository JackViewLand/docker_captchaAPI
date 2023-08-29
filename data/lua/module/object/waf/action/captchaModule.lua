local tool = require 'module/object/toolModule'
local cjson = require 'cjson'
local html = require 'module/html/captchaHtml' 
local ngx_re = require "ngx.re"
local captchaInfo = ngx.shared.captchaInfo
local writeLuaLog = true

local _M = {}

local function checkCaptchaStatus()
    local captchaKey = captchaInfo:get("captchaKey")
    local siltchaUrl = captchaInfo:get("captchaUrl_status")

    local http = require "resty.http"
    local httpc = http.new()

    local res, err = httpc:request_uri(siltchaUrl, {
        method = "GET",
        ssl_verify = false,
        headers = {
            ["client-token"] = captchaKey,
        },
        keepalive_timeout = 60,
        keepalive_pool = 10
    })
    if res then
        local res_data = cjson.decode(res.body)
        local isRunning = false
        if res_data['status'] == "RUNNING" then 
            isRunning = true
            --tool.swrite("check captcha status: RUNNING")
        else
            tool.swrite("----reconnect captcha----")
        end
    end
    return isRunning
end

local function access(user_uniInfo,user_token)
    local method = ngx.req.get_method()
    local bucketList = ngx.shared.bucketList
    local captchaToken,ruleNameToken = "",""
    local user_info = tool.getInfo()
    local captchaUrl = captchaInfo:get("captchaUrl_verify")
    local captchaKey = captchaInfo:get("captchaKey")
    local var_writeLuaLog = ngx.var.writeLuaLog or nil
    if var_writeLuaLog == 'false' then writeLuaLog = false end

    if writeLuaLog then tool.swrite("---hit captcha access") end
    
    local bucketList_time = tonumber(ngx.ctx.bucketListTime)
    if not bucketList_time then bucketList_time = 600 end

    if method == 'POST' then
        if writeLuaLog then tool.swrite("---hit second verify /post") end
        local http = require "resty.http"
        local cjson = require "cjson"
        ngx.req.read_body()
        local args,err = ngx.req.get_post_args(200)
        local neualgotoken = args.neualgotoken
        for key, val in pairs(args) do
            if key == "neualgotoken" then
                captchaToken  = ngx_re.split(val,":")[1]
                ruleNameToken = ngx_re.split(val,":")[2]
            end
        end
	
        local captchaIp = user_info["ip"]
        local data = '{"token":"'..captchaToken..'","ip":"'..captchaIp..'"}'

        local httpc = http.new()
	
        
	local res, err = httpc:request_uri(captchaUrl, {
            method = "POST",
            body = data,
            ssl_verify = false,
            headers = {
                ["client-token"] = captchaKey,
                ["Content-Type"] = "application/json",
            },
            keepalive_timeout = 60,
            keepalive_pool = 10
        })

	if writeLuaLog then
            if not res then tool.swrite(tool.getTime()..": captch verify get response nil") end
            if err then tool.swrite(tool.getTime()..": error post to neualgo captcha: "..err) end
	end

        if res then
            local captchaRespJson = res.body
            -- save second verify result log
            if writeLuaLog then tool.swrite(tool.getTime()..": second verify result: "..captchaRespJson) end
            local captchaRespTbl = cjson.decode(captchaRespJson)
            if captchaRespTbl["success"] == true then
                -- save success log
		        if writeLuaLog then
                    tool.swrite(tool.getTime()..": second verify success!("..user_token..")")
                    tool.swrite("--save bucketList: "..user_token)
		        end
                bucketList:set(user_uniInfo,user_token,bucketList_time)
                --return ngx.exit(200)
            else
                -- save fail log
		        if writeLuaLog then
                    tool.swrite(tool.getTime()..": second verify fail! reload verify page("..user_token..")")
                    tool.swrite("--return captcha html")
		        end
                local page = html.create_html(user_token)
                ngx.say(page)
            end
        end
    else

	if writeLuaLog then
        tool.swrite(tool.getTime()..": user first time login("..user_token..")")
	    tool.swrite("---frist request create captcha html")
	end

	local page = html.create_html(user_token)
	ngx.status = 200
	ngx.header["content-type"] = "text/html"
    	ngx.say(page)
	ngx.exit(200)
		
    end
end

_M.access = access
_M.checkCaptchaStatus=checkCaptchaStatus

return _M
