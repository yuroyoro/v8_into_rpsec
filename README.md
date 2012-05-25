# Sample of Embeding V8 and jQuery into RSpec.

This is a sample project that embeding 'V8 javascript engine' into rspec, powered by 'therubyracer'.

therubyracer : https://github.com/cowboyd/therubyracer

see :
サーバーサイド jQuery をやってみる！ - IT戦記 : http://d.hatena.ne.jp/amachang/20100208/1265640443

```ruby
#!/usr/bin/env ruby

require 'v8'
require 'open-uri'

class JSBridge
  def print(s)
    super(s)
  end
end

ctx = V8::Context.new(:with => JSBridge.new)
ctx.eval(open('http://www.chimaira.org/tools/minidom.js.txt').read)
ctx.eval(open('http://ejohn.org/files/htmlparser.js').read)
ctx.eval(open('http://amachang.sakura.ne.jp/misc/php_jquery/fix.js').read)

workaournd_js = <<-__JAVASCRIPT
Document.prototype.compareDocumentPosition =
Element.prototype.compareDocumentPosition = function(other) {
  return 32; // this is a mock implemntation.
};
__JAVASCRIPT

ctx.eval(workaournd_js)
href = "http://amachang.sakura.ne.jp/misc/php_jquery/pasee.html"
ctx.eval("location.href = '#{href}'")

html = open(href).read
ctx['html'] = html

ctx.eval("parseHtml(html, document)")

ctx.eval(open('http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js').read)

puts 'loaded jquery '
puts "exec $('div.hoge').get()"
puts ctx.eval("$('div.hoge').get()")
```

