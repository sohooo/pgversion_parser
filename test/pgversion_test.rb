require 'test_helper'
require 'date'

class PGVersionTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PGVersion::VERSION
  end

  def setup
    @v96 = PGVersion.v "9.6.5"
    @v92 = PGVersion.v "9.2"
    @v10 = PGVersion.v "10"
  end

  def test_it_creates_pgversion_instance
    assert @v96.instance_of? PGVersion::Version
  end

  def test_it_provides_major_version
    assert_equal @v96.major, "9.6"
  end

  def test_it_provides_minor_version
    assert_equal @v96.minor, 5
  end

  def test_it_assumes_minor_version_when_not_provided
    assert_equal @v92.minor, 0
  end

  def test_it_understands_new_version_numbering_scheme
    assert_equal @v10.major, "10"
  end

  def test_it_can_compare_versions
    assert @v96 > @v92
    assert @v10 > @v92
  end

  def test_it_also_sorts_versions_this_way
    assert [@v10, @v92, @v96].sort.first == @v92
  end

  def test_it_knows_eol_of_version
    assert @v92.eol?
    assert @v10.eol > Date.new(2021)
  end

  def test_it_just_cant_predict_future_eols
    assert_nil PGVersion.v("42").eol?
  end

  def test_it_handles_invalid_version_formats
    [
      "9.6.5.3",
      "9..2",
      "10.funky",
      "9.5a",
      "10,2",
      "9 .2",
    ].each do |invalid_version|
      assert_raises(PGVersion::InvalidVersion) { PGVersion.v invalid_version }
    end
  end

  def test_it_supports_postgres_version_notation
    [ "9.6.5", "9.2", "10.2", "10", 9, 9.2, 10.1, 11, ].each do |valid_version|
      assert PGVersion.v valid_version
    end
  end
end
