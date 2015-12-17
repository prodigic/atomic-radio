$ = jQuery = require 'jquery'

module.exports =
class AtomicRadioView

  radioDial: null
  channels: require('./stations').channels
  stations: require('./stations').stations

  constructor: (serializedState) ->

    # Create root element
    # TODO replace dom code with library
    @radioDial = Object.keys(@stations)

    @$element = $('<div class="atomic-radio"></div>')

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

    @ident_station = document.createElement('img')
    @ident_station.src=@channels["SOMAFM"].image
    ident_right.appendChild(@ident_station)

    @ident_description = document.createElement('div')
    @ident_description.textContent = @stations["SOMAFM:SF1033"].description
    @ident_description.className = "audio-station-description"
    ident_right.appendChild(@ident_description)

    ident.appendChild(ident_left);
    ident.appendChild(ident_right);

    message.appendChild(ident)
    @$element.append(message)
    @$element.append(audio_container)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @$element.remove()

  getElement: ->
    @$element

  play: ->
    @audio.play()

  paused: ->
    @audio.paused

  pause: ->
    @audio.pause()

  nextStation: () ->
    [nowplaying, nextup, rest... ] = @radioDial
    @radioDial = [nextup, rest..., nowplaying]
    @setStation(nextup)

  prevStation: () ->
    [nowplaying, rest..., previous ] = @radioDial
    @radioDial = [previous, nowplaying,  rest...]
    @setStation(previous)

  setStation: (ident) ->
    channel = ident.split(":")[0]
    console.log(ident, @stations[ident].stream_url, @radioDial)
    @audio.src = @stations[ident].stream_url
    @ident_img.src=@stations[ident].stream_image
    @ident_station.src=@channels[channel].image
    @ident_description.textContent=@stations[ident].description
    @play()
