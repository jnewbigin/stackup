require "spec_helper"

require "stackup/yaml"

describe Stackup::YAML do

  describe ".load" do

    let(:data) do
      described_class.load(input)
    end

    describe "plain YAML" do

      let(:input) do
        <<-YAML
        Outputs:
          Foo: "bar"
        YAML
      end

      it "loads as normal" do
        expect(data).to eql(
          "Outputs" => {
            "Foo" => "bar"
          }
        )
      end

    end

    describe "!Ref" do

      let(:input) do
        <<-YAML
        Outputs:
          Foo: !Ref "Bar"
        YAML
      end

      it "expands to Ref" do
        expect(data).to eql(
          "Outputs" => {
            "Foo" => {
              "Ref" => "Bar"
            }
          }
        )
      end

    end

    describe "!GetAtt" do

      let(:input) do
        <<-YAML
        Outputs:
          Foo: !GetAtt Bar.Baz
        YAML
      end

      it "expands to Fn::GetAtt" do
        expect(data).to eql(
          "Outputs" => {
            "Foo" => {
              "Fn::GetAtt" => [
                "Bar",
                "Baz"
              ]
            }
          }
        )
      end

    end

  end

end
