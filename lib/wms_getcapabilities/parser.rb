require 'logger'
$logger = Logger.new(STDOUT)
$logger.level = Logger::WARN

module WmsGetcapabilities

  class Parser

    READERS_V1 = {
      'Service' => lambda { |node, obj|
                    puts node.name;
                    obj.service ||= OpenStruct.new
                    read_child_nodes(node, obj.service)
      },
      'Name' => lambda { |node, obj|
                    obj.name = child_value(node)
      },
      'Title' => lambda { |node, obj|
                    obj.title = child_value(node)
      },
      'Abstract' => lambda { |node, obj|
                    obj.abstract = child_value(node)
      },
      'BoundingBox' => lambda { |node, obj|
        bbox = OpenStruct.new
        bbox.bbox = [
          node['minx'].to_f,
          node['miny'].to_f,
          node['maxx'].to_f,
          node['maxy'].to_f
        ]

        res = OpenStruct.new
        res.x = node['resx'].to_f if node['resx']
        res.y = node['resy'].to_f if node['resy']

        bbox.res = res unless res.x.nil? || res.y.nil?

        obj.bbox = bbox
      },
      'OnlineReource' => lambda { |node, obj|
        # obj.contact_information = OpenStruct.new
        # read_child_nodes(node, obj.contact_information)
      },
      'ContactInformation' => lambda { |node, obj|
        obj.contact_information = OpenStruct.new
        read_child_nodes(node, obj.contact_information)
      },
      'ContactPersonPrimary' => lambda { |node, obj|
        obj.person_primary = OpenStruct.new
        read_child_nodes(node, obj.person_primary)
      },
      'Capability' => lambda { |node, obj|
        obj.capability = OpenStruct.new
        obj.capability.nested_layers = Array.new
        obj.capability.layers = Array.new

        read_child_nodes(node, obj.capability)
      },
      'Layer' => lambda { |node, obj|
        parent_layer = nil
        capability = nil

        if (obj.capability)
          capability = obj.capability
          parent_layer = obj
        else
          capability = obj
        end

        layer = OpenStruct.new

        obj.nested_layers ||= Array.new
        obj.nested_layers << layer
        read_child_nodes(node, layer)
      },
      'Request' => lambda { |node, obj|
        obj.request = OpenStruct.new
        read_child_nodes(node, obj.request)
      },
      'KeywordList' => lambda { |node, obj|
        read_child_nodes(node, obj)
      },
      'SRS' => lambda { |node, obj|
        obj.srs ||= Hash.new
        obj.srs[child_value(node)] = true
      }
      
    }

    READERS_V1_1 = {
      'Keyword' => lambda { |node, obj|
        obj.keywords ||= []
        obj.keywords << child_value(node)
      }
    }

    READERS_V3 = {
      'WMS_Capabilities' => lambda { |node, obj|
                              puts node.name;
                              read_child_nodes(node, obj)
      }
    }

    READERS = READERS_V1
                .merge(READERS_V1_1)
                .merge(READERS_V3)



    def initialize(io)
      @io = io
      @parser = LibXML::XML::Parser.io(io)
      @raw = @parser.parse
      @capabilities = OpenStruct.new
      @root = @raw.root
      self.class.read_node(@root, @capabilities)
    end

    def capabilities
      @capabilities
    end

    class << self
      def read_node(node, obj)
        if (obj.nil?)
          obj = OpenStruct.new
        end

        reader = READERS[node.name]
        if (reader)
          reader.call(node, obj)
        end
      end

      def read_child_nodes(node, obj)
        if (obj.nil?)
          obj = OpenStruct.new
        end

        children = node.children
        children.each do |child|
          if (child.node_type == 1)
            read_node(child, obj)
          end
        end

        obj
      end

      def child_value(node, default = nil)
        value = default || ""

        node.each do |child|
          case child.node_type
          when 3,4 # Text: 3 or CDATA: 4 use cdata? or text?
            value << child.content
          end
        end
        value.strip!

        value
      end
    end
  end
end

