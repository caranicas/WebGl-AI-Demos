THREE = require 'threejs'
Demo = require './flockingDemo'
Boid = require './../components/objs/normal/boid.coffee'
Behavior = require './../components/behaviors/base/flockAvoidBehavior.coffee'
Constraint = require './../components/behaviors/constraints/flockAvoidConstraint.coffee'
Static = require './../components/objs/normal/sphere.coffee'
Utils = require '../../utils/goblinUtils'


class FlockingAvoidDemo extends Demo

  flockCount:1
  avoidCount:2
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
      randX = 0#(Math.random()*(@size/5)) - (@size/10)
      randY = 0#(Math.random()*(@size/5)) - (@size/10)
      randZ = -99#(Math.random()*(@size/5)) - (@size/10)
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
      randX = 0#((Math.random()*@size) - @size/2)
      randY = 0#((Math.random()*@size) - @size/2)
      randZ = 0#((Math.random()*@size) - @size/2)
      geometry = new THREE.SphereGeometry(4, 8, 6)
      material = new THREE.MeshLambertMaterial( { color: 0xff00ff, wireframe: false} )
      themesh = new THREE.Mesh( geometry, material )
      themesh.position.set(randX,randY,randZ)
      avoid = new Static()
      avoid.init({mesh:themesh, velocity:new THREE.Vector3()})
      @scene.add(avoid.mesh)
      @avoidObjs.push(avoid)
      @sceneObjs.push(avoid)
      ++i

    console.log 'CREATE AVOID',@avoidObjs[0].acceleration.z

  __update: ->
    console.log 'UPDATE BOIDS'
    for entity in @boids
      entity.update(@boids)

    console.log 'UPDATE AVOID',@avoidObjs[0].acceleration.z
    for avoid in @avoidObjs
      avoid.update()

    alert 'pause'

module.exports = FlockingAvoidDemo
