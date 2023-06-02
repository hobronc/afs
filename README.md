# afs
Wrapper for APT, Flatpak and Snap



            This is a simple bash script to update/install/remove from 3 sources: regular packages, Flatpaks and Snaps together."
            Dependencies: fzf - fuzzy finder. If the fzf binary is not avaible the sript propose to install it.
                          nala - Commandline frontend for the apt package manager"
            
            There is three main option in the script:"
            
                1 - Update the system"
                2 - Install packages. Search in the Ubuntu/Debian/etc. repositories with apt. And also search in the Flatpak (flathub), and Snap repos"
                3 - Remove packages. List all packages installed with FZF (fuzzyfinder) and remove them with the appropriate package manager."
                4 - Setup - Enable the Flatpak and Snap package services"
            
            If there is no argument when the script is launched you are presented with a menu."
            Where you can select from the previously mentioned options."
            Or you can launch the scipt with arguments."
            
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
![Screenshot from 2023-06-02 13-53-02](https://github.com/hobronc/afs/assets/45543141/0822b80c-122a-4de0-ba6a-459572ce1c82)


## Update
![Screenshot from 2023-06-02 13-53-28](https://github.com/hobronc/afs/assets/45543141/5b568c17-ce0f-405a-8d94-4aeec89b6b6a)


## Install example: "discord"
lines starting with 'O' are already installed

you can select multiple items at the same time with tab
![Screenshot from 2023-06-02 13-58-30](https://github.com/hobronc/afs/assets/45543141/63a09521-18e1-44de-94e2-2042096b75d4)



## Remove example: "gedit"
you can select multiple items at the same time with tab
![Screenshot from 2023-06-02 13-54-58](https://github.com/hobronc/afs/assets/45543141/ba37200d-7f56-414d-9397-c30119deef8f)

## Help page
![Screenshot from 2023-06-02 14-03-29](https://github.com/hobronc/afs/assets/45543141/fc2d4c71-7e52-46a0-9630-6b6769360a17)
