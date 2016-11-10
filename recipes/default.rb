#
# Cookbook Name:: cronapt
# Recipe:: default
#
# Copyright (C) 2014 Greg Palmier

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#   http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package 'cron-apt' do
  action :upgrade
end

if node['cronapt']['environment']
  cronapt_env = node['cronapt']['environment']
else
  cronapt_env = node.chef_environment
end

qa = beta = production = false

case cronapt_env
when 'qa'
  qa = true
  reboot_reminder_day = '2,3,4,5'
when 'beta'
  beta = true
  reboot_reminder_day = '2,3,4,5'
when 'overhead'
  overhead = true
  reboot_reminder_day = '2,3,4,5'
when 'production'
  production = true
  reboot_reminder_day = '1,2,3,5'
else
  fail "'#{cronapt_env}' is an invalid environment for cron-apt. Please use 'qa', 'beta', 'overhead', or 'production'."
end

template '/etc/cron.d/cron-apt' do
  source 'cron-apt.erb'
  owner 'root'
  group 0
  mode 00644
  variables(
    qa: qa,
    beta: beta,
    overhead: overhead,
    production: production
  )
end

template '/etc/cron-apt/action.d/6-upgrade' do
  source '6-upgrade.erb'
  owner 'root'
  group 0
  mode 00644
  variables(
    enable_upgrade: node['cronapt']['enable_upgrade']
  )
end

template '/etc/apt/apt.conf.d/local' do
  source 'dpkg-options.erb'
  owner 'root'
  group 0
  mode 00644
  variables(
    force_confmiss: node['cronapt']['force_confmiss'],
    force_confnew: node['cronapt']['force_confnew'],
    force_confdef: node['cronapt']['force_confdef'],
    force_confold: node['cronapt']['force_confold']
  )
end

template '/etc/cron-apt/config' do
  source 'config.erb'
  owner 'root'
  group 0
  mode 00644
  variables(
    mailon: node['cronapt']['mailon'],
    mailto: node['cronapt']['mailto'],
    aptcommand: node['cronapt']['aptcommand']
  )
end

cookbook_file '/usr/local/bin/apt-get-slack' do
  source 'apt-get-slack'
  owner 'root'
  group 'root'
  mode '0755'
end

cookbook_file '/usr/local/bin/reboot-reminder' do
  source 'reboot-reminder'
  owner 'root'
  group 'root'
  mode '0755'
end

if node['cronapt']['enable_reboot']
  do_reboot = 'yes'
else
  do_reboot = 'no'
end

file '/etc/cron.d/reboot-reminder' do
  user 'root'
  group 'adm'
  mode '0640'
  content "0 10 * * #{reboot_reminder_day} root /usr/local/bin/reboot-reminder #{do_reboot} >/dev/null 2>&1\n"
end
