Behavior = require './../behavior.coffee'
THREE = require 'threejs'
Util = require './../../../../utils/behaviorUtil.coffee'


class FlockPhysBehavior extends Behavior

  constructor:(boid, constraints) ->
    super

  update:(objs) ->
    separation = @calcSeparate objs
    alignment = @calcAlignment objs
    cohesion = @calcCohesion objs
    #avoid = Util.avoidWalls(@boid.getPosition(),(@boid.bounding/2),(@boid.bounding/3), @constraints.maxAvoid)

    separation.multiplyScalar @constraints.sepWeight
    alignment.multiplyScalar @constraints.aligWeight
    cohesion.multiplyScalar @constraints.cohWeight

    #point = @boid.object.goblin.position
    point =  new Goblin.Vector3(2,0,2)
    @boid.object.goblin.applyForce(separation,point)
    @boid.object.goblin.applyForce(alignment,point)
    @boid.object.goblin.applyForce(cohesion,point)
    #@boid.object.goblin.applyForce(avoid)
    #applyForceAtWorldPoint
    #@boid.object.goblin.angular_velocity.x = 1

    #@boid.object.goblin.applyForce(avoid)
    #@boid.getAcceleration().add(separation)
    #@boid.getAcceleration().add(alignment)
    #@boid.getAcceleration().add(cohesion)
    #@boid.getAcceleration().add(avoid)


  calcAlignment:(objs)->
    total = new THREE.Vector3(0,0,0)
    #total = new new Goblin.Vector3()
    count = 0

    for obj in objs
      if obj isnt @boid
        distLine = new THREE.Line3(@boid.getPosition(),obj.getPosition())
        distance = distLine.distance()
        if distance > 0 && distance < @constraints.aligRad
          total.add(obj.getVelocity())
          count++

    if count > 0
      total.divideScalar(count)
      total.normalize()
      total.multiplyScalar(@boid.maxSpeed)
      steer = new THREE.Vector3(0,0,0)
      steer.subVectors(total,@boid.getVelocity())
      steer = Util.limit(steer,@boid.maxForce)
      return steer

    else
      return new THREE.Vector3(0,0,0)

  calcCohesion:(objs) ->
    total = new THREE.Vector3(0,0,0)
    count = 0
    for obj in objs
      if obj isnt @boid
        distLine = new THREE.Line3(@boid.getPosition(), obj.getPosition())
        distance = distLine.distance()
        if distance > 0 and distance < @constraints.cohRad
          total.add(obj.getPosition())
          count++

    if count > 0
      total.divideScalar(count)
      return Util.seekSteer(total, @boid.getPosition(), @boid.getVelocity(), @boid.maxForce, @boid.maxSpeed)

    else
      return  new THREE.Vector3(0,0,0)


  calcSeparate:(objs) ->
    steer = new THREE.Vector3(0,0,0)
    vector = new THREE.Vector3(0,0,0)
    count = 0

    for obj in objs
      if obj isnt @boid
        distLine = new THREE.Line3(@boid.getPosition(), obj.getPosition())
        distance = distLine.distance()
        if distance > 0 and distance < @constraints.sepRad
          diff = new THREE.Vector3(0,0,0).subVectors(@boid.getPosition(), obj.getPosition())
          diff.normalize()
          diff = diff.divideScalar(distance)
          steer.add(diff)
          count++


    if (count > 0)
      steer.divideScalar(count)

    if(steer.length() > 0)
      steer.normalize()
      steer.multiplyScalar(@boid.maxSpeed)
      steer = steer.sub(@boid.getVelocity())
      steer = Util.limit(steer, @boid.maxForce)

    return steer



module.exports = FlockPhysBehavior
