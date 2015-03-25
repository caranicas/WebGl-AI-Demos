
Backbone   = require 'backbone'

module.exports = Backbone.Model.extend

  defaults:
    data:[
      {
        'url':'/facing'
        'name':'facing'
        'demoClass':require './gl/demos/facingDemo.coffee'
      }

      {
        'url':'/flocking'
        'name':'flocking'
        'demoClass':require './gl/demos/flockingDemo.coffee'
      }

    ]
