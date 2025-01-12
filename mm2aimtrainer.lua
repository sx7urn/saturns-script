local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MM2 Aim Trainer",
   Icon = 83578070161806, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "MM2 Aim Trainer",
   LoadingSubtitle = "by @sx7urn",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "mm2aimtrainer", -- Create a custom folder for your hub/game
      FileName = "saveconfig"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Key System",
      Subtitle = "MM2 Aim Trainer",
      Note = "Key: mm2aimtrainerbeta:3", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GratcbKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
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

local BotParagraph = BotTab:CreateParagraph({Title = "Note", Content = "To change NPC's WalkSpeed/JumpPower/Amount, go to the MM2 Aim Trainer's 'NPC Settings' to change! Maybe I'll try to figure how to change the values from the hub idk.."})

local BotSection = BotTab:CreateSection("Combat")

local player = game:GetService("Players").LocalPlayer
local teleporting = false  -- Track whether teleporting is active

-- Button creation
local Button = BotTab:CreateButton({
    Name = "Kill NPC(s)",
    Callback = function()
        if teleporting then
            Rayfield:Notify({
                Title = "Already Teleporting",
                Content = "You are already teleporting to NPCs!",
                Duration = 6.5,
                Image = "rewind",
            })
            return
        end

        -- Set teleporting to true to prevent multiple clicks
        teleporting = true

        -- Teleport function (renamed to tptonpc)
        local function tptonpc()
            local partName = "HumanoidRootPart"
            local rigsFolder = workspace:FindFirstChild("Rigs")  -- Find the "Rigs" folder in workspace

            -- Continuous teleporting until no parts are left in the "Rigs" folder
            while teleporting do
                -- Check if the "Rigs" folder exists
                if rigsFolder then
                    local partsToTeleport = {}

                    -- Collect all "HumanoidRootPart" from NPCs in the "Rigs" folder
                    for _, v in pairs(rigsFolder:GetDescendants()) do
                        if v.Name:lower() == partName:lower() and v:IsA("BasePart") then
                            table.insert(partsToTeleport, v)
                        end
                    end

                    -- If no parts found, stop the loop
                    if #partsToTeleport == 0 then
                        Rayfield:Notify({
                            Title = "Teleport Complete",
                            Content = "No NPCs left in the Rigs folder.",
                            Duration = 6.5,
                            Image = "rewind",
                        })
                        teleporting = false  -- Stop teleporting
                        break
                    end

                    -- Ensure the player isn't seated
                    local humanoid = player.Character and player.Character:FindFirstChildOfClass('Humanoid')
                    if humanoid and humanoid.SeatPart then
                        humanoid.Sit = false
                        task.wait(0.1)
                    end

                    -- Teleport to the first NPC part
                    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = partsToTeleport[1].CFrame  -- Teleport to the first part
                        table.remove(partsToTeleport, 1)  -- Remove the teleported part
                    end

                else
                    -- If "Rigs" folder doesn't exist, stop the loop
                    Rayfield:Notify({
                        Title = "Error",
                        Content = "'Rigs' folder not found in workspace!",
                        Duration = 6.5,
                        Image = "rewind",
                    })
                    teleporting = false
                    break
                end

                task.wait(0.1)  -- Small delay before checking again
            end
        end

        -- Server event firing
        local function fireServerEvent()
            -- Retrieve the equipped knife value dynamically
            local equippedKnifeName = player:FindFirstChild("EquippedKnife") and player.EquippedKnife.Value
            if not equippedKnifeName then
                Rayfield:Notify({
                    Title = "Error",
                    Content = "EquippedKnife StringValue not found or has no value!",
                    Duration = 6.5,
                    Image = "rewind",
                })
                teleporting = false
                return
            end
            
            local knife = player.Character:FindFirstChild(equippedKnifeName)
            if not knife then
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Knife tool not found in character!",
                    Duration = 6.5,
                    Image = "rewind",
                })
                teleporting = false
                return
            end
            
            local knifeServer = knife:FindFirstChild("KnifeServer")
            if knifeServer and knifeServer:FindFirstChild("SlashStart") then
                while teleporting do
                    local args = {[1] = 1}
                    local success, err = pcall(function()
                        knifeServer.SlashStart:FireServer(unpack(args))
                    end)
                    if not success then
                        Rayfield:Notify({
                            Title = "Error",
                            Content = "Error firing server event: " .. tostring(err),
                            Duration = 6.5,
                            Image = "rewind",
                        })
                    end
                    task.wait(0.1)
                end
            else
                Rayfield:Notify({
                    Title = "KnifeServer or SlashStart not found.",
                    Content = "KnifeServer or SlashStart event not found in knife!",
                    Duration = 6.5,
                    Image = "rewind",
                })
                teleporting = false
            end
        end

        -- Run both functions
        task.spawn(tptonpc)  -- Call the renamed teleport function
        task.spawn(fireServerEvent)
    end,
})

local BotParagraph = BotTab:CreateParagraph({Title = "Note", Content = "Shoot NPC will be in future update (possibly)?"})

local FarmTab = Window:CreateTab("Auto Farm", "swords") -- Title, Image
local FarmSection = FarmTab:CreateSection("Kill Farm")

