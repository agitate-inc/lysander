const https = require('https');
const httpProxy = require('http-proxy')
const fs = require('fs');
const keyLocation = '/etc/letsencrypt/live/flawlesscougarbuffet.tk/privkey.pem';
const certLocation = '/etc/letsencrypt/live/flawlesscougarbuffet.tk/fullchain.pem';
const port = 8217;
const MongoClient = require('mongodb').MongoClient;
const mongoURL = 'mongodb://localhost:27017';
const mongoClient = new MongoClient(mongoURL);
const options = {
  key : fs.readFileSync(keyLocation),
  cert : fs.readFileSync(certLocation)
}
let dbName = 'userData';
let originAliasCol = 'originAliases';
let amokUnitAddr = '35.184.67.220'
let db


let generateIP = function(){
  return (Math.floor(Math.random() * 255) + 1)+"."+(Math.floor(Math.random() * 255) + 0)+"."+(Math.floor(Math.random() * 255) + 0)+"."+(Math.floor(Math.random() * 255) + 0);
}

let proxy = httpProxy.createProxyServer({ ssl : {key : fs.readFileSync(keyLocation, 'utf8'), cert : fs.readFileSync(certLocation, 'utf8')}
, target : `https://${amokUnitAddr}`, secure : true })

proxy.on('error', function(err){
  console.log(err);
})


let server = https.createServer(options, (req, res) => {
  let origin = req.headers["x-forwarded-for"];
  let targetCol = db.collection(originAliasCol);
  let dataString
	console.log(origin);
  targetCol.findOne({"origin" : origin})
    .then(function(findOneReturn){
      let alias;

      if(!findOneReturn){
        alias = generateIP();
        return targetCol.insertOne({"origin" : origin, "alias" : alias});
      }
        return findOneReturn;
      })
      .then(function(originAliasDoc){
        let origin = originAliasDoc.origin;
        let alias = originAliasDoc.alias;
        req.headers["x-forwarded-for"] = alias;
	req.headers["x-real-ip"] = alias;
        req.headers["host"] = 'flawlesscougarbuffet.tk'
        proxy.web(req, res);
      })
    })

mongoClient.connect().then(function(connectedClient){
    db = connectedClient.db(dbName);
    server.listen(port);
});
