RspecView = require '../lib/rspec-view'

describe "RspecView", ->
  beforeEach ->
    @rspecView = new RspecView('example_spec.rb')

  describe 'addOutput', ->
    it 'adds output', ->
      @rspecView.addOutput('foo')
      expect(@rspecView.output.html()).toBe 'foo'

    it 'corectly formats complex output', ->
      output = '[31m# ./foo/bar_spec.rb:123:in `block (3 levels) in <top (required)>[0m'
      @rspecView.addOutput(output)
      expect(@rspecView.output.html()).toBe '<p class="rspec-color tty-31">' +
        '# <a href="./foo/bar_spec.rb" data-line="123" data-file="./foo/bar_spec.rb">' +
        './foo/bar_spec.rb:123' +
        '</a>' +
        ':in `block (3 levels) in &lt;top (required)&gt;' +
        '</p>'
