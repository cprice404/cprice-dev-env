=begin
 This is a machine generated stub using stdlib-doc for <b>class RegexpError</b>
 Sources used:  Ruby 1.9.2-p290
 Created on 2011-09-02 14:09:46 +0400 by IntelliJ Ruby Stubs Generator.
=end

require 'standard_error'
# Raised when given an invalid regexp expression.
# 
#    Regexp.new("?")
# 
# <em>raises the exception:</em>
# 
#    RegexpError: target of repeat operator is not specified: /?/
class RegexpError < StandardError
end
