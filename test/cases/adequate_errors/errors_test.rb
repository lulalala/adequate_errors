require "minitest/autorun"
require "active_model"
require "models/topic"
require 'adequate_errors/errors'

describe AdequateErrors::Errors do
  let(:model) { Topic.new }
  let(:legacy_errors) { ActiveModel::Errors.new(model) }
  subject { AdequateErrors::Errors.new(model, legacy_errors: legacy_errors) }

  describe '#add' do
    it 'assigns attributes' do
      assert_equal 0, subject.error_objects.size
      assert_equal 0, legacy_errors.details.count

      subject.add(:title, :not_attractive)

      assert_equal 1, subject.error_objects.size
      assert_equal :title, subject.error_objects.first.attribute
      assert_equal :not_attractive, subject.error_objects.first.type

      assert_equal 1, legacy_errors.details.count
      assert_equal [{:error=>:not_attractive}], legacy_errors.details[:title]
    end
  end

  describe '#delete' do
    it 'assigns attributes' do
      subject.add(:title, :not_attractive)
      subject.add(:title, :not_provocative)
      subject.add(:content, :too_vague)

      subject.delete(:title)

      assert_equal 1, subject.error_objects.size
      assert_equal 1, legacy_errors.details.count
      assert_equal [], legacy_errors.details[:title]
    end
  end

  describe '#clear' do
    it 'assigns attributes' do
      subject.add(:title, :not_attractive)
      subject.add(:content, :too_vague)

      subject.clear

      assert_equal 0, subject.error_objects.size
      assert_equal 0, legacy_errors.details.count
      assert_equal [], legacy_errors.details[:title]
    end
  end

  describe '#where' do
    describe 'attribute' do
      it '' do
        subject.add(:title, :not_attractive)
        subject.add(:content, :too_vague)

        assert_equal 0,subject.where(:attribute => :foo).size
        assert_equal 1,subject.where(:attribute => :title).size
        assert_equal 1,subject.where(:attribute => :title, :type => :not_attractive).size
        assert_equal 0,subject.where(:attribute => :title, :type => :too_vague).size
        assert_equal 1,subject.where(:type => :too_vague).size
      end
    end
  end
end