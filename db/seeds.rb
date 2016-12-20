personal = List.create!(title: 'Personal')
work = List.create!(title: 'Work')
school = List.create!(title: 'School')

['Spicy jalapeno frankfurter pig drumstick, beef ribs leberkas tri-tip rump alcatra tenderloin kielbasa ribeye cupim swine spare ribs.', 'Sirloin flank andouille pork belly swine.', 'Ground round picanha meatball hamburger.'].each do |t|
  personal.tasks.create!(title: t)
end

['Pork chop flank swine, ribeye beef ribs capicola jowl.', 'Andouille filet mignon chicken, beef cow short ribs pork belly.', 'Turkey ham bacon venison chicken picanha alcatra doner cupim boudin shankle cow pork loin fatback turducken.'].each do |t|
  work.tasks.create!(title: t)
end

['Drumstick chicken picanha t-bone ribeye short loin tail.', 'Drumstick chicken salami corned beef tri-tip bresaola shoulder capicola hamburger ribeye kielbasa.', 'Tri-tip tongue flank beef ribs swine, corned beef pig meatloaf venison leberkas.'].each do |t|
  school.tasks.create!(title: t)
end
