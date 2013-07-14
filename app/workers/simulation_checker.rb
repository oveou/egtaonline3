class SimulationChecker
  include Sidekiq::Worker
  sidekiq_options queue: 'backend'

  def perform
    Backend.update_simulations(Simulation.active)
  end
end