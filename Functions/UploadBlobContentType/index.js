var azure = require('azure-storage');
var streamifier = require('streamifier');

module.exports = function (context, inputBlob) {
    
    var content = '<?xml version="1.0" encoding="UTF-8"?><Response><Say voice="alice" language="es-ES">' + inputBlob + '</Say></Response>' 
    var options = {contentSettings:{contentType:'application/xml'}}
    var outputFileName = context.bindingData.blobname + ".xml"; 
    var blobService = azure.createBlobService("--");

    content_stream = streamifier.createReadStream(content);
    content_stream.pipe(blobService.createWriteStreamToBlockBlob("voice-templates", outputFileName, options, function(error, result, response) {
        if (!error) {
            context.log("File uploaded");
        }
        else{
            context.log("Error uploading file");
        }
    }));
    
    
    context.done();
};
