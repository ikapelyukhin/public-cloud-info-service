# Copyright © 2014 SUSE LLC, James Mason <jmason@suse.com>.
# All Rights Reserved.
#
# THIS WORK IS SUBJECT TO U.S. AND INTERNATIONAL COPYRIGHT LAWS AND TREATIES.
# IT MAY NOT BE USED, COPIED, DISTRIBUTED, DISCLOSED, ADAPTED, PERFORMED,
# DISPLAYED, COLLECTED, COMPILED, OR LINKED WITHOUT SUSE'S PRIOR WRITTEN
# CONSENT. USE OR EXPLOITATION OF THIS WORK WITHOUT AUTHORIZATION COULD SUBJECT
# THE PERPETRATOR TO CRIMINAL AND CIVIL LIABILITY.

require_relative '../spec_helper'

describe 'Root Path' do
  describe 'GET /' do
    before { get '/' }

    it 'is successful' do
      expect(last_response.status).to eq 200
    end
  end
end

describe 'supported version' do
  describe 'v1' do
    it 'responds successfully' do
      get "v1/#{$valid_providers.first}/#{$valid_categories.first}"
      expect(last_response.status).to eq 200
    end
  end

  describe 'any other version' do
    before { get "/v2/#{$valid_providers.first}/#{$valid_categories.first}" }
    it 'is 400 Bad Request' do
      expect(last_response.status).to eq 400
    end
    it 'returns no body' do
      expect(last_response.body).to eq ''
    end
  end
end

describe 'route validation' do
  describe 'provider' do
    describe 'valid providers' do
      it 'responds successfully' do
        $valid_providers.each do |provider|
          get "v1/#{provider}/#{$valid_categories.first}"
          expect(last_response.status).to eq 200
        end
      end
    end

    describe 'invalid providers' do
      it 'is 404 Not Found' do
        get "v1/foo/#{$valid_categories.first}"
        expect(last_response.status).to eq 404
      end
    end
  end

  describe 'category' do
    describe 'valid categories' do
      it 'responds successfully' do
        $valid_categories.each do |category|
          get "v1/#{$valid_providers.first}/#{category}"
        end
      end
    end

    describe 'invalid category' do
      it 'is 404 Not Found' do
        get "v1/#{$valid_providers.first}/foo"
        expect(last_response.status).to eq 404
      end
    end
  end

  describe 'extention' do
    describe 'valid extentions' do
      it 'responds successfully' do
        $valid_extensions.each do |ext|
          get "v1/#{$valid_providers.first}/#{$valid_categories.first}.#{ext}"
          expect(last_response.status).to eq 200
        end
      end
    end

    describe 'no extention' do
      it 'responds successfully' do
        get "v1/#{$valid_providers.first}/#{$valid_categories.first}"
        expect(last_response.status).to eq 200
      end
    end

    describe 'invalid extentions' do
      it 'is 400 Bad Request' do
        get "v1/#{$valid_providers.first}/#{$valid_categories.first}.foo"
        expect(last_response.status).to eq 400
      end
    end
  end
end
