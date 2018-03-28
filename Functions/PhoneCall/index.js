//Dependecies
var request = require('request');
const rp = require('request-promise');

module.exports = function (context, inputBlob) {
    context.log("-------- Twilio phone call --------");
    
    var blobURL = "https://minsaitocrpoc.blob.core.windows.net/voice-templates/" + context.bindingData.blob;
    
    //Leer de keyVault
    const accountSid = 'AC861f071b53f8c69f36f0b941b6affb8a';
    const authToken = '0849cec7b05abf185771f779c52bbd5e';
    const client = require('twilio')(accountSid, authToken);

    client.calls
    .create({
        url: blobURL,
        to: '+34914808359',
        from: '+34911984521',
        method: 'GET',
    });
    context.done();
};
