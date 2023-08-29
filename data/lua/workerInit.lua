local tool = require "/data/lua/module/object/toolModule"
local cjson = require "cjson"
local captchaInfo = ngx.shared.captchaInfo
local captcha = require 'module/object/waf/action/captchaModule'

-- check captcha status
local checkCaptchaStatus = captcha.checkCaptchaStatus
local ok, err = ngx.timer.every(10, checkCaptchaStatus)
if not ok then
    ngx.log(ngx.ERR, "Failed to create timer: ", err)
end

