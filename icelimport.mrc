;########################
;# ReiBot Icel Importer #
;########################
;v1.0
;This script is to import data from the Eggdrop script Icel
;REFERENCE: 32 is ascii space

alias icelimport {
  var %file = $?="Enter path to the icel-shared.dat file"
  echo -a Starting import from %file
  var %linenum = 2
  var %profline = 1
  var %linetot = $read(%file,0)
  while (%linenum <= %linetot) {
    echo -a Line %linenum of %linetot
    echo -a ENTERING PROCESS!
    remove newdate.txt
    var %line = $read(%file,%linenum)
    var %profile = $gettok(%line,4,32)
    var %text = $gettok(%line,5-,32)
    var %whoset = $gettok(%line,3,32)
    var %idate = $gettok(%line,1,32)
    var %url = http://tkware.info/mircdata.php?date= $+ %idate
    echo -a %url
    if ($getproflines(%profile) == $null) {
      writeini -n profiles.ini %profile %profline %text
      writeini -n profiles.ini %profile SetBy %whoset
      if (!$download(.\newdate.txt, GET, %url, 2)) { echo -a DATE CONVERSION ERROR -- Import halted. | halt }
      else { writeini -n profiles.ini %profile SetTime $read(.\newdate.txt,1) }
      inc %linenum
    }
    else {
      var %totlines = $getproflines(%profile)
      inc %totlines
      writeini -n profiles.ini %profile %totlines %text
      writeini -n profiles.ini %profile SetBy %whoset
      if (!$download(.\newdate.txt, GET, %url, 2)) { echo -a DATE CONVERSION ERROR -- Import halted. | halt }
      else { writeini -n profiles.ini %profile SetTime $read(.\newdate.txt,1) }
      inc %linenum
    }
  }
  echo -a 9PROCESS COMPLETE!
}
