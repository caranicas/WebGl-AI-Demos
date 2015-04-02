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

  avoidWalls:(vector,bounds,buffer, strength) ->
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

    return avoidance

  facing:(entity) ->
    vel = entity.getVelocity().clone()
    vel.normalize()
    up = new THREE.Vector3(0,1,0)
    quat = new THREE.Quaternion()
    quat.setFromUnitVectors(up,vel)
    entity.mesh.rotation.setFromQuaternion(quat,'XYZ')

  lookAhead:(position, velocity, lookMag) ->
    ahead = velocity.clone().normalize()
    ahead.multiplyScalar lookMag
    look = new THREE.Vector3().addVectors(position,ahead)
    look


  randomUnit: ->
    (Math.random()*2)-1

  # facing_old:(entity) ->
  #   vel = entity.getVelocity().clone()
  #   vel.normalize()
  #   up = new THREE.Vector3(0,1,0)
  #   right = new THREE.Vector3(1,0,0)
  #   ortho1 =  new THREE.Vector3().crossVectors( vel, up )
  #   rotation = new THREE.Matrix4().makeBasis(ortho1,vel,up)
  #   quat = new THREE.Quaternion()
  #   quat.setFromRotationMatrix(rotation)
  #   entity.mesh.rotation.setFromQuaternion(quat,'XYZ')




module.exports = new Util
