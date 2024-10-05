# afs
Wrapper for APT, Flatpak and Snap



            This is a simple bash script to update/install/remove from 3 sources: regular packages with apt, Flatpaks and Snaps together."
            Dependencies: 
            	mandatory: fzf - fuzzy finder. If the fzf binary is not available the sript propose to install it.
                        recommended: nala - Command line frontend for the apt package manager"
            
            There are three main option in the script:"
            
                1 - Update the system"
                2 - Install packages. Search in the Ubuntu/Debian/etc. repositories with apt. And also search in the Flatpak (flathub), and Snap repos"
                3 - Remove packages. List all packages installed with FZF (fuzzyfinder) and remove them with the appropriate package manager."
                4 - Setup - Enable the Flatpak and Snap package services"
            
            If there is no argument when the script is launched you are presented with a menu."
            Where you can select from the previously mentioned options."
            Or you can launch the scipt with arguments."
	    
	    	- ua|uu|update-all|0 - Update with all available methods (apt,flatpak,snap)
            
	    	- u|update|1 - Update (if a second arguent was given that will be used as the update method)"
              second arguments could be: (check all avaible options in the update menu)"
                (1 or a) = ALL (APT,Flatpak,Snap)\n    (2 or r) = Apt only \n    (3 or f) = FLATPAK only\n    (4 or s) = SNAP only"
            
            - i|install|2 - Install packages (if a second argument is given that will be the search term.)"
                You can select multiple programs. The script will try to install them accordingly."
            
            - r|remove|3 - Remove packages"
                You can select multiple programs. The script will try to remove them accordingly."
            
            example: afs.sh i - launch the install menu. will ask for a search term directly"
            example: afs.sh i <search term> - will search for the <search term> in the standard repositeories, Flathub, Snap"
            example: afs.sh u a - ALL method will be used t0o update the system - Apt,Flatpak,Snap"
            
            - s|setup - Setup"
                You can setup/enable the Flatpak and Snap repositories from the script"
            

## Main page
![Screenshot from 2023-06-02 16-07-53](https://github.com/hobronc/afs/assets/45543141/123f80bd-3064-4a31-9a04-b28f11caa669)



## Update
![Screenshot from 2023-06-02 16-08-23](https://github.com/hobronc/afs/assets/45543141/1a329f3f-2d5c-4d23-ab55-4f708bac631f)
![Screenshot from 2023-06-02 16-08-48](https://github.com/hobronc/afs/assets/45543141/3ca4d166-c204-4b5a-ad86-09c6ff2d066f)


## Install example: "discord"
lines starting with 'O' are already installed

you can select multiple items at the same time with tab and than press enter to install all

![Screenshot from 2023-06-02 16-09-08](https://github.com/hobronc/afs/assets/45543141/62e806eb-0e6b-4bf8-b6cc-e953ef71dd8b)


## Remove example: "vlc"
you can select multiple items at the same time with tab
![Screenshot from 2023-06-02 16-09-31](https://github.com/hobronc/afs/assets/45543141/94eac6aa-8136-474c-b9c3-3b8141816b7d)


## Help page
![Screenshot from 2023-06-02 14-03-29](https://github.com/hobronc/afs/assets/45543141/fc2d4c71-7e52-46a0-9630-6b6769360a17)
