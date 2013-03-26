#
# Author:: Seth Vargo <sethvargo@gmail.com>
# Cookbook:: hostsfile
# Provider:: entry
#
# Copyright 2012, Seth Vargo, CustomInk, LCC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Creates a new hosts file entry. If an entry already exists, it will be
# overwritten by this one.
action :create do
  hostsfile.add(
    :ip_address => new_resource.ip_address,
    :hostname => new_resource.hostname,
    :aliases => new_resource.aliases,
    :comment => new_resource.comment,
    :priority => new_resource.priority
  )

  new_resource.updated_by_last_action(true) if hostsfile.save!
end

# Create a new hosts file entry, only if one does not already exist for
# the given IP address. If one exists, this does nothing.
action :create_if_missing do
  if hostsfile.find_entry_by_ip_address(new_resource.ip_address).nil?
    hostsfile.add(
      :ip_address => new_resource.ip_address,
      :hostname => new_resource.hostname,
      :aliases => new_resource.aliases,
      :comment => new_resource.comment,
      :priority => new_resource.priority
    )

    new_resource.updated_by_last_action(true) if hostsfile.save!
  end
end

# Appends the given data to an existing entry. If an entry does not exist,
# one will be created
action :append do
  hostsfile.append(
    :ip_address => new_resource.ip_address,
    :hostname => new_resource.hostname,
    :aliases => new_resource.aliases,
    :comment => new_resource.comment,
    :priority => new_resource.priority
  )

  new_resource.updated_by_last_action(true) if hostsfile.save!
end

# Updates the given hosts file entry. Does nothing if the entry does not
# exist.
action :update do
  hostsfile.update(
    :ip_address => new_resource.ip_address,
    :hostname => new_resource.hostname,
    :aliases => new_resource.aliases,
    :comment => new_resource.comment,
    :priority => new_resource.priority
  )

  new_resource.updated_by_last_action(true) if hostsfile.save!
end

# Removes an entry from the hosts file. Does nothing if the entry does
# not exist.
action :remove do
  hostsfile.remove(new_resource.ip_address)

  new_resource.updated_by_last_action(true) if hostsfile.save!
end

private
def hostsfile
  @hostsfile ||= Manipulator.new(node)
end
