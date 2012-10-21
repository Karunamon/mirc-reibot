;#####ReiBot Aliases#####

;Full init for when we first load
rbinit {
  set %rbproduct ReiBot
  set %rbversion v0.1d
  set %rbcopyright CC(BY-NC-SA)2012 TKWare Enterprises Ltd, Some Rights Reserved
  set %rbpass foo
  set %rbmaster SomeAbsurdlyLongNameThatsLongerThanAnySaneIRCStandardSoThisExistsYetCantBeUsedUntilSetToSomethingElse
  set %rbmasterdef SomeAbsurdlyLongNameThatsLongerThanAnySaneIRCStandardSoThisExistsYetCantBeUsedUntilSetToSomethingElse
  set %rbchan #deviant
  echo -a %rbproduct %rbversion configuration initialized.
  return 1
}

;Light init done on each startup
rblightinit {
  set %rbversion 0.1d
  echo -a %rbproduct %rbversion ready!
}

ismaster {
  if ($1 == %rbmaster) { return $true }
  else { return $null }
}

isdebug {
  if (%rbdebug == 1) { return $true }
  else { return $null }
}


;catnick - Blast a file to someone over the wire
;beware of flooding off the network!
;$catnick ( file target )
catnick {
  var catlen = $lines($1)
  var cattrg = $2
  var catlin = 1
  var catfil = $1
  While (%catlin <= %catlen) {
    .msg %cattrg $read(%catfil,nt, %catlin)
    inc %catlin
  }
}

;Debug Functions
;The magnitude of this security hole compares favorably with the U.S. national debt.
;Control the value of %rbdebug carefully, or else!
dex {
  if $isdebug { $eval( $1- ) }
}
dsay {
  dex ( msg %rbchan $1- )
}
dpmsg {
  dex ( msg $1 $2- )
}
dmmsg {
  dpmsg ( %rbmaster $1- )
}

;mIRC Default Aliases
/op /mode # +ooo $$1 $2 $3
/dop /mode # -ooo $$1 $2 $3
/j /join #$$1 $2-
/p /part #
/n /names #$$1
/w /whois $$1
/k /kick # $$1 $2-
/q /query $$1
/send /dcc send $1 $2
/chat /dcc chat $1
/ping /ctcp $$1 ping
/s /server $$1-

;Reload
/recycle {
  //unload -rs reibotmain.mrc
  //load -rs reibotmain.mrc
}
