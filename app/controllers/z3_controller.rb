require 'ostruct'
require 'z3/blogic/base'
require 'filled_memory_backend'
class Z3Controller < ApplicationController


  def on_headers
    log_command
    backend.start_upload(command) if command.with_data?
    backend.start_xml(command) if command.with_xml?
    send_continue
  end

  def on_body
    if command.with_data?
      command.upload.add(data)
      logger.info "received data: #{data.size}, #{speed(command.upload.speed)}"
    end
    if command.with_xml?
      command.xml.add(data) #we shouldn't pump too much in here
      logger.info "received xml: #{data.size}, #{speed(command.xml.speed)}"
    end
  end

  def on_close
    #logger.info 'closing connection'
  end

  def response
    result=backend.execute
    if result.last.respond_to?(:resume)
      stream_result(result)
    else
      #logger.info 'response string'
      result
    end
  rescue Z3::Error => err
    error_out(err)
  end

  private

  def send_continue
    env["stream.send_continue"].call if headers["Expect"] == "100-continue"
  end

  def router
    env['rack.z3.command'] ||= Z3::Router.new(env)
  end

  def backend
    config['storage'] ||= FilledMemoryBackend.new(:logger => env.logger)
    @backend ||= Z3::Blogic::Base.new(config['storage'], command, env.logger)
  end

  def command
    #env["z3.access_key"] = "AKanaccesskey" #fake the key for browser testing
    env['rack.z3.command'] ||= router.command.new(env, :logger => env.logger)
  end

  def error_out(err)
    logger.info("Z3 ERROR: #{err.code}")
    [err.http_status_code, {'Content-Type' => 'application/xml'}, err.to_xml]
  end


  def log_command
    logger.info(command)
    logger.info("AUTH: signature: #{command.valid_signature?("asupersecretkeys")}, valid_time: #{command.valid_time?}, query:#{command.query_string_request_authentication?}")
  end

  def speed(value)
    "#{(value/(1024**2)).to_i} MB/s"
  end
end
