THREE = require 'threejs'
Demo = require './DemoInterface'
EffectComposer = require 'effectcomposer'
DotScreenShader = require 'dotscreenshader'
Mic = require './../components/audio/microphone'


class AudioShaderDemo extends Demo

  size:100

  constructor: ->
    @audioStream = new Mic()
    super

  threeInit: ->
    super
    @__initShader()
    @__createShaderEffects()

  __initShader: ->
    @composer = new EffectComposer( @renderer )
    @composer.addPass( new EffectComposer.prototype.RenderPass( @scene, @camera ) )

  __createShaderEffects: ->
    @effect = new EffectComposer.prototype.ShaderPass( new DotScreenShader() )
    @effect.renderToScreen = true
    @effect.uniforms[ 'scale' ].value = 2
    @composer.addPass( @effect )

  __initLights: ->
    light = new THREE.AmbientLight( 0xff0000 )# // soft white light
    @scene.add( light )

  __initGeometry:->
    #super
    #@__floorGeometry()
    @__buildingGeomety()

  __floorGeometry: ->
    @floorTexture = new THREE.ImageUtils.loadTexture( 'textures/checkerboard.jpg' )
    @floorTexture.wrapT = THREE.RepeatWrapping
    @floorTexture.wrapS = @floorTexture.wrapT
    @floorTexture.repeat.set( 10, 10 )
    floorMaterial = new THREE.MeshBasicMaterial( { map: @floorTexture, side: THREE.DoubleSide } )
    floorGeometry = new THREE.PlaneGeometry(@size, @size, 10, 10)
    floor = new THREE.Mesh(floorGeometry, floorMaterial)
    floor.position.y = -0.5
    floor.rotation.x = Math.PI / 2
    @scene.add(floor)

  __buildingGeomety: ->
    #shader = new DotScreenShader()
    #console.log 'vertex',shader.vertexShader

    @geometry = new THREE.BoxGeometry( 20, 20, 20 )
    @material = new THREE.MeshPhongMaterial( { color: 0xffffff, shading: THREE.FlatShading } )

    ###
    { uniforms: {time: { type: "c", value: new THREE.Color(0xff00ff ) },resolution: { type: "c", value: new THREE.Color(0xff00ff) }},attributes: {vertexOpacity: { type: 'f', value: [] }}, }
    ###
    @mesh = new THREE.Mesh( @geometry, @material )
    @mesh.position.y = 5
    @mesh.position.x = 0
    @scene.add(@mesh)
    @sceneObjs.push(@mesh)



    @mesh2 = new THREE.Mesh( @geometry, @material )
    @mesh2.position.y = 25
    @mesh2.position.x = 25
    @scene.add(@mesh2)
    @sceneObjs.push(@mesh2)



  loop:->
    requestAnimationFrame =>
       @loop()
    @update()
    @render()

  render: ->
    @stats.begin()
    @composer.render()
    @stats.end()

  update: ->
    for mesh in @sceneObjs
      mesh.rotation.x += 0.01
      mesh.rotation.y += 0.02

    newValue = @audioStream.update()
    if newValue isnt 0
      newValue /=10
      console.log 'new value', newValue
      @effect.uniforms[ 'scale' ].value = 1/newValue


module.exports = AudioShaderDemo
