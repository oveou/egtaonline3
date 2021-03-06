require 'spec_helper'

describe DailyCleanup do
  let(:stale_simulations) { [] }
  let(:finished) { [double('first_simulation'), double('second_simulation')] }
  describe 'perform' do
    before do
      Simulation.should_receive(:stale).twice.and_return(stale_simulations)
      Simulation.should_receive(:recently_finished).and_return(finished)
    end

    it 'deletes old simulations and requeues recently finished' do
      stale_simulations.should_receive(:delete_all)
      finished.each do |sim|
        sim.should_receive(:requeue)
      end
      DailyCleanup.new.perform
    end
  end
end
