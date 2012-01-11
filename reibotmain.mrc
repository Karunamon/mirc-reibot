;###############
;# ReiBot Main #
;###############

;Initialization handler
on *:LOAD:{
  $rbinit()
}

;CTCP Identity. Fucking mIRC..
ctcp *:VERSION: {
  .echo -a Recieved VERSION request from $nick $+ @ $+ $site
  .ctcpreply $nick VERSION %rbproduct %rbversion
  .ctcpreply $nick VERSION %rbcopyright
}

;Could I see some identificaption?
ctcp *:IDENTIFY: {
  $dex(msg $nick First token: $1)
  $dex(msg $nick Second token: $2)
  $dex(msg $nick Third token: $3)
  if ($2 == %rbpass) {
    set %rbmaster $nick
    .ctcpreply $nick IDENTIFY Access granted.
  }
  else .ctcpreply $nick IDENTIFY Access DENIED.
}

ctcp *:LOGOUT: {
  if $ismaster($nick) {
    //set %rbmaster %rbmasterdef
    .ctcpreply $nick LOGOUT You have logged out successfully.
  }
  else .ctcpreply $nick LOGOUT Nope.
}


;Basic commands handler
on *:TEXT:Rei,*:#:{
  $dex( msg $chan caught attention string)
  $dex( msg $chan working on $2-)
  if (identify yourself isin $2-) {
    msg $chan I am %rbproduct %rbversion - Channel services bot unit 00
  }
  elseif (debug mode alpha isin $2-) && $ismaster($nick)  {
    msg $chan Set to mode α 
    set %rbdebug 1
    .notice $nick WARNING! Debug mode is a SERIOUS security hole.ANY AND ALLtext preceeded by the attention string will be evaluated. DISABLE WHEN DONE!!! 
  }
  elseif (debug mode omega isin $2-) && $ismaster($nick) {
    msg $chan Set to mode Ω 
    set %rbdebug 0
  }
  ;  elseif (raw command mode isin $2-) && $ismaster($nick) {
  ;    msg $chan Ready.
  ;    set %rbraw 1
  ;  }  
  else msg $chan What?
}

;Raw commanda handler
;on *:TEXT:Rei,*:#:{
;if $ismaster($nick) && ( %rbraw == 1 ) {
;eval 
