THREE = require 'threejs'
DemoInterface = require './DemoInterface'
BehaviorFacing = require './../components/behaviors/facing.coffee'
Boid = require './../components/objs/boid.coffee'

class FacingDemo extends DemoInterface

  LightObj:
    lightOneColor:0x00ff00
    lightTwoColor:0xffffff

  size:200
  vertOff:60
  flockCount:1


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
      randX = 0#(Math.random()*(@size/5)) - (@size/10)
      randY = 0#(Math.random()*(@size/5)) - (@size/10)
      randZ = 0#(Math.random()*(@size/5)) - (@size/10)
      geometry = new THREE.CylinderGeometry(0,1,4,8,1)
      material = new THREE.MeshLambertMaterial( { color: 0x00ffff, wireframe: false} )
      themesh = new THREE.Mesh( geometry, material )
      themesh.position.set(randX,randY,randZ)
      boid = new Boid()
      xvel = 1
      yvel = 0
      zvel = 0
      boid.init({behavior:new BehaviorFacing(boid), mesh:themesh, bounding:@size, velocity:new THREE.Vector3(xvel, yvel, zvel)})
      @scene.add(boid.mesh)
      @sceneObjs.push(boid)
      ++i

  __update: ->
    for entity in @sceneObjs
      entity.update(@sceneObjs)


module.exports = FacingDemo
