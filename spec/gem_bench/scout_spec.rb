require 'spec_helper'

RSpec.describe GemBench::Scout do
  let(:instance) { GemBench::Scout.new }
  describe 'initialize' do
    it 'does not raise error' do
      expect { instance }.to_not raise_error
    end
    context 'check_gemfile' do
      context 'is true' do
        let(:instance) { GemBench::Scout.new(check_gemfile: true) }
        it 'does not raise error' do
          expect { instance }.to_not raise_error
        end
      end
      context 'is false' do
        let(:instance) { GemBench::Scout.new(check_gemfile: false) }
        it 'does not raise error' do
          expect { instance }.to_not raise_error
        end
      end
      context 'is nil' do
        let(:instance) { GemBench::Scout.new(check_gemfile: nil) }
        it 'does not raise error' do
          expect { instance }.to_not raise_error
        end
      end
    end
  end
  describe '#gem_paths' do
    it('is an array') do
      expect(instance.gem_paths).to be_an(Array)
    end
    it('is not empty') do
      expect(instance.gem_paths).to_not be_empty
    end
    it('of paths with gems') do
      expect(instance.gem_paths.count { |x| x =~ /gems/ }).to eq(instance.gem_paths.length)
    end
  end
  describe '#gemfile_path' do
    it('is an string') do
      expect(instance.gemfile_path).to be_a(String)
    end
    it('is not empty') do
      expect(instance.gemfile_path).to_not be_empty
    end
    it('points to a Gemfile') do
      expect(instance.gemfile_path).to match('Gemfile')
    end
  end
  describe '#gemfile_trash' do
    context 'check_gemfile: true' do
      let(:instance) { GemBench::Scout.new(check_gemfile: true) }
      it 'does not raise error' do
        expect { instance.gemfile_trash }.to_not raise_error
      end
      it 'sets gemfile_trash' do
        expect(instance.gemfile_trash).to be_an(Array)
      end
      it 'gemfile_trash is not empty' do
        expect(instance.gemfile_trash).to_not be_empty
        expect(instance.gemfile_trash).to eq(["# Specify your gem's dependencies in gem_bench.gemspec\n"])
      end
    end
    context 'check_gemfile: false' do
      let(:instance) { GemBench::Scout.new(check_gemfile: false) }
      it 'does not raise error' do
        expect { instance.gemfile_trash }.to_not raise_error
      end
      it 'sets gemfile_trash' do
        expect(instance.gemfile_trash).to be_an(Array)
      end
      it 'gemfile_trash is empty' do
        expect(instance.gemfile_trash).to be_empty
      end
    end
    context 'check_gemfile: nil' do
      let(:instance) { GemBench::Scout.new(check_gemfile: nil) }
      it 'does not raise error' do
        expect { instance.gemfile_trash }.to_not raise_error
      end
      it 'sets gemfile_trash' do
        expect(instance.gemfile_trash).to be_an(Array)
      end
      it 'gemfile_trash is not empty' do
        expect(instance.gemfile_trash).to_not be_empty
        expect(instance.gemfile_trash).to eq(["# Specify your gem's dependencies in gem_bench.gemspec\n"])
      end
    end
  end
  describe '#gemfile_lines' do
    context 'check_gemfile: true' do
      let(:instance) { GemBench::Scout.new(check_gemfile: true) }
      it 'does not raise error' do
        expect { instance.gemfile_lines }.to_not raise_error
      end
      it 'sets gemfile_lines' do
        expect(instance.gemfile_lines).to be_an(Array)
      end
      it 'gemfile_lines is not empty' do
        expect(instance.gemfile_lines).to_not be_empty
        expect(instance.gemfile_lines[0..1]).to eq(["source 'https://rubygems.org'\n",
                                                    "gem \"bundler\" # For specs!\n"])
      end
    end
    context 'check_gemfile: false' do
      let(:instance) { GemBench::Scout.new(check_gemfile: false) }
      it 'does not raise error' do
        expect { instance.gemfile_lines }.to_not raise_error
      end
      it 'sets gemfile_lines' do
        expect(instance.gemfile_lines).to be_an(Array)
      end
      it 'gemfile_lines is empty' do
        expect(instance.gemfile_lines).to be_empty
      end
    end
    context 'check_gemfile: nil' do
      let(:instance) { GemBench::Scout.new(check_gemfile: nil) }
      it 'does not raise error' do
        expect { instance.gemfile_lines }.to_not raise_error
      end
      it 'sets gemfile_lines' do
        expect(instance.gemfile_lines).to be_an(Array)
      end
      it 'gemfile_lines is not empty' do
        expect(instance.gemfile_lines).to_not be_empty
        expect(instance.gemfile_lines[0..1]).to eq(["source 'https://rubygems.org'\n",
                                                    "gem \"bundler\" # For specs!\n"])
      end
    end
  end
  describe '#loaded_gems' do
    let(:instance) { GemBench::Scout.new }
    it 'does not raise error' do
      expect { instance.loaded_gems }.to_not raise_error
    end
    it 'sets gemfile_lines' do
      expect(instance.loaded_gems).to be_an(Array)
    end
    it 'is not empty' do
      expect(instance.loaded_gems).to_not be_empty
    end
    it 'includes dependencies' do
      names = instance.loaded_gems.map { |tuple| tuple[0] }
      expect(names).to include('rspec')
      expect(names).to include('rake')
      expect(names).to include('bundler')
    end
  end
end
