{$, $$$, EditorView, ScrollView, View} = require 'atom'
ChildProcess = require 'child_process'
path = require 'path'

module.exports =
class RSpecOutputView extends ScrollView
  atom.deserializers.add(this)

  @deserialize: ({filePath}) ->
    new RSpecOutputView(filePath)

  @content: ->
    @div class: 'rspec-output', tabindex: -1, =>
      @div class: 'rspec-spinner', 'Starting RSpec...'
      @pre class: 'rspec-terminal'

  constructor: (filePath) ->
    super
    console.log "File path:", filePath
    @filePath = filePath
    @output = @find(".rspec-output")
    @terminal = @find(".rspec-terminal")
    @spinner = @find(".rspec-spinner")

  serialize: ->
    deserializer: 'RSpecOutputView'
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

  run: (line_number) ->
    @spinner.show()
    @terminal.empty()
    project_path = atom.project.getRootDirectory().getPath()

    spawn = ChildProcess.spawn

    command = "rspec #{@filePath}"
    command = "#{command} -l #{line_number}" if line_number

    console.log "[RSpec] running: #{command}"

    terminal = spawn("bash", ["-l"])

    terminal.on 'close', @onClose

    terminal.stdout.on 'data', @onStdOut
    terminal.stderr.on 'data', @onStdErr

    terminal.stdin.write("cd #{project_path} && #{command}\n")
    terminal.stdin.write("exit\n")

  addOutput: (output) =>
    @spinner.hide()
    @terminal.append("#{output}")
    @scrollTop(@[0].scrollHeight)

  onStdOut: (data) =>
    @addOutput data

  onStdErr: (data) =>
    @addOutput data

  onClose: (code) =>
    console.log "[RSpec] exit with code: #{code}"
