local plr = game.Players.LocalPlayer ; 

local Inventory = require(plr.PlayerGui.Main.UIController.Inventory) ;
local Spritesheets = require(plr.PlayerGui.Main.UIController.Inventory.Spritesheets) ;

local modules = {Funcs = {} , Invs = {} , Data = {}} ;

do -- Get Inventory ;

    for i ,v in pairs(Inventory.Items) do 
        table.insert(modules.Invs,v.details.Name) ;        
    end ;

end ;

do -- Get Sprites 

    for i ,v in pairs(Spritesheets) do 
        for i2 ,v2 in pairs(v) do 
            modules.Data[i2:split(".png")[1]:sub(1,#i2-5)] = {
                Name = i2:split(".png")[1]:sub(1,#i2-5) ;
                Image = i ;
                X = v2[1] ;
                X2 = v2[2] ;
                Y = v2[3] ;
                Y2 = v2[4] ;
            }
        end ;
    end ;

end ; 

do -- Funcs ;

    local Funcs = modules.Funcs ;

    function Funcs.GetAllData() 
        local Alls = { };
        for i ,v in pairs(modules.Invs) do 
            if modules.Data[v] then 
                table.insert(Alls,modules.Data[v]) ;
            end 
        end ;
        return Alls 
    end ;

    function Funcs.GetDataType(args) 
        local Results = { } ;
        for i ,v in pairs(Inventory.Items) do 
            if modules.Data[v.details.Name] and (v.details.Type == args.Type or not args.Type ) then 
                Results[v.details.Name] = modules.Data[v.details.Name]
            end ;
        end ;
        return Results 
    end ;

    function Funcs.Remote(args) 
        wait(.25) ;
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(args) ;
    end ;

end ;

function modules.new(Func,...) 
    if not modules.Funcs[Func] then return end ;

    return modules.Funcs[Func](...) ;
end ;

return modules ; 
