# frozen_string_literal: true

require 'restaurant'

describe Restaurant do
  let(:test_file) { 'spec/fixtures/restaurants_test.txt' }
  let(:crescent) { Restaurant.new(name: 'Crescent', cuisine: 'paleo', price: '321') }

  describe 'attributes' do
    it 'allows reading and writing for :name' do
      expect(crescent.name = 'Domino').to eq('Domino')
    end

    it 'allow reading and writing for :cuisine' do
      expect(crescent.cuisine = 'Italian').to eq('Italian')
    end

    it 'allow reading and writing for :price' do
      expect(crescent.price = '20').to eq('20')
    end
  end

  describe '.load_file' do
    it 'does not set @@file if filepath is nil' do
      no_output { Restaurant.load_file(nil) }
      expect(Restaurant.file).to be_nil
    end

    it 'sets @@file if filepath is usable' do
      no_output { Restaurant.load_file(test_file) }
      expect(Restaurant.file).not_to be_nil
      expect(Restaurant.file.class).to be(RestaurantFile)
      expect(Restaurant.file).to be_usable
    end

    it 'outputs a message if filepath is not usable' do
      expect do
        Restaurant.load_file(nil)
      end.to output(/not usable/).to_stdout
    end

    it 'does not output a message if filepath is usable' do
      expect do
        Restaurant.load_file(test_file)
      end.not_to output.to_stdout
    end
  end

  describe '.all' do
    it 'returns array of restaurant objects from @@file' do
      Restaurant.load_file(test_file)
      restaurants = Restaurant.all
      expect(restaurants.class).to eq(Array)
      expect(restaurants.length).to eq(Restaurant.all.count)
      expect(restaurants.first.class).to eq(Restaurant)
    end

    it 'returns an empty array when @@file is nil' do
      no_output { Restaurant.load_file(nil) }
      restaurants = Restaurant.all
      expect(restaurants).to eq([])
    end
  end

  describe '#initialize' do
    context 'with no options' do
      # subject would return the same thing
      let(:no_options) { Restaurant.new }

      it 'sets a default of "" for :name' do
        expect(no_options.name).to eq('')
      end

      it 'sets a default of "unknown" for :cuisine' do
        expect(no_options.cuisine).to eq('unknown')
      end

      it 'does not set a default for :price' do
        expect(no_options.price).to be_nil
      end
    end

    context 'with custom options' do
      it 'allows setting the :name' do
        expect(Restaurant.new(name: 'Pescarus').name).to eq('Pescarus')
      end

      it 'allows setting the :cuisine' do
        expect(Restaurant.new(cuisine: 'Pescarus').cuisine).to eq('Pescarus')
      end

      it 'allows setting the :price' do
        expect(Restaurant.new(price: '100').price).to eq('100')
      end
    end
  end

  describe '#save' do
    it 'returns false if @@file is nil' do
      Restaurant.load_file(nil)
      expect(crescent.save).to be(false)
    end

    it 'returns false if not valid' do
      crescent.name = nil
      expect(crescent.save).to be(false)
    end

    it 'calls append on @@file if valid' do
      Restaurant.load_file(test_file)
      expect(Restaurant.file).not_to be_nil

      expect(Restaurant.file).to receive(:append).with(crescent)
      crescent.save
    end
  end

  describe '#valid?' do
    it 'returns false if name is nil' do
      expect(Restaurant.new(name: nil)).not_to be_valid
    end

    it 'returns false if name is blank' do
      expect(Restaurant.new(name: '')).not_to be_valid
    end

    it 'returns false if cuisine is nil' do
      expect(Restaurant.new(cuisine: nil)).not_to be_valid
    end

    it 'returns false if cuisine is blank' do
      expect(Restaurant.new(cuisine: '')).not_to be_valid
    end

    it 'returns false if price is nil' do
      expect(Restaurant.new(price: nil)).not_to be_valid
    end

    it 'returns false if price is 0' do
      expect(Restaurant.new(price: '0')).not_to be_valid
    end

    it 'returns false if price is negative' do
      expect(Restaurant.new(price: '-1')).not_to be_valid
    end

    it 'returns true if name, cuisine, price are present' do
      expect(crescent).to be_valid
    end
  end
end
