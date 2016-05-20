#!/bin/bash

RE='^[0-9]$' # regex for user input sanitation


Menu () {
   echo "What would you like to do?"
   echo "   1. Download recent videos"
   echo "   2. Search for videos by name"
   echo "   3. Quit"
   while read -p "Enter your choice: " mainMenu;
   do
      case $mainMenu in
         1) Download
         exit
         ;;
         2) Search
         exit
         ;;
         3) exit
         ;;
         *) echo "Invalid input, try again."
         ;;
      esac
   done
}

Download () {
   while read -p "How many recent videos do you wish to download? (0 to go back): " qty;
   do
      IntsOnly $qty
      retval=$?

      if [ "$retval" == 2 ];
      then
         break
      elif [ "$retval" == 0 ];
      then
         ./.giant_bomb_cli.py -l $qty --quality hd --download
         # $(dirname "${BASH_SOURCE[0]}")/blah when complete so bigdogpitbull and .py can be moved to PATH
      fi
   done

   Menu
}

# incomplete for now. Plans include having an initial search and then asking if the user would
# like to download listed videos
Search () {
   read -p "Enter search terms: " searchTerms
   while read -p "How many videos would you like to list? (0 to go back): " qty;
   do
      IntsOnly $qty
      retval=$?

      if [ "$retval" == 2 ];
      then
         break
      elif [ "$retval" == 0 ];
      then
         echo -e "COMMAND WILL BE PLACED HERE WHEN I'M NOT TOO TIRED TO TYPE IT IN\n"
         break
      fi
   done

   Menu
}

# lukewarm attempt at making input sanitation modular
# returns 1 if non-integral, 2 if input is 0, and 0 is input is an integer
IntsOnly () {
   qty=$1

   if ! [[ $qty =~ $RE ]];
   then
      echo "Invalid input, try again." >&2;
      retval=1
   elif [ $qty == 0 ];
   then
      retval=2
   else
      retval=0
   fi
   return "$retval"
}

# visions of int main()...
Menu

