const express = require('express');
const app = express();

var path = require('path');
var sdk = require('./sdk');

const PORT = 8080;
const HOST = 'localhost';

app.get('/api/getWallet', function (req, res) {
    var walletid = req.query.walletid;

    let args = [walletid];

    sdk.send(false, 'getWallet', args, res);
});
app.get('/api/setCar', function (req, res) {
    var title = req.query.title;
    var singer = req.query.singer;
    var price = req.query.price;
    var walletid = req.query.walletid;

    let args = [title, singer, price, walletid];
    sdk.send(true, 'setCar', args, res);
});
app.get('/api/getAllCar', function (req, res) {
    let args = [];
    sdk.send(false, 'getAllCar', args, res);
});
app.get('/api/purchaseCar', function (req, res) {
    var walletid = req.query.walletid;
    var key = req.query.Carkey;
    
    let args = [walletid, key];
    sdk.send(true, 'purchaseCar', args, res);
});
app.use(express.static(path.join(__dirname, './client')));

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
