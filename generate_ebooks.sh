#!/usr/bin/env bash

volumes=20
archive=c2.com_cgi_20150104

vol_to_generate=$1

if [ ! -d "$archive" ]; then
    curl -L -o $archive.7z https://archive.org/download/c2.com-wiki_201501/c2.com_cgi_20150104.7z
    7z x $archive.7z
fi

n=0
cd $archive
for i in *
do
    if [ $((n+=1)) -gt $volumes ]; then
        n=1
    fi

    if [[ ! -z $vol_to_generate && $n -ne $vol_to_generate ]]; then
        continue
    fi

    todir="../$archive"_$n
    [ -d "$todir" ] || mkdir "$todir"
    # Strip non-utf8
    iconv -o "$todir/$i" --verbose -f utf8 -t utf8 -c $i
done
cd ..

pandoc -o "${archive}_$vol_to_generate.epub" "${archive}_$vol_to_generate"/*.html
