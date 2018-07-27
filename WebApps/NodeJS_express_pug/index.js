//Dependecies
var express = require("express");
var app = express();

app.set('views', 'views');
app.set('view engine', 'pug');

app.use(express.static("public"));

var roles = ["CSCYT", "IntelligentValuations"];
app.get('/', function (req, res) {
    res.render('dashboard', {subscriptions: roles, currentSubscription: "", x_axis: ""})
});

app.get('/:suscription', function (req, res) {
    var suscription = req.params.suscription;
    var rows = {"0":{"PartitionKey":{"_":"201807"},"RowKey":{"_":"CSCYT"},"Codigo":{"_":"UNK"},"Cost":{"_":"83.53"},"Elemento":{"_":"UNK"},"Owner":{"_":"JoséIgnacioAguillo"}},"1":{"PartitionKey":{"_":"201807"},"RowKey":{"_":"IntelligentValuations"},"Codigo":{"_":"AVALIM"},"Elemento":{"_":"6"},"ExtendedCost":{"_":"2762.04"},"Owner":{"_":"RafaelSánchezRiesco"}},"2":{"PartitionKey":{"_":"201806"},"RowKey":{"_":"IntelligentValuations"},"Codigo":{"_":"AVALIM"},"Elemento":{"_":"6"},"ExtendedCost":{"_":"2114"},"Owner":{"_":"RafaelSánchezRiesco"}},"3":{"PartitionKey":{"_":"201805"},"RowKey":{"_":"IntelligentValuations"},"Codigo":{"_":"AVALIM"},"Elemento":{"_":"6"},"ExtendedCost":{"_":"1752.21"},"Owner":{"_":"RafaelSánchezRiesco"}},"4":{"PartitionKey":{"_":"201808"},"RowKey":{"_":"IntelligentValuations"},"Codigo":{"_":"AVALIM"},"Elemento":{"_":"6"},"ExtendedCost":{"_":"3287.12"},"Owner":{"_":"RafaelSánchezRiesco"}},"5":{"PartitionKey":{"_":"201801"},"RowKey":{"_":"IntelligentValuations"},"Codigo":{"_":"AVALIM"},"Elemento":{"_":"6"},"ExtendedCost":{"_":"2762.04"},"Owner":{"_":"RafaelSánchezRiesco"}},"6":{"PartitionKey":{"_":"201802"},"RowKey":{"_":"IntelligentValuations"},"Codigo":{"_":"AVALIM"},"Elemento":{"_":"6"},"ExtendedCost":{"_":"2114"},"Owner":{"_":"RafaelSánchezRiesco"}},"7":{"PartitionKey":{"_":"201803"},"RowKey":{"_":"IntelligentValuations"},"Codigo":{"_":"AVALIM"},"Elemento":{"_":"6"},"ExtendedCost":{"_":"1752.21"},"Owner":{"_":"RafaelSánchezRiesco"}},"8":{"PartitionKey":{"_":"201804"},"RowKey":{"_":"IntelligentValuations"},"Codigo":{"_":"AVALIM"},"Elemento":{"_":"6"},"ExtendedCost":{"_":"3287.12"},"Owner":{"_":"RafaelSánchezRiesco"}}};
    
    //Copy the object content
    var subscriptionsJSON = Object.assign({}, rows);
    for (var i in rows){
        if (suscription != rows[i].RowKey._){
            delete subscriptionsJSON[i];
        }
    }

    var orderedCosts = {};
    for (var k = 0; k < Object.keys(rows).length; k++){
        if (subscriptionsJSON[k] != undefined){
            var pk = subscriptionsJSON[k].PartitionKey._;
            if (subscriptionsJSON[k].ExtendedCost != undefined){
                orderedCosts[pk] = subscriptionsJSON[k].ExtendedCost._;
            }
            else {
                orderedCosts[pk] = subscriptionsJSON[k].Cost._;
            }
        }
    }

    var months = [];
    var costs = [];
    for (var e in orderedCosts){
        months.push(e);
        costs.push(parseFloat(orderedCosts[e]));
    }
    res.render('dashboard', {subscriptions: roles, currentSubscription: suscription, x_axis: months, y_axis: costs});
  });
  
app.listen(3000, function(){
    console.log("Listening on port 3000!")
});