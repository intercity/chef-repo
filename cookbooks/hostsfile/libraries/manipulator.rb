#
# Author:: Seth Vargo <sethvargo@gmail.com>
# Cookbook:: hostsfile
# Library:: manipulator
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

class Manipulator
  attr_reader :node

  def initialize(node)
    @node = node.to_hash

    # Fail if no hostsfile is found
    Chef::Log.fatal "No hostsfile exists at '#{hostsfile_path}'!" unless ::File.exists?(hostsfile_path)
    contents = ::File.readlines(hostsfile_path)

    @entries = contents.collect do |line|
      Entry.parse(line) unless line.strip.nil? || line.strip.empty?
    end.compact
  end

  def ip_addresses
    @entries.collect do |entry|
      entry.ip_address
    end.compact || []
  end

  def add(options = {})
    @entries << Entry.new(
      :ip_address => options[:ip_address],
      :hostname => options[:hostname],
      :aliases => options[:aliases],
      :comment => options[:comment],
      :priority => options[:priority]
    )
  end

  def update(options = {})
    if entry = find_entry_by_ip_address(options[:ip_address])
      entry.hostname = options[:hostname]
      entry.aliases = options[:aliases]
      entry.comment = options[:comment]
      entry.priority = options[:priority]
    end
  end

  def append(options = {})
    if entry = find_entry_by_ip_address(options[:ip_address])
      entry.aliases = [ entry.aliases, options[:hostname], options[:aliases] ].flatten.compact.uniq
      entry.comment = [ entry.comment, options[:comment] ].compact.join(', ') unless entry.comment && entry.comment.include?(options[:comment])
    else
      add(options)
    end
  end

  def remove(ip_address)
    if entry = find_entry_by_ip_address(ip_address)
      @entries.delete(entry)
    end
  end

  def save
    save!
  rescue
    false
  end

  def save!
    entries = []
    entries << "#"
    entries << "# This file is managed by Chef, using the hostsfile cookbook."
    entries << "# Editing this file by hand is highly discouraged!"
    entries << "#"
    entries << "# Comments containing an @ sign should not be modified or else"
    entries << "# hostsfile will be unable to guarantee relative priority in"
    entries << "# future Chef runs!"
    entries << "#"
    entries << "# Last updated: #{::Time.now}"
    entries << "#"
    entries << ""
    entries += unique_entries.sort_by{ |e| [-e.priority.to_i, e.hostname.to_s] }
    entries << ""

    ::File.open(hostsfile_path, 'w') do |file|
      file.write( entries.join("\n") )
    end
  end

  def find_entry_by_ip_address(ip_address)
    @entries.detect do |entry|
      !entry.ip_address.nil? && entry.ip_address == ip_address
    end
  end

  private
  # Returns the path to the hostsfile.
  def hostsfile_path
    @hostsfile_path ||= case node['platform_family']
      when 'windows'
        "#{node['kernel']['os_info']['system_directory']}\\drivers\\etc\\hosts"
      else
        # debian, rhel, fedora, suse, gentoo, slackware, arch, mac_os_x, windows
        '/etc/hosts'
      end
  end

  # This is a crazy way of ensuring unique objects in an array using a Hash
  def unique_entries
    remove_existing_hostnames
    Hash[*@entries.map{ |entry| [entry.ip_address, entry] }.flatten].values
  end

  # This method ensures that hostnames/aliases and only used once. It
  # doesn't make sense to allow multiple IPs to have the same hostname
  # or aliases. This method removes all occurrences of the existing
  # hostname/aliases from existing records.
  #
  # This method also intelligently removes any entries that should no
  # longer exist.
  def remove_existing_hostnames
    new_entry = @entries.pop
    changed_hostnames = [ new_entry.hostname, new_entry.aliases ].flatten.uniq

    @entries = @entries.collect do |entry|
      entry.hostname = nil if changed_hostnames.include?(entry.hostname)
      entry.aliases = entry.aliases - changed_hostnames

      if entry.hostname.nil?
        if entry.aliases.empty?
          nil
        else
          entry.hostname = entry.aliases.shift
          entry
        end
      else
        entry
      end
    end.compact

    @entries << new_entry
  end
end
