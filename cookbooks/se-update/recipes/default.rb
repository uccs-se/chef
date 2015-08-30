cron 'update' do
  minute default['update']['minute']
  hour default['update']['hour']
  day default['update']['day']
  weekday default['update']['weekday']
  month default['update']['month']
  user default['chef']['user']
  command %W{
          git pull -b #{default['git']['branch']} #{default['git']['repo']} #{default['chef']['home']} && chef-solo
  }.join(' ')
end