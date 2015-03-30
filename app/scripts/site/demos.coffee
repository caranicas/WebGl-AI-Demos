
Backbone   = require 'backbone'

module.exports = Backbone.Model.extend

  defaults:
    data:[
      {
        'url':'/flocking'
        'name':'flocking'
        'demoClass':require './gl/demos/flockingDemo.coffee'
      }

    ]
