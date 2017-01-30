require 'stupidedi'
require 'nokogiri'
require 'pp'

module X12XmlGen
  class Runner
    def initialize(name, guide)
      @name = name
      @guide = guide
    end

    def run
      LOGGER.info "Running #{@name}"

      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml['medi'].edimap("xmlns:medi" => "http://www.milyn.org/schema/edi-message-mapping-1.6.xsd") {
          xml['medi'].description('name' => @guide.name, 'version' => 1.0)
          xml['medi'].delimiters('segment' => '~', 'field' => "*", 'component' => ":", 'sub-component' => "")

          xml['medi'].segments('xmltag' => 'edi', 'name' => "#{@guide.functional_group}#{@guide.id}", 'ignoreUnmappedSegments' => true) {
            xml['medi'].segmentGroup('xmltag' => 'transaction', 'minOccurs' => 1, 'maxOccurs' => -1) {
              @guide.table_defs.each do |table_def|
                do_table_def(xml, table_def)
              end
            }
          }
        }
      end

      xml = builder.to_xml(indent: 4)

      xml
    end

    private

    def do_table_def(xml, table_def)
      table_def.header_segment_uses.each do |header_segment_use|
        do_segment_use(xml, header_segment_use)
      end

      table_def.loop_defs.each do |loop_def|
        do_loop_def(xml, loop_def)
      end
    end

    def do_segment_use(xml, segment_use)

      segcode = segment_use.definition.id.to_s

      if segment_use.definition.element_uses.size > 0 && (segment_use.definition.element_uses[0].methods.include? :allowed_values)
        p segment_use.definition.id.to_s
        p segment_use.definition.element_uses[0].definition.id.to_s
        p segment_use.definition.element_uses[0].allowed_values
        p segment_use.definition.element_uses[0].allowed_values.class.name == nil
        if segment_use.definition.element_uses[0].allowed_values.size >= 1 && segment_use.definition.element_uses[0].allowed_values.class.name != nil
          allowed_values = segment_use.definition.element_uses[0].allowed_values
          allowed_values = allowed_values.to_a.join('|')
          allowed_values = "(#{allowed_values})"

          segcode = "#{segcode}\\*#{allowed_values}.*"
        end
        p "==="
      end

      xml['medi'].segment('segcode' => segcode,
                          'xmltag' => segment_use.definition.id.to_s.downcase,
                          'name' => segment_use.definition.name,
                          'description' => segment_use.definition.purpose,
                          'truncatable' => true,
                          'ignoreUnmappedFields' => true,
                          'minOccurs' => segment_use.requirement.required? ? 1 : 0,
                          'maxOccurs' => segment_use.repeat_count.inspect == '>1' ? -1 : segment_use.repeat_count.inspect) do
        segment_use.definition.element_uses.each do |element_use|
          do_element_use(xml, element_use)
        end
      end
    end

    def do_loop_def(xml, loop_def)

      xml['medi'].segmentGroup('xmltag' => loop_def.id.gsub(' ', '-').downcase,
                               'minOccurs' => loop_def.requirement.required? ? 1 : 0,
                               'maxOccurs' => loop_def.repeat_count.inspect == '>1' ? -1 : loop_def.repeat_count.inspect) {
        loop_def.header_segment_uses.each do |header_segment_use|
          do_segment_use(xml, header_segment_use)
        end

        loop_def.loop_defs.each do |l|
          do_loop_def(xml, l)
        end
      }
    end

    def data_type(n)
      r = n.class.name.split('::').last

      case r
      when 'DT'
        { 'dataType' => 'Date' }
      when 'R'
        { 'dataType' => 'Float' }
      when 'AN'
        { 'dataType' => 'String' }
      when 'ID'
        { 'dataType' => 'String' }
      #when 'TM'
      when 'Nn'
        { 'dataType' => 'Integer' }
      else
        { 'dataType' => 'String' }
      end
    end

    def data_type_parameters(n)
      n.class.name.split('::').last == 'DT' ? { 'dataTypeParameters' => 'format=yyyyMMdd' } : {}
    end

    def do_element_use(xml, element_use)
      if element_use.definition.composite?
        xml['medi'].field('xmltag' => element_use.definition.id,
                          'name' => element_use.definition.name,
                          'required' => element_use.requirement.required?,
                          'truncatable' => true) do
          element_use.definition.component_uses.each do |component_use|
            xml['medi'].component('xmltag' => component_use.definition.id,
                                  'name' => component_use.definition.name,
                                  'required' => component_use.requirement.required?,
                                  'minLength' => component_use.definition.min_length,
                                  'maxLength' => component_use.definition.max_length)
                        .merge(data_type(component_use.definition))
                        .merge(data_type_parameters(component_use.definition))
          end
        end
        return
      end

      xml['medi'].field('xmltag' => element_use.definition.id,
                        'name' => element_use.definition.name,
                        'required' => element_use.requirement.required?,
                        'minLength' => element_use.definition.min_length,
                        'maxLength' => element_use.definition.max_length)
                  .merge(data_type(element_use.definition))
                  .merge(data_type_parameters(element_use.definition))
    end
  end
end
