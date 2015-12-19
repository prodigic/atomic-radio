$ = jQuery = require 'jquery'

module.exports =
class AtomicRadioView

  radioDial: null
  channels: require('./metadata').channels
  stations: require('./metadata').stations

  element : $ require './template.js'
  audio : null

  constructor: (serializedState) ->
    @radioDial = Object.keys(@stations)
    @audio = $('audio.audio-element',@element).get(0)
    @setStation @radioDial[0]

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

  nextStation: () ->
    [nowplaying, nextup, rest... ] = @radioDial
    @radioDial = [nextup, rest..., nowplaying]
    @setStation(nextup)

  prevStation: () ->
    [nowplaying, rest..., previous ] = @radioDial
    @radioDial = [previous, nowplaying,  rest...]
    @setStation(previous)

  toggleTinyMode: () ->
    $('.message' , @element ).toggleClass('tiny')

  setStation: (station) ->
    channel = station.split(":")[0]
    console.log channel, station, @stations[station].stream_url, @radioDial

    $('.channel-ident-image' , @element ).attr('src',@channels[channel].image)
    $('.station-ident-image'  , @element ).attr('src',@stations[station].stream_image)
    $('span.station-name'  , @element ).html(@stations[station].title)
    $('span.station-description'  , @element ).html(@stations[station].description)

    $('audio.audio-element ' , @element ).attr('src',@stations[station].stream_url)

    @play()
