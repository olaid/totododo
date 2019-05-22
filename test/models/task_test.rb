require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  def setup
    @task= Task.new(name:"Example",is_done: true)
  end
  test "should be valid" do
    assert @task.valid?
  end
  test "name should be present" do
    @task.name = " "
    assert_not @task.valid?
  end

  test "task count" do
    assert_difference 'Task.all.count', 1 do
      task=Task.new(name:"aaa")
      task.save
    end
    assert_difference 'Task.all.count', -1 do
      Task.last.destroy
    end
  end
end
