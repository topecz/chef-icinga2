
default['icinga2']['build_type'] = 'release' # options: stable, snapshot

case node['platform_family']
when 'rhel'
  default['icinga2']['yum']['description'] = "ICINGA #{node['icinga2']['build_type'].capitalize} "
  default['icinga2']['yum']['mirrorlist'] = nil
  default['icinga2']['yum']['gpgcheck'] = true
  default['icinga2']['yum']['enabled'] = true
  default['icinga2']['yum']['gpgkey'] = 'http://packages.icinga.org/icinga.key'
  default['icinga2']['yum']['action'] = :create

  default['icinga2']['yum']['baseurl'] = value_for_platform(
    %w(centos redhat fedora) => { 'default' => "http://packages.icinga.org/epel/$releasever/#{node['icinga2']['build_type']}/" },
    'amazon' => { 'default' => "http://packages.icinga.org/epel/6/#{node['icinga2']['build_type']}/" }
  )

  # icinga2 package version suffix
  default['icinga2']['icinga2_version_suffix'] = value_for_platform(
    %w(centos redhat fedora) => { 'default' => ".el#{node['platform_version'].split('.')[0]}" },
    'amazon' => { 'default' => '.el6' }
  )

when 'debian'
  default['icinga2']['apt']['repo'] = 'ICINGA Stable Release'
  default['icinga2']['apt']['keyserver'] = 'keyserver.ubuntu.com'
  default['icinga2']['apt']['components'] = %w(main)
  default['icinga2']['apt']['deb_src'] = true
  default['icinga2']['apt']['action'] = :add

  case node['icinga2']['build_type']
  when 'snapshot'
    default['icinga2']['apt']['repo'] = 'ICINGA Snapshots Release'
    default['icinga2']['apt']['uri'] = 'http://packages.icinga.org/ubuntu'
    default['icinga2']['apt']['distribution'] = 'icinga-' + node['lsb']['codename'].to_s + '-snapshots'
    default['icinga2']['apt']['key'] = '34410682'

    # icinga2 package version suffix
    default['icinga2']['icinga2_version_suffix'] = value_for_platform(
      'ubuntu' => { 'default' => '~' + node['lsb']['codename'].to_s }
    )
  when 'release'
    default['icinga2']['apt']['repo'] = 'ICINGA Stable Release'
    default['icinga2']['apt']['uri'] = 'http://ppa.launchpad.net/formorer/icinga/ubuntu'
    default['icinga2']['apt']['distribution'] = node['lsb']['codename']
    default['icinga2']['apt']['key'] = '36862847'

    # icinga2 package version suffix
    default['icinga2']['icinga2_version_suffix'] = value_for_platform(
      'ubuntu' => { 'default' => '~ppa1~' + node['lsb']['codename'].to_s + '1' }
    )
  end
end
