#!/usr/bin/env ruby
$:.unshift(File.expand_path('../../lib', __FILE__))
%w{querystring test/unit}.each{|i| require i}

class QueryStringTest < Test::Unit::TestCase
  include QueryString

  # shorthand stringify
  def s *a
    QueryString.stringify *a
  end

  def test_stringify
    # testing object
    o = { 
      :a => 1,
      :b => [2,3,4,'http://www.google.com/hello?far=near&war=peace']
    }

    queries = {
      s(o, :array_brackets => true, :array_index => true) => 
        'a=1&b[0]=2&b[1]=3&b[2]=4&b[3]=http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace',
      s(o, :array_brackets => false, :array_index => true) =>
        'a=1&b0=2&b1=3&b2=4&b3=http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace',
      s(o, :array_brackets => true, :array_index => false) =>
        'a=1&b[]=2&b[]=3&b[]=4&b[]=http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace',
      s(o) =>
        'a=1&b=2&b=3&b=4&b=http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace',
      s(o, :seperator => '|') =>
        'a=1|b=2|b=3|b=4|b=http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace',
      s(o, :equals => '~') =>
        'a~1&b~2&b~3&b~4&b~http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace',
      s(o, :array_style => :combine) =>
        'a=1&b=2,3,4,http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace',
      s(o, :array_style => :combine, :array_seperator => '.') =>
        'a=1&b=2.3.4.http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace'
    }

    queries.each do |k,v|
      assert_equal(v,k)
    end
  end

  def test_version
    assert_not_nil(QueryString::VERSION)
  end
end

