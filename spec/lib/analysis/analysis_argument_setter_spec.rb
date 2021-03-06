require 'analysis'
class GamePresenter
end

describe AnalysisArgumentSetter do
	let(:required_argument_list) {  "-foo bar" }
	before(:each) do
		@setter = AnalysisArgumentSetter.new(required_argument_list)
	end

	describe "#prepare_input" do
		let(:game) { double ("game") }
		let(:local_input_path) { "local_input_path" }
		let(:input_file_name) {"input_file_name"}
		let(:game_presenter) {double "presenter"}
		let(:game_json) {double "game_json"}
		let(:file_path) {"local_input_path/input_file_name"}
		it "prepares the right input file" do
			GamePresenter.should_receive(:new).with(game).and_return(game_presenter)
			game_presenter.should_receive(:to_json).and_return(game_json)			
			File.stub(:join).with(local_input_path,input_file_name).and_return(file_path)			
			FileUtils.stub(:mv).with(game_json.to_s,file_path).and_return(true)			
			@setter.prepare_input(game, local_input_path, input_file_name)
		end

		it "moves the input to the right folder" do
			GamePresenter.stub(:new).with(game).and_return(game_presenter)
			game_presenter.stub(:to_json).and_return(game_json)			
			File.should_receive(:join).with(local_input_path,input_file_name).and_return(file_path)			
			FileUtils.should_receive(:mv).with(game_json.to_s,file_path).and_return(true)			
			@setter.prepare_input(game, local_input_path, input_file_name).should be_true
		end
	end

	describe "#set_input_file" do
		it "sets input file name" do
			@setter.set_input_file("input")
			expect(@setter.instance_variable_get(:@input_file_name)).to eq("input")
		end
	end

	describe "#set_output_file" do
		it "sets output file name" do
			@setter.set_output_file("output")
			expect(@setter.instance_variable_get(:@output_file_name)).to eq("output")
		end
	end

	describe "#add_argument" do
		it "adds additional arguements" do
			@setter.add_argument("additional")
			expect(@setter.instance_variable_get(:@required_argument_list)).to eq("-foo bar additional ")
		end
	end

	describe "#set_up_remote_script" do
		script_path = "script_path"
		work_dir = "work_dir"
		it "copies the right script to the remote folder" do
			expect(@setter.set_up_remote_script(script_path, work_dir)).to eq("cp -r script_path/AnalysisScript.py work_dir")
		end
	end


	describe "#set_up_remote_input" do
		input_file_path = "input_file_path"
		work_dir = "work_dir"
		it "copies the right analysis input to the remote folder" do
			expect(@setter.set_up_remote_input(input_file_path, work_dir)).to eq("cp -r input_file_path work_dir")
		end
	end

	describe "#get_output" do
		work_dir = "work_dir"
		filename = "filename"
		local_dir = "local_dir"
		it "gets the right output back" do
			expect(@setter.get_output(work_dir, filename, local_dir)).to eq("cp -r work_dir/filename local_dir")
		end
	end
end