url = require 'url'

RSpecView = require './rspec-view'

module.exports =
  configDefaults:
    command: "rspec"

  activate: (state) ->
    if state?
      @lastFile = state.lastFile
      @lastLine = state.lastLine

    atom.config.setDefaults "atom-rspec",
      command: "rspec"

    atom.workspaceView.command 'rspec:run'         , => @run()
    atom.workspaceView.command 'rspec:run-for-line', => @runForLine()
    atom.workspaceView.command 'rspec:run-last'    , => @runLast()

    atom.workspace.registerOpener (uriToOpen) ->
      {protocol, pathname} = url.parse(uriToOpen)
      return unless protocol is 'rspec-output:'
      new RSpecView(pathname)

  rspecView: null

  deactivate: ->
    @rspecView.destroy()

  serialize: ->
    rspecViewState: @rspecView.serialize()
    lastFile: @lastFile
    lastLine: @lastLine

  openUriFor: (file, lineNumber) ->
    @lastFile = file
    @lastLine = lineNumber

    previousActivePane = atom.workspace.getActivePane()
    uri = "rspec-output://#{file}"
    atom.workspace.open(uri, split: 'right', changeFocus: false, searchAllPanes: true).done (rspecView) ->
      if rspecView instanceof RSpecView
        rspecView.run(lineNumber)
        previousActivePane.activate()

  runForLine: ->
    console.log "Starting runForLine..."
    editor = atom.workspace.getActiveEditor()
    console.log "Editor", editor
    return unless editor?

    cursor = editor.getCursor()
    console.log "Cursor", cursor
    line = cursor.getScreenRow()
    console.log "Line", line

    @openUriFor(editor.getPath(), line)

  runLast: ->
    return unless @lastFile?
    @openUriFor(@lastFile, @lastLine)

  run: ->
    console.log "RUN"
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    @openUriFor(editor.getPath())
