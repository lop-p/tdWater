--Helper function for UI to configure properties
    function property(name, list, key)
        local current = GetString(key)
        if current == "" then 
            current = list[1]
        end
        UiPush()
            UiFont("regular.ttf", 22)
            UiText(name)
            UiTranslate(100, 0)
            UiFont("bold.ttf", 22)
            if UiTextButton(current) then
                local new = nil
                for i=1, #list-1 do
                    if list[i] == current then
                        new = list[i+1]		
                    end
                end
                if new then
                    SetString(key, new)
                else
                    SetString(key, list[1])
                end
            end
        UiPop()
    end
    
    
    --Configuration UI
    function draw()
        UiTranslate(0, 22)
        property("Color", {"Normal", "Classic tdWater", "Toxic Chemicals"}, "savegame.mod.color")
    end
    