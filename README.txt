titleizor - Add "subtitles" to (TIFF) images. 

Run the script without arguments to see usage and options. 

* USAGE

Single picture mode: 

  titleizor.pl -i my_picture.tif -o my_picture_with_title.tif -t "This is my picture"

Directory mode: 

  titleizor.pl -d ../images/ -v
  
The directory should contain a file called titles.txt, that lists the filenames and titles, separated by a comma, eg: 

picture1.tif,Title of picture1
picture2.tif,Mona Liza