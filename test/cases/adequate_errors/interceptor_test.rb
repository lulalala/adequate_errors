require "minitest/autorun"
require "active_model"
require "models/topic"
require 'adequate_errors/interceptor'
require 'adequate_errors/errors'

describe AdequateErrors::Interceptor do
  let(:model) { Topic.new }
  let(:rails_errors) { ActiveModel::Errors.new(model) }
  let(:adequate_errors) { AdequateErrors::Errors.new(model, rails_errors) }
  subject { AdequateErrors::Interceptor.new(rails_errors, adequate_errors) }

  describe '#add' do
    it 'assigns attributes' do
      assert_equal 0, subject.size
      assert_equal 0, rails_errors.details.count

      subject.add(:title, :not_attractive)

      assert_equal 1, rails_errors.size
      assert_equal 1, rails_errors.details.count
      assert_equal [{:error=>:not_attractive}], rails_errors.details[:title]

      assert_equal 1, adequate_errors.size
      assert_equal :title, adequate_errors.first.attribute
      assert_equal :not_attractive, adequate_errors.first.type

    end
  end

  describe '#delete' do
    it 'assigns attributes' do
      subject.add(:title, :not_attractive)
      subject.add(:title, :not_provocative)
      subject.add(:content, :too_vague)

      subject.delete(:title)

      assert_equal 1, subject.size
      assert_equal 1, rails_errors.details.count
      assert_equal [], rails_errors.details[:title]

      assert_equal 1, adequate_errors.size
      assert_equal :content, adequate_errors.first.attribute
    end
  end

  describe '#clear' do
    it 'assigns attributes' do
      subject.add(:title, :not_attractive)
      subject.add(:content, :too_vague)

      subject.clear

      assert_equal 0, subject.size
      assert_equal 0, rails_errors.details.count
      assert_equal [], rails_errors.details[:title]

      assert_equal 0, adequate_errors.size
    end
  end
end