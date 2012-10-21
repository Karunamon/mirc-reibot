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

; 
; Author:    FiberOPtics - mirc.fiberoptics@gmail.com
;
; Usage:    $download(exportfile, HEAD, url)
;            $download(exportfile, GET,  url, 1-3 [,headers])
;            $download(exportfile, POST, url, 1-3, postdata [,headers])
;
; Info    - Allows you to download HTML/XML/data from http urls just like you would do with sockets.
;            The data refers to files like .exe, .zip, pictures, movies etc. basically anything that 
;            is not in text format, rather binary format. Unlike with sockets, usually no headers
;            will have to be specified, the code will find out itself what to send to the server.
;            This does not work for downloading from ftp locations.
;
;          - $download() returns $false if nothing has been written to the exportfile, or
;            if an error has occured during the download process. The error code and description
;            (if any) are echoed to the active window. $download() returns $true in all other cases.
;
;          - $download() will pause the current thread until all data has been downloaded, before 
;            continuing the code following it. It does however not freeze mIRC. This allows you to code
;            the download process in one single alias, with the code to parse the retrieved data. Code
;            examples can be found at the end of the documentation.
;            If you want to download something that is triggered in an on text event, then specify a
;            timer or signal, so that $download() is initiated on another thread.
;
;            on *:text:!download &:#chan: set %download.url $2 | .timer 1 0 myalias 
;            alias myalias ...
;
;            Note: Do not pass $2 as a parameter to the timer, because it would be evaluated twice,
;                  once when setting the timer, and once when triggering the timer. This means someone
;                  with bad intentions could exploit you by typing !download <bad identifier>
;                  This is not related to the snippet, but I thought I should mention it anyway.
;
;            on *:text:!download &:#chan: signal getfile $2
;            on *:signal:getfile: ...
;
;          - Note that this identifier is made primarily to be used to retrieve HTML/XML for parsing,
;            and the downloading of small files. It will normally work well on downloading bigger files
;            as well. In my tests I successfully downloaded a 33MB .exe from a http location. However,
;            there is no caching of any kind, so if something happens to either your connection, or the
;            server's connection, then you will lose all your data. Therefore it is advised not to 
;            use it to download big files.
;
;          - Unfortunately, due to current mIRC limitations, this snippet relies on the running
;            of VBScript in a .vbs file. This offers both positive and negative points:
;
;            * Positive is that the snippet waits to continue processing until all data has
;              been received, making code for retrieving data/html source very easy, as all code
;              can be put in one small alias.
;
;            * Another advantage is that any file transfer that you have initiated in mIRC with 
;              $download, doesn't need mIRC to do the actual downloading. That means even if you
;              close your mIRC, the downloads will continue and saved to the correct file when finished.
;
;            * On the other hand, the executing of a .vbs file may tick off certain AVG or anti-spyware
;              programs. I know for a fact that Microsoft anti-spyware software will complain about 
;              this if you have this setting enabled. Nothing I can do about it.
;
;        -  The COM object that takes care of downloading will remain open until the data has been
;            received. This means that it may be open for quite a while for downloading files, so be
;            careful that you don't accidentally close all COM objects. The connection wouldn't be lost,
;            but you wouldn't know anymore when it is finished, and the .vbs file wouldn't be deleted. 
;
;
; Requires:  mIRC 6.0, Windows ME or higher
;
; Install:  This is a snippet with the alias prefix, which must be copy/pasted to the Remote tab
;            in the Scripts Editor. alt+r -> tab "Remote" -> paste
;
; Params:
;
;        1) Exportfile
;        --------------
;        The retrieved data will be written to this file. You either specify the full path to the file
;        like: c:\some folder\myfile.jpg, or you just specify a filename like htmlsource.txt which will
;        then be saved in your main mIRC folder. You don't need to include the " " on filepaths with 
;        spaces in it, as the snippet takes care of this already.
;
;        2) GET, HEAD, POST
;        ------------------
;        The server will respond with headers followed by data when specifying GET/POST
;        The server will respond with only the headers when specifying HEAD.
;
;        When specifying POST, the postdata should be put in the 5th parameter.
;        
;        3) URL
;        -------
;        This is the actual url to the file/site that you want to download. Note that you can only
;        specify urls that start with http:// The snippet will prefix your url with http:// if it
;        doesn't contain it. It is very important to specify the correct full url to get the best
;        results. In other words, specify http://www.winamp.com/ instead of winamp.com or something.
;        
;        Note that the snippet does not support downloading from an ftp, just http links!
;
;        4) Bitmask (1-3)
;        ----------------
;        This parameter is a numeric value between 1 and 3, which specifies what you want to download:
;
;        1 = headers 
;        2 = body 
;        3 = both    
;
;        Note that because of this bitmask, you could specify a GET operation with bitmask 1,
;        which would only write the headers to the exportfile, thus simulating a HEAD. However,
;        the load on the server is bigger because a GET downloads both headers and data, whereas 
;        a HEAD only retrieves the headers.
;        
;        When downloading binary data like .exe, .zip, .rar, .dll, .jpg etc. files, you should 
;        only specify bitmask 2. Your file would otherwise be corrupted when you try to /run <file>
;        because the headers are not part of the data, thus shouldn't be included. You can of course
;        specify 3 to watch the headers, but you will need to remove them from the file before
;        trying to execute this file.
;
;        5) Headers 
;        ----------
;        As stated, you will usually not need to specify any header (not even Host: <the host>) as 
;        the snippet will figure this out by itsself usually. I added the option nevertheless to 
;        specify headers when necessary. It's possible of course that you need to add in some 
;        extra headers like cookie data etc. The format is:
;
;        Label: value  
;
;        To specify multiple headers seperate them by linefeeds ($lf) 
;        -> Cookie: <some cookie> $lf Connection: close 
;        
;        Note that I am automatically adding the following header with each method:
;        -> User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322)
;
;        In the case of a POST I am automatically adding the header:
;        -> Content-Type: application/x-www-form-urlencoded
;
;        Note that in case of a POST, the headers go in the 6th parameter, as the 5th is then preserved
;        for the postdata.
;
;
;      - Code samples (demonstrative):
;        -----------------------------
;
;        NEVER FORGET TO PUT THE URL INSIDE A VARIABLE IF IT CONTAINS COMMA's. 
;
;        alias showfile loadbuf $iif($active != status window,-pi $ifmatch,-spi)
;                
;        var %url = http://www.mirc.com/
;        if ($download(mirc_com.txt, GET, %url, 3)) showfile mirc_com.txt
;
;        var %url = http://mirc.stealth.net/download/mirc616.exe
;        if ($download(mirc616.exe, GET, %url , 2)) run mirc616.exe
;
;        var %url = http://www.google.com/search?hl=en&q=mirc
;        if (!$download(google.txt, GET, %url, 2)) echo -a Error querying google, try again.
;        else showfile google.txt
;      
;        var %url = http://www.mircscripts.org/download.php?id=2930&type=2
;        if (!$download(checkgmail.zip, GET, %url, 2)) echo -a Error downloading checkgmail.zip
;        else run checkgmail.zip
;      
;        var %url = http://www.foxnews.com/xmlfeed/rss/0,4313,1,00.rss
;        if ($download(foxnews.txt, GET, %url, 3)) showfile foxnews.txt
;
;        var %url = http://www.mirc.net/pictures/7ddab9fb3897453e8fee89b49d366ac4369e10ad.jpg
;        if ($download(fiberoptics.jpg, GET, %url, 2)) run fiberoptics.jpg
;
;        var %url = http://www.jobpredictor.com/jobbodynew.asp
;        var %postdata = email=fiberoptics&submit3=Submit+for+jobprediction
;        if ($download(predict.txt, POST, %url, 3, %postdata)) showfile predict.txt
;
;        var %url = http://world.altavista.com/tr
;        var %postdata = doit=done&intl=1&tt=urltext&trtext=this+is+a+test&lp=en_nl&btnTrTxt=Translate
;        if ($download(translate.txt, POST, %url, 3, %postdata)) showfile translate.txt
;        
;

alias download {
  var %r = $(|,) return $false, %e = scon -r !echo $color(info) -a $!!download: Error -
  if (!$isid) %e this snippet can only be called as an identifier. %r
  if ($os isin 9598) %e this snippet requires Windows ME or higher. %r
  if ($version < 6) %e this snippet requires mIRC version 6.0 or higher. %r
  var %dir = $nofile($1), %file = $nopath($1), %method = $upper($2), %url = $3
  var %bit = $4, %headers = $iif($2 == get,$5,$6), %postdata = " $+ $5", %res
  if (* !iswm %file) %e you must specify a file to save the data to. %r
  if (%file != $mkfn(%file)) %e file %file contains illegal characters. %r 
  if (* !iswm %dir) %dir = $mircdir
  elseif (!$isdir(%dir)) %e no such folder %dir %r
  if (!$istok(get head post,$2,32)) %e method can only be GET, HEAD or POST. %r
  if (!$regex(%e,$3,/^\S+\.\S+\.\S+$/)) %e you didn't specify an url to download from. %r
  if ($2 != head) {
    if ($4 !isnum 1-3) %e bitmask should be a digit in range 1-3. %r 
    if ($2 == post) && (* !iswm $5) %e you didn't specify any post data. %r
    if (%headers) && (!$regsub(%e,%headers,/(\S+?): (.+?)(?=\s?\n|$)/g,"\1" $chr(44) "\2",%headers)) {
      %e bad header syntax. Correct -> Label: value seperated by $!!lf's %r
    }
  }
  var %file = $+(",%dir,%file,"), %id = $+(@download,$ticks,$r(1111,9999),.vbs), %a = aline %id
  if (http://* !iswm $3) %url = http:// $+ $3
  .comopen %id wscript.shell 
  if ($comerr) %e could not open Wscript.Shell. %r
  write -c %file
  window -h %id
  %a on error resume next  
  %a sub quit $lf set http = nothing : set ado = nothing : wscript.quit $lf end sub
  %a sub errmsg 
  %a set fso = createobject("scripting.filesystemobject")
  %a set file = fso.createtextfile( %file ,true)
  %a file.write("Err number: " & err.number & " = " & err.description) : file.close
  %a set fso = nothing 
  %a quit
  %a end sub
  %a arr = array("winhttp.winhttprequest.5.1","winhttp.winhttprequest","msxml2.serverxmlhttp","microsoft.xmlhttp")
  %a i = 0 $lf while i < 4 and not isobject(http) : set http = createobject(arr(i)) : i = i + 1 : wend 
  %a if not isobject(http) then errmsg
  %a err.clear
  %a http.open $+(",%method,") , $+(",%url,") ,false
  %a http.setrequestheader "User-Agent","Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322)"
  if (%headers) { tokenize 10 %headers | scon -r %a http.setrequestheader $* }
  if (%method == post) {
    %a http.setrequestheader "Content-Type","application/x-www-form-urlencoded" 
    %a http.send %postdata
  }
  else %a http.send
  %a if err then errmsg
  %a set ado = createobject("adodb.stream") 
  %a if not isobject(ado) then errmsg
  %a ado.open
  if (%bit != 2) {
    %a ado.type = 2 : ado.charset = "ascii" 
    %a ado.writetext "HTTP/1.1 " & http.status & " " & http.statustext,1
    %a ado.writetext http.getallresponseheaders,1 : ado.position = 0 
  }
  if (%bit != 1) %a ado.type = 1 : ado.read : ado.write http.responsebody 
  %a ado.savetofile %file ,2 : ado.close : quit
  savebuf %id %id 
  close -@ %id
  .comclose %id $com(%id,run,1,bstr*,%id,uint,0,bool,true)
  .remove %id 
  %res = $read(%file,t,1) 
  if (Err number:*=* iswm %res) || (!$file(%file)) %e $iif(%res,%res,no data could be retrieved) - %url %r
  return $true 
  :error
  if ($com(%id)) .comclose %id
  if ($isfile(%id)) .remove %id
  if ($window(%id)) close -@ %id
  return $false
}
