#! /bin/bash

profile=profile.txt
username=$(sed 1!d $profile)
mangas=manga.txt
gender=$(sed 2!d $profile)
red="\033[31m"
blue="\033[34m"
green="\033[32m"
yellow="\033[33m"
magenta="\033[35m"
cian="\033[36m"
nocolor="\033[0m"
cv="chapter"
cvs="chapters"
current_list=""
name=""
line_number=""

login() {
	if [ "$(wc -l $profile | cut -d' ' -f1)" != "4" ]
	then
		clear
		echo " "
		echo " What's your name, onii-chan?"
		read -p " > " username
		echo " Noice to meet u"
		echo -e " Are you a weeb, $blue$username$nocolor-chan?"
		read -p " [y/n] > " weeb
		if [ "$weeb" = "n" ] || [ "$weeb" = "N" ]
		then
			exit
		fi
		echo " Are you degenerate?"
		read -p " [y/n] > "
		echo " Are you a waifu or a husbando tho?"
		read -p " [w/h] > " gender
		echo " Are you real?"
		read -p " [y/n] > " 
		echo " Are you part of the matrix?"
		read -p " [y/n] > "
		echo " Do you question reality?"
		read -p " [y/n] > "
		echo -e " What's your favorite color, $blue$username$nocolor-chan?"
		echo -e "$red [r]red$blue [b]blue$green [g]green$yellow [y]yellow$magenta [m]magenta$cian [c]cian$nocolor"
		read -p " [r/b/g/y/m/c] > " get_color1
		echo " What about a second favorite color?"
		echo -e "$red [r]red$blue [b]blue$green [g]green$yellow [y]yellow$magenta [m]magenta$cian [c]cian$nocolor"
		read -p " [r/b/g/y/m/c] > " get_color2
		echo " Nice taste bro"
		echo "$username" > $profile
		if [ "$gender" = "w" ] || [ "$gender" = "W" ]
		then
			echo "w" >> $profile
		elif [ "$gender" = "h" ] || [ "$gender" = "H" ]
		then
			echo "h" >> $profile
		fi
		echo -e "$get_color1" >> $profile
		echo -e "$get_color2" >> $profile
	fi
}

colors(){	
	get_color1=$(sed 3!d $profile)
	get_color2=$(sed 4!d $profile)
	case "$get_color1" in
		r | R)
			color1="$red"
			;;
		b | B)
			color1="$blue"
			;;
		g | G)
			color1="$green"
			;;
		y | Y)
			color1="$yellow"
			;;
		m | M)
			color1="$magenta"
			;;
		c | C)
			color1="$cian"
			;;
	esac

	case "$get_color2" in
		r | R)
			color2="$red"
			;;
		b | B)
			color2="$blue"
			;;
		g | G)
			color2="$green"
			;;
		y | Y)
			color2="$yellow"
			;;
		m | M)
			color2="$magenta"
			;;
		c | C)
			color2="$cian"
			;;
	esac
}

main() {
	username=$(sed 1!d $profile)
	clear
	echo " "
	echo -e "$color1 Ohayo $color2$username$color1-chan"
	echo -e "$color2 Did you read any manga today you$color1 baka$color2 ?!"
	echo -e "$color1 Anywhay, what would you want to do today$color2 baka onii-chan$color1?"
	echo " "
	echo -e "$color1 [r]$color2 Reading $(echo $count_reading)"
	echo -e "$color2 [f]$color1 Finished $(echo $count_finished)"
	echo -e "$color1 [p]$color2 Plan to read $(echo $count_plan_to_read)"
	echo -e "$color2 [d]$color1 Dropped $(echo $count_dropped)"
	echo -e "$color1 [h]$color2 On hold $(echo $count_on_hold)"
	echo -e "$color2 [a]$color1 Add new manga"
	echo -e "$color1 [s]$color2 Settings"
	echo -e "$color2 [t]$color1 Stats"
	echo -e "$color1 [q]$color2 Exit"
	echo -e "$color1"
	read -p " > " choice

	case "$choice" in
		r | R)
			current_list="r"
			edit_manga "$list_reading"
			;;
		f | F)
			current_list="f"
			edit_manga "$list_finished"
			;;
		p | P)
			current_list="p"
			edit_manga "$list_plan_to_read"
			;;
		d | D)
			current_list="d"
			edit_manga "$list_dropped"
			;;
		h | H)
			current_list="h"
			edit_manga "$list_on_hold"
			;;
		a | A)
			add_new
			;;
		t | T)
			paste <(stats) <(now_reading) | column -t -s $'\t'; echo ""
			;;
		s | S)
			settings
			;;
		q | Q)
			exit
			;;
		*)
			main
			;;
	esac
}

stats() {
	case "$gender" in
		h)
			actual_gender="husbando"
			;;
		w)
			actual_gender="waifu"
			;;
	esac
			
	clear
	echo ""
	echo -e "$color1 Weeb name: $color2$username-chan"
	echo -e "$color2 Gender: $color1$actual_gender"
	echo -e "$color1 Total mangas:$color2 $(($(echo $list_reading | wc -l)+$(echo $list_finished | wc -l)+$(echo $list_dropped | wc -l)+$(echo $list_plan_to_read | wc -l)+$(echo $list_on_hold | wc -l)))"
	echo -e "$color2 Reading:$color1 $(echo $list_reading | wc -l)"
	echo -e "$color1 Finished:$color2 $(echo $list_finished | wc -l)"
	echo -e "$color2 Dropped:$color1 $(echo $list_dropped | wc -l)"
	echo -e "$color1 On hold:$color2 $(echo $list_on_hold | wc -l)"
	echo -e "$color2 Plan to read:$color1 $(echo $list_plan_to_read | wc -l)"
}

now_reading() {
	now_reading=$(awk -F'|' '$2~/^r/' manga.txt | awk -v color1="$color1" -F'|' '{print color1" "$1}')
	echo " "
	echo -e "$color2 Now reading:"
	echo -e "$now_reading" | cut -d'|' -f1
	echo ""
}

add_new() {
	clear
	echo " "
	echo -e "$color1 What's the$color2 sauce$color1 of the manga?"
	echo -e "$color1 Please don't use '$color2|$color1'$color2"
	read -p " > " sauce
	echo -e "$color1 How many $cv does $color2$sauce$color1 have?$color2"
	read -p " > " chapters
	echo -e "$color1 Are you currently reading it$color2 [r]$color1, did you finished it$color2 [f]$color1, do you plan to read it$color2 [p]$color1, or did you dropped it$color2 [d]$color1?$color2"
	read -p " [r/f/p/d/h] > " get_state
	case "$get_state" in
		r | R)
			state="r"
			;;
		f | F)
			state="f"
			;;
		p | P)
			state="p"
			;;
		d | D)
			state="d"
			;;
		h | H)
			state="h"
			;;
		*)
			add_new
			;;
	esac
	case "$state" in
		r | d | h)
			echo -e "$color1 And wich chapter/volume did you read$color2 last time$color1?$color2"
			read -p " > " last_chapter
			echo -e "$color1 How many ★ do you give to this manga?$color2"
			read -p " > " rating
			;;
		f)
			last_chapter="$chapters"
			echo -e "$color1 How many ★ do you give to this manga?$color2"
			read -p " > " rating
			;;
		p)
			last_chapter="0"
			rating="0"
			;;
	esac
		echo "$sauce|$state|$last_chapter|$chapters|$rating" >> $mangas
	main
}

lists(){
	list_reading=$(awk -F'|' '$2~/^r/' $mangas | awk -v color2="$color2" -v color1="$color1" -v cv="$cv" -F'|' '{print color2$1color1": "cv": "color2$3"/"$4color1" rating: "color2$5"★ "}')
	count_reading=$(awk -F'|' '$2~/^r/' $mangas | wc -l)
	list_finished=$(awk -F'|' '$2~/^f/' $mangas | awk -v color2="$color2" -v color1="$color1" -v cv="$cv" -F'|' '{print color2$1color1": "cv"s: "color2$4color1" rating: "color2$5"★ "}')
	count_finished=$(awk -F'|' '$2~/^f/' $mangas | wc -l)
	list_dropped=$(awk -F'|' '$2~/^d/' $mangas | awk -v color2="$color2" -v color1="$color1" -v cv="$cv" -F'|' '{print color2$1color1": "cv": "color2$3"/"$4color1" rating: "color2$5"★ "}')
	count_dropped=$(awk -F'|' '$2~/^d/' $mangas | wc -l)
	list_plan_to_read=$(awk -F'|' '$2~/^p/' $mangas | awk -v color2="$color2" -v color1="$color1" -v cv="$cv" -F'|' '{print color2$1color1": "cv"s: "color2$4color1}')
	count_plan_to_read=$(awk -F'|' '$2~/^p/' $mangas | wc -l)
	list_on_hold=$(awk -F'|' '$2~/^h/' $mangas | awk -v color2="$color2" -v color1="$color1" -v cv="$cv" -F'|' '{print color2$1color1": "cv": "color2$3"/"$4color1" rating: "color2$5"★ "}')
	count_on_hold=$(awk -F'|' '$2~/^h/' $mangas | wc -l)
}

edit_manga(){
	clear
	echo " "
	echo -e "$color2 uwu$color1 Here you can edit your progress of this manga:$color2"
	name=$(name "$1" | cut -d':' -f1)
	line_number=$(line_number "$name")
	if [ "$name" = "" ]
	then 
		main
	else
		echo " $name"
		echo " "
		echo -e "$color1 What's wrong whit this manga??"
		echo -e "$color2 Edit status$color1 (s)"
		echo -e "$color1 Edit total $cvs$color2 (t)"
		echo -e "$color2 Edit current $cv$color1 (c)"
		echo -e "$color1 Edit rating$color2 (r)"
		echo -e "$color2 Edit name$color1 (n)"
		echo -e "$color1 Back$color2 (b)"
		echo " "
		read -p " > " edit
		case "$edit" in
			s | S)
				edit_status
				;;
			t | T)
				edit_total
				;;
			c | C)
				edit_current
				;;
			r | R)
				edit_rating
				;;
			n | N)
				edit_name
				;;
			*)
				main
				;;
		esac
	fi
}

edit_status(){
	clear
	echo " "
	echo -e "$color1 How do you categorize this manga: $color2$name"
	echo -e "$color1 [r]$color2 Reading"
	echo -e "$color2 [f]$color1 Finished"
	echo -e "$color1 [p]$color2 Plan to read"
	echo -e "$color2 [h]$color1 On hold"
	echo -e "$color1 [d]$color2 Dropped$color1"
	echo " "
	read -p " > " edit_state
	case "$edit_state" in
		r | R)
			new_state="r"
			;;
		f | F)
			new_state="f"
			;;
		p | P)
			new_state="p"
			;;
		h | H)
			new_state="h"
			;;
		d | D)
			new_state="d"
			;;
		*)
			main
			;;
	esac
	awk -v line_number="$line_number" -v new_state="$new_state" -F'|' 'NR==line_number{OFS=FS;$2=new_state} {print}' $mangas > tmp && mv tmp $mangas
	edit_next
	}

edit_total(){
	clear
	echo " "
	echo -e "$color1 How many $color2$cvs$color1 does $color2$name$color1 have?$color2"
	read -p " > " edit_total
	awk -v line_number="$line_number" -v edit_total="$edit_total" -F'|' 'NR==line_number{OFS=FS;$4=edit_total} {print}' $mangas > tmp && mv tmp $mangas
	edit_next
}

edit_current(){
	clear
	echo " "
	echo -e "$color1 Whats's the$color2 last $cv$color1 you read?$colo2"
	read -p " > " edit_current
	awk -v line_number="$line_number" -v edit_current="$edit_current" -F'|' 'NR==line_number{OFS=FS;$3=edit_current} {print}' $mangas > tmp && mv tmp $mangas
	edit_next
}

edit_rating(){
	clear
	echo " "
	echo -e "$color1 How many$color2 ★ $color1 do you give to$color2$name$color1?$color2"
	read -p " > " edit_rating
	awk -v line_number="$line_number" -v edit_rating="$edit_rating" -F'|' 'NR==line_number{OFS=FS;$5=edit_rating} {print}' $mangas > tmp && mv tmp $mangas
	edit_next
}

edit_name(){
	clear
	echo " "
	echo -e "$color1 So what's the$color2 REAL SAUCE$color1 of$color2$name$color1??!$color2"
	read -p " > " edit_name
	awk -v line_number="$line_number" -v edit_name="$edit_name" -F'|' 'NR==line_number{OFS=FS;$1=edit_name} {print}' $mangas > tmp && mv tmp $mangas
	edit_next
}

edit_next(){
	lists
	case "$current_list" in
		r)
			edit_manga "$list_reading"
			;;
		f)
			edit_manga "$list_finished"
			;;
		p)
			edit_manga "$list_plan_to_read"
			;;
		d)
			edit_manga "$list_droppen"
			;;
		h)
			edit_manga "$list_on_hold"
			;;
	esac
}

settings() {
	clear
	echo " "
	echo -e "$color1 What's wrong $color2$username$color1-chan?"
	echo " "
	echo -e "$color1 [p]$color2 Change primary color"
	echo -e "$color2 [s]$color1 Change secondary color"
	echo -e "$color1 [u]$color2 Change username"
	echo -e "$color2 [g]$color1 Change gender"
	echo -e "$color1 [b]$color2 Back"
	echo -e "$color1"
	read -p " > " option
	case "$option" in
		p | P)
			edit_color primary
			;;
		s | S)
			edit_color secondary
			;;
		u | U)
			edit_username
			;;
		g | G)
			edit_gender
			;;
		b | B)
			main
			;;
		*)
			settings
			;;
	esac
}

edit_color() {
	clear
	echo " "
	echo -e "$color1 P-please choose a new color$color2 $onii-chan"
	echo " "
	echo -e "$red [r]red,$blue [b]blue,$green [g]green,$yellow [y]yellow,$magenta [m]magenta,$cian [c]cian"
	echo -e "$color2"
	read -p " > " new_color
	case "$1" in
		primary)
			awk -v new_color="$new_color" -F'|' 'NR==3{OFS=FS;$1=new_color} {print}' $profile > tmp && mv tmp $profile
			;;
		secondary)	
			awk -v new_color="$new_color" -F'|' 'NR==4{OFS=FS;$1=new_color} {print}' $profile > tmp && mv tmp $profile
			;;
	esac
	colors
	main
}

edit_username() {
	clear
	echo " "
	echo -e "$color1 So u lied to me!"
	echo -e "$color2 Tell me your$color1 real name$color2 right$color1 here$color2 right$color1 now$color2!!"
	echo -e "$color1"
	read -p " > " new_username
	awk -v new_username="$new_username" -F'|' 'NR==1{OFS=FS;$1=new_username} {print}' $profile > tmp && mv tmp $profile
	main
}

edit_gender() {
	case "$gender" in
		h | H)
			show_gender="husbando"
			new_gender="w"
			;;
		w | W)
			show_gender="waifu"
			new_gender="h"
			;;
	esac
	clear
	echo " "
	echo -e "$color1 I KNEW IT!"
	echo -e "$color2 YOU ARE A$color1 TRAP"
	echo " "
	echo -e "$color1 Current gender: $color2$show_gender"
	echo -e "$color2 Sooo.. You want to change to your$color1 real gender$color2 or?"
	echo -e "$color1"
	read -p " [y/n] > " change_gender
	case "$change_gender" in
		y | Y)
			awk -v new_gender="$new_gender" -F'|' 'NR==2{OFS=FS;$1=new_gender} {print}' $profile > tmp && mv tmp $profile
			settings
			;;
		n | N)
			settings
			;;
		*)
			settings
			;;
	esac
}

name(){
	echo -e "$1" | fzf --ansi | cut -d'|' -f1
}

line_number(){
	grep -n "$1" $mangas | grep -Eo '^[^:]+'
}

login
colors
lists
main
