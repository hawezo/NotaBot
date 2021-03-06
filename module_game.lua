-- Copyright (C) 2018 Jérôme Leclercq
-- This file is part of the "Not a Bot" application
-- For conditions of distribution and use, see copyright notice in LICENSE

local bot = Bot
local client = Client
local discordia = Discordia

Module.Name = "game"
Module.Global = true

function Module:GetConfigTable()
	return {
		{
			Array = true,
			Global = true,
			Name = "GameList",
			Description = "List of games",
			Type = bot.ConfigType.String,
			Default = {},
			Sensitive = true
		},
	}
end

function Module:OnLoaded()
	self.Clock = discordia.Clock()
	self.Counter = 0
	self.Clock:on("min", function ()
		self.Counter = self.Counter + 1
		if (self.Counter >= 3) then
			self:UpdateGame()
			self.Counter = 0
		end
	end)

	self.Clock:start()
	self:UpdateGame()
	return true
end

function Module:OnUnload()
	self.Clock:stop()
end

function Module:UpdateGame()
	local games = self.GlobalConfig.GameList
	local newGame = games[math.random(1, #games)]
	if (type(newGame) == "function") then
		newGame = newGame()
	end

	client:setGame(newGame)
end