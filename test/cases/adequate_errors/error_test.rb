require "cases/helper"
require "minitest/autorun"
require 'adequate_errors'
require "models/topic"

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

  describe '#message' do
    let(:model) { Topic.new }

    it 'returns message' do
      subject = AdequateErrors::Error.new(model, :title, :inclusion,value: 'title')
      assert_equal "Title is not included in the list", subject.message
    end

    it 'returns custom message with interpolation' do
      subject = AdequateErrors::Error.new(model, :title, :inclusion,message: "custom message %{value}", value: "title")
      assert_equal "custom message title", subject.message
    end

    it 'returns plural interpolation' do
      subject = AdequateErrors::Error.new(model, :title, :too_long, count: 10)
      assert_equal "Title is too long (maximum is 10 characters)", subject.message
    end

    it 'returns singular interpolation' do
      subject = AdequateErrors::Error.new(model, :title, :too_long, count: 1)
      assert_equal "Title is too long (maximum is 1 character)", subject.message
    end

    it 'returns count interpolation' do
      subject = AdequateErrors::Error.new(model, :title, :too_long, message: "custom message %{count}", count: 10)
      assert_equal "custom message 10", subject.message
    end

    it 'renders lazily using current locale' do
      I18n.backend.store_translations(:pl,{adequate_errors: {messages: {invalid: "%{attribute} jest nieprawidłowe"}}})

      I18n.with_locale(:en) { model.errors.adequate.add(:title, :invalid) }
      I18n.with_locale(:pl) {
        assert_equal 'Title jest nieprawidłowe', model.errors.adequate.first.message
      }
    end
  end
end