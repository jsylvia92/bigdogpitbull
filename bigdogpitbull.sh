#!/bin/bash

RE='^[0-9]+$'   # regex for user input error checking

#files for settings storage
CONFIGDIR=~/.bigdogpitbull
CONFIG=~/.bigdogpitbull/config

if [ ! -d "$CONFIGDIR" ]; then
   mkdir $CONFIGDIR
   echo -e "\e[1mCreated config directory\e[0m ~/.bigdogpitbull/"
fi
# separate checks in case the directory exists, but not the file
if [ ! -f "$CONFIG" ]; then
   exec 3>&1 >$CONFIG
   echo "hd"
   echo "0"
   exec >&3-
   echo -e "\e[1mCreated config file\e[0m ~/.bigdogpitbull/config"
fi

# read from config file
config=() # settings array. [0] is quality, [1] is offset
while read line
do
   config+=("$line")
done < $CONFIG

Menu () {
   menuFlag=0 # menu options print if 0 to prevent stdout clutter
   while true;
   do
      if [ "$menuFlag" == 0 ];
      then
         echo -e "\n\e[1mWhat would you like to do?\e[0m"
         echo "   1. Download recent videos"
         echo "   2. Search for videos"
         echo "   3. Settings"
         echo "   4. Quit"
         menuFlag=1
      fi
      read -p $'\e[1mEnter your choice: \e[0m' mainMenu;
      case "$mainMenu" in
         1) RecentDownload
         menuFlag=0
         ;;
         2) PreSearch
         menuFlag=0
         ;;
         3) Settings
         menuFlag=0
         ;;
         4) break
         ;;
         *) echo -e "\e[92mInvalid input, try again.\e[39m"
         ;;
      esac
   done
   echo
}

# TODO:
#    store settings in config file
Settings () {
   menuFlag=0
   while true;
   do
      if [ "$menuFlag" == 0 ];
      then
         echo -e "\n\e[1mSettings\e[0m"
         echo "   0. Return to main menu"
         echo "   1. Change video quality"
         echo "   2. Change results offset"
         echo "   3. Show video types stored in giant_bomb_cli.py"
         echo "   4. Help menu for giant_bomb_cli.py flags and usage"
         echo "   5. Version number of giant_bomb_cli.py"
         menuFlag=1
      fi
      read -p $'\e[1mEnter your choice: \e[0m' settingsMenu;
      case "$settingsMenu" in
         0) break
         ;;
         1) VideoQuality
         menuFlag=0
         ;;
         2) OffsetResults
         menuFlag=0
         ;;
         3) echo
         ./.giant_bomb_cli.py --dump_video_types
         menuFlag=0
         ;;
         4) echo
         ./.giant_bomb_cli.py --help
         menuFlag=0
         ;;
         5) echo
         ./.giant_bomb_cli.py --version
         menuFlag=0
         ;;
         *) echo -e "\e[92mInvalid input, try again.\e[39m"
         ;;
      esac
   done
}

VideoQuality () {
   menuFlag=0
   while true;
   do
      if [ "$menuFlag" == 0 ];
      then
         echo -e "\n\e[1mSet Video Quality\e[0m"
         echo -n "   1. HD"
         if [ "${config[0]}" == "hd" ];
         then
            echo -n " (current setting)"
         fi
         echo -ne "\n   2. High"
         if [ "${config[0]}" == "high" ];
         then
            echo -n " (current setting)"
         fi
         echo -ne "\n   3. Low"
         if [ "${config[0]}" == "low" ];
         then
            echo -n " (current setting)"
         fi
         echo
         menuFlag=1
      fi
      read -p $'\e[1mEnter your choice: \e[0m' qualityOpt;
      case "$qualityOpt" in
         1) config[0]=hd
         ;;
         2) config[0]=high
         ;;
         3) config[0]=low
         ;;
         *) echo -e "\e[92mInvalid input, try again.\e[39m"
         continue
         ;;
      esac
      # write settings to file
      cat > $CONFIG << EOL
         ${config[0]}
         ${config[1]}
EOL
      break
   done
}

OffsetResults () {
   echo -e "\n\e[1mSet Results Offset\e[0m"
   echo "   Current setting: ${config[1]}"
   while read -p $'\e[1mEnter results offset: \e[0m' qty;
   do
      IntsOnly "$qty"
      retval=$?
      if [ "$retval" == 1 ]; # user entered non-integral input
      then
         echo -e "\e[92mInvalid input, try again.\e[39m"
         continue # therefore, return to start of loop and try again
      else
         config[1]=$qty
         # write settings to file
         cat > $CONFIG << EOL
            ${config[0]}
            ${config[1]}
EOL
         return
      fi
   done
}

RecentDownload () {
   echo
   while read -p $'\e[1mHow many recent videos do you wish to download? (0 to go back): \e[0m' qty;
   do
      IntsOnly "$qty"
      retval=$?
      if [ "$retval" == 1 ]; # user entered non-integral input
      then
         echo -e "\e[92mInvalid input, try again.\e[39m" >&2;
      elif [ "$retval" == 2 ]; # user entered 0, go back
      then
         return
      elif [ "$retval" == 0 ];
      then
         echo
         ./.giant_bomb_cli.py -l "$qty" --offset "${config[1]}" --quality "${config[0]}" --download
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
      case "$searchOpt" in
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

IDSearch () {
   while read -p $'\e[1mEnter video ID (0 to go back): \e[0m' vID;
   do
      IntsOnly "$vID"
      retval=$?
      if [ "$retval" == 1 ]; # user entered non-integral input
      then
         echo -e "\e[92mInvalid input, try again.\e[39m"
         continue
      elif [ "$retval" == 2 ]; # if input was 0, go back
      then
         return
      elif [ "$retval" == 0 ]; # if input was a valid integer, proceed to command
      then
         echo
         ./.giant_bomb_cli.py --filter --id "$vID"
      fi
      break
   done
   echo -e "\n\e[1mWould you like to download this video?\e[0m"
   echo "   1. Yes, download it"
   echo "   2. No, don't download it"
   while read -p $'\e[1mEnter your choice: \e[0m' dl;
   do
      case "$dl" in
         1) ./.giant_bomb_cli.py --filter --id "$vID" --quality "${config[0]}" --download
         return
         ;;
         2) return
         ;;
         *) echo -e "\e[92mInvalid input, try again.\e[39m"
         continue
         ;;
      esac
   done
}

# TODO:
#    cry at how stupid big I let this function become
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
      case "$videoType" in
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
      while read -p $'\e[1mEnter search terms (0 to go back, q to search menu): \e[0m' searchTerms;
      do
         menuFlag=0 # for if user opts to return to video type filter menu
         if [ "$searchTerms" == "q" ];
         then
            return # quit to menu
         elif [ "$searchTerms" != 0 ]; # if user did not opt to go back, continue
         then
            while read -p $'\e[1mHow many videos would you like to list? (0 to go back, q to search menu): \e[0m' qty;
            do
               if [ "$qty" == "q" ];
               then
                  return # quit to menu
               fi
               IntsOnly "$qty"
               retval=$?
               if [ "$retval" == 1 ]; # user entered non-integral input
               then
                  echo -e "\e[92mInvalid input, try again.\e[39m"
                  continue
               elif [ "$retval" == 2 ]; # if input was 0, go back to previous prompt
               then
                  break
               elif [ "$retval" == 0 ]; # if input was a valid integer, proceed to command
               then
                  backFlag=0 # will return to # videos to list if set to 1
                  echo -e "\e[1mSort in...\e[0m"
                  echo "   0. Go back"
                  echo "   1. Ascending order?"
                  echo "   2. Descending order?"
                  while read -p $'\e[1mEnter your choice (q to search menu): \e[0m' ord;
                  do
                     case "$ord" in
                        0) backFlag=1
                        ;;
                        1) sort="asc"
                        ;;
                        2) sort="desc"
                        ;;
                        q) return
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
                     ./.giant_bomb_cli.py -l "$qty" --filter --name "$searchTerms" --offset "${config[1]}" --sort "$sort"
                  else
                     ./.giant_bomb_cli.py -l "$qty" --filter --name "$searchTerms" --video_type "$videoType" --offset "${config[1]}" --sort "$sort"
                  fi
                  echo -e "\n\e[1mWould you like to download these videos?\e[0m"
                  echo "   1. Yes, download them"
                  echo "   2. No, don't download them"
                  while read -p $'\e[1mEnter your choice: \e[0m' dl;
                  do
                     case "$dl" in
                        1) DownloadResults "$qty" "$searchTerms" "$sort" "$videoType"
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
               continue # return to list video qty prompt if input is invalid
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
      ./.giant_bomb_cli.py -l "$1" --filter --name "$2" --sort "$3" --offset "${config[1]}" --quality "${config[0]}" --download
   else
      ./.giant_bomb_cli.py -l "$1" --filter --name "$2" --video_type "$4" --sort "$3" --offset "${config[1]}" --quality "${config[0]}" --download
   fi
}

# returns 1 if non-integral, 2 if input is 0, and 0 is input is a nonzero integer
IntsOnly () {
   qty=$1
   if ! [[ $qty =~ $RE ]];
   then
      retval=1
   elif [ "$qty" == 0 ];
   then
      retval=2
   else
      retval=0
   fi
   return "$retval"
}

Menu
