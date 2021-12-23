var initailData =
    """
    
    <!DOCTYPE html>
    <html lang="en">
        
        <head>

            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">

            <style> </style>

        </head>

        <body>

            <h1>JavaScript Handlers</h1>
            <button onclick="call()"> Send Data </button>


            <script>

              const call = () => {
                console.log('bcs');
              }

              window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
                  window.flutter_inappwebview
                    .callHandler('AjaxHandler', 'ip', 'location', 'connection', 'mac', 'bcs')
                    .then(function(result) {
                        console.log(JSON.stringify(result));
                  });
              });

                
            </script>

        </body>

    </html>


""";
