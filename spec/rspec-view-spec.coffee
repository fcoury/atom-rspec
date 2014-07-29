RspecView = require '../lib/rspec-view'

describe "RspecView", ->
  beforeEach ->
    @rspecView = new RspecView('example_spec.rb')

  describe 'addOutput', ->
    it 'adds output', ->
      @rspecView.addOutput('foo')
      expect(@rspecView.output.html()).toBe 'foo'

    it 'adds atom hyperlinks on files with line numbers', ->
      primaryOutput = '# ./foo/bar_spec.rb:123:in `block (3 levels) in <top (required)>'
      @rspecView.addOutput(primaryOutput)
      expect(@rspecView.output.html()).toBe '# <a href="./foo/bar_spec.rb" '+
      'data-line="123" data-file="./foo/bar_spec.rb">./foo/bar_spec.rb:123</a>:in '+
      '`block (3 levels) in &lt;top (required)&gt;'

    it 'escapes html tags', ->
      @rspecView.addOutput('<b>bold</b> text')
      expect(@rspecView.output.html()).toBe '&lt;b&gt;bold&lt;/b&gt; text'

    describe 'colorize', ->
      it 'corretly sets colors to fail/pass marks', ->
        @rspecView.addOutput("[31mF[0m[31mF[0m[31mF[0m[33m*[0m[33m*[0m[31mF[0m")
        expect(@rspecView.output.html()).toBe(
          '<p class="rspec-color tty-31">F</p>' +
          '<p class="rspec-color tty-31">F</p>' +
          '<p class="rspec-color tty-31">F</p>' +
          '<p class="rspec-color tty-33">*</p>' +
          '<p class="rspec-color tty-33">*</p>' +
          '<p class="rspec-color tty-31">F</p>'
        )

      it 'sets proper colors', ->
        @rspecView.addOutput('[31m  got: value != #<ChecksReader::Line:0x2f6a408 [(3, 0); (9, 6)], angle=45.0>[0m')
        expect(@rspecView.output.html()).toBe '<p class="rspec-color tty-31">  got: value != #&lt;ChecksReader::Line:0x2f6a408 [(3, 0); (9, 6)], angle=45.0&gt;</p>'
