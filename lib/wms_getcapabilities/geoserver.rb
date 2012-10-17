module WmsGetcapabilities
  
  class Geoserver

    def initialize(root_url)
      @root_url = root_url
    end

    def get_capabilities(version = "1.1.1")
      service   = "wms"
      request   = "GetCapabilities"
      
      response  = open("#{@root_url}/wms?service=#{service}?version=#{version}?request=#{request}")
      @capabilities = Parser.new(response).capabilities
    end

    def capabilities
      @capabilities
    end

    def layers
      @capabilities.nested_layers
    end
  
  end

end