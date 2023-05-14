-- Prettyboy-yumi
-- Yumi <yumi@prettyboytellem.com>
-- April 16, 2020

-- Whitelist restrictions won't let us install a motd.txt ourselves
local function DefaultMOTD() return [[
<!DOCTYPE HTML>
<html>
<head><style>
body { font-family: "Meiryo", "MS PGothic", "sans-serif"; color: white }
h1, h2 { font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif }
</style><head>
<body>
<h1>Welcome to the server!</h1>
<p>This is the default MOTD; if you are the server op then you probably want to
change this by creating a file at <code>cfg/motd.txt</code> and putting your
own text or HTML MOTD. Here are some things you should probably include:
<ul>
	<li>Name of the server</li>
	<li>Basic rules</li>
	<li>Overview / explanation of the gamemode (if uncommon)</li>
	<li>Names / e-mails of admins who can help</li>
	<li>Link to an official website (if applicable)</li>
</ul>
<p>Other than that, you're free to do whatever you want however you want; hell,
you can even run Javascript in here. The code isn't licensed so you can do
anything just don't re-upload it without permission kthnx <img
src="https://cdn.prettyboytellem.com/web-content/smiley/grin.gif">. If you're
using this add-on and like it (or want to request a feature!) send me an
e-mail (yumi@prettyboytellem.com) or you can
<a href="https://steamcommunity.com/profiles/76561198067447023/">message me via
Steam</a></p>
<p>This project is also <a href="https://github.com/yumi-xx/gmod-motd">hosted on
Github</a> so you can browse the source freely and raise an issue / contribute
a fix if you find any bugs!</p>
</body>
</html>
]]
end

local function SendMOTD(p)
	-- Read from cfg/motd.txt file
	local data = file.Read("cfg/motd.txt", "GAME") or DefaultMOTD()

	-- No MOTD file!
	if !data then return end

	-- Stream MOTD file to the client via data
	net.Start("MOTD")
	net.WriteData(util.Compress(data))	-- File itself
	net.Send(p)
end

-- Pre-cache network strings
hook.Add("Initialize", "MOTDStrings", function()
	util.AddNetworkString("MOTD")
end )

-- Trigger the MOTD client-side
hook.Add("PlayerInitialSpawn", "SendMOTD", SendMOTD)

hook.Add("PlayerSay", "MOTD", function(p, text)
	if string.lower(text) == "/motd" || string.lower(text) == "!motd" then
		SendMOTD(p)
	end
end )
