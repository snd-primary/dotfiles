-- ~/.hammerspoon/init.lua
hs.window.animationDuration = 0

-- Ctrl+Alt+L: 左半分 / 右上 / 右下 の3分割グリッド
hs.hotkey.bind({"ctrl", "alt"}, "L", function()
  local screen = hs.screen.mainScreen()
  local wins = hs.fnutils.filter(hs.window.orderedWindows(), function(w)
    return w:isStandard() and w:isVisible() and w:screen():id() == screen:id()
  end)

  if #wins < 3 then
    hs.alert.show("ウィンドウが3つ未満です")
    return
  end

  local units = {
    hs.geometry.rect(0,   0,   0.5, 1),    -- 左
    hs.geometry.rect(0.5, 0,   0.5, 0.5),  -- 右上
    hs.geometry.rect(0.5, 0.5, 0.5, 0.5),  -- 右下
  }
  for i, u in ipairs(units) do
    wins[i]:moveToUnit(u)
  end
end)

-- Ctrl+Alt+R: 設定リロード
hs.hotkey.bind({"ctrl", "alt"}, "R", function()
  hs.reload()
end)

hs.alert.show("Hammerspoon loaded")
