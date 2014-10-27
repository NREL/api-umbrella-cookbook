module ApiUmbrella
  module OmnibusHelpers
    def omnibus_package_dir
      dir = nil

      case node[:platform_family]
      when "rhel"
        dir = "el/#{node[:platform_version].to_i}"
      when "debian"
        case(node[:platform])
        when "debian"
          dir = "debian/#{node[:platform_version].to_i}"
        when "ubuntu"
          dir = "ubuntu/#{node[:platform_version]}"
        end
      end

      if(!dir)
        raise "Undefined package directory scheme for #{node[:platform_family].inspect} #{node[:platform].inspect} #{node[:platform_version].inspect}"
      end

      dir
    end
  end
end
