var webviewxInitialContent = """
                    <!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="./icon.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link rel="stylesheet" href="./index.css">
    <title>WVX</title>
</head>

<body>

    <div class="pt-3 px-5 pb-3 code-scan text-center">

        <input type="text" class="form-control" id="code-result" placeholder="scan result">

        

        <button onclick="testPlatformSpecificMethod(123);" type="button" class="btn btn-primary btn-block mt-3">Scan</button>


    </div>

    <div class="divider">

    </div>

    <div class="image text-center">
       
        <img class="img img-thumbnail my-3" height="300" width="300" src="./download.png" alt="" srcset="">
        
        <br>
            
        <button type="button" class="btn btn-primary  ">Take Image</button>
        
    </div>

    <div class="divider"></div>

    <div class="ip-ui text-center mt-3 mx-5">
        
        <h3 id="ip">IP: __</h3>
        <h3 id="uid">UID: __</h3>
        
    </div>



    <!-- js::begin -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
        crossorigin="anonymous"></script>
    <!--<script src="./index.js"></script>-->
    
    <script>
    
    function onPageFinishedFromFlutter(data) {
    console.log(data);
    return data;
}

function responseForFlutterRequest(data) {
    console.log(data);
    document.getElementById("result").innerHTML = data;
    return;
}

function setIP(data) {
    console.log(data);
    document.getElementById("ip").innerHTML = 'IP: ' + data;
    return;
}

function setUI(data) {
    console.log(data);
    document.getElementById("uid").innerHTML = 'UID: ' + data;
    return;
}


function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }

        
    </script>
    <!-- js::end -->
</body>

</html>
      
      """;
