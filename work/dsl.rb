module Confection

  class ContextDSL < BasicObject

    def initialize(&block)
      @missing_block = block
    end

    def eval!(&block)
      @context = block.binding.eval("self")
      instance_eval(&block)
    end

    def method_missing(sym, *xargs, &block)
      context = @context
      context_block = ::Proc.new do |*args|
        context.instance_exec(*args, &block)
      end
      @missing_block.call(sym, context_block)
    end

  end

end



if $0 == __FILE__

  config = {}

  dsl = Confection::ContextDSL.new do |name, block|
    config[name] = block
  end

  dsl.eval! do
    foo do
      puts self
    end
  end

  config[:foo].call

end
