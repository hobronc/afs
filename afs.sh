#!/usr/bin/bash
 
## Set the main work folder
work_folder='/tmp/afs-'$RANDOM
 
mkdir $work_folder
cd $work_folder || exit

###Check if fzf is avaible, if not the script will propose to install it.
if ! command -v fzf &> /dev/null ; then
    tput setaf 2; echo -e "\nThis script has one dependencies: \n    FZF - fuzzy finder package \n    And Optionally (recomended)): nala - Commandline frontend for apt."; tput sgr0
    tput setaf 3; echo -e "\nDo you wish to install fzf now? (y/n)"; tput sgr0
    read -r confirmation_fzf
        if [[ $confirmation_fzf == "y" ]]; then
            sudo apt install fzf && tput setaf 2 
        fi    
    echo -e "\nInstallation of FZF done.\n"; tput sgr0

    if ! command -v nala &> /dev/null ; then
    tput setaf 3; echo -e "Do you wish to try installing nala now? (y/n)"; tput sgr0
    read -r confirmation_nala
        if [[ $confirmation_nala == "y" ]]; then
            sudo apt install nala && tput setaf 2 
        fi
        
    echo -e "\nInstallation of nala is done."; tput sgr0

    fi
fi

###Check if nala is avaible, if not the script will use apt instead.
if command -v nala &> /dev/null ; then
    apt_frontend='nala'
    tput setaf 2; echo -e "nala - the commandline frontend for apt is not present we reccomend using it instead of apt."; tput sgr0
else
    apt_frontend='apt'
fi


### SET variables if the flatpak and snap package manager is installed
FLATPAK_ENABLE='0'
if command -v flatpak &> /dev/null ; then
    FLATPAK_ENABLE='1'
fi

SNAP_ENABLE='0'
if command -v snap &> /dev/null ; then
    SNAP_ENABLE='2'
fi
 
### create a sum for easier comparasion
FLAT_SNAP_ENABLE=$(($FLATPAK_ENABLE + $SNAP_ENABLE))
 
 
updater(){
    ### First show the installed packages
    # from FLATPAK
    if [[ "$FLATPAK_ENABLE" -eq "1" ]]; then
            tput setaf 4; echo "        --- Flatpak packages: (only apps) ---"; tput sgr0
            flatpak list --app
    fi
 
    # from Snaps
    if [[ "$SNAP_ENABLE" -eq "2" ]]; then
        tput setaf 6; echo -e "\n        --- Snap packages: ---"; tput sgr0
        snap list
    fi
    # from the repoes
    tput setaf 5; echo -e "\n        --- Installed packages (only the number) from the standard repositories: ---"; tput sgr0
        apt list --installed 2>/dev/null | wc -l
        list_upgradable_apt_file="$work_folder/upgradable_apt"
        apt list --upgradable 2>/dev/null>>$list_upgradable_apt_file
 
        if (( $(cat $list_upgradable_apt_file | wc -l ) == 1 )); then
            tput setaf 7; echo -e "\nThere is no upgradable package."; tput sgr0
        else
        tput setaf 2; echo -e "  - Upgradable packages: - \n"; tput sgr0
        cat $list_upgradable_apt_file
        fi
 
    if [ -z $update_method ]; then
        ### The updated ask for the options, the $FLAT_SNAP_ENABLE variable define the availability of Flatpak and Snaps
        tput setaf 3; echo -e "\nDo you wish to update?"; tput sgr0
        case $FLAT_SNAP_ENABLE in
            0) ### no flatpak or snap avaible
                tput setaf 2; echo -e " 1 or a = ALL (ther is only APT avaible) \n 2 or r = Apt only"; tput sgr0
            ;;
            1) # only flatpak is avaible
                tput setaf 2; echo -e " 1 or a = ALL \n 2 or r = Apt only \n 3 or f = FLATPAK only\n<SNAP is not avaible>"; tput sgr0
            ;;
            2) # only snap is avaible
                tput setaf 2; echo -e " 1 or a = ALL \n 2 or r = Apt only \n 4 or s = SNAP only\n<FLATPAK is not avaible>"; tput sgr0
            ;;
            3) # both are avaible
                tput setaf 2; echo -e " 1 or a = ALL \n 2 or r = Apt only \n 3 or f = FLATPAK only\n 4 or s = SNAP only"; tput sgr0
            ;;
        esac
 
        ### read for the option
        read -r update_method
        echo
        fi
 
    case $update_method in
        a|1)
            tput setaf 1; echo -e  "Authentication required! Password:"; tput sgr0
            tput setaf 2; sudo echo -e  "Authentication OK"; tput sgr0
            echo
            tput setaf 5; echo -e "\n   --- Updating with APT: ---"; tput sgr0
                
                if command -v nala &> /dev/null ; then
                    sudo nala upgrade -y
                else
                    sudo apt update && sudo apt upgrade -y
                fi
                
                 
            if [[ "$FLATPAK_ENABLE" -eq "1" ]]; then
                tput setaf 4; echo -e "\n   --- Updating Flatpaks: ---"; tput sgr0
                flatpak update -y
            fi
 
            if [[ "$SNAP_ENABLE" -eq "2" ]]; then
                tput setaf 6; echo -e "\n   --- Updating Snaps: ---"; tput sgr0
                sudo snap refresh
            fi
            close_delete wait
        ;;
        r|2)
            tput setaf 1; echo -e  "Authentication required! Password:"; tput sgr0
            tput setaf 2; sudo echo -e  "Authentication OK"; tput sgr0
            echo
            tput setaf 5; echo -e "\n   --- Updating with APT: ---"; tput sgr0
                sudo $apt_frontend upgrade -y
                close_delete wait
        ;;
        f|3)
            if [[ "$FLATPAK_ENABLE" -eq "1" ]]; then
                tput setaf 1; echo -e  "Authentication required! Password:"; tput sgr0
                tput setaf 2; sudo echo -e  "Authentication OK"; tput sgr0
                echo
                tput setaf 4; echo -e "\n   --- Updating Flatpaks: ---"; tput sgr0
                    flatpak update -y
                    close_delete wait
            else
                tput setaf 3; echo -e  "There is no FLATPAK support. Wrong choice!\nExiting..."; tput sgr0
                close_delete
            fi
 
        ;;
        s|4)
            if [[ "$SNAP_ENABLE" -eq "2" ]]; then
                tput setaf 1; echo -e  "Authentication required! Password:"; tput sgr0
                tput setaf 2; sudo echo -e  "Authentication OK"; tput sgr0
                echo
                tput setaf 6; echo -e "\n   --- Updating Snaps: ---"; tput sgr0
                    sudo snap refresh
                    close_delete wait
            else
                tput setaf 3; echo -e  "There is no SNAP support. Wrong choice!\nExiting..."; tput sgr0
                close_delete
            fi
        ;;
        *)
        tput setaf 3; echo -e "\nUnknown choice. Exiting..."; tput sgr0
           close_delete
        ;;
    esac
 
    close_delete wait
}
 
 
### FUNCTION - list all the installed packages on the system - add Flatpak and Snap packages to if they are avaibled
lister_installed() {
 
    list_installed_file="$work_folder/installed"
    apt list --installed 2>/dev/null | awk -F '/' '{print "O APT " $1}'>>$list_installed_file
     
    if [[ "$FLATPAK_ENABLE" -eq "1" ]]; then
        flatpak list --columns=app | awk '{print "O FLAT " $1}'>>$list_installed_file
    fi
     
    if [[ "$SNAP_ENABLE" -eq "2" ]]; then
        snap list | awk '{print "O SNAP " $1}'>>$list_installed_file
    fi
 
}
 
search_package_install() {
 
    if [ -z "$search_term" ]; then
        ### Ask for the search term, which to use.
        tput setaf 2; echo -e "\nPlease provide a search term\n"; tput sgr0
        read -r search_term
        echo
    else
        tput setaf 2; echo -e "\nStart searching for $search_term...\n"; tput sgr0
    fi
 
 
    if [ -z $search_term ]; then
        tput setaf 1; echo -e "No search term provided\nExiting..."; tput sgr0
        close_delete
    fi
 
    search_result_file_full="$work_folder/search_result_full"
 
    tput setaf 5; echo -e " Search the standard repository"; tput sgr0
    apt-cache search $search_term | awk '{print "- APT " $0 "..."}'>>$search_result_file_full
 
    if [[ "$FLATPAK_ENABLE" -eq "1" ]]; then
        tput setaf 4; echo -e " Search the Flatpak repos"; tput sgr0
        flatpak search --columns=app,name,description $search_term | awk '{print "- FLAT " $0 "..."}'>>$search_result_file_full
    fi
 
    if [[ "$SNAP_ENABLE" -eq "2" ]]; then
        tput setaf 6; echo -e " Search the Snap repos"; tput sgr0
        snap search $search_term 2>/dev/null | awk '{$2=$3=$4=""; print "- SNAP " $0 "..."}'>>$search_result_file_full
    fi
 
 
    #### if a line is already installed then change the marking in the search result file.
    while read -r line; do
        sed -i "s/- $line/O $line/g" $search_result_file_full
    done < <(grep -Fxf <(sort $search_result_file_full | awk '{print $2" "$3}') <(sort $list_installed_file | awk '{print $2" "$3}'))
 
 
}
 
FZF() {
 
    if [[ $1 == "install" ]]; then
 
        list_for_fzf=$(cat $search_result_file_full | grep -v 'FLAT No matches found' | grep -v 'SNAP Name  ')
 
        number_of_result=$(wc -l $search_result_file_full | awk '{ print $1 }')
 
        if [[ "$number_of_result" -lt "1" ]]; then
            echo -e "\nNo package found. Exiting..."
            close_delete
        fi
    elif [[ $1 == "remove" ]]; then
        list_for_fzf=$(cat $list_installed_file | grep -v "SNAP Name" | grep -v "Listing...")
    fi
    
    ### COLORIZE THE FZF WITH ANSI COLORS
    list_for_fzf=$(echo -e "$list_for_fzf" \
    	| awk -v srch="APT" -v repl="\e[36mAPT \e[0m" '{ sub(srch,repl,$0); print $0 }' \
    	| awk -v srch="FLAT" -v repl="\e[34mFLAT\e[0m" '{ sub(srch,repl,$0); print $0 }' \
    	| awk -v srch="SNAP" -v repl="\e[35mSNAP\e[0m" '{ sub(srch,repl,$0); print $0 }' \
    	| awk -v srch='-' -v repl="\e[93m-\e[0m" '{ sub(srch,repl,$0); print $0 }' \
    	| awk -v srch='O' -v repl="\e[92mO\e[0m" '{ sub(srch,repl,$0); print $0 }' )
    

    pkg="$(
        echo -e "$list_for_fzf" |                                     # load list of package names from $pacui_list_install_all variable. "-e" interprets the added newlines.
        # sort -k1,1 -u |
        fzf -i \
            --ansi \
            --multi \
            --exact \
            --no-sort \
            --select-1 \
            --query="" \
            --cycle \
            --layout=reverse \
            --bind=pgdn:half-page-down,pgup:half-page-up \
            --margin="4%,1%,1%,2%" \
            --info=inline \
            --no-unicode \
            --preview '
                if [[ {1} == "O" ]]                      # check, if 1. field of selected line (in fzf) is a locally installed package.
                then
                    if [[ {2} == "APT" ]]
                    then
                    echo -e "\e[1;32mPackage is already INSTALLED with \e[36mAPT \e[1;32mInfo: \n\e[0m"
                    apt-cache show {3} | grep -v "SHA"
                    fi
                    if [[ {2} == "FLAT" ]]
                    then
                    echo -e "\e[1;32mPackage is already INSTALLED with \e[34mFlatpak. \e[1;32mInfo: \n\e[0m"
                    flatpak remote-info flathub {3}
                    fi
                    if [[ {2} == "SNAP" ]]
                    then
                    echo -e "\e[1;32mPackage is already INSTALLED with \e[35mSnap. \e[1;32mInfo: \n\e[0m"
                    snap info {3}
                    fi
                else
                    if [[ {2} == "APT" ]]
                    then
                    echo -e "\e[1;93mPackage is avaible with \e[36mAPT \e[1;93mInfo: \n\e[0m"
                    apt-cache show {3} | grep -v "SHA"
                    fi
                    if [[ {2} == "FLAT" ]]
                    then
                    echo -e "\e[1;93mPackage is avaible with \e[34mFlatpak. \e[1;93mInfo: \n\e[0m"
                    flatpak remote-info flathub {3}
                    fi
                    if [[ {2} == "SNAP" ]]
                    then
                    echo -e "\e[1;93mPackage is avaible with \e[35mSnap. \e[1;93mInfo: \n\e[0m"
                    snap info {3}
                    fi
                fi' \
            "$(
                if (( $(tput cols) >= 125 ))
                then
                    echo "--preview-window=right:45%:wrap"                  # depending on the terminal width (determined by "tput cols"), the preview window is either shown on the right or the bottom
                else
                    echo "--preview-window=bottom:45%:wrap"
                fi
            )" \
            --header="TAB key to (un)select. ENTER to install. ESC to quit." \
            --prompt="Enter string to filter list > " |
        awk '{print $2" "$3""}'                                                 # use "awk" to filter output of "fzf" and only get the first field (which contains the package name). 
										# "fzf" should output a separated (by newline characters) list of all chosen packages!
    )"
 
 
        selection_result_file="$work_folder/selection_result"
 
    echo $pkg>>$selection_result_file
    max_word=$(cat $selection_result_file | wc -w)
    if [ $max_word -lt "2" ]; then
        echo -e "\nNo package selected. Exiting..."
        close_delete
    fi
 
        ### we proceed to make 3 list with the selected packages regarding the repository sources
        count_source='1'
        count_pkg='2'
        APT_packages=""
        FLAT_packages=""
        SNAP_packages=""
 
    while [[ $count_source -le $max_word ]]
    do
        source=$(cat $selection_result_file | cut -d " " -f $count_source)
        package=$(cat $selection_result_file | cut -d " " -f $count_pkg)
        case $source in
            APT)
                APT_packages="$APT_packages $package"
            ;;
            FLAT)
                FLAT_packages="$FLAT_packages $package"
            ;;
            SNAP)
                SNAP_packages="$SNAP_packages $package"
            ;;
        esac
        count_source=$(( count_source + 2 ))
        count_pkg=$(( count_pkg + 2 ))
    done
 
    if [[ -n $APT_packages ]]; then
        tput setaf 5; echo -e "\nAPT  packages selected:"; tput sgr0
        echo "$APT_packages"
    fi
    if [[ -n $FLAT_packages ]]; then
        tput setaf 4; echo -e "\nFLAT packages selected:"; tput sgr0
        echo "$FLAT_packages"
    fi
    if [[ -n $SNAP_packages ]]; then
        tput setaf 6; echo -e "\nSNAP packages selected:"; tput sgr0
        echo "$SNAP_packages"
    fi
    echo
 
}
 
install_packages() {
    # determine the word number for every type.
    APT_package_number=$(echo "$APT_packages" | wc -w)
    FLAT_package_number=$(echo $FLAT_packages | wc -w)
    SNAP_package_number=$(echo "$SNAP_packages" | wc -w)
 
    # Check for the number of packages selected, only proceed if min 1 is selected in one type
    if [ $APT_package_number -gt "0" ] || [ $SNAP_package_number -gt "0" ] || [ $FLAT_package_number -gt "0" ]; then
        tput setaf 1; echo -e  "Authentication required! Password:"; tput sgr0
        tput setaf 2; sudo echo -e  "Authentication OK"; tput sgr0
        echo
    fi
 
    # Installing regular packages with APT
    if [ $APT_package_number -gt "0" ]; then
        tput setaf 5; echo -e "Installing packages from standard repository:\n"; tput sgr0
        sudo $apt_frontend install $APT_packages
        tput setaf 5; echo -e  "APT installation: DONE!\n"; tput sgr0
    fi
 
    # Installing FLATPAKs
    if [ $FLAT_package_number -gt "0" ] && [ $FLATPAK_ENABLE -eq "1" ]; then
        tput setaf 4; echo -e "Installing FLATPAK packages:\n"; tput sgr0
        flatpak install $FLAT_packages
        tput setaf 4; echo -e  "Flatpak installation: DONE!\n"; tput sgr0
    fi
 
    # Installing SNAPs
    if [ $SNAP_package_number -gt "0" ] && [ $SNAP_ENABLE -eq "2" ]; then
        tput setaf 6; echo -e "Installing Snap packages:\n"; tput sgr0
        sudo snap install $SNAP_packages
        tput setaf 6; echo -e  "SNAP installation: DONE!\n"; tput sgr0
    fi
 
}
 
remove_packages() {
    # determine the word number for every type.
    APT_package_number=$(echo $APT_packages | wc -w)
    FLAT_package_number=$(echo $FLAT_packages | wc -w)
    SNAP_package_number=$(echo $SNAP_packages | wc -w)
 
    # Check for the number of packages selected, only proceed if min 1 is selected in one type
    if [ $APT_package_number -gt "0" ] || [ $SNAP_package_number -gt "0" ] || [ $FLAT_package_number -gt "0" ]; then
        tput setaf 1; echo -e  "Authentication required! Password:"; tput sgr0
        tput setaf 2; sudo echo -e  "Authentication OK"; tput sgr0
        echo
    fi
 
    # Remove regular packages with APT
    if [ $APT_package_number -gt "0" ]; then
        tput setaf 5; echo -e "Remove packages from standard repository:\n"; tput sgr0
        sudo $apt_frontend remove $APT_packages
        tput setaf 5; echo -e  "\nAPT removal: DONE!\n"; tput sgr0
    fi
 
    # Remove FLATPAKs
    if [ $FLAT_package_number -gt "0" ] && [ $FLATPAK_ENABLE -eq "1" ]; then
        tput setaf 4; echo -e "Remove FLATPAK packages:\n"; tput sgr0
        flatpak remove $FLAT_packages
        tput setaf 4; echo -e  "\nFlatpak removal: DONE!\n"; tput sgr0
    fi
 
    # Remove SNAPs
    if [ $SNAP_package_number -gt "0" ] && [ $SNAP_ENABLE -eq "2" ]; then
        tput setaf 6; echo -e "Remove Snap packages:\n"; tput sgr0
        sudo snap remove $SNAP_packages
        tput setaf 6; echo -e  "\nSNAP removal: DONE!\n"; tput sgr0
    fi
 
}

### Setup function - Options to enable flatpak and snap repositories
setup() {
    setup_install_package_names=""
    ### Ask the user if they want to install Flatpak
    tput setaf 3; echo -e "\n Do you wish to Install the Flatpak service?\n(y|n)"; tput sgr0
    read -r flatpak_install
    if [[ $flatpak_install == "y" ]]; then ### if the answer was yes (y) add "flatpak" to the list of packages to install
        setup_install_package_names="$setup_install_package_names "flatpak
    fi
    
    
    ### Ask the user if they want to install Snapd
    tput setaf 3; echo -e "\n Do you wish to Install the Snap service?\n(y|n)"; tput sgr0
    read -r snap_install
    if [[ $snap_install == "y" ]]; then ### if the answer was yes (y) add "snapd" to the list of packages to install
        setup_install_package_names="$setup_install_package_names "snapd
    fi
    
    ### If no answer is provided we can simply exit
    if [[ $setup_install_package_names == "" ]]; then
        tput setaf 3; echo -e "\n No service was selected to install"; tput sgr0
        close_delete
    else
        sudo $apt_frontend install $setup_install_package_names
    fi
    ### IF the install was correct the binaries should be in place so we can add the flathub repo
    if [[ -f "$FLATPAK_LOCATION" ]]; then
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        tput setaf 3; echo -e "\nFlathub repository added.\n"; tput sgr0
    fi
    if [[ -f "$SNAP_LOCATION" ]]; then
        sudo snap install core
        tput setaf 3; echo -e "\nSnap core service installed.\n"; tput sgr0
    fi
    
    tput setaf 3; echo -e "\n Please note that the Flatpak service installation requires a reboot to be fully finished."; tput sgr0
}

### FUNCTION - delete the temp folder at the end
close_delete() {
    if [[ $1 == "wait" ]]; then
        tput setaf 2; echo -e "\nDONE!"; tput sgr0
        read -r
    fi
    cd /
    rm -rf $work_folder
    exit 0
}
 
###  Menu function.
menu_main() {
 
    ### if an option is provided when the script is lauched then proceed with that option. if $1 was empty show the menu.
    if [ -z $1 ]; then
        tput setaf 3; echo -e "\n      --- Please choose from the following options: ---\n"; tput sgr0
        tput setaf 7; echo -e " u|1 - Update the system (APT,Flap,Snap)\n"; tput sgr0
        tput setaf 7; echo -e " i|2 - Install package (search all available package in the repositories with APT,Flatpak,Snap)\n"; tput sgr0
        tput setaf 7; echo -e " r|3 - Remove package (search all installed package with APT,Flatpak,Snap)\n"; tput sgr0
        if [[ $FLAT_SNAP_ENABLE != "3" ]]; then
            tput setaf 7; echo -e " s   - Setup - Enable the Flatpak and Snap package services\n"; tput sgr0
        fi
        tput setaf 7; echo -e " h|? - Help page"; tput sgr0
        echo
        
        read -r menu_selection
 
        #~ Clear the screen after the menu. This is the only time when we clear the terminal.
            local lines
            # number of lines of the user's terminal.
            lines="$( tput lines )"
            for (( i=1; i<lines; i++ ))
            do
                    # insert "lines" number of empty lines:
                    echo
            done
 
        # move cursor to the top left of the terminal
        tput cup 0 0
 
    else ### if there were an argument in $1 then us that as the choice
        menu_selection=$1
    fi
 
    case $menu_selection in
        u|update|1)
            if [[ -n $2 ]];then ### set the update method if a second argument was given
                update_method=$2
            fi
            updater
            close_delete wait
        ;;
        i|install|2)
            lister_installed ## call the installed packages (list creaton) function
 
            if [[ -n $2 ]];then ### only set search_term if the 2. var is not empty.
                search_term=$2
            fi
            search_package_install $search_term ## call the search function
            FZF install    ## call the FZF function with the install argument
 
            tput setaf 3; echo -e "Do you want to continue installign the selected packages? [Y/n]"; tput sgr0
            read -r proceed_confirmation
                case $proceed_confirmation in
                    y|Y)
                        install_packages
                        close_delete wait
                    ;;
                    *)
                        tput setaf 1; echo -e "Installation interrupted, exiting...\n"; tput sgr0
                        close_delete
                    ;;
                esac
        ;;
        r|remove|3)
            lister_installed ## call the installed packages (list creaton) function
            FZF remove ### call the fzf function with the remove argument
 
            tput setaf 3; echo -e "\nDo you want to continue removing the selected packages? [Y/n]"; tput sgr0
            read -r proceed_confirmation
                case $proceed_confirmation in
                    y|Y)
                        remove_packages
                    ;;
                    *)
                        tput setaf 1; echo -e "Remove interrupted, exiting...\n"; tput sgr0
                    ;;
                esac
            close_delete wait
        ;;
        s|setup)
        	setup
        	close_delete wait
        ;;
        h|--help)
            echo -e "This is a simple bash script to update/install/remove from 3 sources: regular packages, Flatpaks and Snaps together."
            echo -e "Dependencies: fzf - fuzzy finder. If the fzf binary is not avaible the sript propose to install it."
            echo -e "	 optional: nala - Commandline frontend for the apt package manager"
            echo
            echo -e "There is three main option in the script:"
            echo
            echo -e "    1 - Update the system"
            echo -e "    2 - Install packages. Search in the Ubuntu/Debian/etc. repositories with apt . And also search in the Flatpak (flathub), and Snap repos"
            echo -e "    3 - Remove packages. List all packages installed with FZF (fuzzyfinder) and remove them with the appropriate package manager."
            echo -e "    4 - Setup - Enable the Flatpak and Snap package services"
            echo
            echo -e "If there is no argument when the script is launched you are presented with a menu."
            echo -e "Where you can select from the previously mentioned options."
            echo -e "Or you can launch the scipt with arguments."
            echo
            echo -e "- u|update|1 - Update (if a second arguent was given that will be used as the update method)"
            echo -e "  second arguments could be: (check all avaible options in the update menu)"
            echo -e "    (1 or a) = ALL (APT,Flatpak,Snap)\n    (2 or r) = Apt only \n    (3 or f) = FLATPAK only\n    (4 or s) = SNAP only"
            echo
            echo -e "- i|install|2 - Install packages (if a second argument is given that will be the search term.)"
            echo -e "    You can select multiple programs. The script will try to install them accordingly."
            echo
            echo -e "- r|remove|3 - Remove packages"
            echo -e "    You can select multiple programs. The script will try to remove them accordingly."
            echo
            echo -e "example: afs.sh i - launch the install menu. will ask for a search term directly"
            echo -e "example: afs.sh i <search term> - will search for the <search term> in the standard repositeories, Flathub, Snap"
            echo -e "example: afs.sh u a - ALL method will be used t0o update the system - Apt,Flatpak,Snap"
            echo
            echo -e "- s|setup - Setup"
            echo -e "    You can setup/enable the Flatpak and Snap repositories from the script"
            echo
        ;;
        *)
        tput setaf 1; echo -e "\nNo option provided exiting..."; tput sgr0
        close_delete
        ;; 
    esac
 
}
 
### Simply launch the main menu
menu_main $1 $2
 
