{$, $$$, EditorView, ScrollView, View} = require 'atom'
ChildProcess = require 'child_process'

module.exports =
class RSpecOutputView extends ScrollView
  atom.deserializers.add(this)

  @deserialize: ({filePath}) ->
    new RSpecOutputView(filePath)

  @content: ->
    @div class: 'rspec-output', tabindex: -1, =>
      @div class: 'rspec-spinner', 'Starting RSpec, please wait...'
      @pre class: 'rspec-terminal'

  constructor: (filePath) ->
    super
    console.log "File path:", filePath
    @filePath = filePath

  serialize: ->
    deserializer: 'MarkdownPreviewView'
    filePath: @getPath()

  destroy: ->
    @unsubscribe()

  getTitle: ->
    "RSpec Output - #{@getPath()}"

  getUri: ->
    "rspec-output://#{@getPath()}"

  getPath: ->
    atom.project.getPath()

  showError: (result) ->
    failureMessage = "The error message"

    @html $$$ ->
      @h2 'Running RSpec Failed'
      @h3 failureMessage if failureMessage?

  run: (line_number) ->
    project_path = atom.project.getRootDirectory().getPath()

    spawn = ChildProcess.spawn

    command = "rspec #{@filePath}"
    command = "#{command} -l #{line_number}" if line_number

    console.log "[RSpec] running: #{command}"

    terminal = spawn("bash", ["-l"])

    terminal.on 'close', (code) -> console.log " *** I AM DONE #{code} ***"

    terminal.stdout.on 'data', @onStdOut
    terminal.stderr.on 'data', @onStdErr

    terminal.stdin.write("cd #{project_path} && #{command}\n")
    terminal.stdin.write("exit\n")

    console.log "RSpecView was run!"

  addOutput: (output) =>
    $(".rspec-spinner").hide()
    $(".rspec-terminal").append("#{output}")
    $('.rspec-output').scrollTop($('.rspec-output')[0].scrollHeight);

  onStdOut: (data) =>
    @addOutput data

  onStdErr: (data) =>
    @addOutput data

  onClose: (code) =>
    console.log "[RSpec] exit with code: #{code}"
    $(".rspec-output").append("<h3>This is done!</h3>")
    $(".rspec-spinner").hide()
