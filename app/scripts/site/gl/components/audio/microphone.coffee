class Microphone

  constructor: ->
    @context = new (window.AudioContext || window.webkitAudioContext)()
    navigator.getUserMedia = (navigator.getUserMedia ||  navigator.webkitGetUserMedia ||navigator.mozGetUserMedia || navigator.msGetUserMedia)
    navigator.getUserMedia({audio: true},@stream, @error)


  stream:(stream) =>
    console.log 'STREAM', stream
    input = @context.createMediaStreamSource(stream)
    @analyser = @context.createAnalyser()
    @analyser.fftSize = 2048
    @analyser.minDecibels = -80
    @analyser.maxDecibels = -10
    @analyser.smoothingTimeConstant = 0.85
    bufferLength = @analyser.fftSize
    input.connect(@analyser)

  error:(e) =>
    console.error('Error getting microphone', e)
    @

  update: ->
    if @analyser?
      freqArray = new Uint8Array(@analyser.frequencyBinCount)
      timeArray = new Uint8Array(@analyser.frequencyBinCount)

      @analyser.getByteFrequencyData(freqArray)
      @analyser.getByteTimeDomainData(timeArray)
      #console.log 'freqArray',freqArray
      #console.log 'timeArray',timeArray
      #for data in freqArray
        #comp = data/128
      #if data isnt 0
      return freqArray[0]
    else
      return 0



module.exports = Microphone
