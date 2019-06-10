class RenamePriorityColumnToTasks < ActiveRecord::Migration[5.2]
  def change
    rename_column :tasks, :priority, :next_task
  end
end
