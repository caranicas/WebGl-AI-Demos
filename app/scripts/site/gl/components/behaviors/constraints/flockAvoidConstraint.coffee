Constraint = require './flockConstraint.coffee'

class FlockAvoidConstraint extends Constraint

  seeAhead:10
  avoidWeight:300

  sepRad:5
  aligRad:3
  cohRad:16

  sepWeight:3
  cohWeight:0.7
  aligWeight:2

  constructor:(defaults) ->
    super

module.exports = FlockAvoidConstraint
