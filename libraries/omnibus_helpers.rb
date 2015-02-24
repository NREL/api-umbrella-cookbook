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

    def omnibus_package_extension
      extension = case node[:platform_family]
      when "rhel"
        "rpm"
      when "debian"
        "deb"
      end

      if(!extension)
        raise "Undefined package extension scheme for #{node[:platform_family].inspect} #{node[:platform].inspect} #{node[:platform_version].inspect}"
      end

      extension
    end

    def omnibus_package
      # The RPM version number changes hyphens to dashes (so if our version was
      # 0.8.0-pre1, the package version will be 0.8.0_pre1).
      version = node[:omnibus][:env][:api_umbrella_version].gsub(/-/, "_")
      iteration = node[:omnibus][:env][:api_umbrella_iteration] || 1
      extension = omnibus_package_extension
      package = case node[:platform_family]
      when "rhel"
        "api-umbrella-#{version}-#{iteration}.el#{node[:platform_version].to_i}.x86_64.#{extension}"
      when "debian"
        "api-umbrella_#{version}-#{iteration}_amd64.#{extension}"
      end

      if(!package)
        raise "Undefined package scheme for #{node[:platform_family].inspect} #{node[:platform].inspect} #{node[:platform_version].inspect}"
      end

      package
    end
  end
end
