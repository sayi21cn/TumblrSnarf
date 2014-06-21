#!/usr/bin/env bash
#
echo ""
echo "================================================================"
echo -e "\e[1;37m TumblrSnarf - The Kenny Loggins of TumblrSnarfs\e[0m"
echo "================================================================"
echo ""
echo -e "What's snarfing? I bet its weird!"
echo ""
#
URLS=$(mktemp -t url-$$.XXXXXXXXXX)
SPEC=$(mktemp -t spec-$$.XXXXXXXXXX)
PROG=$(mktemp -t prog-$$.XXXXXXXXXX)
GOO="https://www.google.com/search"
APT="/api/read/json?num=10000&start=1&callback=jQuery171014495612293296067"
NOW=$(date +"%Y-%m-%d-%H%M%S")
################################################
hrny()
{
echo -e "\n\e[1;34m[*]\e[0m Searching for $kind\n"
lynx -dump -listonly -nonumbers -unique_urls -startfile_ok "$GOO?q=site:tumblr.com+$kind&num=25" |
sed -e 's/http/\n\nhttp/g'| 
egrep -v 'google' |
grep -v -e 'youtube' |
egrep -v '&sa=U&ei='| 
sed -e 's/&hl=*//' | 
sed -e 's/&ct=clnk//'|
sed 's/+.*//'|
grep -i 'tumblr.com'|
sort -u |
uniq >> $URLS
}
################################################
prep()
{
cat $PROG |while read line; do
echo -e "Site : " $line
lynx -dump -listonly -nonumbers "http://$line$APT"|
sed -e 's/\":"http/\nhttp/g' |
sed -e 's/.jpg/.jpg\n/g'|
egrep -i "\.jpg"|
sed -e 's/\\//g'|
egrep -i "1280.jpg$"|
sort -u |
uniq >> $SPEC
echo "";
done
}
################################################
read -p "What kinda pics ya wanna snarf? (use a + between words) : " kind
echo ""
echo -e "Really? You want $kind pictures? OK, hang on."
echo -e "\n\e[1;34m[*]\e[0m Creating folder..\e[0m"
target_folder=$kind$NOW
echo $target_folder
mkdir -p $target_folder
hrny
echo -e "Time to download a lot of $kind pictures.\e[0m"
cat $URLS |sed -n '4,$ s@^.*http://\([^/]*\).*$@\1@p'|grep -v -e "www.tumblr.com"|sort |uniq >> $PROG
echo ""
prep
	echo -e "\e[1;37m OH DEAR GOD! \e[0m"
sleep 2
echo -e "\n\e[1;34m[*]\e[0m Downloading...\e[0m"
################################################
wget -i $SPEC --tries=2 --user-agent=Snarfer/1.1 -P $target_folder/
echo -e "\n\e[1;34m[*]\e[0m Completed! The number of pictures you now have: \e[0m"
ls -1 $target_folder | wc -l
echo ""
rm $URLS
rm $SPEC
rm $PROG
echo -e "\n\e[1;34m[*]\e[0m Goodbye! \e[0m"
