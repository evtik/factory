class Factory
  def self.new(*attrs, &block)
    Class.new do
      attr_accessor(*attrs)

      define_method :initialize do |*args|
        raise ArgumentError, 'struct size differs' if args.length > attrs.length

        args.each_with_index do |arg, i|
          send "#{attrs[i]}=", arg
        end
      end

      define_method :[] do |arg|
        arg.is_a?(Numeric) ? send(attrs[arg]) : send(arg)
      end

      define_method :[]= do |arg, val|
        arg.is_a?(Numeric) ? send("#{attrs[arg]}=", val) : send("#{arg}=", val)
      end

      class_eval(&block) if block_given?
    end
  end
end
