#! /usr/bin/ruby

require 'forwardable'

class RecordCollection
  extend Forwardable
  attr_accessor :records

  def_delegator :@records, :[], :record_by_index

  def_delegator :@records, :size

  def_delegator :@records, :<<

  def_delegator :@records, :map

end


rc = RecordCollection.new
rc.records = [1,1,212,2,23,34,5]

p rc.record_by_index 2

p rc << 1000

p rc.size

rc.records = rc.map {|n| n * 2 }

p rc.records.inspect

