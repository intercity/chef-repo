#
# Author:: Seth Vargo <sethvargo@gmail.com>
# Cookbook:: hostsfile
# Library:: entry
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

require 'ipaddr'

class Entry
  attr_accessor :ip_address, :hostname, :aliases, :comment, :priority

  def initialize(options = {})
    raise ArgumentError, ':ip_address and :hostname are both required options' if options[:ip_address].nil? || options[:hostname].nil?

    @ip_address = IPAddr.new(options[:ip_address])
    @hostname = options[:hostname]
    @aliases = [options[:aliases]].flatten.compact
    @comment = options[:comment]
    @priority = options[:priority] || calculate_priority(options[:ip_address])
  end

  def priority=(new_priority)
    @calculated_priority = false
    @priority = new_priority
  end

  class << self
    # Creates a new Hostsfile::Entry object by parsing a text line. The
    # `line` attribute will be in the following format:
    #
    #     1.2.3.4 hostname [alias[, alias[, alias]]] [# comment [@priority]]
    #
    # This returns a new Entry object...
    def parse(line)
      entry_part, comment_part = line.split('#', 2).collect { |part| part.strip.empty? ? nil : part.strip }

      if comment_part && comment_part.include?('@')
        comment_part, priority = comment_part.split('@', 2).collect { |part| part.strip.empty? ? nil : part.strip }
      else
        priority = nil
      end

      # Return nil if the line is empty
      return nil if entry_part.nil?

      # Otherwise, collect all the entries and make a new Entry
      entries = entry_part.split(/\s+/).collect{ |entry| entry.strip unless entry.nil? || entry.strip.empty? }.compact
      return self.new(
        :ip_address => entries[0],
        :hostname => entries[1],
        :aliases => entries[2..-1],
        :comment => comment_part,
        :priority => priority
      )
    end
  end

  # Write out the entry as it appears in the hostsfile
  def to_s
    hosts = [hostname, aliases].flatten.join(' ')

    comments = "# #{comment.to_s}".strip
    comments << " @#{priority}" unless priority.nil? || @calculated_priority
    comments = comments.strip
    comments = nil if comments == '#'

    [ip_address, hosts, comments].compact.join("\t").strip
  end

  private
  # Attempt to calculate the relative priority of each entry
  def calculate_priority(ip_address)
    @calculated_priority = true
    ip_address = IPAddr.new(ip_address)

    return 81 if ip_address == IPAddr.new('127.0.0.1')
    return 80 if IPAddr.new('127.0.0.0/8').include?(ip_address) # local
    return 60 if ip_address.ipv4? # ipv4
    return 20 if ip_address.ipv6? # ipv6
    return 00
  end
end
