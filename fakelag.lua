
local pos
local myEnt = nil
local drawcontext


local m1 = {
    materials.Create( "AC_Fresnel", [["VertexLitGeneric"
    {   
        $basetexture "vgui/white_additive"
        $bumpmap "models/player/shared/shared_normal"
        $envmap "skybox/sky_dustbowl_01"
        $envmapfresnel "1"
        $phong "1"
        $phongfresnelranges "[0 0.05 0.1]"
        $selfillum "1"
        $selfillumfresnel "1"
        $basemapalphaphongmask "1"
        $selfillumfresnelminmaxexp "[0.5 0.5 0]"
        $selfillumtint "[0 0 0]"
        $envmaptint "[0.5 1 0]"
        $additive "0"
    }
    ]])
}

local chams = m1[1]

gui.SetValue("Fake Lag", 1);
local fakelagvalue = gui.GetValue("Fake Lag Value (ms)") / 1000;

local function fakelag()
    if gui.GetValue("Thirdperson") == 1 then
        local me = entities.GetLocalPlayer()
        if myEnt == nil then
            myEnt = entities.CreateEntityByName( "grenade" )
            myEnt:SetModel( "models/player/sniper.mdl" )
        end

        if globals.RealTime() % fakelagvalue <= 0.008 then
            pos = me:GetAbsOrigin()
        end

        if pos ~= nil then
            myEnt:SetAbsOrigin(pos)
        end
    else 
        myEnt:Release()
        myEnt = nil
    end
end


local function onDrawModel( drawModelContext )

	
    local entity = drawModelContext:GetEntity()
    local model = drawModelContext:GetModelName()

    if entity == myEnt then
        drawModelContext:ForcedMaterialOverride ( chams )
        chams:SetShaderParam( "$envmaptint", Vector3(255, 0, 255) )
        chams:SetShaderParam( "$color2", Vector3(255, 0, 255) )
    end
end

local function OnUnload()    
    gui.SetValue("Fake Lag", 0);                            
    myEnt:Release()
    myEnt = nil
end

callbacks.Unregister( "DrawModel", "hook12323" ) 

callbacks.Unregister("Unload", "MCT_Unload") 

callbacks.Unregister("Draw", "fakelag")



callbacks.Register( "DrawModel", "hook12323", onDrawModel ) 

callbacks.Register("Unload", "MCT_Unload", OnUnload)

callbacks.Register( "Draw", "fakelag", fakelag )