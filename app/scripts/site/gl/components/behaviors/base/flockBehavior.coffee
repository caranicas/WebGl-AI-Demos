Behavior = require './../behavior.coffee'
THREE = require 'threejs'
Util = require './../../../../utils/behaviorUtil.coffee'

class FlockBehavior extends Behavior

  constructor:(boid,constraints) ->
    super

  update:(objs) ->
    super
    Util.facing(@boid)

  __calculateForces:(objs) ->
    @separation = @calcSeparate objs
    @alignment = @calcAlignment objs
    @cohesion = @calcCohesion objs

    @separation.multiplyScalar @constraints.sepWeight
    @alignment.multiplyScalar @constraints.aligWeight
    @cohesion.multiplyScalar @constraints.cohWeight

    @walls = Util.avoidWalls(@boid.getPosition(),(@boid.bounding/2),(@boid.bounding/10), @constraints.maxAvoid)

  __applyForces: ->
    console.log 'boid ',@,@boid.acceleration
    console.log 'avoid0 ', @avoids[0], @avoids[0].acceleration
    console.log 'avoid1 ', @avoids[1], @avoids[1].acceleration
    @boid.acceleration.add(@walls)
    console.log '\n\n\n'

    console.log 'boid post ',@, @boid.acceleration
    console.log 'avoid0 post  ', @avoids[0], @avoids[0].acceleration
    console.log 'avoid1 post ', @avoids[1], @avoids[1].acceleration

    @boid.acceleration.add(@separation)
    @boid.acceleration.add(@alignment)
    @boid.acceleration.add(@cohesion)


  calcAlignment:(boids)->
    total = new THREE.Vector3(0,0,0)
    count = 0

    for boid in boids
      if boid isnt @boid
        distLine = new THREE.Line3(@boid.getPosition(),boid.getPosition())
        distance = distLine.distance()
        if distance > 0 && distance < @constraints.aligRad
          total.add(boid.getVelocity())
          count++

    if count > 0
      total.divideScalar(count)
      total.normalize()
      total.multiplyScalar(@boid.maxVel)
      steer = new THREE.Vector3(0,0,0)
      steer.subVectors(total,@boid.getVelocity())
      steer = Util.limit(steer,@boid.maxForce)
      return steer

    else
      return new THREE.Vector3(0,0,0)

  calcCohesion:(boids) ->
    total = new THREE.Vector3(0,0,0)
    count = 0
    for boid in boids
      if boid isnt @boid
        distLine = new THREE.Line3(@boid.getPosition(), boid.getPosition())
        distance = distLine.distance()
        if distance > 0 and distance < @constraints.cohRad
          total.add(boid.getPosition())
          count++

    if count > 0
      total.divideScalar(count)
      return Util.seekSteer(total, @boid.getPosition(), @boid.getVelocity(), @boid.maxForce, @boid.maxVel)

    else
      return  new THREE.Vector3(0,0,0)

  calcSeparate:(boids) ->
    steer = new THREE.Vector3(0,0,0)
    vector = new THREE.Vector3(0,0,0)
    count = 0

    for boid in boids
      if boid isnt @boid
        distLine = new THREE.Line3(@boid.getPosition(), boid.getPosition())
        distance = distLine.distance()
        if distance > 0 and distance < @constraints.sepRad
          diff = new THREE.Vector3(0,0,0).subVectors(@boid.getPosition(), boid.getPosition())
          diff.normalize()
          diff = diff.divideScalar(distance)
          steer.add(diff)
          count++

    if (count > 0)
      steer.divideScalar(count)

    if(steer.length() > 0)
      steer.normalize()
      steer.multiplyScalar(@boid.maxVel)
      steer = steer.sub(@boid.getVelocity())
      steer = Util.limit(steer, @boid.maxForce)

    return steer



module.exports = FlockBehavior
