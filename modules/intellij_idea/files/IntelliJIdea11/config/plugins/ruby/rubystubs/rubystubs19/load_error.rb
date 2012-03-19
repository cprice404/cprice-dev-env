=begin
 This is a machine generated stub using stdlib-doc for <b>class LoadError</b>
 Sources used:  Ruby 1.9.2-p290
 Created on 2011-09-02 14:09:46 +0400 by IntelliJ Ruby Stubs Generator.
=end

# Raised when a file required (a Ruby script, extension library, ...)
# fails to load.
# 
#    require 'this/file/does/not/exist'
# 
# <em>raises the exception:</em>
# 
#    LoadError: no such file to load -- this/file/does/not/exist
class LoadError < ScriptError
end
