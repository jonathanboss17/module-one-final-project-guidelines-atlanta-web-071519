def create_itinerary(user, text_input)
    itinerary_new= ItineraryList.create(text: text_input)
    user.itinerary_lists << itinerary_new 
    user.itinerary_lists.last
end

def view_current_intineraries

end

def change_itinerary 

end
 