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

* LICENCE

Copyright 2010 Magnus Enger Libriotech
 
This file is part of titleizor.
 
titleizor is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
 
titleizor is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License
along with titleizor. If not, see <http://www.gnu.org/licenses/>.

* Source code
 
Source code available from:
http://github.com/MagnusEnger/titleizor