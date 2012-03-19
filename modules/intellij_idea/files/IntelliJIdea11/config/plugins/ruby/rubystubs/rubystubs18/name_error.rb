=begin
 This is a machine generated stub using stdlib-doc for <b>class NameError</b>
 Sources used:  Ruby 1.8.7-p352
 Created on Fri Sep 02 15:05:12 +0400 2011 by IntelliJ Ruby Stubs Generator.
=end

class NameError < StandardError
    # NameError.new(msg [, name])  => name_error
    #  
    # Construct a new NameError exception. If given the <i>name</i>
    # parameter may subsequently be examined using the <code>NameError.name</code>
    # method.
    def self.new(msg, *name)
        #This is a stub, used for indexing
    end
    # name_error.name    =>  string or nil
    #  
    # Return the name associated with this NameError exception.
    def name()
        #This is a stub, used for indexing
    end
    # name_error.to_s   => string
    #  
    # Produce a nicely-formated string representing the +NameError+.
    def to_s()
        #This is a stub, used for indexing
    end
    class message < Data
    end
end
