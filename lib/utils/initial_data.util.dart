var initailData = """
                        <!DOCTYPE html>
                        <html lang="en">
                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
                            </head>
                            <body>
                                <h1>JavaScript Handlers</h1>
                                <script>
                                    window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
                                        window.flutter_inappwebview.callHandler('handlerFoo')
                                          .then(function(result) {
                                            // print to the console the data coming
                                            // from the Flutter side.
                                            console.log(JSON.stringify(result));
                                            
                                            window.flutter_inappwebview
                                              .callHandler('handlerFooWithArgs', 1, true, ['bar', 5], {foo: 'baz'}, result);

                                            window.flutter_inappwebview
                                              .callHandler('AjaxHandler', 'connection');



                                        });
                                    });

                                    
                                </script>
                            </body>
                        </html>
                    """;
