; Kte dynamic script file
; Do not edit or unload this file while using Kte!
alias theme.text {
  if (!$var(%:echo)) { return $false }
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
  if ($isalias(kte:: $+ $1)) { kte:: $+ $1 | return $true }
  elseif (* iswm $hget(Kte_Theme, $1)) {
    var %ln
    set -n %ln $hget(Kte_Theme, $1)
    if ($gettok(%ln, 1, 32) == !Script) { set -n %ln $deltok(%ln, 1, 32) }
    else { set -n %ln % $+ :echo $dll($scriptdir $+ kte.dll, MTSPrecompile, %ln) $!+  % $+ :comments }
    .timerkte_theme 1 0 %ln | .timerkte_theme -e | return $true
  }
  return $false
}
alias kte_void

alias -l _entered {
  var %def = $readini($mircini, events, default), %set
  if (!%def) { %def = 0,0,0,0,0,0,0,0 }
  %set = $readini($mircini, events, $1)
  if (!%set) { %set = 0,0,0,0,0,0,0,0 }
  while ($findtok(%set, 0, 1, 44)) { %set = $puttok(%set, $calc($gettok(%def, $ifmatch, 44) + 1), $ifmatch, 44) }
  hadd Kte_Events $1 %set
}
alias -l _left {
  set -u0 %kte_chan $1
  var %i = $scon(0)
  while (%i) { if ($scon(%i) != $cid) && ($scon(%i).kte_haschan) { return } | dec %i }
  hdel Kte_Events $1
}
alias -l kte_haschan return $chan(%kte_chan)

alias -l _isactive if ($cid == $activecid) { return 1 } | return 0
alias -l _active if ($cid == $activecid) { return a } | return s
alias -l _ischat {
  var %n = $mid($1, 2)
  if (=* !iswm $1) { return 1 }
  if (=* iswm $1) && (($chat(%n)) || ($fserv(%n))) { return 1 }
  return 0
}

; events
on ^&*:JOIN:#:{
  if ($chan !ischan) { return }
  if ($nick == $me) { _entered $chan }
  var %tgt = $gettok($hget(Kte_Events, $chan), 1, 44)
  if (%tgt = 3) && ($nick != $me) { haltdef | return }
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
set -nu1 %::target $target
if ($nick($chan, $nick).pnick != $nick) { set -nu1 %::cmode $left($ifmatch, 1) } | set -nu1 %::cnick $nick($chan, $nick).color
set -nu1 %::chan $chan
  if (%tgt = 2) { set -u1 %:echo echo $color(join) -sti2 }
  else { set -u1 %:echo echo $color(join) -ti2 $chan }
if ($nick == $me) { %:echo     11 12  01 $+ 01 joined %::chan $+  %:comments | haltdef }
else { %:echo     11 12  01 $+ 01 join: %::nick 12(11 $+ %::address $+ 12) $+  %:comments | haltdef }
unset %:echo %::nick %::address %::target %::me %::server %::port %::pre %::c? %::chan %::cmode %::cnick
}
on ^&*:PART:#:{
  if ($chan !ischan) { return }
  var %tgt = $gettok($hget(Kte_Events, $chan), 2, 44)
  if ($nick != $me) || (%tgt = 2) {
    if (%tgt = 3) { goto skip }
    if (%tgt = 2) { set -u1 %:echo echo $color(part) -sti2 }
    else { set -u1 %:echo echo $color(part) -ti2 $chan }
    set -nu1 %::text $strip($1-, o)
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
set -nu1 %::target $target
if ($nick($chan, $nick).pnick != $nick) { set -nu1 %::cmode $left($ifmatch, 1) } | set -nu1 %::cnick $nick($chan, $nick).color
set -nu1 %::chan $chan
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo $+(%::pre,,%::c1) part: %::nick $+(,%::c3,$chr(40),,%::c2,%::address,,%::c3,$chr(41)) $iif(%::text,$+(,%::c3,$chr(40),,%::c2,%::text,,%::c3,$chr(41))) | haltdef
unset %:echo %::nick %::address %::target %::parentext %::me %::server %::port %::pre %::c? %::chan %::cmode %::cnick %::text
  }
  :skip
  if ($nick == $me) { _left $chan }
}

on ^&*:QUIT:{
  var %i = $comchan($nick, 0), %tgt, %st = 0
  set -nu1 %::text $strip($1-, o)
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
  while (%i) {
    %::chan = $comchan($nick, %i)
    %tgt = $gettok($hget(Kte_Events, %::chan), 3, 44)
    if (%tgt = 4) { dec %i | continue }
    if (%tgt = 3) || (%tgt = 2) { %st = 1 }
if (!%tgt) || (%tgt = 3) || (%tgt = 1) { %:echo = echo $color(quit) -ti2 %::chan | %:echo $+(%::pre,,%::c1) quit: %::nick $+(,%::c3,$chr(40),,%::c2,%::address,,%::c3,$chr(41)) $iif(%::text,$+(,%::c3,$chr(40),,%::c2,%::text,,%::c3,$chr(41))) }
    dec %i
  }
  unset %::chan
if ($query($nick)) { %:echo = echo $color(quit) -ti2 $nick | %:echo $+(%::pre,,%::c1) quit: %::nick $+(,%::c3,$chr(40),,%::c2,%::address,,%::c3,$chr(41)) $iif(%::text,$+(,%::c3,$chr(40),,%::c2,%::text,,%::c3,$chr(41))) }
if (%st) { %:echo = echo $color(quit) -sti2 | %:echo $+(%::pre,,%::c1) quit: %::nick $+(,%::c3,$chr(40),,%::c2,%::address,,%::c3,$chr(41)) $iif(%::text,$+(,%::c3,$chr(40),,%::c2,%::text,,%::c3,$chr(41))) }
  haltdef
unset %:echo %::nick %::address %::parentext %::me %::server %::port %::pre %::c? %::text
}

on ^&*:NICK:{
  var %i = $comchan($newnick, 0), %tgt
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
  set -u1 %::newnick $newnick
if ($nick == $me) { %:echo = echo $color(nick) -sti2 | %:echo     11 12  01 $+ 01 nick: %::newnick $+  %:comments }
  while (%i) {
    set -u1 %::chan $comchan($newnick, %i)
    %tgt = $gettok($hget(Kte_Events, %::chan), 7, 44)
if (%tgt != 2) || ($nick == $me) { %:echo = echo $color(nick) -ti2 %::chan | %:echo     11 12  01 $+ 01 nick: %::nick 12(11 $+ %::address $+ 12)01 is now %::newnick $+  %:comments }
    dec %i
  }
if ($query($newnick)) { unset %::chan | %:echo = echo $color(nick) -ti2 $newnick | %:echo     11 12  01 $+ 01 nick: %::nick 12(11 $+ %::address $+ 12)01 is now %::newnick $+  %:comments }
  haltdef
unset %:echo %::nick %::address %::chan %::newnick %::me %::server %::port %::pre %::c?
}

on ^&*:USERMODE:{
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
  set -nu1 %::modes $1-
  set -u1 %:echo echo $color(mode) -sti2
%:echo     11 12  01 $+ 01 usermode: %::modes $+  %:comments | haltdef
  unset %::modes
unset %:echo %::nick %::address %::me %::server %::port %::pre %::c?
}
on ^&*:RAWMODE:#:{
  if ($chan !ischan) { return }
  var %tgt = $gettok($hget(Kte_Events, $chan), 4, 44)
  if (%tgt = 3) { haltdef | return }
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
set -nu1 %::target $target
if ($nick($chan, $nick).pnick != $nick) { set -nu1 %::cmode $left($ifmatch, 1) } | set -nu1 %::cnick $nick($chan, $nick).color
set -nu1 %::chan $chan
  if (%tgt = 2) { set -u1 %:echo echo $color(mode) -sti2 }
  else { set -u1 %:echo echo $color(mode) -ti2 $chan }
  set -nu1 %::modes $1-
%:echo     11 12  01 $+ 01 mode: %::nick 12(11 $+ %::address $+ 12) 01set: %::modes $+  %:comments | haltdef
  unset %::modes
unset %:echo %::nick %::address %::target %::me %::server %::port %::pre %::c? %::chan %::cmode %::cnick
}

on ^&*:TOPIC:#:{
  if ($chan !ischan) { return }
  var %tgt = $gettok($hget(Kte_Events, $chan), 5, 44)
  if (%tgt = 3) { haltdef | return }
  if (%tgt = 2) { set -u1 %:echo echo $color(topic) -sti2 }
  else { set -u1 %:echo echo $color(topic) -ti2 $chan }
  set -nu1 %::text $1-
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
set -nu1 %::target $target
if ($nick($chan, $nick).pnick != $nick) { set -nu1 %::cmode $left($ifmatch, 1) } | set -nu1 %::cnick $nick($chan, $nick).color
set -nu1 %::chan $chan
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo     11 12  01 $+ 01 %::nick sets topic: 12(11 $+ %::text $+ 12) $+  %:comments | haltdef
unset %:echo %::nick %::address %::target %::parentext %::me %::server %::port %::pre %::c? %::chan %::cmode %::cnick %::text
}
on ^&*:KICK:#:{
  if ($chan !ischan) { return }
  var %tgt = $gettok($hget(Kte_Events, $chan), 8, 44)
  if (%tgt = 3) && ($knick != $me) { haltdef | return }
  if (%tgt = 2) { set -u1 %:echo echo $color(kick) -sti2 }
  else { set -u1 %:echo echo $color(kick) -ti2 $chan }
  set -u1 %::knick $knick
  set -u1 %::kaddress $gettok($address($knick, 5), 2, 33)
  set -nu1 %::text $strip($1-, o)
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
set -nu1 %::target $target
if ($nick($chan, $nick).pnick != $nick) { set -nu1 %::cmode $left($ifmatch, 1) } | set -nu1 %::cnick $nick($chan, $nick).color
set -nu1 %::chan $chan
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
  if ($knick == $me) {
%:echo     11 12  01 $+ 01 You were kicked from %::chan by %::nick 12(11 $+ %::text $+ 12) $+  %:comments
    if (%tgt == 2) { set -u1 %:echo echo $color(kick) -ti2 $chan }
    else { set -u1 %:echo echo $color(kick) -seti2 }
%:echo     11 12  01 $+ 01 You were kicked from %::chan by %::nick 12(11 $+ %::text $+ 12) $+  %:comments
    _left $chan
  }
else { %:echo     11 12  01 $+ 01 kick: %::nick 12(11 $+ %::address $+ 12)01 kicked %::knick 12(11 $+ %::text $+ 12) $+  %:comments }
  haltdef
unset %:echo %::nick %::address %::target %::parentext %::knick %::kaddress %::me %::server %::port %::pre %::c? %::chan %::cmode %::cnick %::text
}

on ^&*:INVITE:#:{
  var %e = echo $color(invite) -ti2
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
set -nu1 %::chan $chan
set -nu1 %::target $target
  if ($_isactive) && (@* !iswm $active) && ($hget(Kte_Events, Active.Invites)) { set -u1 %:echo %e $+ a }
  else { set -u1 %:echo %e $+ s }
%:echo     11 12  01 $+ 01 invite: %::nick 12(11 $+ %::address $+ 12)01 invites you to join %::chan $+  %:comments | haltdef
unset %:echo %::nick %::address %::chan %::target %::me %::server %::port %::pre %::c?
}

on ^&*:ERROR:*:{
  set -u1 %:echo echo $color(other) -sti2 | set -nu1 %::text $2-
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo     11 12  01 $+ 01 error: %::text $+  %:comments | haltdef
unset %:echo %::nick %::parentext %::me %::server %::port %::pre %::c? %::text
}

on ^&*:NOTIFY:{
  set -u1 %:echo echo $color(notify) -ti2 $+ $iif(($_isactive) && (@* !iswm $active), a, s)
  set -nu1 %::text $notify($nick).note
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo     11 12  01 $+ 01 notify: %::nick 12(11 $+ %::address $+ 12) is on irc $+  %:comments | haltdef
unset %:echo %::nick %::address %::parentext %::me %::server %::port %::pre %::c? %::text
}
on ^&*:UNOTIFY:{
  set -u1 %:echo echo $color(notify) -ti2 $+ $iif(($_isactive) && (@* !iswm $active), a, s)
  set -nu1 %::text $notify($nick).note
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo     11 12  01 $+ 01 notify: %::nick 12(11 $+ %::address $+ 12) is off irc $+  %:comments | haltdef
unset %:echo %::nick %::address %::parentext %::me %::server %::port %::pre %::c? %::text
}

on ^&*:WALLOPS:*:{
  set -u1 %:echo echo $color(wallops) -ti2 $+ $iif(($_isactive) && (@* !iswm $active), a, s)
  set -nu1 %::text $strip($1-, o)
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
set -nu1 %::target $target
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo 11!01 $+ %::nick $+ 11!01 %::text $+  %:comments | haltdef
unset %:echo %::nick %::address %::target %::parentext %::me %::server %::port %::pre %::c? %::text
}

on &*:DNS:{
  set -u1 %:echo echo $color(info) -ti2 $+ $iif(($_isactive) && (@* !iswm $active), a, s)
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
  if ($dns(0)) {
    var %i = 1, %t = $dns(0)
    while (%i <= %t) {
      set -nu1 %::nick $dns(%i).nick
      set -nu1 %::address $dns(%i)
      set -nu1 %::iaddress $dns(%i).ip
      set -nu1 %::naddress $dns(%i).addr
      set -nu1 %::raddress $remtok($dns(%i).ip $dns(%i).addr, $dns(%i), 1, 32)
%:echo $str($chr(160) ,14) $+(,%::c1) resolved: %::raddress | haltdef
      inc %i
    }
  }
  else {
    set -nu1 %::nick $nick
    set -nu1 %::address $address
%:echo     11 12  01 $+(,%::c1) dns: unable to resolve %::address | haltdef
  }
unset %:echo %::nick %::address %::iaddress %::raddress %::naddress %::me %::server %::port %::pre %::c?
}

on ^&*:SNOTICE:*:{
  set -u1 %:echo echo $color(notice) -sti2
  set -nu1 %::text $strip($1-, o)
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::target $target
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo 11-01 $+ %::server $+ 11-01 %::text $+  %:comments | haltdef
unset %:echo %::nick %::target %::parentext %::me %::server %::port %::pre %::c? %::text
}

on &*:INPUT:*:{
  if ($0) && ((/* !iswm $1) || ($ctrlenter)) && (($active ischan) || ($query($active)) || (=* iswm $active)) && ($window($active, 0) = 1) {
    say $1- | halt
  }
}

alias say {
  if ($isid) { return }
  if ($status == disconnected) || (!$0) || (($active !ischan) && (!$query($active))) && (=* !iswm $active) {
    .timer.kte 1 0 !say $1- | .timer.kte -e | halt
  }
  .!msg $active $1-
  set -u1 %:echo echo $color(own) -ati2
  set -nu1 %::text $1- | set -u1 %::target $active | set -u1 %::nick $me
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
  if ($active ischan) {
    set -u1 %::chan $active
    if ($nick($active, $me).pnick != $me) { set -u1 %::cmode $left($ifmatch, 1) }
    set -u1 %::cnick $nick($active, $me).color
%:echo 11( $+ %::cmode $+ 01 $+ %::nick $+ 11) %::text $+  %:comments
  }
  else {
    set -u1 %::cnick $cnick($me).color
%:echo 11(01 $+ %::nick $+ 11) %::text $+  %:comments
  }
unset %:echo %::parentext %::target %::nick %::address %::chan %::cnick %::cmode %::me %::server %::port %::pre %::c? %::text
}
alias query {
  if ($isid) { return }
  if (!$0) { .timer.kte 1 0 !query | .timer.kte -e | halt }
  !query $1
  if ($0 > 1) {
    if (!$server) { .timer.kte 1 0 !query $1- | .timer.kte -e | halt }
    msg $1-
  }
}
alias msg {
  if ($isid) { return }
  if ($0 < 2) || ((=* !iswm $1) && ($status == disconnected)) || (!$_ischat($1)) {
    .timer.kte 1 0 !msg $1- | .timer.kte -e | halt
  }
  .!msg $1-
  if (!$show) { return }
  set -nu1 %::text $2- | set -u1 %::target $1 | set -u1 %::nick $me
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
  ; %::nick = $me. This is a matter of logic.
  ; Use <target> in your script, not <nick>, to refer to the recipient of the message.
  if ($1 ischan) || ($query($1)) || (=* iswm $1) {
    set -u1 %:echo echo $color(own) -ti2 $1
    if ($1 ischan) {
      if ($nick($1, $me).pnick != $me) { set -u1 %::cmode $left($ifmatch, 1) }
      set -u1 %::cnick $nick($1, $me).color
%:echo 11( $+ %::cmode $+ 01 $+ %::nick $+ 11) %::text $+  %:comments
    }
else { %:echo 11(01 $+ %::nick $+ 11) %::text $+  %:comments }
  }
  else {
    set -u1 %:echo echo $color(own) -ti2 $+ $_active
%:echo 11-> *01 $+ %::target $+ 11* %::text $+  %:comments | haltdef
  }
unset %:echo %::parentext %::target %::nick %::me %::server %::port %::pre %::c? %::chan %::cmode %::cnick %::text
}
alias amsg {
  if ($isid) { return }
  if ($status == disconnected) || (!$0) || (!$chan(0)) { .timer.kte 1 0 !amsg $1- | .timer.kte -e | halt }
  !.amsg $1-
  if (!$show) { return }
  set -nu1 %::text $1- | set -u1 %::nick $me
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
  var %i = $chan(0)
  while (%i) {
    set -u1 %::chan $chan(%i)
    set -u1 %::target %::chan
    set -u1 %:echo echo $color(own) -ti2 %::chan
    if ($nick($chan(%i), $me).pnick != $me) { set -u1 %::cmode $left($ifmatch, 1) }
    set -u1 %::cnick $nick(%::chan, $me).color
%:echo 11( $+ %::cmode $+ 01 $+ %::nick $+ 11) %::text $+  %:comments
    dec %i
  }
unset %:echo %::parentext %::nick %::cnick %::cmode %::chan %::target %::me %::server %::port %::pre %::c? %::text
}


alias me {
  if ($isid) { return }
  if (!$server) || (!$0) || (($active !ischan) && (!$query($active))) && (=* !iswm $active) {
    .timer.kte 1 0 !me $1- | .timer.kte -e | halt
  }
  .!describe $active $1-
  if (!$show) { return }
  set -u1 %:echo echo $color(action) -ati2
  set -nu1 %::text $1- | set -u1 %::target $active | set -u1 %::nick $me
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
  if ($active ischan) {
    set -u1 %::chan $active
    if ($nick($active, $me).pnick != $me) { set -u1 %::cmode $left($ifmatch, 1) }
    set -u1 %::cnick $nick($active, $me).color
  }
%:echo 11  $+ %::me %::text $+  %:comments
unset %:echo %::parentext %::target %::nick %::chan %::cnick %::cmode %::me %::server %::port %::pre %::c? %::text
}
alias action {
  if ($isid) { return }
  if (!$server) || (!$0) || (($active !ischan) && (!$query($active))) && (=* !iswm $active) {
    .timer.kte 1 0 !action $1- | .timer.kte -e | halt
  }
  me $1-
}
alias describe {
  if ($isid) { return }
  if (!$server) || ($0 < 2) || (!$_ischat($1)) {
    .timer.kte 1 0 !describe $1- | .timer.kte -e | halt
  }
  .!describe $1-
  if (!$show) { return }
  set -nu1 %::text $2- | set -u1 %::target $1 | set -u1 %::nick $1
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
  if ($1 ischan) || ($query($1)) || (=* iswm $1) {
    set -u1 %:echo echo $color(action) -ti2 $1
    if ($1 ischan) {
      set -u1 %::chan $1
      if ($nick($1, $me).pnick != $me) { set -u1 %::cmode $left($ifmatch, 1) }
      set -u1 %::cnick $nick($1, $me).color
%:echo 11  $+ %::me %::text $+  %:comments
    }
else { %:echo 11  $+ %::me %::text $+  %:comments }
  }
else { set -u1 %:echo echo $color(action) -ti2 $+ $_active | %:echo -> * $+ %::target $+ * %::text $+  %:comments }
unset %:echo %::parentext %::target %::chan %::cmode %::cnick %::nick %::me %::server %::port %::pre %::c? %::text
}
alias ame {
  if ($isid) { return }
  if (!$server) || (!$0) || (!$chan(0)) { .timer.kte 1 0 !ame $1- | .timer.kte -e | halt }
  !.ame $1-
  if (!$show) { return }
  set -nu1 %::text $1- | set -u1 %::nick $me
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
  var %i = $chan(0)
  while (%i) {
    set -u1 %::chan $chan(%i)
    set -u1 %::target %::chan
    set -u1 %:echo echo $color(action) -ti2 %::chan
    if ($nick(%::chan, $me).pnick != $me) { set -u1 %::cmode $left($ifmatch, 1) }
    set -u1 %::cnick $nick(%::chan, $me).color
%:echo 11  $+ %::me %::text $+  %:comments
    dec %i
  }
unset %:echo %::parentext %::target %::chan %::cnick %::cmode %::nick %::me %::server %::port %::pre %::c? %::text
}

alias notice {
  if ($isid) { return }
  if (!$server) || ($0 < 2) { .timer.kte 1 0 !notice $1- | .timer.kte -e | halt }
  .!notice $1-
  if (!$show) { return }
  set -nu1 %::text $2- | set -u1 %::target $1 | set -u1 %::nick $1
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
  set -u1 %:echo echo $color(notice) -ti2 $+ $_active
if ($1 ischan) { set -u1 %::chan $1 | %:echo 11-> -01 $+ %::target $+ 11- %::text $+  %:comments }
else { %:echo 11-> -01 $+ %::nick $+ 11- %::text $+  %:comments }
unset %:echo %::parentext %::target %::nick %::chan %::me %::server %::port %::pre %::c? %::text
}

on &^*:TEXT:*:#:{
  if ($chan !ischan) { return }
  set -u1 %:echo echo $color(normal) -mlbfti2 $chan
  set -nu1 %::text $strip($1-, o)
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
if ($nick($chan, $nick).pnick != $nick) { set -nu1 %::cmode $left($ifmatch, 1) } | set -nu1 %::cnick $nick($chan, $nick).color
set -nu1 %::chan $chan
set -nu1 %::target $target
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo 11( $+ %::cmode $+ 01 $+ %::nick $+ 11) %::text $+  %:comments | haltdef
unset %:echo %::nick %::address %::target %::parentext %::me %::server %::port %::pre %::c? %::chan %::cmode %::cnick %::text
}
on &^*:ACTION:*:#:{
  if ($chan !ischan) { return }
  set -u1 %:echo echo $color(action) -mlbfti2 $chan
  set -nu1 %::text $strip($1-, o)
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
if ($nick($chan, $nick).pnick != $nick) { set -nu1 %::cmode $left($ifmatch, 1) } | set -nu1 %::cnick $nick($chan, $nick).color
set -nu1 %::chan $chan
set -nu1 %::target $target
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo 11  $+ %::nick %::text $+  %:comments | haltdef
unset %:echo %::nick %::address %::target %::parentext %::me %::server %::port %::pre %::c? %::chan %::cmode %::cnick %::text
}
on &^*:NOTICE:*:#:{
  if ($chan !ischan) { return }
  set -u1 %:echo echo $color(notice) -mti2 $chan
  set -nu1 %::text $strip($1-, o)
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
if ($nick($chan, $nick).pnick != $nick) { set -nu1 %::cmode $left($ifmatch, 1) } | set -nu1 %::cnick $nick($chan, $nick).color
set -nu1 %::chan $chan
set -nu1 %::target $target
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo 11-01 $+ %::nick $+ : $+ %::target $+ 11- %::text $+  %:comments | haltdef
unset %:echo %::nick %::address %::target %::parentext %::me %::server %::port %::pre %::c? %::chan %::cmode %::cnick %::text
}

on &^*:CHAT:*:{
  if ($window(=$nick, 0) > 1) { return }
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
set -nu1 %::target $target
  if (ACTION * iswm $1-) {
    set -u1 %:echo echo $color(action) -mti2lbf =$nick
    set -nu1 %::text $strip($mid($1-, 8, -1), o)
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo 11  $+ %::nick %::text $+  %:comments | haltdef
  }
  else {
    set -u1 %:echo echo $color(normal) -mti2lbf =$nick
    set -nu1 %::text $strip($1-, o)
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo 11(01 $+ %::nick $+ 11) %::text $+  %:comments | haltdef
  }
unset %:echo %::nick %::address %::target %::parentext %::me %::server %::port %::pre %::c? %::text
}

on &^*:TEXT:*:?:{
  var %e = echo $color(normal) -mti2
  set -nu1 %::text $strip($1-, o)
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
set -nu1 %::target $target
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
  if ($query($nick)) {
    set -u1 %:echo %e $nick
%:echo 11(01 $+ %::nick $+ 11) %::text $+  %:comments | haltdef
  }
  else {
    if ($window(Message Window)) { set -u1 %:echo %e $+ d }
    elseif ($_isactive) && (@* !iswm $active) && ($hget(Kte_Events, Active.Queries)) { set -u1 %:echo %e $+ a }
    else { set -u1 %:echo %e $+ s }
%:echo 11*01 $+ %::nick $+ 11* %::text $+  %:comments | haltdef
  }
unset %:echo %::nick %::address %::target %::parentext %::me %::server %::port %::pre %::c? %::text
}
on &^*:ACTION:*:?:{
  var %e = echo $color(action) -mti2
  set -nu1 %::text $strip($1-, o)
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
set -nu1 %::target $target
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
if ($query($nick)) { set -u1 %:echo %e $nick | %:echo 11  $+ %::nick %::text $+  %:comments | haltdef }
  else {
    if ($window(Message Window)) { set -u1 %:echo %e $+ d }
    elseif ($_isactive) && (@* !iswm $active) && ($hget(Kte_Events, Active.Queries)) { set -u1 %:echo %e $+ a }
    else { set -u1 %:echo %e $+ s }
%:echo * %::nick %::text $+  %:comments | haltdef
  }
unset %:echo %::nick %::address %::target %::parentext %::me %::server %::port %::pre %::c? %::text
}
on &^*:NOTICE:*:?:{
  var %e = echo $color(notice) -mti2
  if ($_isactive) && (@* !iswm $active) && ($hget(Kte_Events, Active.Notices)) { set -u1 %:echo %e $+ a }
  else { set -u1 %:echo %e $+ s }
  set -nu1 %::text $strip($1-, o)
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
set -nu1 %::target $target
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo 11-01 $+ %::nick 11(01 $+ %::address $+ 11)- %::text $+  %:comments | haltdef
unset %:echo %::nick %::address %::target %::parentext %::me %::server %::port %::pre %::c? %::text
}

ctcp ^&*:*:?:kte_onctcp $1-
ctcp ^&*:*:#:kte_onctcp $1-
alias -l kte_onctcp {
  if ($1 == VERSION) || (($target == $me) && ($1 == DCC)) { return }
  var %ch = 0, %txt, %rpl
  if ($target != $me) { %ch = 1 }
  if ($target ischan) {
    var %tgt = $gettok($hget(Kte_Events, $chan), 6, 44)
    if (%tgt = 2) { set -u1 %:echo echo $color(ctcp) -sti2 }
    else { set -u1 %:echo echo $color(ctcp) -ti2 $target }
  }
  else {
    set -u1 %:echo echo $color(ctcp) -ti2 $+ $iif((@* !iswm $active) && ($_isactive) && ($hget(Kte_Events, Active.CTCPs)), a, s)
  }
  set -u1 %::ctcp $1
  set -n %txt $2-
  if ($1 == PING) { %txt = | set -n %rpl $1- }
  elseif ($1- == TIME) { set -n %rpl $1 $fulldate }
  elseif ($1- == FINGER) { set -n %rpl $1 $($fullname, 2) (-) Idle $idle second $+ $iif(($idle != 1), s) }
  set -nu1 %::text $strip(%txt, o)
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
if ($nick($chan, $nick).pnick != $nick) { set -nu1 %::cmode $left($ifmatch, 1) } | set -nu1 %::cnick $nick($chan, $nick).color
set -nu1 %::chan $chan
set -nu1 %::target $target
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
if (%ch) { %:echo 11[01 $+ %::nick $+ : $+ %::chan %::ctcp $+ 11] 01 $+ %::text $+  %:comments }
else { %:echo 11[01 $+ %::nick %::ctcp $+ 11] 01 $+ %::text $+  %:comments }
  if (%rpl) { !.ctcpreply $nick %rpl }
unset %:echo %::nick %::address %::target %::parentext %::me %::server %::port %::pre %::c? %::chan %::cmode %::cnick %::text
  haltdef
}

alias ctcp {
  if ($isid) { return }
  if ($0 < 2) || (!$server) || ($2 == DCC) { .timer.kte 1 0 !ctcp $1- | .timer.kte -e | return }
  .!ctcp $1-
  if (!$show) { return }
  set -u1 %::target $1
  set -u1 %::ctcp $upper($2)
  set -nu1 %::text $3-
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
  set -u1 %:echo echo $color(ctcp) -ti2 $+ $_active
if ($1 ischan) { set -u1 %::chan $1 | %:echo 11-> [01 $+ %::target %::ctcp $+ 11] 01 $+ %::text $+  %:comments }
else { set -u1 %::nick $1 | %:echo 11-> [01 $+ %::target %::ctcp $+ 11] 01 $+ %::text $+  %:comments }
unset %:echo %::parentext %::nick %::chan %::ctcp %::target %::me %::server %::port %::pre %::c? %::text
}

on &*:CTCPREPLY:*:{
  var %rpl | set -n %rpl $2-
  if ($1 == PING) && ($2- isnum 1- $+ $ctime) { %rpl = $duration($calc($ctime - $2)) }
  set -u1 %:echo echo $color(ctcp) -ti2 $+ $_active
  set -u1 %::ctcp $upper($1)
  set -nu1 %::text $strip(%rpl, o)
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::nick $nick
set -nu1 %::address $address
set -nu1 %::target $target
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo 11[01 $+ %::nick %::ctcp reply11] 01 $+ %::text $+  %:comments | haltdef
unset %:echo %::nick %::address %::target %::parentext %::ctcp %::me %::server %::port %::pre %::c? %::text
}

alias ctcpreply {
  if ($isid) { return }
  if ($0 < 2) || (!$server) { .timer.kte 1 0 !ctcpreply $1- | .timer.kte -e | return }
  .!ctcpreply $1-
  if (!$show) { return }
  set -u1 %:echo echo $color(ctcp) -ti2 $+ $_active
  set -u1 %::target $1
  set -u1 %::ctcp $upper($2)
  set -nu1 %::text $3-
  set -u1 %::nick $1
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo 11-> [01 $+ %::target %::ctcp reply11] 01 $+ %::text $+  %:comments
unset %:echo %::parentext %::ctcp %::target %::nick %::me %::server %::port %::pre %::c? %::text
}

alias dns {
  if ($isid) { return }
  if (!$0) || (($1 == -h) && ($0 = 1)) || ((. !isin $1) && ($1 != -h) && (!$server)) {
    .timer.kte 1 0 !dns $1- | .timer.kte -e | return
  }
  .!dns $1-
  if (!$show) { return }
  var %h = $1, %f
  if ($istok(-h -c, $1, 32)) { %f = $1 | %h = $2 }
  if (%f != -h) && (. !isin %h) && ($address(%h, 5)) { %h = $gettok($ifmatch, 2, 64) }
  set -u1 %:echo echo $color(info) -ti2 $+ $iif((@* iswm $active) && ($_isactive), s, a)
  set -u1 %::address %h
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
%:echo     11 12  01 $+(,%::c1) dns: resolving %::address
unset %:echo %::address %::me %::server %::port %::pre %::c?
}

; ----------------------------------------------------------------------
; Numeric (raw) events  ------------------------------------------------
; ----------------------------------------------------------------------

raw 002:*:set -u1 %::value $ [ $+ [ $0 ] ] | _doraw $1-
raw 003:*:if ($2-5 == this server was created) { set -u1 %::value $6- } | _doraw $1-
raw 221:*:set -u1 %::nick $me | set -u1 %::modes $2 | _doraw $1-
raw 250:*:set -u1 %::value $5 | _doraw $1-
raw 251:*:set -u1 %::users $4 | set -u1 %::text $7 | set -u1 %::value $10 | _doraw $1-
raw 255:*:set -u1 %::users $4 | set -u1 %::value $7 | _doraw $1-
raw 265:*:set -u1 %::users $5 | set -u1 %::value $7 | _doraw $1-
raw 266:*:set -u1 %::users $5 | set -u1 %::value $7 | _doraw $1-
raw 301:*:{
  if ($halted) { return }
  if ($hget(Kte_Whois)) { hadd Kte_Whois Away $3- | haltdef }
  else { set -u1 %::nick $2 | set -nu1 %::away $3- | set -nu1 %::text $3- | _doraw $1- }
}
raw 302:*:{
  if ($halted) || (!$isalias(kte::Raw.302)) { return }
  var %i = 2, %t = $0, %p, %addr, %pos
  while (%i <= %t) {
    %p = $ [ $+ [ %i ] ]
    %addr = $gettok(%p, 2, 61)
    %pos = $pos(%addr, $left($remove(%addr, +, -), 1), 1)
    set -u1 %::nick $gettok(%p, 1, 61)
    set -u1 %::address $mid(%addr, %pos)
    set -u1 %::value $left(%addr, $calc(%pos - 1))
    if ($right(%::nick, 1) == *) { %::nick = $left(%::nick, -1) | %::value = %::value $+ * }
    ._doraw $1-
    inc %i
  }
}

; /list
raw 321:*:if (!$halted) && ($isalias(kte::Raw.321)) { _doraw $1- }
raw 322:*:if (!$halted) && ($isalias(kte::Raw.322)) { _doraw $1- }
raw 323:*:if (!$halted) && ($isalias(kte::Raw.323)) { _doraw $1- }
; /links
raw 364:*:if (!$halted) && ($isalias(kte::Raw.364)) { _doraw $1- }
raw 365:*:if (!$halted) && ($isalias(kte::Raw.365)) { _doraw $1- }

raw 324:*:set -u1 %::chan $2 | set -u1 %::value $3- | set -u1 %::modes $3- | set -u1 %::text $3- | _doraw $1-
raw 329:*:set -u1 %::chan $2 | set -u1 %::value $asctime($3) | set -u1 %::text $3- | _doraw $1-
raw 333:*:set -u1 %::chan $2 | set -u1 %::nick $3 | set -u1 %::value $asctime($4) | set -u1 %::text %::value | _doraw $1-
raw 341:*:set -u1 %::nick $2 | set -u1 %::chan $3 | _doraw $1-
raw 352:*:{
  if ($2 != *) { set -u1 %::chan $2 }
  set -u1 %::address $+($3, @, $4)
  set -u1 %::wserver $5
  set -u1 %::nick $6
  set -u1 %::away $iif((h isin $7), H, G)
  set -u1 %::isoper is $iif((* !isin $7), not)
  set -u1 %::cmode $remove($7, *, H, G)
  set -u1 %::value $8
  set -u1 %::realname $9-
  _doraw $1-
}
raw 353:*:set -u1 %::chan $2 | set -u1 %::text $3- | _doraw $1-
raw 372:*:set -nu1 %::text $3- | _doraw $1-
raw 391:*:set -u1 %::text $3- | _doraw $1-

; whois
raw 311:*:{
  var %h = Kte_Whois
  if ($halted) { return }
  if ($hget(%h)) { showwhois Whois }
  if (* iswm $hget(Kte_Theme, Whois)) {
    if (!$hget(%h)) { hmake %h 4 }
    hadd %h Nick $2 | hadd %h Address $+($3, @, $4)
    hadd %h RealName $6-
    haltdef
  }
  if ($isalias(kte::Raw.311)) {
    set -u1 %::nick $2
    set -u1 %::address $+($3, @, $4)
    set -nu1 %::realname $6-
    ._doraw $1-
  }
}
raw 314:*:{
  var %h = Kte_Whois
  if ($halted) { return }
  if ($hget(%h)) { showwhois Whowas }
  elseif (* iswm $hget(Kte_Theme, Whowas)) {
    if (!$hget(%h)) { hmake %h 4 } | hadd %h Nick $2 | hadd %h Address $+($3, @, $4)
    hadd %h RealName $6- | haltdef
  }
  if ($isalias(kte::Raw.314)) {
    set -u1 %::nick $2 | set -u1 %::address $+($3, @, $4) | set -nu1 %::realname $6- | ._doraw $1-
  }
}
raw 319:*:{
  if ($halted) { return }
  if ($hget(Kte_Whois)) { hadd Kte_Whois Chan $hget(Kte_Whois, Chan) $3- | haltdef }
  if ($isalias(kte::Raw.319)) { set -u1 %::nick $2 | set -nu1 %::chan $3- | ._doraw $1- }
}
raw 312:*:{
  if ($halted) { return }
  if ($hget(Kte_Whois)) { hadd Kte_Whois WServer $3 | hadd Kte_Whois ServerInfo $4- | haltdef }
  if ($isalias(kte::Raw.312)) { set -u1 %::nick $2 | set -u1 %::wserver $3 | set -nu1 %::serverinfo $4- | ._doraw $1- }
}
raw 307:*:{
  if ($halted) { return }
  if ($hget(Kte_Whois)) { hadd Kte_Whois IsRegd is | haltdef }
  if ($isalias(kte::Raw.307)) { set -u1 %::nick $2 | set -u1 %::isregd is | ._doraw $1- }
}
raw 313:*:{
  if ($halted) { return }
  if ($hget(Kte_Whois)) { hadd Kte_Whois IsOper is | hadd Kte_Whois OperLine $3- | haltdef }
  if ($isalias(kte::Raw.313)) { set -u1 %::nick $2 | set -u1 %::isoper is | set -nu1 %::operline $3- | ._doraw $1- }
}
raw 317:*:{
  if ($halted) { return }
  if ($hget(Kte_Whois)) { hadd Kte_Whois IdleTime $3 | hadd Kte_Whois SignonTime $4 | haltdef }
  if ($isalias(kte::Raw.317)) {
    set -u1 %::nick $2
    set -u1 %::idletime $3
    set -u1 %::signontime $asctime($4)
    ._doraw $1-
  }
}
raw 318:*:{
  if ($halted) { return }
  if ($hget(Kte_Data, ..NoNick)) { hdel Kte_Data ..NoNick | halt }
  if ($hget(Kte_Whois)) { showwhois Whois | hfree Kte_Whois | haltdef }
  if ($isalias(kte::Raw.318)) { set -nu1 %::nick $2 | ._doraw $1- }
}
raw 369:*:{
  if ($halted) { return }
  if (* iswm $hget(Kte_Data, ..NoNick)) { hdel Kte_Data ..NoNick | halt }
  if ($hget(Kte_Whois)) { showwhois Whowas | hfree Kte_Whois | haltdef }
  if ($isalias(kte::Raw.369)) { set -nu1 %::nick $2 | ._doraw $1- }
}

raw *:*:{
  if (6* iswm $numeric) || ($halted) { return }
  if ($numeric = 303) && (!$2-) { Kte_error - $+ $_active The specified nicks are not online | haltdef }
  set -u1 %::nick $2 | set -u1 %::chan $2 | set -u1 %::value $2
  _doraw $1-
}
; /_doraw str <params>
alias -l _doraw {
  var %cl = info2, %f, %n = $right(00 $+ $numeric, 3)
  if ($istok(401 404, $numeric, 32)) { hadd Kte_Data ..NoNick $2 }
  elseif (* iswm $hget(Kte_Data, ..NoNick)) { hdel Kte_Data ..NoNick }
  if ($halted) && ($show) { goto end }
  if ($istok(331 332 333, $numeric, 32)) { %cl = topic }
  elseif ($numeric = 372) { %cl = normal }
  set -u1 %::numeric $numeric
  set -u1 %::fromserver $nick
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
set -nu1 %::target $target
  if ($istok(324 328 329 331 332 333 352 353 366 367 368 404 482, $numeric, 32)) {
    var %ch = $2 | if ($numeric = 353) { %ch = $3 }
    set -u1 %::chan %ch
    if (%ch ischan) { %f = -ti2 %ch }
    set -u1 %::value $3
    if (!$var(%::text)) { set -nu1 %::text $3- }
  }
  if (!$isalias(kte::Raw. $+ %n)) {
    if (!%f) { %f = -ti2 $+ $iif(($_isactive) && ($status != connecting) && (@* !iswm $active), a, s) }
    set -u1 %:echo echo $color(%cl) %f
    if (!$var(%::text)) { set -nu1 %::text $2- }
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
%:echo 01 $+ %::text $+  %:comments
  }
  else {
    if ($istok(403 405 437 442 467 468 471 473 474 475 477 478, $numeric, 32)) {
      set -u1 %::chan $2
      if ($numeric = 478) { set -u1 %::value $3 | set -nu1 %::text $4- }
      elseif (!$var(%::text)) { set -nu1 %::text $3- }
    }
    elseif ($istok(432 433 436 438, $numeric, 32)) { set -nu1 %::text $3- }
    elseif ($numeric = 301) {
      if (!$hget(Kte_Events, Active.Away)) { %f = -ti2s }
      elseif ($query($2)) { %f = -ti2 $2 }
    }
    if (!%f) { %f = -ti2 $+ $iif(($_isactive) && ($status != connecting) && (@* !iswm $active), a, s) }
    if (!$var(%::text)) {
      if ($var(%::nick)) || ($var(%::chan)) || ($var(%::value)) { set -nu1 %::text $3- }
      else { set -nu1 %::text $2- }
    }
    set -u1 %:echo echo $color(%cl) %f
if (* iswm %::text) { set -nu1 %::parentext 11(01 $+ %::text $+ 11) }
    $+(kte::Raw., %n)
  }
  haltdef
  :end
unset %:echo %::nick %::address %::chan %::modes %::wserver %::target %::parentext %::fromserver %::value %::numeric %::away %::isoper %::cmode %::realname %::me %::server %::port %::pre %::c? %::text
}

alias -l showwhois {
  var %h = Kte_Whois
  if (!$hget(%h, IsOper)) { hadd %h IsOper is not }
  if (!$hget(%h, IsRegd)) { hadd %h IsRegd is not }
set -nu1 %::me $me | set -nu1 %::server $server | set -nu1 %::port $port
set -nu1 %::pre     11 12  01
set -nu1 %::c1 01 | set -nu1 %::c2 11 | set -nu1 %::c3 12 | set -nu1 %::c4 06
  set -u1 %::nick $hget(%h, Nick) | set -u1 %::address $hget(%h, Address) | set -nu1 %::realname $hget(%h, RealName)
  set -nu1 %::chan $hget(%h, Chan) | set -u1 %::wserver $hget(%h, WServer) | set -nu1 %::serverinfo $hget(%h, ServerInfo)
  set -nu1 %::text $hget(%h, Text) | set -u1 %::isregd $hget(%h, IsRegd) | set -u1 %::isoper $hget(%h, IsOper)
  set -nu1 %::operline $hget(%h, OperLine) | set -u1 %::idletime $hget(%h, IdleTime)
  set -u1 %::signontime $asctime($hget(%h, SignonTime)) | set -nu1 %::away $hget(%h, Away)
  set -u1 %:echo echo $color(whois) -ti2 $+ $iif(($_isactive) && (@* !iswm $active) && ($hget(Kte_Events, Active.Whois)), a, s)
if ($1 == Whois) { luminosity.whois }
else { luminosity.whowas }
  hdel -w Kte_Whois *
unset %:echo %::nick %::address %::realname %::chan %::wserver %::serverinfo %::text %::isregd %::isoper %::operline %::idletime %::signontime %::away %::me %::server %::port %::pre %::c?
}


alias -l kte::Echo %:echo 01 $+ %::text $+  %:comments
alias -l kte::EchoTarget %:echo 01 $+ %::text $+  %:comments
alias -l kte::Error %:echo     11 12  01 $+ 01 error: %::text $+  %:comments
alias -l kte::RAW.221 %:echo     11 12  01 $+ 01 usermode: %::modes $+  %:comments
alias -l kte::Raw.301 %:echo     11 12  01 %::nick is away: %::text $+  %:comments
alias -l kte::RAW.432 %:echo     11 12  01 $+ 01 error:  $+ %::nick $+  invalid nickname $+  %:comments
alias -l kte::RAW.404 %:echo     11 12  01 $+ 01 error:  $+ %::chan $+  unable to send message $+  %:comments
alias -l kte::RAW.353 %:echo     11 12  01 $+ 01names 12(11 $+ %::chan $+ 12):01 %::text $+  %:comments
alias -l kte::RAW.341 %:echo     11 12  01 $+ 01 $+ %::nick invited to %::chan $+  %:comments
alias -l kte::RAW.005 %:echo %::text $+  %:comments
alias -l kte::RAW.473 %:echo     11 12  01 $+ 01 error:  $+ %::chan $+  invite only $+  %:comments
alias -l kte::Raw.302 %:echo     11 12  01 $+ 01 userhost %::nick $+ : %::address $+  %:comments
alias -l kte::RAW.433 %:echo     11 12  01 $+ 01 error:  $+ %::nick $+  is in use $+  %:comments
alias -l kte::RAW.421 %:echo     11 12  01 $+ 01 error:  $+ %::value $+  invalid command $+  %:comments
alias -l kte::RAW.366 %:echo     11 12  01 $+ 01end of /names %::chan $+  %:comments
alias -l kte::RAW.254 %:echo $+(%::pre,,%::c1,%::value) $iif(%::value == 1,channel,channels) formed
alias -l kte::Raw.303 %:echo     11 12  01 %::text are online $+  %:comments
alias -l kte::RAW.375 %:echo     11 12  01 $+ 01MOTD - %::server $+  %:comments
alias -l kte::RAW.255 %:echo     11 12  01 $+ 01I have %::users clients and %::value servers $+  %:comments
alias -l kte::RAW.471 %:echo     11 12  01 $+ 01 error:  $+ %::chan $+  is full $+  %:comments
alias -l kte::RAW.391 %:echo     11 12  01 $+ 01server time: %::text $+  %:comments
alias -l kte::Raw.332 %:echo     11 12  01 $+ 01 topic: 12(11 $+ %::text $+ 12)01 $+  %:comments
alias -l kte::RAW.372 %:echo 01 $+ %::text $+  %:comments
alias -l kte::RAW.252 %:echo $+(%::pre,,%::c1,%::value) $iif(%::value == 1,operator,operators) online
alias -l kte::Raw.408 %:echo     11 12  01 $+ 01 error:  $+ %::chan $+  you cannot use colors on this channel $+  %:comments
alias -l kte::RAW.333 %:echo $+(%::pre,,%::c1) set by: $+(,%::c3,$chr(40),,%::c2,%::nick,,%::c3,$chr(41),,%::c1) on $+(,%::c3,$chr(40),,%::c2,$asctime($ctime(%::text),ddd mmm dd $+ $chr(44) yyyy h:nn tt),,%::c3,$chr(41),,%::c1)
alias -l kte::RAW.329 %:echo $+(%::pre,,%::c1) channel created: $+(,%::c3,$chr(40),,%::c2,$asctime(%::text,ddd mmm dd $+ $chr(44) yyyy h:nn tt),,%::c3,$chr(41))
alias -l kte::RAW.265 %:echo     11 12  01 $+ 01Current local users: %::users max: %::value $+  %:comments
alias -l kte::RAW.253 %:echo     11 12  01 $+ 01 $+ %::value unknown connections $+  %:comments
alias -l kte::RAW.001 %:echo 01Welcome %::text $+  %:comments
alias -l kte::RAW.482 %:echo     11 12  01 $+ 01 error:  $+ %::chan $+  you aren't an op $+  %:comments
alias -l kte::RAW.401 %:echo     11 12  01 $+ 01 error:  $+ %::nick $+  no such nickname $+  %:comments
alias -l kte::RAW.266 %:echo     11 12  01 $+ 01Current global users: %::users max: %::value $+  %:comments
alias -l kte::RAW.250 %:echo     11 12  01 $+ 01 $+ %::value total connections $+  %:comments
alias -l kte::RAW.002 %:echo 01Your Host Is %::server $+ , running %::value $+  %:comments
alias -l kte::RAW.474 %:echo     11 12  01 $+ 01 error:  $+ %::chan $+  banned from channel $+  %:comments
alias -l kte::RAW.003 %:echo 01This server was created on %::value $+  %:comments
alias -l kte::Raw.251 %:echo     11 12  01 $+ 01There are %::users users online, %::text invisible, on %::value servers $+  %:comments
alias -l kte::RAW.475 %:echo     11 12  01 $+ 01 error:  $+ %::chan $+  key required $+  %:comments
alias -l kte::RAW.324 %:echo     11 12  01 $+ 01 modes: 12(11 $+ %::modes $+ 12)01 $+  %:comments
alias -l kte::RAW.403 %:echo     11 12  01 $+ 01 error:  $+ %::chan $+  no such channel $+  %:comments
alias -l kte::RAW.376 %:echo     11 12  01 $+ 01end of MOTD $+  %:comments
