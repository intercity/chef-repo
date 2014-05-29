default['rails']['applications_root'] = '/u/apps'

case node['platform_family']
when 'debian'
  if node['platform'] == 'ubuntu' && node['platform_version'] == '14.04'
    default['nginx']['pid'] = '/run/nginx.pid'
  end
end
