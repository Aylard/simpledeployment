'use strict';

const http = require('http')
const fs = require('fs')
const util = require('util');
const logFile = fs.createWriteStream(__dirname + '/logs/debug.log', {flags : 'w'});
const appDir = __filename.replace('app.js', '')
let logStdOut = process.stdout;

const config = {
 port: (process.env.PORT || 3000 )
}

function logToFile(message) {
  logFile.write(util.format(message) + '\n');
  logStdOut.write(util.format(message) + '\n');
}

function returnServerError(response, reason, statusCode) {
 logToFile("!! ERROR: " + (statusCode? statusCode : 500) + "\n" + reason)
 response.writeHead((statusCode? statusCode : 500), {"Content-Type": "text/plain"});
 response.write(reason)
 response.end()
}

function setContentTypeHeader(file) {
 switch (file.substr(file.length - 3).replace('.', '')) {
   case 'css':
     return 'text/css'
   case 'js':
     return 'application/javascript'
   default:
     return 'text/html'
 }
}

function loadFile(response, file) {
 file = appDir + file
 logToFile(".. Trying to load file: " + file)

 fs.exists(file, (exists) => {
   if (!exists) {
     returnServerError(response, "404 File not found\n", 404)
     return
   }

   if (fs.statSync(file).isDirectory()) file += '/index.html'

   fs.readFile(file, "binary", (err, data) => {
     if (err) {
       returnServerError(response, err + "\n")
       return
     }

     response.writeHead(200, {
         "Content-Type": setContentTypeHeader(file) +"; charset=utf-8"
     })
     response.write(data, "binary")
     response.end()
   })
 })
}

function requestHandler (request, response) {
 let url = request.url.substring(1)
 let routeFound = false
 response.statusCode = 200
 logToFile("")
 logToFile(">> Starting request: " + url)
 logToFile("")

 logToFile(".. URL: "+ url)

 for(let i = 0; i < routes.length; i++) {
   if (url.match(routes[i].key) !== null) {
     routes[i].exec(response, url)
     routeFound = true
     break
   }
 }

 if (routeFound === false) {
   returnServerError(response, "404 Route not found\n", 404)
 }
 logToFile("<< request ended")
}

const routes = [
 {
   key: /(.*)(.css|.js|.jpg|.png)+/gi,
   exec: (response, url) => {
    logToFile("== STATIC request")
    loadFile(response, url)
   }
 },
 {
   key: '',
   exec: (response, url) => {
     logToFile("== INDEX request")
     try {
       loadFile(response, 'static/index.html')
     } catch (e) {
       logToFile(e)
       returnServerError(response, e, 500)
     }
   }
 }
]

http.createServer(requestHandler).listen(config.port, (err) => {
 if (err)
   return logToFile("!! Error occured:", err)

 logToFile("=== Server started on " + config.port + " ===")
})
