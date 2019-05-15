RSpecView = require './rspec-view'
{CompositeDisposable} = require 'atom'
url = require 'url'

module.exports =
  config:
    command:
      type: 'string'
      default: 'rspec'
    spec_directory:
      type: 'string'
      default: 'spec'
    save_before_run:
      type: 'boolean'
      default: false
    force_colored_results:
      type: 'boolean'
      default: true
    split:
      type: 'string'
      default: 'right'
      description: 'The direction in which to split the pane when launching rspec'
      enum: [
        {value: 'right', description: 'Right'}
        {value: 'left', description: 'Left'}
        {value: 'up', description: 'Up'}
        {value: 'down', description: 'Down'}
      ]


  rspecView: null
  subscriptions: null

  activate: (state) ->
    if state?
      @lastFile = state.lastFile
      @lastLine = state.lastLine

    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'rspec:run': =>
        @run()

      'rspec:run-for-line': =>
        @runForLine()

      'rspec:run-last': =>
        @runLast()

      'rspec:run-all': =>
        @runAll()

    atom.workspace.addOpener (uriToOpen) ->
      {protocol, pathname} = url.parse(uriToOpen)
      return unless protocol is 'rspec-output:'
      new RSpecView(pathname)

  deactivate: ->
    @rspecView.destroy()
    @subscriptions.dispose()

  serialize: ->
    if @rspecView
      rspecViewState: @rspecView.serialize()
    lastFile: @lastFile
    lastLine: @lastLine

  openUriFor: (file, lineNumber) ->
    @lastFile = file
    @lastLine = lineNumber

    previousActivePane = atom.workspace.getActivePane()
    uri = "rspec-output://#{file}"
    atom.workspace.open(uri, split: atom.config.get("rspec.split"), activatePane: false, searchAllPanes: true).then (rspecView) ->
      if rspecView instanceof RSpecView
        rspecView.run(lineNumber)
        previousActivePane.activate()

  runForLine: ->
    console.log "Starting runForLine..."
    editor = atom.workspace.getActiveTextEditor()
    console.log "Editor", editor
    return unless editor?

    cursor = editor.getLastCursor()
    console.log "Cursor", cursor
    line = cursor.getBufferRow() + 1
    console.log "Line", line

    @openUriFor(editor.getPath(), line)

  runLast: ->
    return unless @lastFile?
    @openUriFor(@lastFile, @lastLine)

  run: ->
    console.log "RUN"
    editor = atom.workspace.getActiveTextEditor()
    return unless editor?

    @openUriFor(editor.getPath())

  runAll: ->
    project = atom.project
    return unless project?

    @openUriFor(project.getPaths()[0] +
    "/" + atom.config.get("rspec.spec_directory"), @lastLine)
