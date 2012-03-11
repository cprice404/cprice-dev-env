module Puppet
    newtype(:oraclejava6) do
        ensurable

        newparam(:name)
        newproperty(:installdir)
        newproperty(:owner)
        newproperty(:group)

    end
end
