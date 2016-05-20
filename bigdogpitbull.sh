#!/bin/bash

RE='^[0-9]$' # regex for user input error checking

# TODO:
#    add options menu:
#       video download quality
#       download directory
Menu () {
   menuFlag=0 # menu options print if 0 to prevent stdout clutter
   while true;
   do
      if [ "$menuFlag" == 0 ];
      then
         echo -e "\n\e[1mWhat would you like to do?\e[0m"
         echo "   1. Download recent videos"
         echo "   2. Search for videos by name"
         echo "   3. Quit"
         menuFlag=1
      fi
      read -p $'\e[1mEnter your choice: \e[0m' mainMenu;
      case $mainMenu in
         1) Download
         menuFlag=0
         continue
         ;;
         2) Search
         menuFlag=0
         continue
         ;;
         3)
         ;;
         *) echo -e "\e[90mInvalid input, try again.\e[39m"
         continue
         ;;
      esac
      break
   done
}

Download () {
   echo
   while read -p $'\e[1mHow many recent videos do you wish to download? (0 to go back): \e[0m' qty;
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
}

# TODO:
#    add search queries: search by name and/or video type, or by ID
#    add descending/ascending
#    add prompt to download listed videos, try another search, or quit to menu
#    change "0 to go back" behavior to go back to previous input
#       add "q to quit to menu" option after above change
Search () {
   echo
   read -p $'\e[1mEnter search terms (0 to go back): \e[0m' searchTerms
   if [ "$searchTerms" == 0 ];
   then
      return
   fi
   while read -p $'\e[1mHow many videos would you like to list? (0 to go back): \e[0m' qty;
   do
      IntsOnly $qty
      retval=$?
      if [ "$retval" == 2 ];
      then
         break
      elif [ "$retval" == 0 ];
      then
         ./.giant_bomb_cli.py -l $qty --filter --name "$searchTerms"
         break
      fi
   done
}

# lukewarm attempt at making input error checking modular
# returns 1 if non-integral, 2 if input is 0, and 0 is input is an integer
IntsOnly () {
   qty=$1
   if ! [[ $qty =~ $RE ]];
   then
       echo -e "\e[90mInvalid input, try again.\e[39m" >&2;
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
