cp = require 'child_process'
q = require("q")


exec = q.nfbind(cp.exec)

task "build", "build coffee script into javascript", ->
  exec("node node_modules/coffee-script/bin/coffee -c ./util/*.coffee")
    .then -> console.log("Coffee compiled...")