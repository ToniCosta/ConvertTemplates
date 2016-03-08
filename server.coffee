express = require 'express'
Route = require './route'
app = new express
route = new Route app

port = process.env.PORT or 4000

app.listen port 
console.log "server running on port #{port}"


