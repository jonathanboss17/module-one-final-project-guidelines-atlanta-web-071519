class CLI

    def initialize
        @prompt = TTY::Prompt.new
        @font = TTY::Font.new(:standard)
        @pastel = Pastel.new 
    end

    #-------WELCOME--------#
    def welcome 
        puts @pastel.yellow(@font.write("Welcome to DreamJot!"))
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
            @prompt.ok("Your account was successfully created! \n\nYour new DreamJot username is #{@name}.\n\n")
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

            menu.choice 'Jot something.', 1
            menu.choice 'View current jots.', 2
            menu.choice 'Change a jot.', 3
            menu.choice 'Delete a jot.', 4
            menu.choice 'View your current destinations.', 5
            menu.choice 'About DreamJot.', 6
            menu.choice 'Exit.', 7
        }
        main_menu_triage(choice)
    end 


    def main_menu_triage(n)
        if (n == 1)
            create_jot
        elsif (n == 2 && !users_jots.empty?)
            view_jots 
        elsif (n == 3 && !users_jots.empty?)
            edit_jot
        elsif (n == 4 && !users_jots.empty?)
            delete_jot
        elsif (n == 5 && !users_jots.empty?)
            view_destinations
        elsif (n == 6)
            about 
        elsif(n==7) 
            bye_bye
        else
            puts "\n\nYou currently have no jots.\n\nTo access this option, please create a new jot (option 1 in the main menu).\n\n"
            main_menu_prompt
        end
    end

    #---------OPTION 1: JOT SOMETHING------#

    def create_jot
        destination_new = get_destination
        new_jot = Jot.create(jot: fill_jot, destination_id: destination_new.id, user_id:@user.id)
        jot_confirm
        jot_confirm_edit
    end

    def fill_jot
        puts "What do you want to jot down? Press enter when done."
        gets.chomp
    end

    def jot_confirm
        @prompt.ok("Your jot was saved! Here is the jot you created:")
        puts Jot.last.jot
    end

    def jot_confirm_edit
        this_prompt = @prompt.yes?("Look good? Do you want to make any edits?")
        if this_prompt 
            Jot.last.update(jot: fill_jot)
            jot_confirm
            jot_confirm_edit
        else  
            main_menu_prompt
        end 
    end

    #---------ASSOCIATE DESTINATION-----------#

    def get_destination
        Destination.create(city: dest_city, state_or_country: dest_state_or_country)
    end

    def dest_state_or_country
        puts "Please provide a state or country (if outside the US):"
        gets.chomp  
    end

    def dest_city
        puts "Please provide a city:"
        gets.chomp
    end

    #---------OPTION 2: VIEW JOTS-------#

    def view_jots
        puts "Here are your current jots:\n\n"
        list_jots
        puts "\n\n"
        sleep 1
        main_menu_prompt
    end

    def users_jots
        Jot.all.select {|j| j.user_id == @user.id}
    end

    def list_jots
        i = 1
        users_jots.each {|j|
            if j.jot
                puts i.to_s + ". " + j.destination.city + ", " + j.destination.state_or_country + ": " + j.jot
            else  
                puts i.to_s + ". Empty."
            end
            i += 1
        } 
    end

    #---------OPTION 3: EDIT JOTS---------#

    def edit_jot
        jot_select
        get_new_text 
        change_jot_text
        edit_confirm 
        main_menu_prompt
    end

    def jot_select
        puts "\n\nWhich jot?  Please enter a number corresponding to the jot you want.\n\n"
        list_jots
        @selected_jot = gets.chomp.to_i
    end 

    def get_new_text
        puts "Sounds good. Go ahead and jot something else."
        @new_text = gets.chomp
    end 

    def change_jot_text 
        i = 1
        # @user.jots
        users_jots.each do |x|
            if(@selected_jot == i)
                x.update(jot: @new_text)
            end
            i += 1
        end
    end 

    def edit_confirm
        puts "Thanks. We've updated your jot.\n\n" 
    end

    #---------OPTION 4: DELETE JOTS--------#

    def delete_jot 
        jot_select
        i = 1
        users_jots.each do |x|
            if(@selected_jot == i)
                Jot.destroy(x.id)
            end
            i += 1
        end 
        delete_confirm
        main_menu_prompt
    end

    def delete_confirm
        puts "Thanks. We've deleted that jot.\n\n" 
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
        users_jots.each {|i| puts i.destination.city + ", " + i.destination.state_or_country}
    end

    #---------ABOUT DREAMJOT----------#

    def about
    puts @pastel.yellow("\n\nDreamJot is an app that let's you do just that.  Envision yourself somewhere new. All you have to do is create an account!")
    puts @pastel.yellow("Once you have an account, you can create and modify jots...") 
    puts @pastel.yellow("or if you don't feel like all that, just type in some notes about your dream destination!\n\n")
        sleep 4
        main_menu_prompt
    end

    #---------EXIT PROGRAM------------# 

    def bye_bye 
        puts "\n\n\nThanks for using DreamJot! Goodbye!\n\n\n"
        sleep 1
        exit 
    end

end


