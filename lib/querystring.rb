require 'cgi'

module QueryString
  VERSION = File.read(File.expand_path('../../VERSION', __FILE__)).strip

  def self.stringify obj, options={}
    o = {
      :seperator => '&',             # between params
      :equals => '=',                # between key/value pairs
      :array_style => :seperate,     # or :combine
      :array_brackets => false,      # use [] with array_style :seperate
      :array_index => false,         # use indexes with array style :seperate
      :array_seperator => ','        # used with :combine array style
    }.merge(options)

    # used for seperate style arrays
    ar_tmpl = "%s#{'[' if o[:array_brackets]}%s#{']' if o[:array_brackets]}#{o[:equals]}%s"

    obj.map do |key,value|
      key = CGI.escape(key.to_s)

      if value.is_a?Array
        case o[:array_style]
        when :combine
          list = value.map do |inner_value|
            CGI.escape(inner_value.to_s)
          end.join o[:array_seperator]
          "#{key}#{o[:equals]}#{list}"
        else  # when :seperate
          value.each_with_index.map do |inner_value, index|
            index = o[:array_index] ? index.to_s : ''
            inner_value = CGI.escape(inner_value.to_s)

            ar_tmpl%[key, index, inner_value]
          end.join o[:seperator]
        end
      else
        value = CGI.escape(value.to_s)

        "#{key}#{o[:equals]}#{value}"
      end
    end.join o[:seperator]
  end
end

