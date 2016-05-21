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
         3) ;;
         *) echo -e "\e[92mInvalid input, try again.\e[39m"
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
#    add search by ID
#    add descending/ascending
#    add prompt to download listed videos, try another search, or quit to menu
#    change "0 to go back" behavior to go back to previous input
#       add "q to quit to menu" option after above change
Search () {
   echo -e "\n\e[1mWould you like to filter by video type?\e[0m"
   echo "   1. No video type filter"
   echo "   2. Video Reviews"
   echo "   3. Quick Looks"
   echo "   4. TANG"
   echo "   5. Endurance Run"
   echo "   6. Events"
   echo "   7. Trailers"
   echo "   8. Premium, Features"
   echo "   9. Premium"
   echo "   10. Extra Life"
   echo "   11. Encyclopedia Bombastica"
   echo "   12. Unfinished"
   echo "   13. Metal Gear Scanlon"
   echo "   14. VinnyVania"
   echo "   15. Breaking Brad"
   while true;
   do
      read -p $'\e[1mEnter your choice (0 to go back): \e[0m' videoType
      case $videoType in
         0) return;;
         1) videoType=0
         echo -e "You entered: \e[1mNo filter\e[0m"
         ;;
         2) videoType=2
         echo -e "You entered: \e[1mVideo Reviews\e[0m"
         ;;
         3) videoType=3
         echo -e "You entered: \e[1mQuick Looks\e[0m"
         ;;
         4) videoType=4
         echo -e "You entered: \e[1mTANG\e[0m"
         ;; 
         5) videoType=5
         echo -e "You entered: \e[1mEndurance Run\e[0m"
         ;;
         6) videoType=6
         echo -e "You entered: \e[1mEvents\e[0m"
         ;;
         7) videoType=7
         echo -e "You entered: \e[1mTrailers\e[0m"
         ;;
         8) videoType=8
         echo -e "You entered: \e[1mPremium Features\e[0m"
         ;;
         9) videoType=10
         echo -e "You entered: \e[1mPremium\e[0m"
         ;;
         10) videoType=11
         echo -e "You entered: \e[1mExtra Life\e[0m"
         ;;
         11) videoType=12
         echo -e "You entered: \e[1mEncyclopedia Bombastica\e[0m"
         ;;
         12) videoType=13
         echo -e "You entered: \e[1mUnfinished\e[0m"
         ;;
         13) videoType=17
         echo -e "You entered: \e[1mMetal Gear Scanlon\e[0m"
         ;;
         14) videoType=18
         echo -e "You entered: \e[1mVinnyVania\e[0m"
         ;;
         15) videoType=19
         echo -e "You entered: \e[1mBreaking Brad\e[0m"
         ;;
         *) echo -e "\e[92mInvalid input, try again.\e[39m"
         continue
         ;;
      esac
      break
   done
   read -p $'\e[1mEnter search terms (0 to go back): \e[0m' searchTerms
   if [ "$searchTerms" == 0 ]; # go to main menu if input is 0
   then
      return
   fi
   while read -p $'\e[1mHow many videos would you like to list? (0 to go back): \e[0m' qty;
   do
      IntsOnly $qty
      retval=$?
      if [ "$retval" == 2 ]; # if input was 0, go back
      then
         return
      elif [ "$retval" == 0 ]; # if input was a valid integer, proceed to command
      then
         if [ "$videoType" == 0 ];
         then
            ./.giant_bomb_cli.py -l $qty --filter --name "$searchTerms"
         else
            ./.giant_bomb_cli.py -l $qty --filter --name "$searchTerms" --video_type $videoType
         fi
         break # query complete, return to main menu (temporary)
      fi
      continue # return to list prompt if input is invalid
   done
}

# lukewarm attempt at making input error checking modular
# returns 1 if non-integral, 2 if input is 0, and 0 is input is an integer
IntsOnly () {
   qty=$1
   if ! [[ $qty =~ $RE ]];
   then
      echo -e "\e[92mInvalid input, try again.\e[39m" >&2;
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
