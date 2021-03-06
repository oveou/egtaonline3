require_relative 'reduced_argument_setter.rb'
require_relative 'analysis_argument_setter.rb'
require_relative 'subgame_argument_setter.rb'
require_relative 'analysis_path_finder.rb'
require_relative 'dominance_argument_setter.rb'

class ScriptsArgumentSetter
	def initialize( analysis_obj, enable_dominance = nil, reduction_obj = nil,subgame_obj = nil)
		@analysis_obj = analysis_obj
		@reduction_obj = reduction_obj
		@subgame_obj = subgame_obj
		if @subgame_obj != nil || enable_dominance != nil
			@dominance_obj = DominanceArgumentSetter.new
		end
		@enable_dominance = enable_dominance
	end

	def set_path(path_obj)
		@path_obj = path_obj
	end

	def prepare_input(game)
		@analysis_obj.prepare_input(game, @path_obj.local_input_path, @path_obj.input_file_name)
		if @subgame_obj != nil
			@subgame_obj.prepare_input(game, @path_obj.local_subgame_path, @path_obj.subgame_json_file_name)
		end
	end

	def set_up_remote_command
		work_dir = @path_obj.working_dir
		analysis_set_up_command = <<-DOCUMENT
#{@analysis_obj.set_up_remote_script(@path_obj.analysis_script_path,work_dir)}
#{@analysis_obj.set_up_remote_input(File.join(@path_obj.remote_input_path, @path_obj.input_file_name), work_dir)}
		DOCUMENT
		if @reduction_obj !=nil
			reduction_set_up_command = "#{@reduction_obj.set_up_remote_script(@path_obj.reduction_script_path,work_dir)}"
		end
		if @subgame_obj != nil
			subgame_set_up_command = "#{@subgame_obj.set_up_remote(File.join(@path_obj.remote_subgame_path, @path_obj.subgame_json_file_name),@path_obj.subgame_script_path, work_dir)}"			
		end

		if @dominance_obj != nil
			dominance_set_up_command = "#{@dominance_obj.set_up_remote_script(@path_obj.dominance_script_path, work_dir)}"
		end

		<<-DOCUMENT
module load python/2.7.5
mkdir #{work_dir}
#{analysis_set_up_command}
#{reduction_set_up_command}
#{subgame_set_up_command}
#{dominance_set_up_command}
cd #{work_dir}
export PYTHONPATH=$PYTHONPATH:#{@path_obj.scripts_path}
		DOCUMENT
	end
	
	def get_script_command
		set_up_input_output
		analysis_command = @analysis_obj.get_command
		if @dominance_obj != nil
			dominance_command = @dominance_obj.get_command
		end	
		if @reduction_obj != nil
			reduction_command = @reduction_obj.get_command
		end
		if @subgame_obj != nil
			subgame_command = @subgame_obj.get_command
		end
		<<-DOCUMENT
#{reduction_command}
#{dominance_command}
#{subgame_command}
#{analysis_command}
		DOCUMENT
	end

	def clean_up_remote_command
		analysis_clean_up = @analysis_obj.get_output(@path_obj.working_dir, @path_obj.output_file_name, @path_obj.remote_output_path)
		
		if @subgame_obj != nil
			subgame_clean_up = @subgame_obj.get_output(@path_obj.working_dir, @path_obj.subgame_json_file_name, @path_obj.remote_subgame_path)
		end

		<<-DOCUMENT
#{analysis_clean_up}
#{subgame_clean_up}
rm -rf #{@path_obj.working_dir}
		DOCUMENT

	end
	private

	def set_up_input_output
		if @reduction_obj != nil
			@reduction_obj.set_input_file(@path_obj.input_file_name)
			@reduction_obj.set_output_file(@path_obj.reduction_file_name)
			if @dominance_obj != nil
				@dominance_obj.set_input_file(@path_obj.reduction_file_name)
			end
			@analysis_obj.set_input_file(@path_obj.reduction_file_name)

		else
			if @dominance_obj != nil
				@dominance_obj.set_input_file(@path_obj.input_file_name)
			end
			@analysis_obj.set_input_file(@path_obj.input_file_name)
		end

		if @subgame_obj != nil 
			@subgame_obj.set_input_file(@path_obj.dominance_json_file_name)
			@subgame_obj.set_output_file(@path_obj.subgame_json_file_name)
			@analysis_obj.add_argument(" -sg #{@path_obj.subgame_json_file_name} ")
		end

		if @enable_dominance != nil
			@analysis_obj.add_argument(" -nd #{@path_obj.dominance_json_file_name} ")
		end

		if @dominance_obj != nil
			@dominance_obj.set_output_file(@path_obj.dominance_json_file_name)
		end
		@analysis_obj.set_output_file(@path_obj.output_file_name)
	end
end