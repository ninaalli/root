#!/usr/bin/env node

var jade = require('jade');
var path = require('path');

console.log("Status: 200");
console.log("Content-Type: text/html");
console.log("");

// ensure that all paths are relative to this file's actual location
process.chdir(__dirname);

var fn = jade.compileFile('templates/index.jade');

console.log(fn({
  'username': process.env.USER || 'guest',
  'home': (process.env.HOME || '/home/guest').replace('/srv', ''),
  'shell': (process.env.SHELL_URI || 'https://52.11.72.188:4200/')
}));
