require_relative "../../lib/flower"
require_relative "../../lib/storage"

RSpec.describe Storage do
  let(:storage) { described_class.new(capacity: capacity) }
  let(:capacity) { nil }

  let(:flower_al) { Flower.new("aL") }
  let(:flower_as) { Flower.new("aS") }
  let(:flower_bl) { Flower.new("bL") }
  let(:flower_bs) { Flower.new("bS") }

  describe "#initialize" do
    subject { storage }

    its(:to_s) { is_expected.to eql("") }
  end

  describe "#full?" do
    subject { storage.full? }

    where(:capacity, :flowers, :expected_result) do
      [
        [nil, [],           false],
        [nil, ["aL"],       false],
        [nil, ["aL", "aS"], false],
        [0,   [],           true],
        [1,   [],           false],
        [1,   ["aL"],       true],
      ]
    end

    with_them do
      before do
        flowers.each do |spec|
          storage.put(Flower.new(spec))
        end
      end
      it { is_expected.to eql(expected_result) }
    end
  end

  describe "#put" do
    subject { storage }

    context "with one flower" do
      before do
        subject.put(flower_al)
      end
      its(:to_s) { is_expected.to eql("aL") }
    end

    context "with two same flowers" do
      before do
        subject.put(flower_al)
        subject.put(flower_al)
      end
      its(:to_s) { is_expected.to eql("aLaL") }
    end

    context "with two different flowers" do
      before do
        subject.put(flower_al)
        subject.put(flower_as)
      end
      its(:to_s) { is_expected.to eql("aLaS") }
    end

    context "when full" do
      before do
        expect(storage).to receive(:full?).and_return(true)
      end
      it "raises an exception" do
        expect { subject.put(flower_al) }
          .to raise_error(Storage::OperationError)
      end
    end
  end

  describe "#take" do
    subject { storage.take(flower) }

    context "when empty" do
      let(:flower) { flower_al }
      it "raises an exception" do
        expect { subject }.to raise_error(Storage::OperationError)
      end
    end

    context "when does not have flower" do
      before do
        storage.put(flower_al)
      end
      let(:flower) { flower_as }
      it "raises an exception" do
        expect { subject }.to raise_error(Storage::OperationError)
      end
    end

    context "when has one flower" do
      before do
        storage.put(flower_al)
      end
      let(:flower) { flower_al }
      it "takes flower from the storage" do
        is_expected.to eql(flower)
        expect(storage.to_s).to eql("")
      end
    end

    context "when has two same flowers" do
      before do
        storage.put(flower_al)
        storage.put(flower_al)
      end
      let(:flower) { flower_al }
      it "takes flower from the storage" do
        is_expected.to eql(flower)
        expect(storage.to_s).to eql("aL")
      end
    end

    context "when has two different flowers" do
      before do
        storage.put(flower_al)
        storage.put(flower_as)
      end
      let(:flower) { flower_al }
      it "takes flower from the storage" do
        is_expected.to eql(flower)
        expect(storage.to_s).to eql("aS")
      end
    end

    context "when has multiple flowers" do
      before do
        storage.put(flower_al)
        storage.put(flower_as)
        storage.put(flower_al)
      end
      let(:flower) { flower_al }
      it "takes flower from the storage" do
        is_expected.to eql(flower)
        expect(storage.to_s).to eql("aSaL")
      end
    end
  end

  describe "#take_first_of_size" do
    subject { storage.take_first_of_size("S") }

    context "when empty" do
      it "raises an exception" do
        expect { subject }.to raise_error(Storage::OperationError)
      end
    end

    context "when does not have flower" do
      before do
        storage.put(flower_al)
      end
      it "raises an exception" do
        expect { subject }.to raise_error(Storage::OperationError)
      end
    end

    context "when has one flower" do
      before do
        storage.put(flower_as)
      end
      it "takes flower from the storage" do
        is_expected.to eql(flower_as)
        expect(storage.to_s).to eql("")
      end
    end

    context "when has two same flowers" do
      before do
        storage.put(flower_as)
        storage.put(flower_as)
      end
      it "takes flower from the storage" do
        is_expected.to eql(flower_as)
        expect(storage.to_s).to eql("aS")
      end
    end

    context "when has two different flowers" do
      before do
        storage.put(flower_as)
        storage.put(flower_bs)
      end
      it "takes flower from the storage" do
        is_expected.to eql(flower_as)
        expect(storage.to_s).to eql("bS")
      end
    end

    context "when has multiple flowers" do
      before do
        storage.put(flower_al)
        storage.put(flower_as)
        storage.put(flower_bs)
        storage.put(flower_as)
      end
      let(:flower) { flower_al }
      it "takes flower from the storage" do
        is_expected.to eql(flower_as)
        expect(storage.to_s).to eql("aLbSaS")
      end
    end
  end

  describe "#most_abundant_of_size" do
    subject { storage.most_abundant_of_size("S") }

    context "when empty" do
      it "returns nil" do
        is_expected.to be_nil
      end
    end

    context "when does not have flower" do
      before do
        storage.put(flower_al)
      end
      it "returns nil" do
        is_expected.to be_nil
      end
    end

    context "when has one flower" do
      before do
        storage.put(flower_as)
      end
      it "returns flower" do
        is_expected.to eql(flower_as)
      end
    end

    context "when has two same flowers" do
      before do
        storage.put(flower_as)
        storage.put(flower_as)
      end
      it "returns flower" do
        is_expected.to eql(flower_as)
      end
    end

    context "when has two different flowers" do
      before do
        storage.put(flower_as)
        storage.put(flower_bs)
      end
      it "returns flower" do
        is_expected.to eql(flower_as)
      end
    end

    context "when has multiple flowers" do
      before do
        storage.put(flower_al)
        storage.put(flower_as)
        storage.put(flower_bs)
        storage.put(flower_as)
      end
      it "returns flower" do
        is_expected.to eql(flower_as)
      end
    end
  end
end
