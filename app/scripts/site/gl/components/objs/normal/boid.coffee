
Entity = require './entity.coffee'

class Boid extends Entity

  behavior:null

  constructor: ->
    super
    @

  init:(defaults) ->
    super

  update:(args)->
    @behavior.update(args)
    super

  __loopPosition: ->
    edges = @bounding/2
    if @mesh.position.x > edges
      @mesh.position.x = -edges
    else if @mesh.position.x < -edges
      @mesh.position.x = edges

    if @mesh.position.y > edges
      @mesh.position.y = -edges
    else if @mesh.position.y < -edges
      @mesh.position.y = edges

    if @mesh.position.z > edges
      @mesh.position.z = -edges
    else if @mesh.position.z < -edges
      @mesh.position.z = edges

module.exports = Boid
