--Helper function for UI to configure properties
    function bgDraw(bg)
        if bg then
            UiPush()
		        UiTranslate(UiCenter(), UiMiddle())
		        UiAlign("center middle")
                UiTranslate(bg.x, bg.y)
                UiImage(bg)
            UiPop()
        end
    end

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
        if GetString("savegame.mod.color") == "Normal" then
            bgDraw("resource/norm.png")
        elseif GetString("savegame.mod.color") == "Classic tdWater" then
            bgDraw("resource/class.png")
        elseif GetString("savegame.mod.color") == "Toxic Chemicals" then
            bgDraw("resource/rad.png")
        end
            
            
        UiTranslate(UiWidth()-300, UiHeight()/2)
        UiPush()
            UiTranslate(-10, 25)
            UiColor(0,0,0)
            UiRect(500, -42)
        UiPop()
        
        property("Color", {"Normal", "Classic tdWater", "Toxic Chemicals"}, "savegame.mod.color")

        UiTranslate(0,20)
    end
    