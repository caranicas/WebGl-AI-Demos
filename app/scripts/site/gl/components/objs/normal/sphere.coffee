
Static = require './static.coffee'
#Static = require './staticEntity.coffee'


class Sphere extends Static

  constructor: ->
    super

  init:(defaults) ->
    super

  getBounds: ->
    return @mesh.geometry.boundingSphere

  update:->
    super


module.exports = Sphere
