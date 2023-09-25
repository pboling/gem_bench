module GemBench
  class StrictVersionGem
    attr_reader :name, :version, :version_type, :valid, :relevant_lines, :index, :tokenized_line

    class << self
      def from_line(all_lines, line, index, opts = {})
        tokenized_line = GemfileLineTokenizer.new(all_lines, line, index)
        return unless tokenized_line.is_gem

        new(
          tokenized_line.name,
          tokenized_line.version,
          tokenized_line.version_type,
          tokenized_line.valid,
          tokenized_line.relevant_lines,
          tokenized_line.index,
          (opts[:debug] == true) ? tokenized_line : nil,
        )
      end
    end

    def initialize(name, version, version_type, valid, relevant_lines, index, tokenized_line = nil)
      @name = name
      @version = version
      @version_type = version_type ? version_type.to_sym : :unknown
      @valid = valid
      @relevant_lines = relevant_lines
      @index = index
      @tokenized_line = tokenized_line # for debugging
    end

    def valid?
      valid
    end

    def is_type?(type)
      version_type == type.to_sym
    end

    def to_s
      <<~EOS
        Gem: #{name}
        Line Number: #{index}
        Version: #{version.inspect}
        Relevant Gemfile Lines:
        #{relevant_lines.join("\n")}
      EOS
    end
  end
end
