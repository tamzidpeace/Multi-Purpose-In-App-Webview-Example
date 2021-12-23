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

             <input type="text" id="text-field">


            <script>

              const call = () => {
                console.log('bcs');
                // console.log(1);
              }

               function fromFlutter(data) {
              // Do something
              console.log("This is working now!!!");
              }

              window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
                  window.flutter_inappwebview
                    .callHandler('AjaxHandler', 'ip', 'location', 'connection', 'mac', 'bcs')
                    .then(function(result) {
                        console.log(JSON.stringify(result));
                  });


                  window.flutter_inappwebview.callHandler('handlerFoo').then(function(result) {
                    console.log('1234');
                  });
              });

              
          

            </script>

        </body>

    </html>


""";
