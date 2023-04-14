
local u5 = require(game:GetService("Players").LocalPlayer.PlayerGui.Main.UIController.Inventory.Spritesheets)

local Data = {
   Image  = {} ,
   Inventorys = {
	Result = {} 
   } ,
};

function Data.Add(Item) 
   if not Item then return end 
   
   local Bag = {} ;

   Bag.Value = {} ;

   local D = {};

   for i ,v in pairs(u5) do 
      if i == Item then 
		for i2 ,v2 in pairs(v) do 
			D[i2] = v2 
		end
      end
   end

   local text = nil ;
   for i ,v in pairs(D) do 
      if i:match("2.png") then continue end 
      if i:match("1.png") then 
         i = i:split("1.png")[1];
      end 

      Bag.Value[i] = {
         Index = Item ,
         Value = {
            Name = i ,
            Datas = v 
         }
      }
   end

   return Bag.Value ;
end

for i ,v in pairs(u5) do 
   Data.Image[i] = {} 
end

for i ,v in pairs(u5) do 
   if Data.Image[i] then 
      table.insert(Data.Inventorys,Data.Add(i))
   end
end

for i ,v in pairs(Data.Inventorys) do 
	for i2 ,v2 in pairs(v) do 
		Data.Inventorys.Result[i2] = v2
	end
end


return Data 
