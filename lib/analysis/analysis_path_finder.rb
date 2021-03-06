class AnalysisPathFinder
  def initialize(game_id,time,local_path,remote_path)
    @game_id = game_id
    @remote_data_path = File.join(remote_path,'egtaonline','analysis',@game_id)
    @local_data_path = File.join(local_path,'analysis',@game_id)
    @scripts_path = File.join(remote_path,'GameAnalysis')
    @time = time
  end

  def scripts_path
    @scripts_path
  end
  
  def local_input_path
    File.join(@local_data_path, 'in')
  end

  def local_output_path
    File.join(@local_data_path, 'out')
  end

  def local_pbs_path
  	File.join(@local_data_path, 'pbs')
  end

  def local_subgame_path
    File.join(@local_data_path, 'subgame')
  end

  def remote_subgame_path
    File.join(@remote_data_path, 'subgame')
  end

  def remote_pbs_path
  	File.join(@remote_data_path, 'pbs')
  end

  def remote_input_path
    File.join(@remote_data_path, 'in')
  end

  def remote_output_path
    File.join(@remote_data_path, 'out')
  end

  def analysis_script_path
    @scripts_path
  end

  def reduction_script_path
    @scripts_path
  end

  def subgame_script_path
    @scripts_path
  end

  def dominance_script_path
    @scripts_path
  end

  def pbs_error_file
    "#{@game_id}-analysis-#{@time}-pbs.e"
  end

  def pbs_output_file
    "#{@game_id}-analysis-#{@time}-pbs.o"
  end

  def working_dir 
    "/tmp/${PBS_JOBID}"
  end

  def input_file_name
    "#{@game_id}-analysis-#{@time}.json"
  end

  def output_file_name
    "#{@game_id}-analysis-#{@time}.txt"
  end

  def reduction_file_name
    "#{@game_id}-reduced-#{@time}.json"
  end

  def subgame_json_file_name
    "#{@game_id}-subgame.json"
  end

  def pbs_file_name
    "#{@game_id}-wrapper-#{@time}"
  end

  def dominance_json_file_name
    "#{@game_id}-dominance-#{@time}.json"
  end
end