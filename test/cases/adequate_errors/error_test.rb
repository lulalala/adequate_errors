require "minitest/autorun"
require 'adequate_errors/error'

describe AdequateErrors::Error do
  subject { AdequateErrors::Error.new(self, :mineral, :not_enough, count: 2) }

  describe '#initialize' do
    it 'assigns attributes' do
      assert_equal self, subject.base
      assert_equal :mineral, subject.attribute
      assert_equal :not_enough, subject.type
      assert_equal({count: 2}, subject.options)
    end
  end

  describe '#match?' do
    it 'handles mixed condition' do
      assert_equal false,subject.match?(:attribute => :mineral, :type => :too_coarse)
      assert_equal true,subject.match?(:attribute => :mineral, :type => :not_enough)
      assert_equal true,subject.match?(:attribute => :mineral, :type => :not_enough, count: 2)
      assert_equal false,subject.match?(:attribute => :mineral, :type => :not_enough, count: 1)
    end

    it 'handles attribute match' do
      assert_equal false,subject.match?(:attribute => :foo)
      assert_equal true,subject.match?(:attribute => :mineral)
    end

    it 'handles error type match' do
      assert_equal false,subject.match?(:type => :too_coarse)
      assert_equal true,subject.match?(:type => :not_enough)
    end

    it 'handles extra options match' do
      assert_equal false,subject.match?(:count => 1)
      assert_equal true,subject.match?(:count => 2)
    end
  end
end