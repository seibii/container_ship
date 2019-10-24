# frozen_string_literal: true

RSpec.describe ContainerShip do
  it 'has a version number' do
    expect(ContainerShip::VERSION).not_to be nil
  end
end
