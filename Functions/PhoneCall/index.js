//Dependecies
var request = require('request');
const rp = require('request-promise');

module.exports = function (context, inputBlob) {
    context.log("-------- Twilio phone call --------");
    
    var blobURL = "" + context.bindingData.blob;
    
    //Leer de keyVault
    const accountSid = '';
    const authToken = '';
    const client = require('twilio')(accountSid, authToken);

    client.calls
    .create({
        url: blobURL,
        to: '+',
        from: '+',
        method: 'GET',
    });
    context.done();
};
