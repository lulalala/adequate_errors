require "minitest/autorun"
require "active_model"
require "models/topic"
require 'adequate_errors/interceptor'
require 'adequate_errors/errors'

describe AdequateErrors::Interceptor do
  let(:model) { Topic.new }
  let(:adequate_errors) { model.errors.adequate }

  describe '#initialize' do
    it 'initialize adequate_errors object' do
      assert_equal ActiveModel::Errors, model.errors.class
    end
  end

  describe '#adequate' do
    it 'returns adequate_errors object' do
      assert_equal AdequateErrors::Errors, model.errors.adequate.class
    end
  end

  describe '#add' do
    it 'assigns attributes' do
      assert_equal 0,model.errors.count
      assert_equal 0, model.errors.details.count

      model.errors.add(:title, :not_attractive)

      assert_equal 1, model.errors.size
      assert_equal 1, model.errors.details.count
      assert_equal [{:error=>:not_attractive}], model.errors.details[:title]

      assert_equal 1, adequate_errors.size
      assert_equal :title, adequate_errors.first.attribute
      assert_equal :not_attractive, adequate_errors.first.type
      assert_equal model, adequate_errors.first.base
    end
  end

  describe '#delete' do
    it 'assigns attributes' do
      model.errors.add(:title, :not_attractive)
      model.errors.add(:title, :not_provocative)
      model.errors.add(:content, :too_vague)

      model.errors.delete(:title)

      assert_equal 1, model.errors.size
      assert_equal 1, model.errors.details.count
      assert_equal [], model.errors.details[:title]

      assert_equal 1, adequate_errors.size
      assert_equal :content, adequate_errors.first.attribute
    end
  end

  describe '#clear' do
    it 'assigns attributes' do
      model.errors.add(:title, :not_attractive)
      model.errors.add(:content, :too_vague)

      model.errors.clear

      assert_equal 0, model.errors.size
      assert_equal 0, model.errors.details.count
      assert_equal [], model.errors.details[:title]

      assert_equal 0, adequate_errors.size
    end
  end
end