require File.dirname(__FILE__) + "/spec_helper"

describe Parser do
  N = Nodes
  
  before do
    @parser = Parser.new
  end
  
  def self.it_should_parse(code, options)
    it "should parse #{code}" do
      @parser.parse(code).nodes.should == options[:as]
    end
  end
  
  # Literals
  it_should_parse %{1}, :as => [N::Number.new(1)]
  it_should_parse %{"ohaie"}, :as => [N::String.new("ohaie")]
  
  # Assign
  it_should_parse %{x = 1}, :as => [N::Assign.new("x", N::Number.new(1))]
  
  # Consts
  it_should_parse %{Const = 1}, :as => [N::ConstSet.new("Const", N::Number.new(1))]
  it_should_parse %{Const}, :as => [N::ConstGet.new("Const")]
  
  # Call
  it_should_parse %{x}, :as => [N::Call.new(nil, "x", [])]
  it_should_parse %{x()}, :as => [N::Call.new(nil, "x", [])]
  it_should_parse %{x 1}, :as => [N::Call.new(nil, "x", [N::Number.new(1)])]
  it_should_parse %{x(1)}, :as => [N::Call.new(nil, "x", [N::Number.new(1)])]
  it_should_parse %{x(1, "1")}, :as => [N::Call.new(nil, "x", [N::Number.new(1), N::String.new("1")])]
  it_should_parse %{x 1, "1"}, :as => [N::Call.new(nil, "x", [N::Number.new(1), N::String.new("1")])]
  it_should_parse %{x:\n  1\n}, :as => [N::Call.new(nil, "x", [N::Block.new(
                                                                [N::Number.new(1)])
                                                              ])]
  it_should_parse %{x(1):\n  1\n  2\n}, :as => [N::Call.new(nil, "x", [N::Number.new(1),
                                                                       N::Block.new(
                                                                         [N::Number.new(1), N::Number.new(2)])
                                                                      ])]
  it_should_parse %{x:\n  1\n2\n}, :as => [N::Call.new(nil, "x", [N::Block.new([N::Number.new(1)])]),
                                           N::Number.new(2)]
  
  # Object calls
  it_should_parse %{1.x}, :as => [N::Call.new(N::Number.new(1), "x", [])]
  it_should_parse %{x.y}, :as => [N::Call.new(N::Call.new(nil, "x", []), "y", [])]
  it_should_parse %{1.x.y}, :as => [N::Call.new(N::Call.new(N::Number.new(1), "x", []),
                                                "y", [])]
  
  # Special object calls
  it_should_parse %{a.x = 1}, :as => [N::Call.new(N::Call.new(nil, "a", []), "x=", [N::Number.new(1)])]
  it_should_parse %{x == 1}, :as => [N::Call.new(N::Call.new(nil, "x", []), "==", [N::Number.new(1)])]
  it_should_parse %{x + 1}, :as => [N::Call.new(N::Call.new(nil, "x", []), "+", [N::Number.new(1)])]
end