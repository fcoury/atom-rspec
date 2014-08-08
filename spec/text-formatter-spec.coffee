TextFormatter = require '../lib/text-formatter'

describe 'htmlEscaped', ->
  it 'escapes html tags', ->
    formatter = new TextFormatter('<b>bold</b> text')
    expect(formatter.htmlEscaped().text).toBe '&lt;b&gt;bold&lt;/b&gt; text'

describe 'fileLinked', ->
  it 'adds atom hyperlinks on files with line numbers', ->
    text = '# ./foo/bar_spec.rb:123:in `block (3 levels) in <top (required)>'
    formatter = new TextFormatter(text)
    expect(formatter.fileLinked().text).toBe('# <a href="./foo/bar_spec.rb" ' +
      'data-line="123" data-file="./foo/bar_spec.rb">./foo/bar_spec.rb:123</a>' +
      ':in `block (3 levels) in <top (required)>'
    )

  it 'adds links when line number is at the end of line', ->
    text = './foo/bar_spec.rb:123\n'
    formatter = new TextFormatter(text)
    expect(formatter.fileLinked().text).toBe '<a href="./foo/bar_spec.rb" ' +
      'data-line="123" data-file="./foo/bar_spec.rb">./foo/bar_spec.rb:123</a>\n'

  it 'adds links when file paths is wrapped with color marks', ->
    text = '[31m./foo/bar_spec.rb:123[0m'
    formatter = new TextFormatter(text)
    expect(formatter.fileLinked().text).toBe '[31m<a href="./foo/bar_spec.rb" ' +
      'data-line="123" data-file="./foo/bar_spec.rb">./foo/bar_spec.rb:123</a>[0m'

  it 'adds links when file path is absolute', ->
    text = '/foo/bar_spec.rb:123'
    formatter = new TextFormatter(text)
    expect(formatter.fileLinked().text).toBe '<a href="/foo/bar_spec.rb" ' +
      'data-line="123" data-file="/foo/bar_spec.rb">/foo/bar_spec.rb:123</a>'

describe 'colorized', ->
  it 'corretly sets colors to fail/pass marks', ->
    formatter = new TextFormatter("[31mF[0m[31mF[0m[31mF[0m[33m*[0m[33m*[0m[31mF[0m")
    expect(formatter.colorized().text).toBe(
      '<p class="rspec-color tty-31">F</p>' +
      '<p class="rspec-color tty-31">F</p>' +
      '<p class="rspec-color tty-31">F</p>' +
      '<p class="rspec-color tty-33">*</p>' +
      '<p class="rspec-color tty-33">*</p>' +
      '<p class="rspec-color tty-31">F</p>'
    )
