THREE = require 'threejs'
Demo = require './flockingDemo'
Boid = require './../components/objs/normal/boid.coffee'
Behavior = require './../components/behaviors/base/flockAvoidBehavior.coffee'
Constraint = require './../components/behaviors/constraints/flockAvoidConstraint.coffee'
Static = require './../components/objs/normal/sphere.coffee'
Utils = require '../../utils/goblinUtils'


class FlockingAvoidDemo extends Demo

  flockCount:30
  avoidCount:1
  avoidObjs:new Array()

  constructor: ->
    super

  __initScene: ->
    super
    @constraints = new Constraint()

  __initGeometry: ->
    @__createAvoidObjects()
    super

  __initDat:->
    super

  createBoids: ->
    i = 0
    while i < @flockCount
      randX = (Math.random()*(@size/5)) - (@size/10)
      randY = (Math.random()*(@size/5)) - (@size/10)
      randZ = -100#(Math.random()*(@size/5)) - (@size/10)
      geometry = new THREE.CylinderGeometry(0,1,4,8,1)
      material = new THREE.MeshLambertMaterial( { color: 0x00ffff, wireframe: false} )
      themesh = new THREE.Mesh( geometry, material )
      themesh.position.set(randX,randY,randZ)
      boid = new Boid()
      xvel = 0#Math.random()
      yvel = 0#Math.random()
      zvel = 0.2 #Math.random()
      boid.init({behavior:new Behavior(boid,@constraints,@avoidObjs), mesh:themesh, bounding:@size, velocity:new THREE.Vector3(xvel, yvel, zvel)})
      @boids.push(boid)
      @scene.add(boid.mesh)
      @sceneObjs.push(boid)
      ++i

  __createAvoidObjects: ->
    i = 0
    while i < @avoidCount
      randX = 0#(Math.random()*@size) - (Math.random()*@size)
      randY = 0#(Math.random()*@size) - (Math.random()*@size)
      randZ = 0#(Math.random()*@size) - (Math.random()*@size)
      geometry = new THREE.SphereGeometry(10, 8, 6)
      material = new THREE.MeshLambertMaterial( { color: 0xff00ff, wireframe: false} )
      themesh = new THREE.Mesh( geometry, material )
      themesh.position.set(randX,randY,randZ)
      avoid = new Static()
      avoid.init({mesh:themesh, velocity:new THREE.Vector3()})
      @scene.add(avoid.mesh)
      @avoidObjs.push(avoid)
      @sceneObjs.push(avoid)
      ++i

  __update: ->
    for entity in @boids
      entity.update(@boids)

    #for avoid in @avoidObjs
    #  avoid.update()



module.exports = FlockingAvoidDemo
