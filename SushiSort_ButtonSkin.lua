-- SushiSort_ButtonSkin.lua
-- Reposiciona y da skin al botón de Sushi Sort en Guild Bank
-- Compatible con Blizzard y ElvUI en WoW 3.3.5a

local f = CreateFrame("Frame")
local lastAnchorMode = nil

local function IsElvUILoaded()
    return IsAddOnLoaded("ElvUI") or _G.ElvUI or _G.E
end

local function GetElvUIEngine()
    return _G.ElvUI or _G.E
end


local function SkinButtonLikeElvUI(btn)
    if not btn then return end

    -- Quitar regiones/texturas Blizzard
    local left   = _G[btn:GetName() .. "Left"]
    local right  = _G[btn:GetName() .. "Right"]
    local middle = _G[btn:GetName() .. "Middle"]

    if left then left:SetTexture(nil) left:SetAlpha(0) end
    if right then right:SetTexture(nil) right:SetAlpha(0) end
    if middle then middle:SetTexture(nil) middle:SetAlpha(0) end

    local regions = { btn:GetRegions() }
    for i = 1, #regions do
        local r = regions[i]
        if r and r.GetObjectType and r:GetObjectType() == "Texture" then
            r:SetTexture(nil)
            r:SetAlpha(0)
        end
    end

    btn:SetNormalTexture("")
    btn:SetPushedTexture("")
    btn:SetHighlightTexture("")
    btn:SetDisabledTexture("")

    -- Fondo principal
    if not btn.bg then
        btn.bg = btn:CreateTexture(nil, "BACKGROUND")
        btn.bg:SetAllPoints(btn)
        btn.bg:SetTexture("Interface\\Buttons\\WHITE8x8")
        btn.bg:SetVertexColor(0.02, 0.02, 0.02, 1)
    end

    -- Borde exterior
    if not btn.border then
        btn.border = CreateFrame("Frame", nil, btn)
        btn.border:SetPoint("TOPLEFT", -1, 1)
        btn.border:SetPoint("BOTTOMRIGHT", 1, -1)

        local function Tex()
            return btn.border:CreateTexture(nil, "BORDER")
        end

        btn.border.t = Tex()
        btn.border.t:SetPoint("TOPLEFT")
        btn.border.t:SetPoint("TOPRIGHT")
        btn.border.t:SetHeight(1)
        btn.border.t:SetTexture("Interface\\Buttons\\WHITE8x8")
        btn.border.t:SetVertexColor(0.22, 0.22, 0.22, 1)

        btn.border.b = Tex()
        btn.border.b:SetPoint("BOTTOMLEFT")
        btn.border.b:SetPoint("BOTTOMRIGHT")
        btn.border.b:SetHeight(1)
        btn.border.b:SetTexture("Interface\\Buttons\\WHITE8x8")
        btn.border.b:SetVertexColor(0.22, 0.22, 0.22, 1)

        btn.border.l = Tex()
        btn.border.l:SetPoint("TOPLEFT")
        btn.border.l:SetPoint("BOTTOMLEFT")
        btn.border.l:SetWidth(1)
        btn.border.l:SetTexture("Interface\\Buttons\\WHITE8x8")
        btn.border.l:SetVertexColor(0.22, 0.22, 0.22, 1)

        btn.border.r = Tex()
        btn.border.r:SetPoint("TOPRIGHT")
        btn.border.r:SetPoint("BOTTOMRIGHT")
        btn.border.r:SetWidth(1)
        btn.border.r:SetTexture("Interface\\Buttons\\WHITE8x8")
        btn.border.r:SetVertexColor(0.22, 0.22, 0.22, 1)
    end

    -- Línea interior superior tenue, muy estilo ElvUI
    if not btn.topline then
        btn.topline = btn:CreateTexture(nil, "ARTWORK")
        btn.topline:SetPoint("TOPLEFT", 1, -1)
        btn.topline:SetPoint("TOPRIGHT", -1, -1)
        btn.topline:SetHeight(1)
        btn.topline:SetTexture("Interface\\Buttons\\WHITE8x8")
        btn.topline:SetVertexColor(0.45, 0.45, 0.45, 0.55)
    end

    -- Capa hover suave
    if not btn.hover then
        btn.hover = btn:CreateTexture(nil, "HIGHLIGHT")
        btn.hover:SetAllPoints(btn)
        btn.hover:SetTexture("Interface\\Buttons\\WHITE8x8")
        btn.hover:SetVertexColor(1, 1, 1, 0.02)
    end

    -- Capa pressed
    if not btn.pushed then
        btn.pushed = btn:CreateTexture(nil, "OVERLAY")
        btn.pushed:SetAllPoints(btn)
        btn.pushed:SetTexture("Interface\\Buttons\\WHITE8x8")
        btn.pushed:SetVertexColor(1, 1, 1, 0.015)
        btn.pushed:Hide()
    end

    btn:HookScript("OnMouseDown", function(self)
        if self.pushed then self.pushed:Show() end
    end)

    btn:HookScript("OnMouseUp", function(self)
        if self.pushed then self.pushed:Hide() end
    end)

    -- Texto
    btn:SetNormalFontObject("GameFontNormalSmall")
    btn:SetHighlightFontObject("GameFontHighlightSmall")
    btn:SetDisabledFontObject("GameFontDisableSmall")

    local text = btn:GetFontString()
    if text then
        text:SetTextColor(0.93, 0.78, 0.12)
        text:SetShadowColor(0, 0, 0, 1)
        text:SetShadowOffset(1, -1)
    end
end

local function GetGuildBankSortButton()
    if _G.GBankFrameSortButton then
        return _G.GBankFrameSortButton
    end

    if _G.GuildBankFrame and _G.GuildBankFrame.sortButton then
        return _G.GuildBankFrame.sortButton
    end

    return nil
end

local function AnchorForBlizzard(btn)
    local parent = _G.GuildBankFrame
    if not parent or not btn then return end

    btn:ClearAllPoints()
    btn:SetParent(parent)
    btn:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -44, -29)
    btn:SetWidth(76)
    btn:SetHeight(22)
    btn:SetFrameStrata("HIGH")
    btn:SetFrameLevel(parent:GetFrameLevel() + 10)
    btn:SetText("Ordenar")

    lastAnchorMode = "blizzard"
end

local function AnchorForElvUI(btn)
    local parent = _G.GuildBankFrame
    if not parent or not btn then return end

    btn:ClearAllPoints()
    btn:SetParent(parent)
    btn:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -44, -29)
    btn:SetWidth(76)
    btn:SetHeight(22)
    btn:SetFrameStrata("HIGH")
    btn:SetFrameLevel(parent:GetFrameLevel() + 10)
    btn:SetText("Ordenar")

    lastAnchorMode = "elvui"
end

local function UpdateGuildButton()
    local btn = GetGuildBankSortButton()
    local parent = _G.GuildBankFrame

    if not btn or not parent then return end

    -- Asegura visibilidad
    btn:Show()
    btn:Enable()

    if IsElvUILoaded() then
        AnchorForElvUI(btn)
    else
        AnchorForBlizzard(btn)
    end

    SkinButtonLikeElvUI(btn)
end

local function DelayedUpdate()
    UpdateGuildButton()
    if C_Timer and C_Timer.After then
        C_Timer.After(0.15, UpdateGuildButton)
        C_Timer.After(0.50, UpdateGuildButton)
        C_Timer.After(1.00, UpdateGuildButton)
    end
end

f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("GUILDBANKFRAME_OPENED")
f:RegisterEvent("ADDON_LOADED")

f:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_LOGIN" then
        DelayedUpdate()
    elseif event == "GUILDBANKFRAME_OPENED" then
        DelayedUpdate()
    elseif event == "ADDON_LOADED" then
        if arg1 == "ElvUI" or arg1 == "Bank Sort" then
            DelayedUpdate()
        end
    end
end)