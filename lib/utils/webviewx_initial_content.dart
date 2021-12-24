var webviewxInitialContent = """
                    <!DOCTYPE html>
          <html lang="en">
          
          <head>
      
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
      
              <style> </style>
      
          </head>
      
          <body>
      
              
              <h3 for="">Requst Result: </h3> 
              <h4 id="result">Hello</h4>               

              <br/> <br/>
               
               
      
              <label for="">Scan result</label> 
               <textarea name="" id="text-field" cols="30" rows="10" ></textarea>
      
      
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
              document.getElementById("result").innerHTML = data;
              return;
            }


          </script>
      
          </body>
      
          </html>>
      
      """;
