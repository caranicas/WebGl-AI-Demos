
Entity = require './entityPhys.coffee'

class BoidPhys extends Entity

  behavior:null

  constructor: ->
    super

  init:(defaults) ->
    super

  update:(objs)->
    @behavior.update(objs)
    super

module.exports = BoidPhys
