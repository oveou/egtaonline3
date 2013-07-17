class SimulationQueuer
  include Sidekiq::Worker
  sidekiq_options queue: 'backend'

  def perform
    to_be_queued = Simulation.queueable.to_a
    to_be_queued.each{ |simulation| Backend.prepare_simulation(simulation) }
    to_be_queued.each{ |simulation| Backend.schedule_simulation(simulation) }
  end
end