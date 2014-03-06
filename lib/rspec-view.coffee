{$, $$$, EditorView, ScrollView} = require 'atom'
ChildProcess = require 'child_process'
path = require 'path'

module.exports =
class RSpecView extends ScrollView
  atom.deserializers.add(this)

  @deserialize: ({filePath}) ->
    new RSpecView(filePath)

  @content: ->
    @div class: 'rspec', tabindex: -1, =>
      @div class: 'rspec-spinner', 'Starting RSpec...'
      @pre class: 'rspec-output'

  constructor: (filePath) ->
    super
    console.log "File path:", filePath
    @filePath = filePath

    @output = @find(".rspec-output")
    @spinner = @find(".rspec-spinner")
    @output.on("click", @terminalClicked)

  serialize: ->
    deserializer: 'RSpecView'
    filePath: @getPath()

  destroy: ->
    @unsubscribe()

  getTitle: ->
    "RSpec - #{path.basename(@getPath())}"

  getUri: ->
    "rspec-output://#{@getPath()}"

  getPath: ->
    @filePath

  showError: (result) ->
    failureMessage = "The error message"

    @html $$$ ->
      @h2 'Running RSpec Failed'
      @h3 failureMessage if failureMessage?

  terminalClicked: (e) =>
    if e.target?.href
      line = $(e.target).data('line')
      file = $(e.target).data('file')
      console.log(file)
      file = "#{atom.project.getPath()}/#{file}"

      promise = atom.workspace.open(file, { searchAllPanes: true, initialLine: line })
      promise.done (editor) ->
        editor.setCursorBufferPosition([line-1, 0])

  run: (lineNumber) ->
    @spinner.show()
    @output.empty()
    projectPath = atom.project.getRootDirectory().getPath()

    spawn = ChildProcess.spawn

    specCommand = atom.config.get("rspec.command")
    command = "#{specCommand} #{@filePath}"
    command = "#{command}:#{lineNumber}" if lineNumber

    console.log "[RSpec] running: #{command}"

    terminal = spawn("bash", ["-l"])

    terminal.on 'close', @onClose

    terminal.stdout.on 'data', @onStdOut
    terminal.stderr.on 'data', @onStdErr

    terminal.stdin.write("cd #{projectPath} && #{command}\n")
    terminal.stdin.write("exit\n")

  addOutput: (output) =>

    output = "#{output}"
    output = output.replace /([^\s]*:[0-9]+)/g, (match) =>
      file = match.split(":")[0]
      line = match.split(":")[1]
      $$$ -> @a href: file, 'data-line': line, 'data-file': file, match

    @spinner.hide()
    @output.append("#{output}")
    @scrollTop(@[0].scrollHeight)

  onStdOut: (data) =>
    @addOutput data

  onStdErr: (data) =>
    @addOutput data

  onClose: (code) =>
    console.log "[RSpec] exit with code: #{code}"
