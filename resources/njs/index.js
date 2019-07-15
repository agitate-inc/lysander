const https = require('https');
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

let server = https.createServer(options, (req, res) => {
  let origin = req.headers["X-Forwarded-For"];
  let targetCol = db.collection(originAliasCol);
  let dataString

  req.on('data', function(data){
    dataString += data;
  })

  req.on('end', function(data){
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
        let origin = originAliasDoc.result.origin;
        let alias = originAliasDoc.result.alias;
        req.headers["X-Forwarded-For"] = alias;

        let amokReq = https.request(amokUnitAddr, { headers : req.headers, method : req.method, port : '443'}, (amokRes) => {
          amokRes.on('data', function(data){
            res.write(data);
          })
          amokRes.on('end', function(){
            res.end();
          })
        })
        amokReq.write(data);
        amokReq.end();
      })
    })
}

mongoClient.connect().then(function(err, connectedClient){
    db = connectedClient.db(dbName);
    server.listen(port);
});
