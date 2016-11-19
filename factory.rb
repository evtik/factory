class Factory
  def self.new(*attrs, &block)
    Class.new do
      send(:attr_accessor, *attrs)

      send(:define_method, :initialize) do |*args|
        args.each_with_index do |arg, i|
          send("#{attrs[i]}=", arg)
        end
      end

      send(:define_method, :[]) do |arg|
        arg.is_a?(Integer) ? send(attrs[arg]) : send(arg)
      end

      send(:define_method, :[]=) do |arg, val|
        arg.is_a?(Integer) ? send("#{attrs[arg]}=", val) : send("#{arg}=", val)
      end

      send(:class_eval, &block) if block_given?
    end
  end
end
