#!/usr/bin/env bash
# Depends on:
#   title, description, link tags in rss
#   fzf
#   w3m # or use curl
#   wl-clipboard # if still on X, use xclip instead
# Author:
#   Sergey Samoylov

source ~/.config/aliasrc_bash_colors
clear

URL="https://www.kommersant.ru/RSS/main.xml"
# Kommers changes encoding in its rss sometimes. Watch out.
content=$(w3m -I utf-8 ${URL})

echo -e "${Black}${On_Blue}RSS Kommersant.ru:${Color_Off}\n"
echo -e "\t${Black}${On_Green}Note:${Color_Off}\n\tLast viewed title -> copied with link to clipboard in wayland\n"

titles=$(printf "%s\n" "$content" | grep -E '<title>' | awk -F'[<>]' '/<title>/{print $3}' | sed 's/.*\/\/ //' | tail -n +3)

descriptions=$(printf "%s\n" "$content" | grep -E '<description>' | awk -F'[<>]' '/<description>/{print $3}' | tail -n +2)

links=$(printf "%s\n" "$content" | grep -E '<link>' | awk -F'[<>]' '/<link>/{print $3}' | tail -n +3)

selected=$(paste <(echo "$titles") <(echo "$descriptions") <(echo "$links") | fzf --height 36 --delimiter '\t' --with-nth 1 --preview 'echo {} | cut -f2 | fmt -w 120' --preview-window=down:wrap --prompt "Поиск: ")

# copy last title and link to clipboard
echo "$selected" | cut -f1,3 | wl-copy

clear
