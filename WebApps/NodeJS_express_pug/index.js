//Dependecies
var http = require('http');
var azure = require('azure-storage');
var jwtDecode = require("jwt-decode");
var TableUtilities = azure.TableUtilities;
var TableQuery = azure.TableQuery;
var dateformat = require('dateformat');
var express = require("express");
var app = express();
var roles = [];

app.set('views', 'views');
app.set('view engine', 'pug');

app.use(express.static("public"));

function getRoles(req){
    var token = req.headers["x-ms-token-aad-id-token"];
    //var userId = request.headers['x-ms-client-princirolespal-name'];
    if (token) {
        var decodedToken = jwtDecode(token);
        var groups = [];
        //get roles of signed user
        if (decodedToken.groups){
            decodedToken.groups.forEach(group => groups.push(group));
        }
        if (decodedToken.roles){
            decodedToken.roles.forEach(role => {
                role = role.replace('@', ' ');
                role = role.replace('&', 'ñ');
                role = role.replace('%', 'ó');
                roles.push(role)
            });
        }
        
    }
    console.log('roles: ' + roles);
    return roles;
}

app.get('/', function (req, res) {
    roles = getRoles(req);
    if (roles.indexOf(process.env.READ_ALL_ROLE) > -1){
            //var index = roles.indexOf(process.env.READ_ALL_ROLE);
            //roles.splice(index, 1);
            let now = new Date();
            var datePartition = dateformat(now, "yyyymm");
            var partitionKeyFilter = TableQuery.stringFilter('PartitionKey', TableUtilities.QueryComparisons.EQUAL, datePartition);
            var query = new azure.TableQuery().where(partitionKeyFilter);
            var tableSvc = azure.createTableService(process.env.BILLING_TABLE_URI, process.env.BILLING_TABLE_KEY);
            getAllSubscriptions(null);
            function getAllSubscriptions(token) {
                tableSvc.queryEntities('results', query, token, function (error, result, res) {
                    if (!error) {
                        for (var i = 0, entity; entity = result.entries[i]; i++) {
                            var jsonEntity = entity;
                            if (roles.indexOf(jsonEntity.RowKey._) === -1){
                                roles.push(jsonEntity.RowKey._);
                            }
                            token = result.continuationToken;
                            if (token){
                                getAllSubscriptions(token);
                            }
                        }
                    }
                });
            }
        }
    res.render('dashboard', {subscriptions: roles, currentSubscription: "", x_axis: ""});
});
  
app.get('/:subscription', function (req, response) {
    var roles = getRoles(req);
    var subscription = req.params.subscription;
    
    if (roles && roles.length > 0){
        var tableSvc = azure.createTableService(process.env.BILLING_TABLE_URI, process.env.BILLING_TABLE_KEY);

        let now = new Date();
        now = now.setMonth(now.getMonth() - 8);
        var datePartition = dateformat(now, "yyyymm");
        console.log(datePartition);

        queryTable(datePartition, subscription);
        function queryTable(datePartition, rowKey) {
            var query, rowKeyFilters, combinedFilters;
            var partitionKeyFilter = TableQuery.stringFilter('PartitionKey', TableUtilities.QueryComparisons.GREATER_THAN_OR_EQUAL, datePartition);
            
            if (roles.indexOf(subscription) === -1){
                response.sendFile(__dirname + '/404.html');
            } else {
                rowKeyFilters = TableQuery.stringFilter('RowKey', TableUtilities.QueryComparisons.EQUAL, subscription);
                combinedFilters = TableQuery.combineFilters('(' + rowKeyFilters, ')' + TableUtilities.TableOperators.AND, partitionKeyFilter);
                query = new azure.TableQuery().where(combinedFilters);
            }
            var entities = [];
            var jsonEntities = {};
            var token = null
            fetchAllEntities(token);
            function fetchAllEntities(token) {
                tableSvc.queryEntities('results', query, token, function (error, result, res) {
                    if (!error) {
                        for (var i = 0, entity; entity = result.entries[i]; i++) {
                                var jsonEntity = entity;
                            if (typeof entity.ExtendedCost !== 'undefined') {
                                delete jsonEntity["Cost"];
                                jsonEntity["ExtendedCost"]["_"] = (Math.round(jsonEntity["ExtendedCost"]["_"] * 100) / 100)
                            } else {
                                jsonEntity["Cost"]["_"] = (Math.round(jsonEntity["Cost"]["_"] * 100) / 100)
                            }
                            jsonEntities[i] = jsonEntity;
                            token = result.continuationToken;
                            if (token){
                                fetchAllEntities(token);
                            }
                        }
                        if(token == null){
                            console.log(JSON.stringify(jsonEntities));
                            var rows = jsonEntities;
    
                            //Copy the object content
                            var subscriptionsJSON = Object.assign({}, rows);
                            for (var j in subscriptionsJSON){
                                if (subscription != subscriptionsJSON[j].RowKey._){
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
                            var lastUpdate = subscriptionsJSON[Object.keys(subscriptionsJSON).length - 1].Timestamp._;
                            var time = new Date(lastUpdate)
                            lastUpdate = dateformat(time, "dd-mm-yyyy HH:MM:ss");
                            console.log(time.toUTCString());
                            for (var e in orderedCosts){
                                months.push(e);
                                costs.push(parseFloat(orderedCosts[e]));
                            }
                            response.render('dashboard', {subscriptions: roles, currentSubscription: subscription, x_axis: months, y_axis: costs, lastUpdate: lastUpdate});        
                        }
                    }
                });
            }
        }
    }
  });
  
const port = process.env.PORT || 1337;
app.listen(port);