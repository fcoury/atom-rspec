url = require 'url'

RSpecOutputView = require './rspec-output-view'

module.exports =
  activate: ->
    console.log "Activating"
    atom.workspaceView.command 'rspec:runForLine', =>
      console.log "Trying to runForLine..."
      @runForLine()

    console.log "Activating 2"
    atom.workspaceView.command 'rspec:run', =>
      @run()

    console.log "Activating 3"
    atom.workspace.registerOpener (uriToOpen) ->
      {protocol, pathname} = url.parse(uriToOpen)
      return unless protocol is 'rspec-output:'
      new RSpecOutputView(pathname)

  rspecView: null

  deactivate: ->
    @rspecView.destroy()

  serialize: ->
    rspecViewState: @rspecView.serialize()

  openUriFor: (file, line_number) ->
    previousActivePane = atom.workspace.getActivePane()
    uri = "rspec-output://#{file}"
    atom.workspace.open(uri, split: 'right', changeFocus: false, searchAllPanes: true).done (rspecOutputView) ->
      if rspecOutputView instanceof RSpecOutputView
        rspecOutputView.run(line_number)
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

  run: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    @openUriFor(editor.getPath())
