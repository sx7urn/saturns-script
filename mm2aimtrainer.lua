local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MM2 Aim Trainer",
   Icon = "sword", -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "MM2 Aim Trainer",
   LoadingSubtitle = "by @sx7urn",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "what"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Key System",
      Subtitle = "MM2 Aim Trainer",
      Note = "Solar Hub Key: mm2aimtrainerbeta:3", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"mm2aimtrainerbeta:3"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local PlayerTab = Window:CreateTab("Player", "user") -- Title, Image
local Section = PlayerTab:CreateSection("Player")

local Input = PlayerTab:CreateInput({
   Name = "Walk Speed",
   CurrentValue = "16",
   PlaceholderText = "WalkSpeed",
   RemoveTextAfterFocusLost = false,
   Flag = "WalkSpeedInput",
   Callback = function(Text)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Text)
   end,
})

local Input = PlayerTab:CreateInput({
   Name = "Jump Power",
   CurrentValue = "50",
   PlaceholderText = "JumpPower",
   RemoveTextAfterFocusLost = false,
   Flag = "playerjumppower",
   Callback = function(Text)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = (Text)
   end,
})

local BotTab = Window:CreateTab("Bot", "bot") -- Title, Image
local Section = BotTab:CreateSection("Settings")

local Input = BotTab:CreateInput({
   Name = "Bot's Walkspeed",
   CurrentValue = "",
   PlaceholderText = "Walkspeed",
   RemoveTextAfterFocusLost = false,
   Flag = "botwalkspeed",
   Callback = function(Text)
       local WalkSpeedValue = tonumber(Text)

       if WalkSpeedValue then
           local args = {
               [1] = game:GetService("Players").LocalPlayer:WaitForChild("Walkspeed"),
               [2] = WalkSpeedValue
           }

           game:GetService("Players").LocalPlayer:WaitForChild("ChangeValue"):FireServer(unpack(args))
       else
           Rayfield:Notify({
               Title = "Invalid Input",
               Content = "Please enter a valid number.",
               Duration = 6.5,
               Image = "triangle-alert",
           })
       end
   end,
})
local Input = BotTab:CreateInput({
   Name = "Input Example (JumpPower)",
   CurrentValue = "",
   PlaceholderText = "Input JumpPower",
   RemoveTextAfterFocusLost = false,
   Flag = "Input1",
   Callback = function(Text)
       local JumpPowerValue = tonumber(Text)

       if JumpPowerValue then
           local args = {
               [1] = game:GetService("Players").LocalPlayer:WaitForChild("JumpPower"),
               [2] = JumpPowerValue
           }

           game:GetService("Players").LocalPlayer:WaitForChild("ChangeValue"):FireServer(unpack(args))
       else
           Rayfield:Notify({
               Title = "Invalid Input",
               Content = "Please enter a valid number for JumpPower.",
               Duration = 6.5,
               Image = "triangle-alert",
           })
       end
   end,
})

local Input = BotTab:CreateInput({
   Name = "Input Example (Innocents)",
   CurrentValue = "",
   PlaceholderText = "Input Innocents",
   RemoveTextAfterFocusLost = false,
   Flag = "Input1",
   Callback = function(Text)
       local InnocentsValue = tonumber(Text)

       if InnocentsValue then
           local args = {
               [1] = game:GetService("Players").LocalPlayer:WaitForChild("Innocents"),
               [2] = InnocentsValue
           }

           game:GetService("Players").LocalPlayer:WaitForChild("ChangeValue"):FireServer(unpack(args))
       else
           Rayfield:Notify({
               Title = "Invalid Input",
               Content = "Please enter a valid number for Innocents.",
               Duration = 6.5,
               Image = "triangle-alert",
           })
       end
   end,
})
