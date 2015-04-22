{$, $$$, EditorView, ScrollView} = require 'atom-space-pen-views'

class TextFormatter
  constructor: (@text)->

  htmlEscaped: ->
    new TextFormatter( $('<div/>').text(@text).html() )

  fileLinked: ->
    text = @text.replace /([\\\/.][^\s]*:[0-9]+)([^\d]|$)/g, (match) =>
      file = match.split(":")[0]
      line = match.split(":")[1].replace(/[^\d]*$/, '')

      fileLineEnd = file.length + line.length
      fileAndLine = "#{file}:#{line}"
      matchWithoutFileAndLine = match.substr(fileLineEnd + 1)

      "<a href=\"#{file}\" data-line=\"#{line}\" data-file=\"#{file}\">"+
      "#{fileAndLine}</a>#{matchWithoutFileAndLine}"
    new TextFormatter(text)

  colorized: ->
    text = @text

    colorStartCount = text.match(/\[3[0-7]m/g)?.length || 0
    colorEndCount = text.match(/\[0m/g)?.length || 0

    # to avoid unclosed tags we always use smaller number of color starts / ends
    replaceCount = colorStartCount
    replaceCount = colorEndCount if colorEndCount < colorStartCount

    for i in [0..replaceCount]
      text = text.replace /\[(3[0-7])m/, (match, colorCode) =>
        "<p class=\"rspec-color tty-#{colorCode}\">"
      text = text.replace /\[0m/g, '</p>'

    new TextFormatter(text)

module.exports = TextFormatter
