require 'spec_helper'
require 'capybara/wheel'

RSpec.configure do |config|
  config.before(:each, :some_hook) do
    @hook_passed_on = true
  end
end

feature 'runs as a wheel feature', :some_hook do

  it 'should pass' do
  end

  it 'should be set as a wheel feature' do
    example.metadata[:type].should == :wheel_feature
  end

  it 'should pass the right hook' do
    @hook_passed_on.should be_true
  end
end

feature 'Page' do
  let(:page) { Capybara::Wheel::Page }

  it 'has access to capybara' do
    page.new.methods.include?(:capybara).should be_true
  end

  context 'can create an element instance' do
    it 'and create a method for it' do
      page.element('rad_element', '#rad-selector').new.should respond_to(:rad_element)
    end
  end

end

feature 'Element' do
  let(:element) { Capybara::Wheel::Element }

  it 'has access to capybara' do
    element.new('#some-selector').methods.include?(:capybara).should be_true
  end

end

feature 'SubElement' do

  let(:parent_selector) { '#parent-selector'}
  let(:sub_selector)    { '#sub-selector'}
  let!(:parent_element) { Capybara::Wheel::Element.new(parent_selector) }
  let!(:subelement)     { class ASubElement < Capybara::Wheel::SubElement
                              def my_element
                                capybara_element
                              end
                          end }

  before :each do
    parent_element.instance_eval do
      def a_sub_element
        ASubElement.new('#sub-selector', self)
      end
    end
  end

  it 'calls parent element capybara_element' do
  end

  # some method sent to element instant sends new for sub element
end

feature 'ElementFactory' do
  let(:subject)   { Capybara::Wheel::ElementFactory }
  let(:selector)  { '#rad-selector'}

  it 'creates an element' do
    Capybara::Wheel::Element.should_receive(:new).with(selector)

    subject.create_element(selector)
  end

  it 'generated instance evalutes block' do
    test_block = Proc.new do
      def evaled_method
      end
    end

    subject.create_element(selector, test_block).should respond_to(:evaled_method)
  end
end