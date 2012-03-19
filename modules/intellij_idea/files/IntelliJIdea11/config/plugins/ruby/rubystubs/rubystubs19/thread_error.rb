=begin
 This is a machine generated stub using stdlib-doc for <b>class ThreadError</b>
 Sources used:  Ruby 1.9.2-p290
 Created on 2011-09-02 14:09:46 +0400 by IntelliJ Ruby Stubs Generator.
=end

require 'standard_error'
# Raised when an invalid operation is attempted on a thread.
# 
# For example, when no other thread has been started:
# 
#    Thread.stop
# 
# <em>raises the exception:</em>
# 
#    ThreadError: stopping only thread
class ThreadError < StandardError
end
