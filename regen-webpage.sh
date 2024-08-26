#! /bin/bash

echo '<html>' > index.html
echo '<head>' >> index.html
echo '<title>My Manga Stats</title>' >> index.html
echo '<link rel="stylesheet" type="text/css" href="index.css">' >> index.html
echo '</head>' >> index.html
echo '<body>' >> index.html
echo '<div class = "title">' >> index.html
echo '<h1>My manga stats</h1>' >> index.html
echo '</div>' >> index.html
echo '<div class = "content">'>> index.html
echo '<div class = "container">' >> index.html
echo '<div class = "reading">' >> index.html
echo '<h2>Reading</h2>' >> index.html
awk -F'|' '$2~/^r/' manga.txt | awk -F'|' '{print "<div class = \"manga\"><h3>"$1"</h3>"$3"/"$4" "$5"★ </div>"}' >> index.html
echo '</div>' >> index.html
echo '<div class = "finished">' >> index.html
echo '<h2>Finished</h2>' >> index.html
awk -F'|' '$2~/^f/' manga.txt | awk -F'|' '{print "<div class = \"manga\"><h3>"$1"</h3>"$3"/"$4" "$5"★ </div>"}' >> index.html
echo '</div>' >> index.html
echo '<div class = "dropped">' >> index.html
echo '<h2>Dropped</h2>' >> index.html
awk -F'|' '$2~/^d/' manga.txt | awk -F'|' '{print "<div class = \"manga\"><h3>"$1"</h3>"$3"/"$4" "$5"★ </div>"}' >> index.html
echo '</div>' >> index.html
echo '<div class = "on_hold">' >> index.html
echo '<h2>On hold</h2>' >> index.html
awk -F'|' '$2~/^h/' manga.txt | awk -F'|' '{print "<div class = \"manga\"><h3>"$1"</h3>"$3"/"$4" "$5"★ </div>"}' >> index.html
echo '</div>' >> index.html
echo '<div class = "plan_to_read">' >> index.html
echo '<h2>Plan to read</h2>' >> index.html
awk -F'|' '$2~/^p/' manga.txt | awk -F'|' '{print "<div class = \"manga\"><h3>"$1"</h3>"$3"/"$4" "$5"★ </div>"}' >> index.html
echo '</div>' >> index.html
echo '</div>' >> index.html
echo '</body>' >> index.html
echo '</html>' >> index.html
