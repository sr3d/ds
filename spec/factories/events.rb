Factory.define :event, :class => Event do |f|
  f.name            'Dinner'
  f.venue           'Banana Leaf, Milpitas'
  f.when            1.day.from_now
  f.start_time      14.hours.from_now
  f.event_type_id   1
end
