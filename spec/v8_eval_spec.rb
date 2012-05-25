# -*- coding: utf-8 -*-

require 'spec_helper'
require 'v8'
require 'open-uri'

class JSBridge
  def print(s)
    super(s)
  end
end

describe 'embeding v8 into rspec' do
  let(:ctx) { V8::Context.new(:with => JSBridge.new) }

  subject { ctx.eval(js) }

  context 'when given javascript expression' do
    let(:js) { "10 * 3" }
    it { should == 30 }
  end

  context 'when define function' do
    let(:js) { <<-__JS
      var oppai = function(n){
        var s = ''; var i = 0;
        for(i = 0; i < n ; i++) s+= "おっぱい！";
        return s;
      };
    __JS
    }

    it('can call defined function from javascript.') {
      subject && ctx.eval('oppai(3)').should == 'おっぱい！おっぱい！おっぱい！'
    }
  end
end
