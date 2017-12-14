require "cases/helper"
require "minitest/autorun"
require 'rspec/mocks/minitest_integration'
require 'adequate_errors'
require "models/topic"
require "models/reply"

describe AdequateErrors::NestedError do
  let(:topic) { Topic.new }
  let(:inner_error) { AdequateErrors::Error.new(topic, :mineral, :not_enough, count: 2) }

  let(:reply) { Reply.new }
  subject { AdequateErrors::NestedError.new(reply, inner_error) }

  describe '#initialize' do
    it 'assigns attributes' do
      assert_equal reply, subject.base
      assert_equal inner_error.attribute, subject.attribute
      assert_equal inner_error.type, subject.type
      assert_equal(inner_error.options, subject.options)
    end

    describe 'overriding attribute and type' do
      subject { AdequateErrors::NestedError.new(reply, inner_error, attribute: :parent, type: :foo) }

      it 'assigns attributes' do
        assert_equal reply, subject.base
        assert_equal :parent, subject.attribute
        assert_equal :foo, subject.type
        assert_equal(inner_error.options, subject.options)
      end
    end
  end

  describe '#message' do
    it "return inner error's message" do
      expect(inner_error).to receive(:message)
      subject.message
    end
  end
end