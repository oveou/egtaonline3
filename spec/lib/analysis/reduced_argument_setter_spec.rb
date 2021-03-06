require 'analysis'
describe ReducedArgumentSetter do	
	let(:reduction_mode) {  "foo" }
	let(:reduced_num_array) { [1, 2, 3]}
	before(:each) do
		@setter = ReducedArgumentSetter.new(reduction_mode, reduced_num_array)
	end
	describe "#get_command" do
		let(:input) { "bar.in" }
		let(:output) { "bar.out" }
		it "has right format of arguments" do
			reduced_num_array.should_receive(:join).with(" ").and_return("1 2 3")
			@setter.set_input_file(input)
			@setter.set_output_file(output)
			@setter.get_command.should == "python Reductions.py -input bar.in -output bar.out foo 1 2 3"
		end
	end
	describe "#set_up_remote_script" do
		let(:script_path) { "bar_s_p"}
		let(:work_dir) { "bar_work"}
		it "copies the  script to the right remote directory" do
			@setter.set_up_remote_script(script_path,work_dir).should == "cp -r bar_s_p/Reductions.py bar_work"
		end
	end
end