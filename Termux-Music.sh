#!/bin/bash

# while-menu-dialog: a menu driven system information program

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Termux-Music" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 4 \
    "1" "Termux-Music" \
    "2" "Open-Youtube" \
    "3" "Display Home Space Utilization" \
    "4" "Display System Information" \
    "5" "Display Disk Space" \
  2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    0 )
      clear
      echo "Program terminated."
      ;;
    1 )
      result =
      user_input=$(\
      dialog --title "Create Directory" \
      --inputbox "Enter Your Song URL/Path:" 8 40 \
      3>&1 1>&2 2>&3 3>&- \
      )

      mpv  "$user_input"
      ;;
    2 )
      result=$(am start --user 0 -n com.android.chrome/com.google.android.apps.chrome.Main)
      ;;
    3 )
      if [[ $(id -u) -eq 0 ]]; then
        result=$(du -sh /home/* 2> /dev/null)
        display_result "Home Space Utilization (All Users)"
      else
        result=$(du -sh $HOME 2> /dev/null)
        display_result "Home Space Utilization ($USER)"
      fi
      ;;
    4 )
      result=$(echo "Hostname: $HOSTNAME"; uptime)
      display_result "System Information"
      ;;
    5 )
      result=$(df -h)
      display_result "Disk Space"
     ;;    
     esac
     done
