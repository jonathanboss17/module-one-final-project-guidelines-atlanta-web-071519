def login
    puts "Please enter your username:"
    x = gets.chomp
    if (User.find_by(username:x))
        User.find_by(username: x)
    else 
        puts "Username does not exist.  Would you like to create an account? \n\n yes/no"

        if (gets.chomp == "yes")
            create_account
        else 
            bye_bye
        end

    end
    
end

def create_account
    puts "Please enter a username for the account:"
    new_username = gets.chomp
    new_user = User.create(username: new_username)
    if new_user
        puts "Your account was successfully created!"
        # sleep 1  
        # main_menu
    end 
    new_user
end

def bye_bye 
    puts "Ok. Thanks for using Daydream!"
    sleep 2
    exit 
end

def main_menu(user)
    puts "Would you like to go to the main menu? \n\n yes/no"

    if(gets.chomp == "yes")
        puts "Please choose from the following menu: \n
        1. Create a new itinerary.
        2. View your current itineraries.
        3. Change an itinerary.
        4. Delete an itinerary."
        x = gets.chomp.to_i
        next_step(user, x)
    else 
        bye_bye
    end

end

def next_step(user, num)
    if ![1,2,3,4].include?(num)
        puts "That number is invalid.  Please enter a valid number."
        x = gets.chomp.to_i
        next_step(user, x)
    end 

    if(num == 1)
        create_itinerary(user)
    end
    if(num == 2)
        view_current_itineraries(user)
    end 
    if(num == 3)
        change_itinerary_prompt(user)
    end
    if(num == 4)
        delete_itinerary_prompt(user)
    end

end



def render
    user = login
    main_menu(user)
    # next_step(user, num.to_i)

end


