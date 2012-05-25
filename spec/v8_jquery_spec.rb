# -*- coding: utf-8 -*-

require 'spec_helper'
require 'v8'
require 'open-uri'

class JSBridge
  def print(s)
    super(s)
  end
end

describe 'embeding v8 and load jquery into rspec' do
  let(:ctx) { V8::Context.new(:with => JSBridge.new) }

  before {
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

    href = "http://yuroyoro-blog.tumblr.com/"
    ctx.eval("location.href = '#{href}'")

    html = <<-HTML
<html>
  <head>
    <title>foo</title>
  </head>
  <body>
    <div>
      <div class="hoge">foo</div>
      <div class="hoge">bar</div>
      <div class="hoge">baz</div>
    </div>
    <ul id='tumblr_list'>
      <li>
        <a href ="http://yuroyoro-blog.tumblr.com/">
          這い寄るゆろよろ・アンド・ライジングフォース日記
        </a>
      </li>
      <li>
        <a href ="http://yuroyoro.tumblr.com/">
          ゆろよろのねたんぶら
        </a>
      </li>
    </ul>
  </body>
</html>
    HTML


    ctx['html'] = html
    ctx.eval("parseHtml(html, document)")

    ctx.load('jquery-1.7.2.js')
  }

  subject { ctx.eval(js) }
  context 'when given css selector ' do
    let(:js){ '$("div.hoge").length' }
    it { should == 3 }
  end

  context 'when given css selector and find' do
    let(:js){ "$('#tumblr_list ').find('a').length" }
    it { should == 2 }
  end

  context 'when given css selector and attr' do
    let(:js){ "$('#tumblr_list > li a:first').attr('href')" }
    it { should == "http://yuroyoro-blog.tumblr.com/" }
  end
end
