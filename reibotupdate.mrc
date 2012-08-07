;################
;#ReiBot Updater#
;################

;Stash registration information into a file so a mirc.ini refresh doesn't unregister us.
;Using set because var didn't play nicely with write for some reason..
alias stashreg {
  ;Grab the reg info from the INI
  set %reguser $readini(mirc.ini,n,user,username)
  set %reglicense $readini(mirc.ini,n,user,license)
  set %regvalid $readini(mirc.ini,n,user,validated)
  ;Construct a batch file
  write registration.bat inifile mirc.ini [user] username= $+ $eval(%reguser)
  write registration.bat inifile mirc.ini [user] license= $+ $eval(%reglicense)
  write registration.Bat inifile mirc.ini [user] validated= $+ $eval(%regvalid)
  unset %reguser
  unset %reglicense
  unset %regvalid
}

;Kick off the update
alias startupdate {
  remove updatelog.log
  //msg %rbchan Checking for update..
  $dmmsg ( Starting update )
  $dmmsg ( 1: Checking for update.. )
  run getupdate.bat
  ;Wait to allow slow internet connections to succeed.
  .timer 1 7 verifyupdate
}

;Examine the output
alias verifyupdate { 
  if ($read(updatelog.log, r, \[up to date\].*master) != $null) {
    $dex($catnick(updatelog.log %rbchan))
    //msg %chan No update found.
    $dmmsg( No update found. )
  }
  else {
    $dmmsg( Found update.)
    //msg %rbchan Found update.
    $dex($catnick(updatelog.log %rbchan))
    runupdate
  }
}

;We've got files, let's do it!
alias runupdate {
  stashreg
  $dmmsg( 2: Running hard update )
  //msg %rbchan Running update. I'll be back in a few seconds.
  run runupdate.bat
  exit
}

CTCP *:UPDATE:* {
  if $ismaster($nick) {
    startupdate
  }
  else {
    .ctcpreply $nick UPDATE Access DENIED.
  }
}

;Ping the bot master with a status if we have an update log on startup
;on *:CONNECT:* {
;  if $isfile(updatelog.log) {
;    msg %rbmaster I ran an update! Here's the log:
;  }
;}
