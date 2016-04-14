class ClockCase < OpenStruct
  def name
    'test_%s' % description.gsub(/[\(\) -]/, '_').gsub('=', 'is_equal_to')
  end

  def test_body
    section == 'equal' &&
      compare_clocks || simple_test
  end

  def compare_clocks
    "clock1 = Clock.at(#{clock1['hour']}, #{clock1['minute']})
    clock2 = Clock.at(#{clock2['hour']}, #{clock2['minute']})
    #{assert_or_refute} clock1 == clock2"
  end

  def assert_or_refute
    expected ? 'assert' : 'refute'
  end

  def simple_test
    "assert #{expected.inspect}, Clock.at(#{hour}, #{minute})#{add_to_clock}"
  end

  def add_to_clock
    " + #{add}" if add
  end

  def skipped
    index > 0 && 'skip' || '# skip'
  end
end

require 'pp'
ClockCases = proc do |data|
  i = 0
  json = JSON.parse(data)
  cases = []
  %w(create add equal).each do |section|
    json[section]['cases'].each do |row|
      row = row.merge(row.merge('index' => i, 'section' => section))
      cases << ClockCase.new(row)
      i += 1
    end
  end
  cases
end
