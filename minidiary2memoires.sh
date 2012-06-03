#!/bin/bash
which perl >/dev/null 2>&1 || echo perl needed
which perl >/dev/null 2>&1 || exit
which sqlite3 >/dev/null 2>&1 || echo sqlite3 needed
which sqlite3 >/dev/null 2>&1 || exit
which mogrify >/dev/null 2>&1 || echo "imagemagick (mogrify) needed"
which mogrify >/dev/null 2>&1 || exit
which zip >/dev/null 2>&1 || echo "zip needed"
which zip >/dev/null 2>&1 || exit
rm -rf output > /dev/null 2>&1
rm -rf tmp > /dev/null 2>&1
mkdir -p output/attachements/images
mkdir -p output/attachements/images/thumb
mkdir -p output/attachements/tcache
mkdir -p tmp
cp backup.properties output
echo "creating basic memoires database"
cat memories.sql |sqlite3 output/memories.db3
echo "reading minidiary database, extracting images and creating sqlimport script"
perl readminidiary.pl > tmp/import.sql
echo "creating thumb images"
cp -a output/attachements/images/*.jpg output/attachements/images/thumb/
for i in output/attachements/images/thumb/*.jpg;do mogrify -resize 50% $i;done
echo "importing minidiary data into memoires database"
cat tmp/import.sql |sqlite3 output/memories.db3
echo "creating zipfile"
cd output
touch memories.db3-journal
zip -q -r ../tmp/memoires_backup.1.zip *
zip -q -d ../tmp/memoires_backup.1.zip attachements/images/
zip -q -d ../tmp/memoires_backup.1.zip attachements/images/thumb/
zip -q -d ../tmp/memoires_backup.1.zip attachements/tcache/
zip -q -d ../tmp/memoires_backup.1.zip attachements/
cd ..
ls -ald tmp/memoires_backup.1.zip
echo "copy tmp/memoires_backup.1.zip to your sdcard (/sdcard/backups/memoires/)"
