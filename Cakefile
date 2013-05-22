cp = require 'child_process'
q = require("q")

exec = (cmd) ->
  hasExec = q.defer()
  cp.exec cmd, (err, stdout, stderr) ->
    return hasExec.reject(err) if err?
    return hasExec.resolve(stdout + stderr)
  hasExec.promise

task "build", "build coffee script into javascript", ->
  exec("node node_modules/coffee-script/bin/coffee -c ./util/*.coffee")
    .then -> console.log("Coffee compiled...")