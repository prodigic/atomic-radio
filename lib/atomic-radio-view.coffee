
module.exports =
class AtomicRadioView

  radioDial: null
  stations: require('./stations').stations

  constructor: (serializedState) ->
    # Create root element
    # TODO replace dom code with library
    @radioDial = Object.keys(@stations)

    @element = document.createElement('div')
    @element.classList.add('atomic-radio')

    @audio = document.createElement('audio')
    @audio.classList.add("audio-element")
    @audio.controls = true
    @audio.src = @stations["SOMAFM:SF1033"].stream_url #"http://ice.somafm.com/sf1033-64.aac"

    # Create message element
    message = document.createElement('div')
    message.classList.add('message')

    # Create html5 audio element
    audio_container = document.createElement('div')
    audio_container.classList.add("audio-element")
    audio_container.appendChild(@audio)

    # create station ident elements
    ident = document.createElement('div')
    ident.className = "audio-station-ident"

    ident_left = document.createElement('div')
    ident_left.className = "audio-station-ident-left"

    @ident_img = document.createElement('img')
    @ident_img.src = @stations["SOMAFM:SF1033"].stream_image
    ident_left.appendChild(@ident_img)

    ident_right = document.createElement('div')
    ident_right.className = "audio-station-ident-right"

    ident_station = document.createElement('img')
    ident_station.src = "http://somafm.com/linktous/150x50sfm1_1.gif"
    ident_right.appendChild(ident_station)
    @ident_description = document.createElement('div')
    @ident_description.textContent = @stations["SOMAFM:SF1033"].description
    @ident_description.className = "audio-station-description"
    ident_right.appendChild(@ident_description)


    ident.appendChild(ident_left);
    ident.appendChild(ident_right);

    message.appendChild(ident)
    message.appendChild(audio_container)

    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  play: ->
    @audio.play()

  paused: ->
    @audio.paused

  pause: ->
    @audio.pause()

  bumpStation: () ->
    [nowplaying, nextup, rest... ] = @radioDial
    @radioDial = [nextup, rest..., nowplaying]
    @setStation(nextup)

  setStation: (ident) ->
    console.log(ident, @stations[ident].stream_url, @radioDial)
    @audio.src = @stations[ident].stream_url
    @ident_img.src=@stations[ident].stream_image
    @ident_description.textContent=@stations[ident].description
    @play()
