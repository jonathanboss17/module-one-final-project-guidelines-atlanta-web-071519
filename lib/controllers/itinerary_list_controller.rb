def create_itinerary(user)
    itinerary_new= ItineraryList.create(itinerary: fill_itinerary)
    user.itinerary_lists << itinerary_new 

    puts "Your itinerary was saved! Here is the itinerary you created:"
    puts user.itinerary_lists.last.itinerary

    main_menu(user)


end

def fill_itinerary
    puts "Fill your itinerary: "
    gets.chomp
end 

def view_current_itineraries(user)
    puts "Here are your current itineraries: "
    user.itinerary_lists.each {|x| puts x.itinerary}
    main_menu(user)
end

def change_itinerary 

end

def update(user)
    puts user.itinerary_lists.each
    puts "Which itinerary would you like to update?"
end
 