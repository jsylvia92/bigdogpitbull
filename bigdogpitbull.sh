#!/bin/bash

RE='^[0-9]+$' # regex for user input error checking

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
         echo "   2. Search for videos"
         echo "   3. Quit"
         menuFlag=1
      fi
      read -p $'\e[1mEnter your choice: \e[0m' mainMenu;
      case $mainMenu in
         1) RecentDownload
         menuFlag=0
         ;;
         2) PreSearch
         menuFlag=0
         ;;
         3) break
         ;;
         *) echo -e "\e[92mInvalid input, try again.\e[39m"
         ;;
      esac
   done
}

RecentDownload () {
   echo
   while read -p $'\e[1mHow many recent videos do you wish to download? (0 to go back): \e[0m' qty;
   do
      IntsOnly $qty
      retval=$?
      if [ "$retval" == 2 ]; # user entered 0, go back
      then
         return
      elif [ "$retval" == 0 ];
      then
         echo
         ./.giant_bomb_cli.py -l $qty --quality hd --download
         # $(dirname "${BASH_SOURCE[0]}")/blah when complete so bigdogpitbull and .py can be moved to PATH
         break
      fi
   done
}

PreSearch () {
   menuFlag=0 # menu options print if 0 to prevent stdout clutter
   while true;
   do
      if [ "$menuFlag" == 0 ];
      then
         echo -e "\n\e[1mHow would you like to search?\e[0m"
         echo "   0. Cancel"
         echo "   1. By key terms and/or video type"
         echo "   2. By video ID"
         menuFlag=1
      fi
      read -p $'\e[1mEnter your choice: \e[0m' searchOpt;
      case $searchOpt in
         0) break
         ;;
         1) Search
         menuFlag=0
         ;;
         2) IDSearch
         menuFlag=0
         ;;
         *) echo -e "\e[92mInvalid input, try again.\e[39m"
         ;;
      esac
   done
}

# TODO:
#    add download prompt
IDSearch () {
   while read -p $'\e[1mEnter video ID (0 to go back): \e[0m' vID;
   do
      IntsOnly $vID
      retval=$?
      if [ "$retval" == 2 ]; # if input was 0, go back
      then
         return
      elif [ "$retval" == 0 ]; # if input was a valid integer, proceed to command
      then
         echo
         ./.giant_bomb_cli.py --filter --id $vID
      fi
      break
   done
}

# TODO:
#    add "q to quit to menu" option
Search () {
   menuFlag=0
   while true;
   do
      if [ "$menuFlag" == 0 ];
      then
         echo -e "\n\e[1mWould you like to filter by video type?\e[0m"
         echo "   0. Back to search menu"
         echo "   1. No video type filter"
         echo "   2. Video Reviews"
         echo "   3. Quick Looks"
         echo "   4. TANG"
         echo "   5. Endurance Run"
         echo "   6. Events"
         echo "   7. Trailers"
         echo "   8. Features"
         echo "   9. Premium"
         echo "   10. Extra Life"
         echo "   11. Encyclopedia Bombastica"
         echo "   12. Unfinished"
         echo "   13. Metal Gear Scanlon"
         echo "   14. VinnyVania"
         echo "   15. Breaking Brad"
         echo "   16. Best of Giant Bomb"
         echo "   17. Game Tapes"
         echo "   18. Kerbal: Project B.E.A.S.T."
         menuFlag=1
      fi
      read -p $'\e[1mEnter your choice: \e[0m' videoType
      case $videoType in
         0) return
         ;;
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
         echo -e "You entered: \e[1mFeatures\e[0m"
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
         16) videoType=20
         echo -e "You entered: \e[1mBest of Giant Bomb\e[0m"
         ;;
         17) videoType=21
         echo -e "You entered: \e[1mGame Tapes\e[0m"
         ;;
         18) videoType=22
         echo -e "You entered: \e[1mKerbal: Project B.E.A.S.T.\e[0m"
         ;;
         *) echo -e "\e[92mInvalid input, try again.\e[39m"
         continue
         ;;
      esac
      while read -p $'\e[1mEnter search terms (0 to go back): \e[0m' searchTerms;
      do
         menuFlag=0 # for if user opts to return to video type filter menu
         if [ "$searchTerms" != 0 ]; # if user did not opt to go back, continue
         then
            while read -p $'\e[1mHow many videos would you like to list? (0 to go back): \e[0m' qty;
            do
               IntsOnly $qty
               retval=$?
               if [ "$retval" == 2 ]; # if input was 0, go back to previous prompt
               then
                  break
               elif [ "$retval" == 0 ]; # if input was a valid integer, proceed to command
               then
                  backFlag=0 # will return to # videos to list if set to 1
                  echo -e "\e[1mSort in...\e[0m"
                  echo "   0. Cancel"
                  echo "   1. Ascending order?"
                  echo "   2. Descending order?"
                  while read -p $'\e[1mEnter your choice: \e[0m' ord;
                  do
                     case $ord in
                        0) backFlag=1
                        ;;
                        1) sort="asc"
                        ;;
                        2) sort="desc"
                        ;;
                        *) echo -e "\e[92mInvalid input, try again.\e[39m"
                        continue
                        ;;
                     esac
                     break
                  done
                  if [ "$backFlag" == 1 ];
                  then
                     continue # return to # of videos listed prompt
                  fi
                  echo
                  if [ "$videoType" == 0 ]; # if no video type was selected
                  then
                     ./.giant_bomb_cli.py -l $qty --filter --name "$searchTerms" --sort "$sort"
                  else
                     ./.giant_bomb_cli.py -l $qty --filter --name "$searchTerms" --video_type "$videoType" --sort "$sort"
                  fi
                  echo -e "\n\e[1mWould you like to download these videos?\e[0m"
                  echo "   1. Yes, download them"
                  echo "   2. No, don't download them"
                  while read -p $'\e[1mEnter your choice: \e[0m' dl;
                  do
                     case $dl in
                        1) DownloadResults $qty $searchTerms $sort $videoType
                        return
                        ;;
                        2) return
                        ;;
                        *) echo -e "\e[92mInvalid input, try again.\e[39m"
                        continue
                        ;;
                     esac
                  done
               fi
               continue # return to list prompt if input is invalid
            done
            continue # user entered 0 at # of videos to list, so return to previous prompt
         else
            break # if user opted to go back during search terms prompt, return to video type list
         fi
      done
      continue # user entered 0; return to filter by video type prompt
   done
}

DownloadResults () {
   echo
   if [ "$4" == 0 ]; # if no video type was selected
   then
      ./.giant_bomb_cli.py -l "$1" --filter --name "$2" --sort "$3" --quality hd --download
   else
      ./.giant_bomb_cli.py -l "$1" --filter --name "$2" --video_type "$4" --sort "$3" --quality hd --download
   fi
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
