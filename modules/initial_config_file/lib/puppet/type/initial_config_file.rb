module Puppet
  newtype(:initial_config_file) do
      newparam(:name) do
          desc "foo"
      end

      newparam(:source) do
      end
      newparam(:recurse) do
      end
      newparam(:mode) do
      end
      newparam(:path) do
      end
      newproperty(:ensure) do
          def retrieve
              return :directory if File.directory?(resource[:path])
              return :file if File.file?(resource[:path])
              return :absent if !File.exists?(resource[:path])
              raise NotImplementedError
          end

          newvalue :directory do
              file = Puppet::Type.type(:file).new({
                  :source       => resource[:source],
                  :recurse      => resource[:recurse],
                  :mode         => resource[:mode],
                  :path         => resource[:path],
                  :ensure       => 'directory',
              })
              catalog = Puppet::Resource::Catalog.new
              catalog.host_config = false
              catalog.add_resource(file)
              catalog.apply
          end
      end
  end  
end
