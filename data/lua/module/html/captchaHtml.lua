local _M={}
local Html = [[
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <style>
            .iframe-container iframe {
                border: 0;
                height: 100%;
                left: 0;
                position: absolute;
                top: 0;
                width: 100%;
            }

            .container {
                display: flex;
                margin: 120px 0;
                justify-content: center;
                text-align: center;
            }

            html>body {
                margin: 0;
                padding: 0;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <silservice data-sil-id="o8xWOEIiQTXuPTHwQMvbvVR191rMhFxjPnm_EPk" data-callback="successCallback"></silservice>
            <div id="demo"></div>
        </div>

        <script async src="https://assets.siltcha.com/js/sil_service.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script>
            function successCallback(token) {
                document.getElementById("demo").innerHTML = "<div> Success </div><div> my token: " + token + " </div>";
                console.log(token);
                var data = {
                    neualgotoken: "",
                };
                data.neualgotoken = token + "ruleNameToken";
                $.post(window.location.href, data, function (r) {
		    location.reload();	
		}).catch(function (err) {
                    console.log(err);
                    location.reload();
                });
            }
        </script>
    </body>
</html>
]]

local function create_html(user_token)
    local html = Html
    html = ngx.re.gsub(html,"ruleNameToken", ":"..user_token, "jo")
    return html 
end

_M.html = Html
_M.create_html = create_html

return _M
