class Person
  def initialize(age, name = 'Unknown', parent_permission = true)
    @name = name
    @age = age
    @parent_permission = parent_permission
  end

  attr_accessor :name
  attr_reader :age, :parent_permission

  def name=(_name)
    @age = age
  end

  def can_use_services?
    if is_of_age? || parent_permission
      true
    else
      false
    end
  end

  private

  def is_of_age?
    age >= 18
  end
end
