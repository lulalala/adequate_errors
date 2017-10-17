require "minitest/autorun"
require 'adequate_errors/error'

describe AdequateErrors::Error do
  describe '#initialize' do
    subject { AdequateErrors::Error.new(self, :mineral, :not_enough, count: 2) }

    it 'assigns attributes' do
      assert_equal self, subject.base
      assert_equal :mineral, subject.attribute
      assert_equal :not_enough, subject.type
      assert_equal({count: 2}, subject.options)
    end
  end
end