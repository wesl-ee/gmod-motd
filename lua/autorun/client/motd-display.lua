local function DisplayMOTD(markup)
	local innerPadding = 56
	local outerPadding = 0
	local bottompanel = 30

	-- Avoid toaster mode if we're at a decent resolution
	if ScrW() > 800 then outerPadding = 100 end

	-- MOTD frame
	local panel = vgui.Create("DFrame")
	panel:SetPos(outerPadding/2, outerPadding/2)
	panel:SetSize(ScrW() - outerPadding, ScrH() - outerPadding)
	panel:SetTitle("Server Message of the Day")
	panel:ShowCloseButton(false)

	-- Free clout
	local unurl = vgui.Create("DLabel", panel)
	unurl:SetText("MOTDv1 by Prettyboy-Yumi")
	unurl:SetSize(150, 25)
	unurl:AlignRight()

	-- Content
	local html = vgui.Create("DHTML", panel)
	html:SetHTML(markup)
	html:SetPos(innerPadding/2, innerPadding/2)
	html:SetSize(ScrW() - outerPadding - innerPadding, ScrH() - outerPadding - innerPadding - bottompanel)

	-- Content controls (in case you click on a link or something)
	local ctrls = vgui.Create("DHTMLControls", panel)
	ctrls:SetWide((ScrW() - outerPadding - innerPadding - 60) / 2 )
	ctrls:SetPos(0, ScrH() - outerPadding - innerPadding / 2 - 10)
	ctrls:SetHTML(html)
	ctrls.RefreshButton:Hide()
	ctrls.StopButton:Hide()
	ctrls.BackgroundColor = Color(0, 0, 0, 0)
	ctrls.HomeButton.DoClick = function()
		html:SetHTML(markup)
	end

	-- Button to close the panel
	local button = vgui.Create("DButton", panel)
	button:SetText("Let's Play!")
	button:SetPos(0, ScrH() - outerPadding - innerPadding / 2 - 5)
	button:SetSize(100, 25)
	button:CenterHorizontal()
	button.DoClick = function(me)
		me:GetParent():Close()
		hook.Run("MOTDClose")
	end

	-- Show it off!
	panel:MakePopup()
	panel:SetVisible(true)
end

net.Receive("MOTD", function(l)
	-- Only respect server MOTD messages
	if IsValid(p) then return end

	-- Max MOTD size: 1 MiB (20 bits)
	local motdata = net.ReadData(l / 8)
	motdata = util.Decompress(motdata)

	DisplayMOTD(motdata)
end )
