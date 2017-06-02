module GemBench
  class StrictVersionGem
    attr_reader :name
    attr_reader :version
    attr_reader :version_type
    attr_reader :valid
    attr_reader :lines
    attr_reader :tokenized_line

    class << self
      def from_line(all_lines, line, index)
        tokenized_line = GemfileLineTokenizer.new(all_lines, line, index)
        return nil unless tokenized_line.is_gem
        new(
            tokenized_line.name,
            tokenized_line.version,
            tokenized_line.version_type,
            tokenized_line.valid,
            tokenized_line.lines,
            tokenized_line
        )
      end
    end

    def initialize(name, version, version_type, valid, lines, tokenized_line)
      @name = name
      @version = version
      @version_type = version_type ? version_type.to_sym : :unknown
      @valid = valid
      @lines = lines
      @tokenized_line = tokenized_line # for debugging
    end

    def valid?
      valid
    end

    def is_type?(type)
      version_type == type.to_sym
    end

    def to_s
      <<-EOS
Gem: #{name}
Detected Version Constraint:
#{version}
Relevant Gemfile Lines:
#{lines.join("\n")}
      EOS
    end
  end
end
