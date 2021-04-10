require "spec_helper"

describe HDKEY do
    describe "Vector 1" do
      it "should have valid keys for vector 1 seed hex (chain m)" do
        keys = KeyRing.get_master_key_from_seed(vector_1.seed)
        expect(keys.private_key).to eql("2b4be7f19ee27bbf30c667b642d5f4aa69fd169872f8fc3059c08ebae2eb19e7")
        expect(keys.chain_code).to eql("90046a93de5380a72b5e45010748567d5ea02bbf6522f979e05c0d8d8ca9fffb")
      end
      it "should be valid for vector path" do
        v = vector_1.vectors.first
        # vector_1.vectors.each do |v|
          keys = KeyRing.derive_path(v.path, vector_1.seed, HARDENED_BITCOIN)
          pp keys.private_key
          expect(keys.private_key).to eql(v.key)
          expect(keys.chain_code).to eql(v.chain_code)
        #   expect(KeyRing.get_public_key(v.key)).to eql(v.public_key)
        end
    #   end
    end
end 