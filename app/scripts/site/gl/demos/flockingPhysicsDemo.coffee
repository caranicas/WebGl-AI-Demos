THREE = require 'threejs'
Demo = require './flockingDemo'
Behavior = require './../components/behaviors/flockPhysBehavior.coffee'
Boid = require './../components/objs/boidPhys.coffee'
Goblin = require 'goblinphysics'
Utils = require '../../utils/goblinUtils'

class FlockingPhysicsDemo extends Demo

  size:200
  vertOff:0
  flockCount:30

  constructor: ->
    super

  __initScene: ->
    super
    @__initGoblin()

  __initGoblin: ->
    BB = new Goblin.BasicBroadphase()
    NP = new Goblin.NarrowPhase()
    IS = new Goblin.IterativeSolver()
    @world = new Goblin.World(BB, NP, IS)
    @world.gravity.y = 0

  createBoids: ->
    i = 0
    wood_material = Utils.createMaterial( 'wood', 1, 1,@renderer)
    while i < @flockCount
      cone =  Utils.createCone(2, 3, 0.1, wood_material, true )
      randX = (Math.random()*(@size/5)) - (@size/10)
      randY = (Math.random()*(@size/5)) - (@size/10)
      randZ = (Math.random()*(@size/5)) - (@size/10)
      xvel = Math.random()*10
      yvel = 0
      zvel = 0#Math.random()*10
      cone.goblin.position.x = randX #0
      cone.goblin.position.y = randY
      cone.goblin.position.z = randZ
      boid = new Boid()
      boid.init({behavior:new Behavior(boid, @constraints), object:cone,constraints:@constraints, bounding:@size, initalVel:{xvel, yvel, zvel}})

      @sceneObjs.push(boid)
      @scene.add(cone)
      @world.addRigidBody(cone.goblin)

      ++i

  __update: ->
    @world.step( 1 / 60 )
    for entity in @sceneObjs
      entity.object.position.set(entity.object.goblin.position.x,entity.object.goblin.position.y,entity.object.goblin.position.z)
      entity.object.quaternion.set(entity.object.goblin.rotation.x,entity.object.goblin.rotation.y,entity.object.goblin.rotation.z,entity.object.goblin.rotation.w)
      entity.update(@sceneObjs)

module.exports = FlockingPhysicsDemo
