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
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "what"
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

-- Button creation
local Button = BotTab:CreateButton({
    Name = "Kill NPC(s)",
    Callback = function()
        local function teleportToInnoParts()
            local partName = "HumanoidRootPart"
            local partsToTeleport = {}

            -- Collect all "HumanoidRootPart" from NPCs in the workspace
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name:lower() == partName:lower() and v:IsA("BasePart") then
                    table.insert(partsToTeleport, v)
                end
            end

            if #partsToTeleport == 0 then
                player:SendNotification({Title = "Error", Text = "No parts named 'HumanoidRootPart' found!"})
                return
            end

            -- Ensure the player isn't seated
            local humanoid = player.Character and player.Character:FindFirstChildOfClass('Humanoid')
            if humanoid and humanoid.SeatPart then
                humanoid.Sit = false
                task.wait(0.1)
            end

            -- Continuous teleporting to NPCs
            for _, part in pairs(partsToTeleport) do
                task.wait(0.1)
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = part.CFrame
                end
            end
        end

        -- Server event firing
        local function fireServerEvent()
            -- Retrieve the equipped knife value dynamically
            local equippedKnifeName = player:FindFirstChild("EquippedKnife") and player.EquippedKnife.Value
            if not equippedKnifeName then
                warn("EquippedKnife StringValue not found or has no value!")
                return
            end
            
            local knife = player.Character:FindFirstChild(equippedKnifeName)
            if not knife then
                warn("Knife tool not found in character!")
                return
            end
            
            local knifeServer = knife:FindFirstChild("KnifeServer")
            if knifeServer and knifeServer:FindFirstChild("SlashStart") then
                while true do
                    local args = {[1] = 1}

                    local success, err = pcall(function()
                        knifeServer.SlashStart:FireServer(unpack(args))
                    end)
                    if not success then
                        Rayfield:Notify(
                        Title = "Error",
                        Content = "Error firing server event: " .. tostring(err),
                        Duration = 6.5,
                        Image = "triangle-alert",
                     })
                    end
                    task.wait(0.1)
                end
            else
                Rayfield:Notify({
   Title = "KnifeServer or SlashStart not found.",
   Content = "KnifeServer or SlashStart event not found in knife!",
   Duration = 6.5,
   Image = "triangle-alert",
                  
        task.spawn(teleportToInnoParts)
        task.spawn(fireServerEvent)
    end,
})

local BotParagraph = BotTab:CreateParagraph({Title = "Note", Content = "Shoot NPC will be in future update (possibly)?"})

local FarmTab = Window:CreateTab("Auto Farm", "swords") -- Title, Image
local BotSection = FarmTab:CreateSection("Kill Farm")

local Toggle = FarmTab:CreateToggle({
    Name = "Toggle Example",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        -- This is triggered when the toggle is changed
        if Value then
            -- If the toggle is enabled, start the functions
            task.spawn(function()
                teleportToInnoParts()
            end)

            task.spawn(function()
                fireServerEvent()
            end)
        else
            -- If the toggle is disabled, stop the loops or any running tasks
            -- You can use a flag to check whether the functions should still run or not.
            stopLoop()
        end
    end,
})

-- Define the teleportToInnoParts function
local player = game:GetService("Players").LocalPlayer

local function teleportToInnoParts()
    local partName = "HumanoidRootPart"
    local partsToTeleport = {}

    -- Collect all "HumanoidRootPart" from NPCs in the workspace
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower() == partName:lower() and v:IsA("BasePart") then
            table.insert(partsToTeleport, v)
        end
    end

    if #partsToTeleport == 0 then
        player:SendNotification({Title = "Error", Text = "No parts named 'HumanoidRootPart' found!"})
        return
    end

    -- Ensure the player isn't seated
    local humanoid = player.Character and player.Character:FindFirstChildOfClass('Humanoid')
    if humanoid and humanoid.SeatPart then
        humanoid.Sit = false
        task.wait(0.1)
    end

    -- Continuous teleporting to NPCs
    for _, part in pairs(partsToTeleport) do
        task.wait(0.1)
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = part.CFrame
        end
    end
end

-- Define the fireServerEvent function
local function fireServerEvent()
    -- Retrieve the equipped knife value dynamically
    local equippedKnifeName = player:FindFirstChild("EquippedKnife") and player.EquippedKnife.Value
    if not equippedKnifeName then
        warn("EquippedKnife StringValue not found or has no value!")
        return
    end
    
    local knife = player.Character:FindFirstChild(equippedKnifeName)
    if not knife then
        warn("Knife tool not found in character!")
        return
    end
    
    local knifeServer = knife:FindFirstChild("KnifeServer")
    if knifeServer and knifeServer:FindFirstChild("SlashStart") then
        while true do
            local args = {[1] = 1}

            local success, err = pcall(function()
                knifeServer.SlashStart:FireServer(unpack(args))
            end)
            if not success then
                Rayfield:Notify(
                Title = "Error",
                Content = "Error firing server event: " .. tostring(err),
                Duration = 6.5,
                Image = "triangle-alert",
             })
            end
            task.wait(0.1)
        end
    else
        Rayfield:Notify({
            Title = "KnifeServer or SlashStart not found.",
            Content = "KnifeServer or SlashStart event not found in knife!",
            Duration = 6.5,
            Image = "triangle-alert",
        })
    end
end

-- Add a function to stop the loops when the toggle is off
local isRunning = true

local function stopLoop()
    isRunning = false
end

-- Modify the teleport and server event functions to check `isRunning`
local function teleportToInnoParts()
    while isRunning do
        -- Same teleport logic as before
        local partName = "HumanoidRootPart"
        local partsToTeleport = {}

        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name:lower() == partName:lower() and v:IsA("BasePart") then
                table.insert(partsToTeleport, v)
            end
        end

        if #partsToTeleport == 0 then
            player:SendNotification({Title = "Error", Text = "No parts named 'HumanoidRootPart' found!"})
            return
        end

        local humanoid = player.Character and player.Character:FindFirstChildOfClass('Humanoid')
        if humanoid and humanoid.SeatPart then
            humanoid.Sit = false
            task.wait(0.1)
        end

        for _, part in pairs(partsToTeleport) do
            task.wait(0.1)
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = part.CFrame
            end
        end
    end
end

local function fireServerEvent()
    while isRunning do
        -- Same server event logic as before
        local equippedKnifeName = player:FindFirstChild("EquippedKnife") and player.EquippedKnife.Value
        if not equippedKnifeName then
            warn("EquippedKnife StringValue not found or has no value!")
            return
        end

        local knife = player.Character:FindFirstChild(equippedKnifeName)
        if not knife then
            warn("Knife tool not found in character!")
            return
        end

        local knifeServer = knife:FindFirstChild("KnifeServer")
        if knifeServer and knifeServer:FindFirstChild("SlashStart") then
            local args = {[1] = 1}

            local success, err = pcall(function()
                knifeServer.SlashStart:FireServer(unpack(args))
            end)
            if not success then
                Rayfield:Notify(
                Title = "Error",
                Content = "Error firing server event: " .. tostring(err),
                Duration = 6.5,
                Image = "triangle-alert",
             })
            end
            task.wait(0.1)
        else
            Rayfield:Notify({
                Title = "KnifeServer or SlashStart not found.",
                Content = "KnifeServer or SlashStart event not found in knife!",
                Duration = 6.5,
                Image = "triangle-alert",
            })
        end
    end
   end
