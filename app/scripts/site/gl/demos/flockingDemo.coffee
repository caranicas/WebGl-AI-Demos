THREE = require 'threejs'
Demo = require './DemoInterface'
Behavior = require './../components/behaviors/base/flockBehavior.coffee'
Constraint = require './../components/behaviors/constraints/flockConstraint.coffee'
Boid = require './../components/objs/normal/boid.coffee'
Utils = require '../../utils/goblinUtils'


class FlockingDemo extends Demo

  size:200
  vertOff:0
  flockCount:40
  boids:new Array()

  constructor: ->
    super

  __initScene: ->
    super
    @constraints = new Constraint()

  __initGeometry: ->
    super
    @createSkyBox()
    @createBoids()

  __initDat:->
    super

    sepWeightController = @dat.add(@constraints,'sepWeight', 0, 7).step(.2)
    sepRadController = @dat.add(@constraints,'sepRad', 0, 100).step(3)

    alignWeightController = @dat.add(@constraints,'aligWeight', 0, 7).step(.2)
    alignRadController = @dat.add(@constraints,'aligRad', 0, 100).step(3)

    cohWeightController = @dat.add(@constraints,'cohWeight', 0, 7).step(.2)
    cohRadController = @dat.add(@constraints,'cohRad', 0, 100).step(3)

    sepWeightController.onChange( (value)=>
      @__updateSepWeight(value)
    )

    sepRadController.onChange( (value)=>
      @__updateSepRad(value)
    )

    alignWeightController.onChange( (value)=>
      @__updateAlignWeight(value)
    )

    alignRadController.onChange( (value)=>
      @__updateAlignRad(value)
    )

    cohWeightController.onChange( (value)=>
      @__updateCohWeight(value)
    )

    cohRadController.onChange( (value)=>
      @__updateCohRad(value)
    )

  __updateSepWeight:(value) ->
    @constraints.sepWeight = value

  __updateSepRad:(value) ->
    @constraints.sepRad = value

  __updateAlignWeight:(value) ->
    @constraints.aligWeight = value

  __updateAlignRad:(value) ->
    @constraints.aligRad = value

  __updateCohWeight:(value) ->
    @constraints.cohWeight = value

  __updateCohRad:(value) ->
    @constraints.cohRad = value

  createSkyBox: ->
    imagePrefix = "textures/skybox/"
    directions  = ["xpos", "xneg", "ypos", "yneg", "zpos", "zneg"]
    imageSuffix = ".png"
    skyGeometry = new THREE.BoxGeometry( @size, @size, @size )
    materialArray = []
    i = 0
    while i < 6
      newMat = new THREE.MeshBasicMaterial({ map: THREE.ImageUtils.loadTexture( imagePrefix + directions[i] + imageSuffix ),side:THREE.BackSide})
      materialArray.push(newMat)
      i++

    skyMaterial = new THREE.MeshFaceMaterial( materialArray )
    skyBox = new THREE.Mesh( skyGeometry, skyMaterial )
    skyBox.position.set(0,@vertOff,0)
    @scene.add( skyBox )

  createBoids: ->
    i = 0
    while i < @flockCount
      randX = (Math.random()*(@size/5)) - (@size/10)
      randY = 0#(Math.random()*(@size/5)) - (@size/10)
      randZ = (Math.random()*(@size/5)) - (@size/10)
      geometry = new THREE.CylinderGeometry(0,1,4,8,1)
      material = new THREE.MeshLambertMaterial( { color: 0x00ffff, wireframe: false} )
      themesh = new THREE.Mesh( geometry, material )
      themesh.position.set(randX,randY,randZ)
      boid = new Boid()
      xvel = Math.random()
      yvel = Math.random()
      zvel = Math.random()
      boid.init({behavior:new Behavior(boid,@constraints), mesh:themesh, bounding:@size, velocity:new THREE.Vector3(xvel, yvel, zvel)})
      @boids.push(boid)
      @scene.add(boid.mesh)
      @sceneObjs.push(boid)
      ++i

  __update: ->
    for entity in @boids
     entity.update(@boids)




module.exports = FlockingDemo
