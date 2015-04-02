THREE = require 'threejs'
Util = require './../../../../utils/behaviorUtil.coffee'
_ = require 'underscore'


class Entity

  mesh:null
  bounding:100
  acceleration:new THREE.Vector3(0,0,0)
  velocity:new THREE.Vector3(0,0,0)
  maxVel:2
  minSpeed:0.0
  maxForce:0.05

  constructor: ->
    @

  init:(defaults) ->
    _.extend(@,defaults)

  update:->
    @__updateVelocity()
    @__updatePosition()
    @__clearAccel()

  __updateVelocity: ->
    console.log 'update velocity ',@, @acceleration
    @velocity.add(@acceleration)
    @__capVelocity()

  __capVelocity: ->
    @velocity = Util.limit(@velocity, @maxVel)

  __clearAccel: ->
    @acceleration = new THREE.Vector3(0,0,0)

  __updatePosition: ->
    @mesh.position.x +=@velocity.x
    @mesh.position.y +=@velocity.y
    @mesh.position.z +=@velocity.z

  debugRender: ->

  getPosition: ->
    return @mesh.position

  getVelocity: ->
    return @velocity

  getAcceleration: ->
    return @acceleration


module.exports = Entity
