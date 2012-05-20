class ApplicationController
  def self.process_headers(api, env, headers, config, options)
    new(api, env, config, options, nil, headers).on_headers
  end

  def self.process_body(api, env, data, config, options)
    new(api, env, config, options, data).on_body
  end

  def self.process_close(api, env, config, options)
    new(api, env, config, options).on_close
  end

  def self.process_response(api, env, config, options)
    new(api, env, config, options).response
  end

  def initialize(api, env, config, options, data=nil, headers=nil)
    @api=api
    @env=env
    @data=data
    @headers=headers
    @logger=env.logger
    @config = config
    @options= options
  end

  attr_reader :env, :data, :headers, :logger, :options, :config

  def chunked_streaming_response(code, headers)

  end

  def stream_result(result)
    handler = lambda {
      if data=result.last.resume
        logger.info "response chunked #{data.size}"
        env.chunked_stream_send(data)
        EM.next_tick(&handler)
      else
        env.chunked_stream_close
      end
    }
    EM.next_tick(&handler)
    @api.chunked_streaming_response(result[0], result[1])
  end
end