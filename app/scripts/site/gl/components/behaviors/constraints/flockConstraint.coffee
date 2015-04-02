Constraint = require './constraint.coffee'

class FlockConstraint extends Constraint

  sepRad:10
  aligRad:40
  cohRad:50

  sepWeight:3
  cohWeight:1.5
  aligWeight:2

  maxAvoid:2.9

  constructor:(defaults) ->
    super

module.exports = FlockConstraint
