require "x12_xml_gen/version"
require 'x12_xml_gen/logging'
require 'x12_xml_gen/formats'
require 'x12_xml_gen/runner'

module X12XmlGen
  def self.run
    X12XmlGen::FORMATS.each do |f|
      r = X12XmlGen::Runner.new("#{f[0]}#{f[2]}", f[3])
      r.run
    end
  end
end
