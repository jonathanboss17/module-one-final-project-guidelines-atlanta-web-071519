def login
    puts "Please enter your username:"
    x = gets.chomp

    if(User.find_by(username: x) == nil)
        puts "Username does not exist.  Would you like to create an account?
        1. yes
        2. no"

        if (gets.chomp == "yes")
            create_account
        else 
            bye_bye
        end

    end

    main_menu
end

def create_account
    puts "Please enter a username for the account:"
    new_username = gets.chomp
    new_user = User.create(username: new_username)
    if new_user
        puts "Your account was successfully created!"
        sleep 1  
        main_menu
    end 
    new_user
end

def bye_bye 
    puts "Ok. No problem! Thanks for using Daydream!"
    sleep 2
    exit 
end

def main_menu
    puts "Would you like to go to the main menu?
    1. yes
    2. no"

    if(gets.chomp == "yes")
        puts "Please choose from the following menu:
        1. Create a new itinerary.
        2. View your current itineraries.
        3. Change an itinerary."
        # getting the number and doing shit with it
    else 
        bye_bye
    end

end

def next_step
end



def render
    login
end
