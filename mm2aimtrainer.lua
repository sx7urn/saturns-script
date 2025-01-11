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
local PlayerSection = PlayerTab:CreateSection("Player")

local PlayerInput = PlayerTab:CreateInput({
   Name = "Walk Speed",
   CurrentValue = "16",
   PlaceholderText = "WalkSpeed",
   RemoveTextAfterFocusLost = false,
   Flag = "WalkSpeedInput",
   Callback = function(Text)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Text)
   end,
})

local PlayerInput = PlayerTab:CreateInput({
   Name = "Jump Power",
   CurrentValue = "50",
   PlaceholderText = "JumpPower",
   RemoveTextAfterFocusLost = false,
   Flag = "playerjumppower",
   Callback = function(Text)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = (Text)
   end,
})

local BotTab = Window:CreateTab("NPC", "bot") -- Title, Image

local BotSection = BotTab:CreateSection("Setting")

local BotParagraph = BotTab:CreateParagraph({Title = "Note", Content = "To change NPC's WalkSpeed/JumpPower/Amount, go to the MM2 Aim Trainer's NPC Settings to change!"})

local BotSection = BotTab:CreateSection("Combat")

local Button = BotTab:CreateButton({
   Name = "Kill NPC(s)",
   Callback = function()
   -- The command function to teleport to parts named "HumanoidRootPart"
local function teleportToInnoParts()
    local partName = "HumanoidRootPart" -- We are looking for parts named "HumanoidRootPart"
    local partsToTeleport = {}  -- Store the parts that match the name

    -- Collect all parts named "HumanoidRootPart"
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower() == partName:lower() and v:IsA("BasePart") then
            table.insert(partsToTeleport, v)
        end
    end

    -- If no parts are found, notify the user
    if #partsToTeleport == 0 then
        player:SendNotification({Title = "Error", Text = "No parts named 'HumanoidRootPart' found!"})
        return
    end

    -- Check if the player is seated and stand them up if needed
    local humanoid = player.Character and player.Character:FindFirstChildOfClass('Humanoid')
    if humanoid and humanoid.SeatPart then
        humanoid.Sit = false
        wait(0.1)  -- Short wait to allow the player to stand
    end

    -- Start an infinite loop to teleport the player continuously
    while true do
        for _, part in pairs(partsToTeleport) do
            wait(0.1)  -- Wait before teleporting to the next part
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = part.CFrame
            end
        end
    end
end

-- The function that fires the server event before teleporting
local function fireServerEvent()
    while true do
        local args = {
            [1] = 1
        }

        game:GetService("Players").LocalPlayer.Character.Knife.KnifeServer.SlashStart:FireServer(unpack(args))
        wait(0.1)
    end
         end
   end,
})
