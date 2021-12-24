var webviewxInitialContent = """
                    <!DOCTYPE html>
          <html lang="en">
          
          <head>
      
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
      
              <style> </style>
      
          </head>
      
          <body>
      
              
            
      
                <label for="">Scan result</label> 
               <textarea name="" id="text-field" cols="30" rows="10" disabled></textarea>
      
      
          <script>
         
      
            function fromFlutter(data) {
              console.log(data);
              document.getElementById("text-field").value = data;
            }

            function onPageFinishedFromFlutter(data) {                
              console.log(data);
              return data;
            }

            function responseForFlutterRequest(data) {
              console.log(data);
              return 2;
            }


          </script>
      
          </body>
      
          </html>>
      
      """;
