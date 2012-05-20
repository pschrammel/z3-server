require "goliath"
require "bad_goliath_hack"

class GoliathApp < Goliath::API

  def on_headers(env, headers)
    Z3Controller.process_headers(self, env, headers, config, options)
  end

  def on_body(env, data)
    Z3Controller.process_body(self, env, data, config, options)
  end

  def on_close(env)
    Z3Controller.process_close(self, env, config, options)
  end

  def response(env)
    Z3Controller.process_response(self, env, config, options)
  end
end