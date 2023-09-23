require 'spec_helper'

RSpec.describe GemBench::Team do
  let(:instance) { GemBench::Team.new }
  describe 'initialize' do
    it 'does not raise error' do
      expect { instance }.to_not raise_error
    end
  end
end
