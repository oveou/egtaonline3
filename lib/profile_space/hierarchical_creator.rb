require_relative 'reduction_creator'

class HierarchicalCreator < ReductionCreator
  def self.expand_assignment(assignment, roles)
    [assignment.map do |role_combination|
      role = roles.find { |r| r.name == role_combination[0] }
      [role.name].concat(strategy_dehasherize(expand_role(hasherize(
        role_combination.drop(1)), role.count)))
    end]
  end
end
