require_relative '../config/environment'
require_all 'lib'
require "tty-prompt"
require "tty-font"
require "pastel"
@prompt = TTY::Prompt.new
@font = TTY::Font.new(:standard)
@pastel = Pastel.new 



#-------WELCOME--------#
def welcome 
    puts @pastel.yellow(@font.write("Welcome to Daydream!"))
    login 
    main_menu
end 
#---------LOGIN--------#

def get_username
    puts "Please enter a username: \n\n"
    @name = gets.chomp
    until @name != ''
        puts @pastel.red("Username is required to use the app. Please enter a username:")
        @name = gets.chomp 
    end
end

def login 
    get_username
    if (User.find_by(username: @name))
        @user = User.find_by(username: @name)
        puts @pastel.yellow("\n\nWelcome back, #{@name}!!\n\n")
    else 
        create_account_prompt
    end
    #@name 
end

def create_account_prompt
    this_prompt = @prompt.yes?("You don't have an account yet.  Would you like to create one now? (required to use the app)")
    if this_prompt
        create_account
    else
        bye_bye
    end 
end

#----------CREATE ACCOUNT--------#

def create_account
    get_username
    add_bio
    # new_user 
    if new_user
        @prompt.ok("Your account was successfully created! \n\nYour new Daydream username is #{@name}.\n\n")
        sleep 1
        main_menu_prompt
    else
        @prompt.error("Uh oh. Something went wrong. You will be returned to the main menu after 3 seconds.")
        sleep 5
        main_menu
    end 
end

def new_user
    @user = User.create(username: @name, bio:@bio)
end 

def add_bio
    this_prompt = @prompt.yes?("Would you like to add a short bio?")
    if this_prompt
        puts "Great! Tell us about yourself. Press enter when done."
        @bio = gets.chomp
    else
        puts "Mysterious. We like it."
    end 
end

#----------MAIN MENU----------#

def main_menu_prompt
    this_prompt = @prompt.yes?('Would you like to go to the main menu?')
    if this_prompt
        main_menu
    else
        bye_bye
    end 
end

def main_menu
    choice = @prompt.select("Please choose from the following:\n\n") { |menu|
        menu.enum '.'

        menu.choice 'Create a new itinerary.', 1
        menu.choice 'View your current itineraries.', 2
        menu.choice 'Change an itinerary.', 3
        menu.choice 'Delete an itinerary.', 4
        menu.choice 'View your current destinations.', 5
        menu.choice 'About Daydream.', 6
        menu.choice 'Exit.', 7
    }
    main_menu_triage(choice)
end 


def main_menu_triage(n)
    if (n == 1)
        create_itinerary
    elsif (n == 2 && !users_itineraries.empty?)
        view_itineraries 
    elsif (n == 3 && !users_itineraries.empty?)
        edit_itinerary
    elsif (n == 4 && !users_itineraries.empty?)
        delete_itinerary 
    elsif (n == 5 && !users_itineraries.empty?)
        view_destinations
    elsif (n == 6)
        about 
    elsif(n==7) 
        bye_bye
    else
        puts "\n\nYou currently have no itineraries.\n\n"
        main_menu_prompt
    end
end

#---------OPTION 1: CREATE ITINERARY------#

def create_itinerary
    destination_new = get_destination
    itinerary_new = ItineraryList.create(itinerary: fill_itinerary, destination_id: destination_new.id, user_id:@user.id)

    itinerary_confirm
    itinerary_confirm_edit
end

def fill_itinerary
    puts "What do you want to put in your itinerary? Press enter when done."
    gets.chomp
end

def itinerary_confirm
    @prompt.ok("Your itinerary was saved! Here is the itinerary you created:")
    puts ItineraryList.last.itinerary
end

def itinerary_confirm_edit
    this_prompt = @prompt.yes?("Look good? Do you want to make any edits?")
    if this_prompt 
        ItineraryList.last.update(itinerary:fill_itinerary)
        itinerary_confirm
        itinerary_confirm_edit
    else  
        main_menu_prompt
    end 
end

#---------ASSOCIATE DESTINATION-----------#

def get_destination
    Destination.create(city: dest_city, state_or_country: dest_state_or_country)
end

def dest_state_or_country
    puts "Please provide the state or country (if outside the US):"
    gets.chomp  
end

def dest_city
    puts "Please provide the city for your trip:"
    gets.chomp
end

#---------OPTION 2: VIEW ITINERARIES-------#

def view_itineraries 
    puts "Here are your current itineraries:\n\n"
    list_itineraries
    puts "\n\n"
    sleep 1
    main_menu_prompt
end

def users_itineraries
    ItineraryList.all.select {|iten| iten.user_id == @user.id}
    # @user.itinerary_lists.map {|itin| itin}
end

def list_itineraries
    #need to also show city + state/country with each itinerary. Stretch goal: be able to update city/state/country
    #without creating a new record. 
    # if(user_itineraries.empty?)
    #     puts "You currently do not have any itineraries."
    # TODO ----> if there are no itineraries, print out a message saying the above 
    i = 1
    users_itineraries.each {|iten|
        if iten.itinerary
            puts i.to_s + ". " + iten.destination.city + ", " + iten.destination.state_or_country + ": " + iten.itinerary
        else  
            puts i.to_s + ". Empty."
        end
        i += 1
    } 
end

#---------OPTION 3: EDIT ITINERARY---------#

def edit_itinerary
    itinerary_select
    get_new_text 
    change_itinerary_text
    edit_confirm 
    main_menu_prompt
end

def itinerary_select
    puts "Which itinerary?\n\n"
    list_itineraries
    @selected_iten = gets.chomp.to_i
end 

def get_new_text
    puts "What would you like the itinerary to say?"
    @new_text = gets.chomp
end 

def change_itinerary_text 
    i = 1
    @user.itinerary_lists.each do |x|
        if(@selected_iten == i)
            x.update(itinerary: @new_text)
        end
        i += 1
    end
end 

def edit_confirm
    puts "Thanks. We've updated your itinerary.\n\n" 
end

#---------OPTION 4: DELETE ITINERARY--------#

def delete_itinerary 
    itinerary_select
    i = 1
    users_itineraries.each do |x|
        if(@selected_iten == i)
            ItineraryList.destroy(x.id)
        end
        i += 1
    end 
    delete_confirm
    main_menu_prompt
end

def delete_confirm
    puts "Thanks. We've deleted that itinerary.\n\n" 
end

#----------VIEW DESTINATIONS--------#

def view_destinations
    puts "Here are your current destinations:\n\n"
    list_destinations
    puts "\n\n"
    sleep 1
    main_menu_prompt
end

def list_destinations
    users_itineraries.each {|i| puts i.destination.city + ", " + i.destination.state_or_country}
end

#---------ABOUT DAYDREAM----------#

def about
   puts @pastel.yellow("\n\nDaydream is an app that let's you do just that.  Envision yourself somewhere new. All you have to do is create an account!")
   puts @pastel.yellow("Once you have an account, you can create and modify itineraries...") 
   puts @pastel.yellow("or if you don't feel like all that, just type in some notes about your dream destination!\n\n")
    sleep 4
    main_menu_prompt
end

#---------EXIT PROGRAM------------# 

def bye_bye 
    puts "Thanks for using Daydream! Goodbye!"
    sleep 1
    exit 
end

#--------RENDER---------------# 

welcome

