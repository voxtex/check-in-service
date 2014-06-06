require_relative '../spec_helper'

def app
  ApplicationApi
end

describe CheckInsApi do
  include Rack::Test::Methods

  describe 'POST /v1/check_in' do
    before(:each) do
      @timestamp = Time.now
      Timecop.freeze(@timestamp)
      @store = create(:store)
      @user = create(:user)
    end

    def calc_hash(store, user_id, timestamp)
      hash_data = [store.id, user_id, timestamp].join('$')
      Base64.encode64(OpenSSL::HMAC.digest('SHA256', store.private_key, hash_data)).chomp
    end

    def check_in(opts = {})
      store = opts.fetch(:store, @store)
      hash = opts.fetch(:hash, calc_hash(store, @user.id, @timestamp))
      post '/v1/check_in', {timestamp: @timestamp, user_id: @user.id, confirmation_hash: hash, store_id: store.id}
    end

    describe 'validates hashes' do
      it 'succeeds with a valid hash' do
        check_in
        expect(last_response.status).to eq(201)
      end

      it 'fails with an invalid hash' do
        check_in(hash: 'abc')
        expect(last_response.status).to eq(422)
      end
    end

    describe 'throttles requests' do
      it 'allows at most 1 check-in per hour per store' do
        check_in
        expect(last_response.status).to eq(201)

        check_in
        expect(last_response.status).to eq(422)

        @timestamp = @timestamp + 1.hour + 1.second
        Timecop.freeze(@timestamp)
        check_in
        expect(last_response.status).to eq(201)
      end

      it 'allows at most 1 check-in per 5 minutes to any store' do
        @store2 = create(:store)
        check_in
        expect(last_response.status).to eq(201)
        check_in(store: @store2)
        expect(last_response.status).to eq(422)

        @timestamp = @timestamp + 5.minutes + 1.second
        Timecop.freeze(@timestamp)
        check_in(store: @store2)
        expect(last_response.status).to eq(201)
      end
    end

    describe 'validate timestamp' do
      it 'ensures the timestamp is not in the future' do
        @timestamp = Time.now + 5.minutes
        check_in
        expect(last_response.status).to eq(422)
      end

      it 'ensures the timestamp is not too far in the past' do
        @timestamp = Time.now - 5.minutes
        check_in
        expect(last_response.status).to eq(422)
      end
    end
  end
end