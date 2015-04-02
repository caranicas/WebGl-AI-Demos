Behavior = require './flockBehavior.coffee'
THREE = require 'threejs'
Util = require './../../../../utils/behaviorUtil.coffee'

class FlockAvoidBehavior extends Behavior

  avoids:null

  constructor:(boid,constraints,avoids) ->
    super
    @avoids = avoids

  update:(objs) ->
    super

  __calculateForces:(objs) ->
    super
    @avoidance = @__calcAvoidance()
    @avoidance.multiplyScalar @constraints.avoidWeight

  __applyForces: ->
    super
    @boid.getAcceleration().add(@avoidance)


  __calcAvoidance: ->
    ahead = Util.lookAhead(@boid.getPosition(),@boid.getVelocity(), @constraints.seeAhead)
    avoidMe = @__findAvoidObject(ahead)
    avoid =  new THREE.Vector3()

    if avoidMe

      ortho  = new THREE.Vector3(Util.randomUnit(),Util.randomUnit(),Util.randomUnit()).normalize()
      vel = @boid.getVelocity()
      avoid = avoid.crossVectors( vel, ortho )
    avoid

  __findAvoidObject:(ahead) ->
    closest = null
    for avoid in @avoids
      if avoid.getBounds().containsPoint ahead
        if closest is null
          closest = avoid

    closest




module.exports = FlockAvoidBehavior
