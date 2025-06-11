# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyLLM::Attachment do
  describe 'MIME type detection with Ruby 3.3+ compatibility' do
    context 'with URLs' do
      it 'handles image URLs without Marcel/open-uri compatibility issues' do
        # This test ensures the fix works - previously this would raise:
        # ArgumentError: wrong number of arguments (given 2, expected 0..1)
        expect do
          attachment = described_class.new('https://httpbin.org/image/jpeg')
          attachment.mime_type # Force MIME type detection
        end.not_to raise_error
      end

      it 'handles non-existent URLs with proper error handling' do
        expect do
          described_class.new('https://example.com/nonexistent')
        end.to raise_error(Faraday::ResourceNotFound)
      end
    end

    context 'with local files' do
      let(:image_path) { File.expand_path('../fixtures/ruby.png', __dir__) }

      it 'continues to work normally for local files' do
        attachment = described_class.new(image_path)
        expect(attachment.mime_type).to eq('image/png')
      end
    end
  end
end
