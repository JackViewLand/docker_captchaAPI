local captchaInfo = ngx.shared.captchaInfo
local captchaKey = os.getenv("captchaKey")
local captchaId = os.getenv("captchaId")
local captchaUrl_html = os.getenv("captchaUrl_html")
local captchaUrl_verify = os.getenv("captchaUrl_verify")
local captchaUrl_status = os.getenv("captchaUrl_status")

captchaInfo:set("captchaKey", captchaKey)
captchaInfo:set("captchaId", captchaId)
captchaInfo:set("captchaUrl_html", captchaUrl_html)
captchaInfo:set("captchaUrl_verify", captchaUrl_verify)
captchaInfo:set("captchaUrl_status", captchaUrl_status)
