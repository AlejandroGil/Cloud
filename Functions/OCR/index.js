//Dependecies
var request = require('request');

module.exports = function (context, myBlob) {
    context.log("---------- OCR -----------");
    
    //Image extension validation
    var extension = context.bindingData.blobextension;
    var validExtensions = ["png", "jpg", "gif", "bmp"];
    if (validExtensions.indexOf(extension.toLowerCase()) == -1){
       context.log("Invalid extension")
       context.done();
    }

    //API Request params 
    var ocrKey = "2720b5ee809449e99a9bb9a944fd3168";
    var translateKey = "c9a474e7eb344722ba86722bcefea4f0";
    var uriBaseOcr = "https://northeurope.api.cognitive.microsoft.com/vision/v1.0/ocr";
    var uriBaseTranslate = "https://api.microsofttranslator.com/V2/Http.svc/Translate";
    var imageURL = "https://minsaitocrpoc.blob.core.windows.net/images/" + context.bindingData.blobname + "." + extension;
    var ocrBody = '{"' + "url" + '":"' + imageURL + '"}';
    var ocrParams = {
        "detectOrientation ": "true",
    };

    // Perform the REST API call.
    var url =  uriBaseOcr + "?" + ocrParams;
    
    request.post({
        headers: {'content-type' : 'application/json',
                  'Ocp-Apim-Subscription-Key' : ocrKey},
        url:     url,
        body:    ocrBody
        }, function(error, response, body){
        context.log("-------- OCR API Response --------");
        context.log(body);

        //Parse JSON
        body = JSON.parse(body);
        var lan = body['language'];
        var lines = body['regions'][0]['lines'];
        var result = "";

        for (var i = 0; i < lines.length; i++){
            var words = lines[i]['words'];
            for (var j = 0; j < words.length; j++){
                result = result + ' ' + (words[j]['text']);
            }
        }
        context.log(result)

        if (lan !== "unk"){
            context.bindings.outputBlob = result;
        }
        context.done();
    });
};


