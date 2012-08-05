;################
;#ReiBot Updater#
;################

;Stash registration information into a file so a mirc.ini refresh doesn't unregister us.
alias stashreg {
  var %reguser = $readini(mirc.ini,n,user,username)
  var %reglicense = $readini(mirc.ini,n,user,license)
  var %regvalid = $readini(mirc.ini,n,user,validated)
  ;writeini -n registration.ini user username %reguser
  ;writeini -n registration.ini user license %reglicense
  ;writeini -n registration.ini user validated %regvalid
}

;Rewrite our registration data
alias writereg  {
  //writeini -n mirc.ini user username %reguser
  //writeini -n mirc.ini user license %reglicense
  //writeini -n mirc.ini use validated %regvalid 
}

;Kick off a git fetch
alias startupdate {
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
  //msg %rbchan Running hard update.
  //msg %rbchan Please do not attempt to use me for the next 30 seconds.
  run runupdate.bat
  .timer 1 30 reboot
}

;Must have been updated, let's reboot so we're in a consistent state.
alias reboot {
  //msg %rbchan Rebooting!
  writereg
  run reboot.bat
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
