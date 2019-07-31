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
    i = 1
    puts "Here are your current itineraries: "
    user.itinerary_lists.each do |x| 
        puts i.to_s + ". " + x.itinerary 
        i+=1
    end
    main_menu(user)
end

def change_itinerary(user)
    itinerary_num = gets.chomp.to_i
    i = 1
    user.itinerary_lists.each do |x|
        if(itinerary_num == i)
            x.update(itinerary: new_text)
        end
        i += 1
    end
    puts "Thanks. We've updated your itinerary.\n\n" 
    main_menu(user)
end

def new_text
    puts "What is your new itinerary?"
    gets.chomp
end

def change_itinerary_prompt(user)
    puts "Which itinerary would you like to update?\n\n"
    i = 1
    user.itinerary_lists.each do |x|
  
        if(x.itinerary != nil)
            puts i.to_s + ". " +  x.itinerary
        else
            puts i.id.to_s + ". Empty."
        end
        i += 1
    end
    
    change_itinerary(user)
end

def delete_itinerary(user)
    itinerary_num = gets.chomp.to_i
    i = 1
    user.itinerary_lists.each do |x|
        if(itinerary_num == i)
            ItineraryList.delete(x.id)
            x.save
        end
        i += 1
    end
    puts "Thanks. We've deleted that itinerary.\n\n" 
    main_menu(user)
end

def delete_itinerary_prompt(user)
    puts "Which itinerary would you like to delete?\n\n"
    i = 1
    user.itinerary_lists.each do |x|
  
        if(x.itinerary != nil)
            puts i.to_s + ". " +  x.itinerary
        else
            puts i.id.to_s + ". Empty."
        end
        i += 1
    end
    
    delete_itinerary(user)
end

#delete_itinerary doesn't delete completely while the user is still logged in. If you choose "view itineraries" after deleting one,
#it still shows up in the list 
 