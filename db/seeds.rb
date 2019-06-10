1.upto(8) do |n|
  if n > 3 then
    if n == 8 then
      Task.create!(name: 'Sample Task'+n.to_s, is_done: true, next_task: -1)
    else
      Task.create!(name: 'Sample Task'+n.to_s, is_done: true, next_task: n+1)
    end
  else
   Task.create!(name: 'Sample Task'+n.to_s, next_task: n+1)
  end
end