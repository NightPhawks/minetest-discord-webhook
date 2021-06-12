# Discord Webhook for Minetest

Minetest mod that send report from Minetest to Discord using Webhook

## Installation

This mod can be installed like 
[any other Minetest mod](https://wiki.minetest.net/Installing_Mods)
but as it use the recent Minetest HTTP API and need to communicate 
with a webhook it need additional setup.

### Minetest HTTP API

Minetest HTTP API is a **recent** extension of the base Minetest Lua 
modding API allowing to **granted** mod to do HTTP request.

First of all your a version of Minetest of 5.4.0 or more, it also need 
to be build for cURL support.

You will also need to grant this mod the HTTP API access, for this you 
will have to edit manually your `minetest.conf` file by adding the 
line:

`secure.http_mods = discord_webhook`

OR

`secure.trusted_mods = discord_webhook`

NOTE: If your `minetest.conf` file already have `secure.http_mods` or `
secure.trusted_mods` entries you can just append `,discord_webhook` at 
the end of the line.

### Discord Webhook's ID and Token

Once you have ensured that Minetest can provide it's HTTP API, you 
will need to provide your webhook ID and Token.

To do so will need to [(create if it's not already done,) copy](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks) 
and split it's URL to gather the ID and Token. A webhook URL look like 
`https://discord.com/api/webhooks/<ID>/<Token>` while `<ID>` is the ID 
    and `<Token>` is the Token.

Then, you will need place them in your `minetest.conf` either by 
editing it manually like before by adding the lines:

```
dwh.id = <ID>
dwh.token = <Token>
```
either by simply use the Minetest in-game advanced settings menu.

## Features

All features are toggle-able

- Send a message when a player join
- Send a message when a player quit
- Send a message when a new player log in
- Send a message when someone tried to join with a wrong password (
disabled by default)
- Send a message when the server start (disabled by default)
- Send a message when the server shutdown (disabled by default, not
 work when server crash or in single player)
- Chat relay (disabled by default)
- Chat action (/me command) relay (disabled by default)
- Direct message to Discord (/dwh command, need the 'shout' privilege)
- Ability for webhook to take the player name when relaying chat

### Upcoming Features

- API allowing to communicate with other Minetest mod allowing them to 
send message
- Support for embedded format

## Troubleshooting

- The mod make the game crash on startup  
It mean that the mod has not been properly installed or you are using 
an invalid version of Minetest.

- Everything is setup correctly but nothing happen, not even an error
This may be caused by slightly outdated version of Minetest (5.3.0), or just you forgetting to activate the mod.