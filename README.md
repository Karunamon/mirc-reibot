ReiBot for mIRC 7.x
===================

ReiBot is a mIRC-based IRC bot (but more accurately, a collection of scripts which, when combined, has bot-like behavior). Since mIRC provides a robust event handling system for everything from messages to socket connections, as well as a powerful scripting language, it is ideal for writing an automated IRC bot.

Current Features
----------------

* Definitions system

A method to retrieve information based on triggers. For instance, if you want to save your channel rules to recall later, the conversation would look like:

    <You> !learn Rules Don't whiz on the electric fence!
    <ReiBot> *Profile Stored*
    <You> ?? Rules
    <ReiBot> Don't whiz on the electric fence!

ReiBot was originally written to store character profiles for a role playing channel - hence why the word Profile is used; but don't let this stop you from using it for whatever you want!

There is also a script included which can import definitions from Icel, an Eggdrop TCL script with a similar definitions system.

ReiBot uses mIRC's INI handler to manage the definitions file - We've tested it with more than 500 profiles and the system remains responsive. The format looks like:

    [Profile Name]
    1=First Line of the profile
    2=Second line of the profile.. and so on
    WhoSet=Nickname of who did the !learn
    SetTime=Last updated datestamp in long format


* Auto update system

This allows you to keep Reibot up to date with this git repo or any other. Simply invoke /startupdate from Reibot or just say "Rei, update yourself" in the channel.
You can use your own git repo simply by changing what your origin/master points to. Needless to say, you must have git installed for this to work.


Planned Features
----------------

ReiBot is in active use by me, and therefore active development. Here's what's on my radar.

Priority 1 is probably going to be in the next release. Priority 5 will be done in my copious free time :)

* A public commands system (Priority: 1)

For channel management, etc. If you can do it with private messages to ChanServ, you'll be able to do it in channel with a simple trigger. This system is going to be coded around Anope services intially (as that's what my home IRC network uses), but I hope to make it compatible with most services backends out there.

* Remote Access (Priority: 3)

Remotely access files and perform actions on the host system.

* Markov-chain chatterbot (Priority: 5)

* Note system (Priority: 2)

* Channel Games (Priority: 5)

Installing
----------

1.  Grab the git repo, and extract it to a folder of your choice.
2.  Just add mIRC! (the exe, that is)
3.  **(Important!)** Edit the aliases file to change the bot's master control password BEFORE starting for the first time.

Special Thanks
------

* Horst Schaeffer (http://www.horstmuc.de) - Inifile, basically makes the update system work.
* FiberOPtics  (mirc.fiberoptics@gmail.com) - mIRC download script, used with the Icel importer
* All the folks on #deviant at irc.frogbox.es - For much inspiration!
* Ayano - For many more great ideas, for keeping me going, for being more awesome than any one person has the right to be :)

License
-------
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/InteractiveResource" property="dct:title" rel="dct:type">ReiBot</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://tkware.info" property="cc:attributionName" rel="cc:attributionURL">Michael Parks</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="https://github.com/Karunamon/Reibot/" rel="dct:source">https://github.com/Karunamon/Reibot/</a>.