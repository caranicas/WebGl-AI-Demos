THREE = require 'threejs'

class Util

  constructor: ->
    @

  seek:(target,current) ->
    new THREE.Vector3().subVectors(target,current)

  seekSteer:(target,curpos, curvel, maxForce, maxSpeed) ->
    seek = @seek(target,curpos).normalize()
    seek.multiplyScalar(maxSpeed)
    steer = @limit(@seek(seek,curvel),maxForce)
    steer

  limit:(vec3, max) ->
    if vec3.length() > max
      vec3.normalize()
      vec3.multiplyScalar(max)
    vec3

  avoidWalls:(vector,bounds, buffer, strength) ->
    avoidance = new THREE.Vector3(0,0,0)

    if vector.x < -bounds+buffer
      avoidance.x = strength
    else if vector.x > bounds-buffer
      avoidance.x = -strength;

    if vector.y < -bounds+buffer
      avoidance.y = strength
    else if vector.y > bounds-buffer
      avoidance.y = -strength

    if vector.z < -bounds+buffer
      avoidance.z = strength
    else if vector.z > bounds-buffer
      avoidance.z = -strength

    return avoidance;

  facing:(entity) ->
    console.log 'facing'
    # VERY CLOSE TO WORKING
    # # FACES THE NOW DIRECTION
    # vel = entity.getVelocity().clone()
    # vel.normalize()
    # up = new THREE.Vector3(0,1,0)
    # left = new THREE.Vector3(1,0,0)
    # ortho1 =  new THREE.Vector3().crossVectors( vel, up )
    # ortho2 = new THREE.Vector3().crossVectors( vel, left )
    # rotation = new THREE.Matrix4().makeBasis(ortho2,vel,up)
    # quat = new THREE.Quaternion()
    # quat.setFromRotationMatrix(rotation)
    # entity.mesh.rotation.setFromQuaternion(quat,'XYZ')


    #orthoginal = new THREE.Vector3().crossVectors( vel, right )
    #console.log 'right', right




    #pos = entity.getPosition().clone()
    #vel = entity.getVelocity().clone()
    #target  = new THREE.Vector3().addVectors(pos, vel)
    #rotationAxis = new THREE.Vector3()
    #rotationAxis.crossVectors( vel, target )
    #rotAngle = vel.angleTo(target)
    #quat = new THREE.Quaternion()
    #quat.setFromUnitVectors (rotationAxis, rotAngle)
    #console.log 'ANGLE',rotAngle
    #entity.mesh.rotation.setFromQuaternion(quat,'XYZ')


    # pos = entity.getPosition().clone()
    # vel = entity.getVelocity().clone()
    # nowDirection = new THREE.Vector3()
    # nowDirection.addVectors(pos, vel)
    # console.log 'nowDirection',nowDirection
    # rotationAxis = new THREE.Vector3()
    # rotationAxis.crossVectors( vel, nowDirection )
    # console.log 'rotationAxis',rotationAxis
    # rotAngle = pos.angleTo(nowDirection)
    #
    # quat = new THREE.Quaternion()
    # quat.setFromAxisAngle(rotationAxis, rotAngle)
    # console.log 'ANGLE',rotAngle
    # entity.mesh.rotation.setFromQuaternion(quat,'XYZ')

    ###
    pos = entity.getPosition().clone()
    vel = entity.getVelocity().clone()
    target = new THREE.Vector3()
    target.addVectors(pos,vel)
    pos.normalize()
    vel.normalize()

    dot = pos.dot(vel)
    #target.normalize()
    if Math.abs(dot + 1.0) < 0.000001
      #alert 'less POS'
      return new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0,1,0),3.1415)
    if Math.abs(dot - 1.0) < 0.000001
      #alert 'less NEG'
      return new THREE.Quaternion(0,0,0,1)

    rotAngle = Math.acos(dot)
    rotAxis = new THREE.Vector3().crossVectors(target,pos).normalize()
    console.log 'ANNGLE, AXIS', rotAngle
    quat = new THREE.Quaternion()
    #alert 'Test'
    quat.setFromAxisAngle(rotAxis, rotAngle)
    entity.mesh.rotation.setFromQuaternion(quat,'XYZ')

    return quat
    ###


module.exports = new Util
