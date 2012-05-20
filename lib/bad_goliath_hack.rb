module BadGoliathHack
  CONTINUE= "HTTP/1.1 100 Continue\r\n\r\n"

  def self.included(base)
    base.class_eval {
      alias :initialize_old :initialize
      def initialize(app, con, env)
        initialize_old(app, con, env)
        env["stream.send_continue"] = proc { @conn.send_data(CONTINUE) }
      end
    }
  end


end

Goliath::Request.send(:include, BadGoliathHack)

