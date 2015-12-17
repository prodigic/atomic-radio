AtomicRadioView = require './atomic-radio-view'

{stations} =  require('./stations')
{CompositeDisposable} = require 'atom'

module.exports = AtomicRadio =
  atomicRadioView: null
  modalPanel: null
  subscriptions: null

  config:
    station:
      type: 'string'
      default: "SOMAFM:SF1033"
      enum: Object.keys(stations)
    auto_play_on_startup:
      type: 'boolean'
      default: false
    use_minimal_player_layout:
      type: 'boolean'
      default: false

  constructor: ->
    @.station.enum = configObject.keys(@stations)

  activate: (state) ->
    @atomicRadioView = new AtomicRadioView(state.atomicRadioViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomicRadioView.getElement(), visible: false)
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atomic-radio:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atomic-radio:play': => @playToggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atomic-radio:bump': => @bumpStation()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomicRadioView.destroy()

  serialize: ->
    atomicRadioViewState: @atomicRadioView.serialize()

  toggle: ->
    console.log 'AtomicRadio was toggled!'
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  playToggle: ->
    if (@atomicRadioView.paused())
      console.log 'AtomicRadio play'
      @atomicRadioView.play()
    else
      console.log 'AtomicRadio pause'
      @atomicRadioView.pause()

  bumpStation: ->
    @atomicRadioView.bumpStation()
