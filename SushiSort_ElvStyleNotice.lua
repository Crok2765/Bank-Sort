-- SushiSort_ElvStyleNotice.lua
-- Aviso estilo ElvUI simple y seguro para WoW 3.3.5a

local function GetNoticeFont()
    local E = _G.ElvUI or _G.E
    if E and E.media and E.media.normFont then
        return E.media.normFont
    end
    return STANDARD_TEXT_FONT
end

local Notice = CreateFrame("Frame", "SushiSortNoticeFrame", UIParent)
Notice:SetWidth(700)
Notice:SetHeight(120)
Notice:SetPoint("TOP", UIParent, "TOP", 0, -180)
Notice:SetFrameStrata("FULLSCREEN_DIALOG")
Notice:SetFrameLevel(100)
Notice:Hide()

--Notice.glow = Notice:CreateTexture(nil, "ARTWORK")
--Notice.glow:SetPoint("TOPLEFT", -30, 30)
--Notice.glow:SetPoint("BOTTOMRIGHT", 30, -30)
--Notice.glow:SetTexture("Interface\\Buttons\\WHITE8x8")
--Notice.glow:SetVertexColor(1, 0.82, 0.10, 0.04)

Notice.text = Notice:CreateFontString(nil, "OVERLAY")
Notice.text:SetPoint("CENTER", Notice, "CENTER", 0, 10)
Notice.text:SetFont(GetNoticeFont(), 30, "OUTLINE")
Notice.text:SetTextColor(1, 0.82, 0.0)
Notice.text:SetShadowColor(0, 0, 0, 1)
Notice.text:SetShadowOffset(1, -1)
Notice.text:SetText("Banco Ordenado")

Notice.subtext = Notice:CreateFontString(nil, "OVERLAY")
Notice.subtext:SetPoint("TOP", Notice.text, "BOTTOM", 0, -6)
Notice.subtext:SetFont(GetNoticeFont(), 14, "")
Notice.subtext:SetTextColor(0.7, 0.7, 0.7)
Notice.subtext:SetShadowColor(0, 0, 0, 1)
Notice.subtext:SetShadowOffset(1, -1)
Notice.subtext:SetText("Terminado")

function ShowSushiSortComplete(msg)
    Notice.text:SetFont(GetNoticeFont(), 30, "OUTLINE")
    Notice.subtext:SetFont(GetNoticeFont(), 14, "")
    Notice.text:SetText(msg or "Banco Ordenado")

    Notice:Show()
    Notice:SetAlpha(1)

    PlaySoundFile("Sound\\Interface\\LevelUp.wav")

    Notice.elapsed = 0
    Notice:SetScript("OnUpdate", function(self, elapsed)
        self.elapsed = self.elapsed + elapsed

        if self.elapsed < 1.6 then
            self:SetAlpha(1)
        elseif self.elapsed < 2.2 then
            local fade = 1 - ((self.elapsed - 1.6) / 0.6)
            self:SetAlpha(fade)
        else
            self:Hide()
            self:SetScript("OnUpdate", nil)
        end
    end)
end

SLASH_SUSHISORTNOTICE1 = "/sstest"
SlashCmdList["SUSHISORTNOTICE"] = function()
    ShowSushiSortComplete("Banco Ordenado")
end