class Behavior

  boid:null
  constraints:null

  constructor:(boid, constraints) ->
    @boid = boid
    @constraints = constraints

  update:(objs) ->
    @__calculateForces(objs)
    @__applyForces()


  __calculateForces:(objs)->

  __applyForces: ->

module.exports = Behavior
