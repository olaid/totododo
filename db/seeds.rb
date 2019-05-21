8.times do |n|
  if n > 3 then
    Task.create!(name: 'Sample Task'+n.to_s, is_done: true)
  else
   Task.create!(name: 'Sample Task'+n.to_s)
  end
end