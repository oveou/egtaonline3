class PbsClockTime
  def self.walltime(seconds)
    "%02d:%02d:%02d" % [ seconds / 3600, ( seconds / 60 ) % 60, seconds % 60 ]
  end
end