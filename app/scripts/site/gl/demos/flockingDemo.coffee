THREE = require 'threejs'
DemoInterface = require './DemoInterface'
BehaviorFlock = require './../components/behaviors/flock.coffee'
Boid = require './../components/objs/boid.coffee'

class FlockingDemo extends DemoInterface

  LightObj:
    lightOneColor:0x00ff00
    lightTwoColor:0xffffff

  size:200
  vertOff:0
  flockCount:40


  __initGeometry: ->
    @createSkyBox()
    @createBoids()
    super

  __initDat:->
    super

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
      @scene.add(boid.mesh)
      @sceneObjs.push(boid)
      ++i

  __update: ->
    for entity in @sceneObjs
      entity.update(@sceneObjs)


module.exports = FlockingDemo
