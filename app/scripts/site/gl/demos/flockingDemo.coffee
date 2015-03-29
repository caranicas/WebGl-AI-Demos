THREE = require 'threejs'
DemoInterface = require './DemoInterface'
BehaviorFlock = require './../components/behaviors/flock.coffee'
Boid = require './../components/objs/boid.coffee'

class FlockingDemo extends DemoInterface

  size:200
  vertOff:0
  flockCount:40
  boids:new Array()

  __initGeometry: ->
    @createSkyBox()
    @createBoids()
    super

  __initDat:->
    boid = new Boid()
    super

    sepWeightController = @dat.add(boid,'sepWeight', 0, 10).step(.5)
    sepRadController = @dat.add(boid,'sepRad', 0, 100).step(3)

    alignWeightController = @dat.add(boid,'aligWeight', 0, 10).step(.5)
    alignRadController = @dat.add(boid,'aligRad', 0, 100).step(3)

    cohWeightController = @dat.add(boid,'cohWeight', 0, 10).step(.5)
    cohRadController = @dat.add(boid,'cohRad', 0, 100).step(3)

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
    for boid in @boids
      boid.sepWeight = value

  __updateSepRad:(value) ->
    for boid in @boids
      boid.sepRad = value

  __updateAlignWeight:(value) ->
    for boid in @boids
      boid.aligWeight = value

  __updateAlignRad:(value) ->
    for boid in @boids
      boid.aligRad = value

  __updateCohWeight:(value) ->
    for boid in @boids
      boid.cohWeight = value

  __updateCohRad:(value) ->
    for boid in @boids
      boid.cohRad = value

  createSkyBox: ->
    console.log 'skyBox'
    imagePrefix = "textures/skybox/"
    directions  = ["xpos", "xneg", "ypos", "yneg", "zpos", "zneg"]
    imageSuffix = ".png"
    skyGeometry = new THREE.BoxGeometry( @size, @size, @size )
    console.log  'geometry',skyGeometry
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
      boid.init({behavior:new BehaviorFlock(boid), mesh:themesh, bounding:@size, velocity:new THREE.Vector3(xvel, yvel, zvel)})
      @boids.push(boid)
      @scene.add(boid.mesh)
      @sceneObjs.push(boid)
      ++i

  __update: ->
    for entity in @sceneObjs
      entity.update(@sceneObjs)


module.exports = FlockingDemo
