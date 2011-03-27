#!/usr/bin/env ruby
$:.unshift(File.expand_path('../../lib', __FILE__))
%w{querystring test/unit}.each{|i| require i}

class QueryStringTest < Test::Unit::TestCase
  include QueryString

  # shorthand parse
  def p *a
    QueryString.parse *a
  end

  def test_parse
    # testing object
    expected = {
      "a" => ["1"],
      "b" => ["2","3","4",'http://www.google.com/hello?far=near&war=peace']
    }

    queries = [
      p('a=1&b[0]=2&b[1]=3&b[2]=4&b[3]=http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace'),
      # p('a=1&b0=2&b1=3&b2=4&b3=http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace'), fuck this
      p('a=1&b[]=2&b[]=3&b[]=4&b[]=http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace'),
      p('a=1&b=2&b=3&b=4&b=http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace'),
      p('a=1|b=2|b=3|b=4|b=http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace', {:seperator => '|'}),
      p('a~1&b~2&b~3&b~4&b~http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace', {:equals => '~'}),
      p('a=1&b=2,3,4,http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace'),
      p('a=1&b=2|3|4|http%3A%2F%2Fwww.google.com%2Fhello%3Ffar%3Dnear%26war%3Dpeace', {:array_seperator => '|'})
    ]

    queries.each do |i|
      assert_equal(expected,i)
    end
  end
end

