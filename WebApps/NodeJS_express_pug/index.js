//Dependecies
var express = require("express");
var app = express();

app.set('views', 'views');
app.set('view engine', 'pug');

app.use(express.static("public"));

var roles = ["CSCYT", "IntelligentValuations"];
app.get('/', function (req, res) {
    res.render('dashboard', {subscriptions: roles, currentSubscription: ""});
});

app.get('/:suscription', function (req, res) {
    var suscription = req.params.suscription;
    var rows = {"0":{"PartitionKey":{"_":"201807"},"RowKey":{"_":"CSCYT"},"Codigo":{"_":"UNK"},"ExtendedCost":{"_":"83.53€"},"Elemento":{"_":"UNK"},"Owner":{"_":"JoséIgnacioAguillo"}},"1":{"PartitionKey":{"_":"201807"},"RowKey":{"_":"IntelligentValuations"},"Codigo":{"_":"AVALIM"},"Elemento":{"_":"6"},"ExtendedCost":{"_":"2762.04€"},"Owner":{"_":"RafaelSánchezRiesco"}},"2":{"PartitionKey":{"_":"201806"},"RowKey":{"_":"IntelligentValuations"},"Codigo":{"_":"AVALIM"},"Elemento":{"_":"6"},"ExtendedCost":{"_":"2114€"},"Owner":{"_":"RafaelSánchezRiesco"}},"3":{"PartitionKey":{"_":"201805"},"RowKey":{"_":"IntelligentValuations"},"Codigo":{"_":"AVALIM"},"Elemento":{"_":"6"},"ExtendedCost":{"_":"1752,21€"},"Owner":{"_":"RafaelSánchezRiesco"}},"4":{"PartitionKey":{"_":"201808"},"RowKey":{"_":"IntelligentValuations"},"Codigo":{"_":"AVALIM"},"Elemento":{"_":"6"},"ExtendedCost":{"_":"3287,12€"},"Owner":{"_":"RafaelSánchezRiesco"}}};
    
    //Copy the object content
    var subscriptionsJSON = Object.assign({}, rows);
    for (var i in rows){
        if (suscription != rows[i].RowKey._){
            delete subscriptionsJSON[i];
        }
    }

    //get costs
    var costs = []
    for (var e in subscriptionsJSON){
        costs.push(parseFloat(subscriptionsJSON[e].ExtendedCost._));
    }

    //get months
    var months = []
    for (var el in subscriptionsJSON){
        months.push(subscriptionsJSON[el].PartitionKey._);
    }
    
    res.render('dashboard', {subscriptions: roles, currentSubscription: subscriptionsJSON, x_axis: months.sort(), y_axis: costs})
  });
  
app.listen(3000, function(){
    console.log("Listening on port 3000!")
});