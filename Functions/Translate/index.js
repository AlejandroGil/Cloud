//Dependecies
var request = require('request');

module.exports = function (context, inputBlob) {
    context.log("-------- Translate API Response --------");

    var translateKey = "c9a474e7eb344722ba86722bcefea4f0";
    var uriBaseTranslate = "https://api.microsofttranslator.com/V2/Http.svc/Translate";
    var extension = context.bindingData.blobextension;
    var textURL = "https://minsaitocrpoc.blob.core.windows.net/results/" + context.bindingData.blobname + "." + extension;

    //Translate text to spanis

    var trParams = "appid&text=" + inputBlob + "&to=es"

    // Perform the REST API call.
    var urlTranslate =  uriBaseTranslate + "?" + trParams;

    var trRequest = {
        url: urlTranslate,
        headers: {
            'Ocp-Apim-Subscription-Key': translateKey
        }
    };
           
    request.get({
        headers: {'Ocp-Apim-Subscription-Key' : translateKey},
        url: urlTranslate,
        }, function (error, response, body) {
        //Parse XML
        var translatedText = body.slice(body.indexOf(">") + 1, body.lastIndexOf("<"));
        
        context.log(translatedText)
        context.bindings.outputBlob = translatedText;
        context.done();
    });
    
};