require "ed25519"
require "openssl"

module HDKEY
  ED25519_CURVE = "ed25519 seed"

  HARDENED_TESTNET = 0x80000001
  HARDENED_BITCOIN = 0x80000000
  HARDENED_AXENTRO = 0x80000276
  PATH_REGEX = /^(m\/)?(\d+'?\/)*\d+'?$/

  class Keys
    attr_reader :private_key
    attr_reader :chain_code

    def initialize(private_key, chain_code)
      @private_key = private_key
      @chain_code = chain_code
    end
  end

  class KeyRing
    def self.get_keys(seed, key)
      key = [key].pack("H*") unless key == ED25519_CURVE
      digest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha512"), key, [seed].pack("H*"))
      private_key = digest[0..63]
      chain_code = digest[64..-1]

      Keys.new(private_key, chain_code)
    end

    def self.get_master_key_from_seed(seed)
      get_keys(seed, ED25519_CURVE)
    end

    def self.ckd_priv(keys, index, hardened_offset = HARDENED_TESTNET)
      seed = [0, keys.private_key, (index + hardened_offset)].pack("CH64N").unpack("H*").first
      get_keys(seed, keys.chain_code)
    end

    def self.get_public_key(private_key, with_zero_byte = true)
      signing_key = Ed25519::SigningKey.new([private_key].pack("H*"))
      public_key = signing_key.keypair.unpack("H*").first[64..-1]
      if with_zero_byte
        public_key = [0, public_key].pack("CH64").unpack("H*").first
      end
      public_key
    end

    def self.derive_path(path, seed, hardened_offset = HARDENED_TESTNET)
      raise "Invalid derivation path. Expected BIP32 format" if PATH_REGEX.match(path).nil?
      master_keys = get_master_key_from_seed(seed)
      path.gsub("'", "").split("/")[1..-1].map { |v| v.to_i }.reduce(master_keys) { |parent_keys, segment|
        ckd_priv(parent_keys, segment, hardened_offset)
      }
    end
  end
end
