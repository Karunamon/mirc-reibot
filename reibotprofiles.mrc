;#####################
;#  ReiBot Profiles  #
;#####################


;Get the number of lines for a profile
;This gets used and abused like you wouldn't believe.
alias getproflines {
  var %gpl = 1 
  if ( $readini(profiles.ini,n,$1,%gpl) == $null ) { return $null }
  while ($readini(profiles.ini,n,$1,%gpl) != $null) {
    inc %gpl
  }
  dec %gpl 1
  return %gpl
} 

;Alias for writing profiles locally
alias writeprofile {
  if ($getproflines($1) == $null) {
    echo -a Inserting line for $1
    .writeini -n profiles.ini $1 1 $2-
  }
  else {
    var %line = $getproflines($1)
    inc %line
    writeini -n profiles.ini $1 %line $2-
  }
}

;Read profile
on $*:TEXT:/^\?\? /S:*: {
  if ($getproflines($2) == $null) {
    .notice $nick No record found. 
  }
  else {
    var %line = 1
    $dex( msg $chan Got $getproflines($2) lines for $2 )
    while (%line <= $getproflines($2)) {
      msg $chan $readini(profiles.ini,n,$2,%line)
      inc %line
    }
  }
}

;Write profile
on $*:TEXT:/^\!learn /S:*: {
  if ($getproflines($2) == $null) {
    $dex( msg $chan Creating new profile for $2 $+ , and assigned to $nick $+ . Timestamp: $fulldate )
    .writeini -n profiles.ini $2 1 $3-
    .writeini -n profiles.ini $2 SetBy $nick
    .writeini -n profiles.ini $2 SetTime $fulldate
    .notice $nick New profile added successfully.
  }
  else {
    if ($readini(profiles.ini,n,$2,SetBy) != $nick) && ($nick != %rbmaster)  {
      $dex( msg $chan Denied profile write for $nick on $2 owned by $readini(profiles.ini,n,$2,SetBy) )
      notice $nick No permission. Only $readini(profiles.ini,n,$2,SetBy) can change that.
      return
    }
    $dex( msg $chan Profile already exists for $2 $+ , append mode selected )
    var %line = $getproflines($2)
    inc %line
    $dex( msg $chan Inserting line for $2 at position %line $+ . Timestamp: $fulldate )
    writeini -n profiles.ini $2 %line $3-
    writeini -n profiles.ini $2 SetTime $fulldate
    .notice $nick New line accepted.
  }
}

;Remove profile
on $*:TEXT:/^\!forget /S:*: {
  if ($getproflines($2) == $null) {
    .notice $nick No such profile exists.
  }
  else {
    $dex( msg $chan Running permissions check.. )
    if ($readini(profiles.ini,n,$2,SetBy) != $nick) && ($nick != %rbmaster) { 
      $dex( msg $chan Deined profile delete for $nick on $2 owned by $readini(profiles.ini,n,$2,SetBy) )
      notice $nick No permission. Only $readini(profiles.ini,n,$2,SetBy) can change that.
      halt
    }
    $dex( msg $chan Removing profile for $2 $+ , requested by $nick )
    remini -n profiles.ini $2
    .notice $nick Profile deleted.
  }
}
