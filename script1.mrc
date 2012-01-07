;#####################
;#  ReiBot Profiles  #
;#####################


;How many lines does someone have? This gets used to hell and back
alias getproflines {
  var %gpl = 1 
  if ( $readini(profiles.ini,n,$1,%gpl) == $null ) { return $null }
  while ($readini(profiles.ini,n,$1,%gpl) != $null) {
    inc %gpl
  }
  dec %gpl 1
  return %gpl
} 


;Simple Read
on $*:TEXT:/\?\? /S:*: {
  if ($getproflines($2) == $null) {
    .notice $nick No record found. 
  }
  else {
    var %line = 1
    $dex( msg $chan Got $getproflines($2) lines for $nick )
    while (%line <= $getproflines($2)) {
      msg $chan $readini(profiles.ini,n,$2,%line)
      inc %line
    }
  }
}


;Simple Write
on $*:TEXT:/\!learn /S:*: {
  if ($getproflines($2) == $null) {
    $dex( msg $chan Creating new profile for $2 $+ , and assigned to $nick $+ . Timestamp: $fulldate )
    .writeini -n profiles.ini $2 1 $3-
    .writeini -n profiles.ini $2 SetBy $nick
    .writeini -n profiles.ini $2 SetTime $fulldate
  }
  else {
    if ($readini(profiles.ini,n,$2,SetBy) != $nick) || ($nick != %rbmaster)  {
      $dex( Deined profile write for $nick on $2 owned by $readini(profiles.ini,n,$2,SetBy) )
      notice $nick No permission. Only $readini(profiles.ini,n,$2,SetBy) can change that.
      return
    }
    $dex( msg $chan Profile already exists for $2 $+, append mode selected )
    var %line = $getproflines($2)
    inc %line
    $dex( msg $chan Inserting line for $2 at position %line $+ . Timestamp: $fulldate )
    writeini -n profiles.ini $2 %line $3-
    writeini -n profiles.ini $2 SetTime $fulldate
  }
}
