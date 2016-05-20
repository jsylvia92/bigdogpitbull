#!/bin/sh

Menu () {
   echo "What would you like to do?"
   echo "   1. Download recent videos"
   echo "   2. Search for videos by name"
   echo "   3. Quit"
   while read -p "Enter your choice: " mainMenu; do
      case $mainMenu in
         1) Download
         exit
         ;;
         2) Search
         exit
         ;;
         3) exit
         ;;
         *) echo "Oops, try again."
         ;;
      esac
   done
}

Download () {
   read -p "How many recent videos do you wish to download? " qty
   if [ "$qty" -gt 0 ]; then
      ./.giant_bomb_cli.py -l $qty --quality hd --download
   else
      echo "Aborted. Returning to main menu.\n"
      Menu
   fi

}

Search () {
   echo "Ha Ha\n"
   Menu
}

Menu