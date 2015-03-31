THREE = require 'threejs'
Demo = require './flockingDemo'
Behavior = require './../components/behaviors/base/flockAvoidBehavior.coffee'
Constraint = require './../components/behaviors/constraints/flockAvoidConstraint.coffee'
Static = require './../components/objs/normal/static.coffee'
Utils = require '../../utils/goblinUtils'


class FlockingAvoidDemo extends Demo

  avoidCount:1
  avoidObjs:new Array()

  constructor: ->
    super

  __initScene: ->
    super
    @constraints = new Constraint()

  __initGeometry: ->
    super
    @__createAvoidObjects()

  __initDat:->
    super


  __createAvoidObjects: ->
    console.log 'creaet avoid'
    i = 0
    while i < @avoidCount
      randX = (Math.random()*(@size/5)) - (@size/10)
      randY = (Math.random()*(@size/5)) - (@size/10)
      randZ = (Math.random()*(@size/5)) - (@size/10)
      geometry = new THREE.CylinderGeometry(0,1,4,8,1)
      material = new THREE.MeshLambertMaterial( { color: 0xff00ff, wireframe: false} )
      themesh = new THREE.Mesh( geometry, material )
      themesh.position.set(randX,randY,randZ)
      avoid = new Static()
      avoid.init({mesh:themesh, velocity:new THREE.Vector3()})
      @scene.add(avoid.mesh)
      @avoidObjs.push(avoid)
      ++i

  __update: ->
    for entity in @sceneObjs
      entity.update(@sceneObjs,@avoidObjs)

    for entity in @avoidObjs
      entity.update()




module.exports = FlockingAvoidDemo
