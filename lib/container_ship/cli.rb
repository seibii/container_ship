require 'thor'

module ContainerShip
  class CLI < Thor
    desc 'version', 'displays gem version'
    def version
      say ContainerShip::VERSION
    end
  end
end
