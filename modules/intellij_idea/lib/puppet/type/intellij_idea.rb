module Puppet
    newtype(:intellij_idea) do
        ensurable

        newparam(:name)
        newproperty(:installdir)
        newproperty(:owner)
        newproperty(:group)

    end
end
