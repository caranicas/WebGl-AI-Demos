THREE = require 'threejs'

class EntityPhys

  object:null
  bounding:100

  maxSpeed:10
  minSpeed:0.3
  maxForce:0.05

  constructor: ->
    @

  init:(defaults) ->
    @behavior = defaults.behavior
    @object = defaults.object
    @bounding = defaults.bounding
    if defaults.initalVel?
      @object.goblin.linear_velocity.x = defaults.initalVel.xvel
      @object.goblin.linear_velocity.y = defaults.initalVel.yvel
      @object.goblin.linear_velocity.z = defaults.initalVel.zvel
    else
      @object.goblin.linear_velocity.x = 1
      @object.goblin.linear_velocity.y = 0
      @object.goblin.linear_velocity.z = 0

  update:(objs)->
    @behavior.update(objs)
    @__loopPosition()

  __capVelocity: ->
    # @velocity = Util.limit(@velocity, @maxSpeed);

  __updateFacing: ->
    # norm = @velocity.clone()
    # norm.normalize();
    # @mesh.rotation.x = norm.z
    # @mesh.rotation.y = norm.z
    # @mesh.rotation.z = norm.z
    # quat = Util.facing(@)
    # @mesh.rotation.setFromQuaternion(quat,'XYZ')

  __loopPosition: ->
    edges = @bounding/2
    if @object.goblin.position.x > edges
      @object.goblin.position.x = -edges;
    else if @object.goblin.position.x < -edges
      @object.goblin.position.x = edges;

    if @object.goblin.position.y > edges
      @object.goblin.position.y = -edges;
    else if @object.goblin.position.y < -edges
      @object.goblin.position.y = edges;

    if @object.goblin.position.z > edges
      @object.goblin.position.z = -edges;
    else if @object.goblin.position.z < -edges
      @object.goblin.position.z = edges;

  debugRender: ->

  getPosition: ->
    return @object.goblin.position

  getVelocity: ->
    return @object.goblin.linear_velocity

  getAcceleration: ->
    return @object.goblin.acceleration



module.exports = EntityPhys
