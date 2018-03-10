require_relative "../../lib/flower"
require_relative "../../lib/storage"

RSpec.describe Storage do
  let(:storage) { described_class.new }

  let(:flower_al) { Flower.new("aL") }
  let(:flower_as) { Flower.new("aS") }
  let(:flower_bl) { Flower.new("bL") }
  let(:flower_bs) { Flower.new("bS") }

  describe "#initialize" do
    subject { storage }

    its(:to_s) { is_expected.to eql("") }
  end

  describe "#put_flower" do
    subject { storage }

    context "with one flower" do
      before do
        subject.put_flower(flower_al)
      end
      its(:to_s) { is_expected.to eql("aL") }
    end

    context "with two same flowers" do
      before do
        subject.put_flower(flower_al)
        subject.put_flower(flower_al)
      end
      its(:to_s) { is_expected.to eql("aLaL") }
    end

    context "with two different flowers" do
      before do
        subject.put_flower(flower_al)
        subject.put_flower(flower_as)
      end
      its(:to_s) { is_expected.to eql("aLaS") }
    end
  end

  describe "#take_flower" do
    subject { storage.take_flower(flower) }

    context "when empty" do
      let(:flower) { flower_al }
      it "raises an exception" do
        expect { subject }.to raise_error(Storage::OperationError)
      end
    end

    context "when does not have flower" do
      before do
        storage.put_flower(flower_al)
      end
      let(:flower) { flower_as }
      it "raises an exception" do
        expect { subject }.to raise_error(Storage::OperationError)
      end
    end

    context "when has one flower" do
      before do
        storage.put_flower(flower_al)
      end
      let(:flower) { flower_al }
      it "takes flower from the storage" do
        is_expected.to eql(flower)
        expect(storage.to_s).to eql("")
      end
    end

    context "when has two same flowers" do
      before do
        storage.put_flower(flower_al)
        storage.put_flower(flower_al)
      end
      let(:flower) { flower_al }
      it "takes flower from the storage" do
        is_expected.to eql(flower)
        expect(storage.to_s).to eql("aL")
      end
    end

    context "when has two different flowers" do
      before do
        storage.put_flower(flower_al)
        storage.put_flower(flower_as)
      end
      let(:flower) { flower_al }
      it "takes flower from the storage" do
        is_expected.to eql(flower)
        expect(storage.to_s).to eql("aS")
      end
    end

    context "when has multiple flowers" do
      before do
        storage.put_flower(flower_al)
        storage.put_flower(flower_as)
        storage.put_flower(flower_al)
      end
      let(:flower) { flower_al }
      it "takes flower from the storage" do
        is_expected.to eql(flower)
        expect(storage.to_s).to eql("aSaL")
      end
    end
  end

  describe "#take_flower_of_size" do
    subject { storage.take_flower_of_size("S") }

    context "when empty" do
      it "raises an exception" do
        expect { subject }.to raise_error(Storage::OperationError)
      end
    end

    context "when does not have flower" do
      before do
        storage.put_flower(flower_al)
      end
      it "raises an exception" do
        expect { subject }.to raise_error(Storage::OperationError)
      end
    end

    context "when has one flower" do
      before do
        storage.put_flower(flower_as)
      end
      it "takes flower from the storage" do
        is_expected.to eql(flower_as)
        expect(storage.to_s).to eql("")
      end
    end

    context "when has two same flowers" do
      before do
        storage.put_flower(flower_as)
        storage.put_flower(flower_as)
      end
      it "takes flower from the storage" do
        is_expected.to eql(flower_as)
        expect(storage.to_s).to eql("aS")
      end
    end

    context "when has two different flowers" do
      before do
        storage.put_flower(flower_as)
        storage.put_flower(flower_bs)
      end
      it "takes flower from the storage" do
        is_expected.to eql(flower_as)
        expect(storage.to_s).to eql("bS")
      end
    end

    context "when has multiple flowers" do
      before do
        storage.put_flower(flower_al)
        storage.put_flower(flower_as)
        storage.put_flower(flower_bs)
        storage.put_flower(flower_as)
      end
      let(:flower) { flower_al }
      it "takes flower from the storage" do
        is_expected.to eql(flower_as)
        expect(storage.to_s).to eql("aLbSaS")
      end
    end
  end
end
