require "pgversion/version"
require "rubygems"
require "date"

# This object provides a clean little interface to the offical Postgres versioning
# policy declared here: https://www.postgresql.org/support/versioning/
#
# Usage
# -----
#
#     # new version
#     v1 = PGVersion.v "9.2.5"
#     v1.major  #=> "9.2"
#     v1.minor  #=> 5
#     v1.eol?   #=> true
#
#     # comarison to other version
#     v2 = PGVersion.v "9.6.6"
#     v2 > v1   #=> true
#
module PGVersion

  def self.v(version)
    ::PGVersion::Version.new version
  end

  class InvalidVersion < StandardError; end

  class Version
    include Comparable

    attr_accessor :version

    def initialize(version)
      @version = version
      validate_version
    end

    def segments
      @version.to_s.split('.').map(&:to_i)
    end

    def major
      segments.take(major_digits).join '.'
    end
    
    def minor
      segments.drop(major_digits)[0] || 0
    end

    def major_digits
      return 2 if segments.first < 10
      return 1
    end

    def eol?
      return true if self < ::PGVersion.v("9.3")
      eol ? eol < Date.today : nil
    end

    def eol
      eol_dates.fetch(major, nil)
    end

    def eol_dates
      {
        "11"  => Date.new(2023, 11,  9),
        "10"  => Date.new(2022, 11, 10),
        "9.6" => Date.new(2021, 11, 11),
        "9.5" => Date.new(2021,  2, 11),
        "9.4" => Date.new(2020,  2, 13),
        "9.3" => Date.new(2018, 11,  8),
        "9.2" => Date.new(2017, 11,  9),
      }
    end

    # File rubygems/version.rb, line 335 (stdlib-2.4.2)
    def <=> other
      return unless ::PGVersion::Version === other
      return 0 if @version == other.version

      lhsegments = segments
      rhsegments = other.segments

      lhsize = lhsegments.size
      rhsize = rhsegments.size
      limit  = (lhsize > rhsize ? lhsize : rhsize) - 1

      i = 0

      while i <= limit
        lhs, rhs = lhsegments[i] || 0, rhsegments[i] || 0
        i += 1

        next      if lhs == rhs
        return -1 if String  === lhs && Numeric === rhs
        return  1 if Numeric === lhs && String  === rhs

        return lhs <=> rhs
      end

      return 0
    end

    def validate_version
      if @version.is_a? Fixnum or @version.is_a? Float
        @version = @version.to_f.to_s
      end

      validated = case major_digits
      when 1 then @version if @version.match(/^(\d+\.)?(\d+\.)?(\d+)$/)
      when 2 then @version if @version.match(/^(\d+\.)?(\d+\.)(\d+)$/)
      end

      validated or fail
    rescue
      raise PGVersion::InvalidVersion, "given version '#{@version}' not supported"
    end

  end

end
