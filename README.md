ReiBot for mIRC 7.x
===================

ReiBot is a mIRC-based IRC bot (but more accurately, a collection of scripts which, when combined, has bot-like behavior). Since mIRC provides a robust event handling system for everything from messages to socket connections, as well as a powerful scripting language, it is ideal for writing an automated IRC bot.

Current Features
----------------

* A definitions system

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

1.  Make a fresh install of mIRC version 7 or greater. I suggest using c:\Reibot, but anything will work.
2.  Clone this repository into the mIRC folder.
3.  Change your mIRC options as you see fit
4.  **(Important!)** Edit the aliases file to change the bot's master control password! 