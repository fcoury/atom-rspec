{$, $$$, EditorView, ScrollView} = require 'atom'
ChildProcess = require 'child_process'
path = require 'path'
TextFormatter = require './text-formatter'

module.exports =
class RSpecView extends ScrollView
  atom.deserializers.add(this)

  @deserialize: ({filePath}) ->
    new RSpecView(filePath)

  @content: ->
    @div class: 'rspec rspec-console', tabindex: -1, =>
      @div class: 'rspec-spinner', 'Starting RSpec...'
      @pre class: 'rspec-output'

  initialize: ->
    super
    @on 'core:copy': => @copySelectedText()

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

  copySelectedText: ->
    text = window.getSelection().toString()
    return if text == ''
    atom.clipboard.write(text)

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

    specCommand = atom.config.get("atom-rspec.command")
    options = " --tty"
    options += " --color" if atom.config.get("atom-rspec.force_colored_results")
    command = "#{specCommand} #{options} #{@filePath}"
    command = "#{command}:#{lineNumber}" if lineNumber

    console.log "[RSpec] running: #{command}"

    terminal = spawn("bash", ["-l"])

    terminal.on 'close', @onClose

    terminal.stdout.on 'data', @onStdOut
    terminal.stderr.on 'data', @onStdErr

    terminal.stdin.write("cd #{projectPath} && #{command}\n")
    terminal.stdin.write("exit\n")

  addOutput: (output) =>
    formatter = new TextFormatter(output)
    output = formatter.htmlEscaped().colorized().fileLinked().text

    @spinner.hide()
    @output.append("#{output}")
    @scrollTop(@[0].scrollHeight)

  onStdOut: (data) =>
    @addOutput data

  onStdErr: (data) =>
    @addOutput data

  onClose: (code) =>
    console.log "[RSpec] exit with code: #{code}"
