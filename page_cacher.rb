require "pathname"

module TheScore
  module Cache
    class Key
      def self.for(request)
        path = Pathname(request.path_info)
        ext_name = path.extname if Rack::Mime::MIME_TYPES.include?(path.extname)
        url = request.path_info
        query_string = Digest::MD5.hexdigest(request.query_string) unless request.query_string.blank?
    
        "#{url}_#{ext_name}_#{Digest::MD5.hexdigest(url)}_#{query_string}"
      end
    end
    
    module ResponseCacher
      include CacheExtension

      def url_cache_key=(url_cache_key)
        @url_cache_key = url_cache_key
      end
      
      def call(env)
        @cached_entry = get_value_with_retries(@url_cache_key)
        
        @http_status = 304
        @use_caching = !@cached_entry.blank?
        
        if @cached_entry.blank?
          invoke_app(env)
        
          if (@http_status == 200 && @use_caching)
            set_value_with_retries(@url_cache_key, build_cache_entry, @cache_ttl)
          end
        end
        
        response = make_response
        
        response.call
        
      end
      
private      
      def build_cache_entry
        @cached_entry = CacheEntry.new 
        @cached_entry.body = @response.last.body 
        @cached_entry.content_type = @response_headers["Content-Type"] 
        @cached_entry.akamai_ttl = @response_headers["Akamai-TTL"] || 60.seconds
  
        @cached_entry
      end
      
      def invoke_app(env)
        debugger
        app = instance_variable_get(:@app)
        @response = app.call(env)
        @response_headers = @response.last.header
        @cache_ttl = @response_headers['Cache-Expiry'] || 7200
        @use_caching = @response_headers['Use-Caching'] || nil

        @http_status = @response.first
      end
      
      def make_response
        response_block = if @use_caching && [304,200].include?(@http_status)
            lambda do # cached response
              akamai_ttl = @cached_entry.akamai_ttl

              [ @http_status, {
                  "Content-Type" => @cached_entry.content_type, 
                  "Expires" => "#{akamai_ttl.seconds.from_now.httpdate}",
                  "Cache-Control" => "public, max-age: #{akamai_ttl}",
                  "Edge-Control" => "cache-maxage=#{akamai_ttl}s,!no-store,!bypass-cache", 
                  "Etag" => Digest::MD5.hexdigest(@cached_entry.body) }, 
                @http_status == 304 ? [@cached_entry.body] : [@cached_entry.body] 
              ]
            end  
          elsif !@use_caching && @http_status == 200
            lambda { @response } # no-cached response
          else # probably an error
            lambda do
              @response[1].delete("Akamai-TTL")
              @response[1].delete("Cache-Expiry")
              @response[1].delete("Use-Caching")

              @response
            end  
          end
        response_block  
      end
    end
    
    class CacheEntry
      attr_accessor :body, :content_type, :akamai_ttl
    end
    
  end
end

class PageCacher
  
  def initialize(app)
    @app = app
  end
    
  def call(env)
    request = Rack::Request.new(env)
    url_cache_key = TheScore::Cache::Key.for(request)

    return @app.call(env) if (request.request_method != 'GET' || request.xhr?)

    @app.extend(TheScore::Cache::ResponseCacher)
    @app.url_cache_key = url_cache_key
    
    @app.call(env) 
  end  
end
