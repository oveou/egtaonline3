require 'backend/flux/flux_policy'

describe FluxPolicy do
  class FluxPolicy
    class Simulation
    end
  end

  let(:flux_policy){ FluxPolicy.new(100) }
  let(:simulation){ double('simulation') }

  #not testing all edge cases because it's a mathematical statement
  describe '#set_queue' do
    context 'when there are no active simulations' do
      before do
        FluxPolicy::Simulation.should_receive(:active_on_flux).and_return([])
        FluxPolicy::Simulation.should_receive(:active_on_other).and_return([])
      end

      it 'updates the state of the simulation to flux and returns the simulation' do
        simulation.should_receive(:update_attributes).with(flux: true)
        flux_policy.set_queue(simulation).should == simulation
      end
    end

    context 'when it should not be sent to flux' do
      before do
        criteria = double(count: 105)
        FluxPolicy::Simulation.should_receive(:active_on_flux).and_return(criteria)
        FluxPolicy::Simulation.should_receive(:active_on_other).and_return([])
      end

      it 'updates the state of the simulation to flux and returns the simulation' do
        simulation.should_not_receive(:update_attributes)
        flux_policy.set_queue(simulation).should == simulation
      end
    end
  end
end