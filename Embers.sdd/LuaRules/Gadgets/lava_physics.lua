function gadget:GetInfo()
   return {
      name = "Lava Physics Handler",
      desc = "Handles collisions with lava",
      author = "raaar",
      date = "2019",
      license = "PD",
      layer = 999,
      enabled = true,
   }
end


-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

if (not gadgetHandler:IsSyncedCode()) then
    return
end



local spGetUnitPosition = Spring.GetUnitPosition
local spGetAllUnits = Spring.GetAllUnits
local spDestroyUnit = Spring.DestroyUnit
local spGetAllFeatures = Spring.GetAllFeatures
local spDestroyFeature = Spring.DestroyFeature
local spGetFeaturePosition = Spring.GetFeaturePosition
local spGetProjectilesInRectangle = Spring.GetProjectilesInRectangle
local spGetProjectilePosition = Spring.GetProjectilePosition
local spDeleteProjectile = Spring.DeleteProjectile
local spSetProjectileCollision = Spring.SetProjectileCollision
local spAddUnitDamage = Spring.AddUnitDamage
local spGetUnitVelocity = Spring.GetUnitVelocity
local spSetUnitVelocity = Spring.SetUnitVelocity
local spGetUnitTransporter = Spring.GetUnitTransporter
local spGetUnitRadius = Spring.GetUnitRadius
local spGetUnitHeight = Spring.GetUnitHeight
local spAddUnitImpulse = Spring.AddUnitImpulse
local spSetFeatureHealth = Spring.SetFeatureHealth
local spGetFeatureHealth = Spring.GetFeatureHealth
local spGetFeatureVelocity = Spring.GetFeatureVelocity
local spSetFeatureVelocity = Spring.SetFeatureVelocity
local spGetFeaturePosition = Spring.GetFeaturePosition
local spGetFeatureRadius = Spring.GetFeatureRadius
local spGetFeatureHeight = Spring.GetFeatureHeight
local spSetFeatureMoveCtrl = Spring.SetFeatureMoveCtrl
local spSpawnCEG = Spring.SpawnCEG
local spPlaySoundFile = Spring.PlaySoundFile
local spGetProjectileDamages = Spring.GetProjectileDamages			-- TODO use this
local spGetProjectileDefID = Spring.GetProjectileDefID

local rand = math.random
local min = math.min

local LAVA_HEIGHT_THRESHOLD = 20
local LAVA_HEIGHT_THRESHOLD_DEEP = 10
local LAVA_PROJECTILE_HEIGHT_THRESHOLD = 40
local LAVA_DAMAGE_PER_FRAME = 10 -- 300 dps (it's actually less as the unit bounces out of it when floating)
local LAVA_FLOAT_VELOCITY = 0.3
local LAVA_FLOAT_VELOCITY_DEEP = 3.0
local burnCEG = "lavasplash"
local burnSound = 'MAPLAVABURN'

local BURN_CEG_DELAY_FRAMES = 3
local BURN_SOUND_DELAY_FRAMES = 9
local PROJECTILE_EFFECT_DELAY_FRAMES = 60

local lastBurnCEGFrameByUnitId = {}
local lastBurnSoundFrameByUnitId = {}
local lastBurnCEGFrameByFeatureId = {}
local lastBurnSoundFrameByFeatureId = {}
local projectileEffectTriggeredFrameById = {}


-- handle objects that fall through the lava layer
function gadget:GameFrame(n)
	-- units : keep them floating, but damage them
	local x,y,z,vx,vy,vz,vyMod, radius, spawnOffset, height, health, lastCEGFrame, lastSoundFrame
	for _,uId in pairs(spGetAllUnits()) do
		x,y,z = spGetUnitPosition(uId)
		if (y and y < LAVA_HEIGHT_THRESHOLD) then
			vyMod = 0
			-- apply damage
			spAddUnitDamage(uId,LAVA_DAMAGE_PER_FRAME)
			
			-- make noise and spawn CEG (only once every few frames)
			radius = tonumber(spGetUnitRadius(uId))
			spawnOffset = radius * 0.6
			height = tonumber(spGetUnitHeight(uId))
			lastCEGFrame = lastBurnCEGFrameByUnitId[uId]
			lastSoundFrame = lastBurnSoundFrameByUnitId[uId]
			
			if (not lastCEGFrame or n - lastCEGFrame > BURN_CEG_DELAY_FRAMES) then
				spSpawnCEG(burnCEG, x -spawnOffset + rand()*2*spawnOffset, LAVA_HEIGHT_THRESHOLD+10, z-spawnOffset + rand()*2*spawnOffset, 0, 1, 0,radius ,radius)
				spSpawnCEG(burnCEG, x -spawnOffset + rand()*2*spawnOffset, LAVA_HEIGHT_THRESHOLD+10, z-spawnOffset + rand()*2*spawnOffset, 0, 1, 0,radius ,radius)
				--spSpawnCEG(burnCEG, x -spawnOffset + rand()*2*spawnOffset, LAVA_HEIGHT_THRESHOLD+10, z-spawnOffset + rand()*2*spawnOffset, 0, 1, 0,radius ,radius)
				lastBurnCEGFrameByUnitId[uId] = n
			end
			if (not lastSoundFrame or n - lastSoundFrame > BURN_SOUND_DELAY_FRAMES ) then
				spPlaySoundFile(burnSound..tostring(rand(1,2)), 1, x, LAVA_HEIGHT_THRESHOLD+10, z)
				lastBurnSoundFrameByUnitId[uId] = n
			end	

			-- modify speed to make them float
			vx,vy,vz,_ = spGetUnitVelocity(uId)
			if (vy and vy <= 0 and not spGetUnitTransporter(uId)) then
				if (y < LAVA_HEIGHT_THRESHOLD - height/2) then
					vyMod = vy + LAVA_FLOAT_VELOCITY_DEEP
					spAddUnitImpulse( uId, 0, 0.5, 0, 1)
					--Spring.Echo("DEEP_LAVA "..n.." vy="..vy.." vyMod="..vyMod)
				else 
					vyMod = vy + LAVA_FLOAT_VELOCITY
					--Spring.Echo("LAVA "..n.." vy="..vy.." vyMod="..vyMod)
				end
				spSetUnitVelocity(uId,0,vyMod,0)
			end
		end
	end
	
	-- features : keep them floating, but damage them
	for _,fId in pairs(spGetAllFeatures()) do
		x,y,z = spGetFeaturePosition(fId)
		if (y and y < LAVA_HEIGHT_THRESHOLD) then
			health = spGetFeatureHealth(fId)
			vyMod = 0
			-- apply damage
			spSetFeatureHealth(fId,health - LAVA_DAMAGE_PER_FRAME)
			
			-- make noise and spawn CEG (only once every few frames)
			radius = tonumber(spGetFeatureRadius(fId))
			height = tonumber(spGetFeatureHeight(fId))
			lastCEGFrame = lastBurnCEGFrameByFeatureId[fId]
			lastSoundFrame = lastBurnSoundFrameByFeatureId[fId]

			if health < 0 then
				radius = radius * 2;  -- make the effects bigger on the dying frame?
			end
			spawnOffset = radius * 0.6
			
			if (not lastCEGFrame or n - lastCEGFrame > BURN_CEG_DELAY_FRAMES) then
				spSpawnCEG(burnCEG, x -spawnOffset + rand()*2*spawnOffset, LAVA_HEIGHT_THRESHOLD+10, z-spawnOffset + rand()*2*spawnOffset, 0, 1, 0,radius ,radius)
				spSpawnCEG(burnCEG, x -spawnOffset + rand()*2*spawnOffset, LAVA_HEIGHT_THRESHOLD+10, z-spawnOffset + rand()*2*spawnOffset, 0, 1, 0,radius ,radius)
				--spSpawnCEG(burnCEG, x -spawnOffset + rand()*2*spawnOffset, LAVA_HEIGHT_THRESHOLD+10, z-spawnOffset + rand()*2*spawnOffset, 0, 1, 0,radius ,radius)
				lastBurnCEGFrameByFeatureId[fId] = n
			end
			if (not lastSoundFrame or n - lastSoundFrame > BURN_SOUND_DELAY_FRAMES ) then
				spPlaySoundFile(burnSound..tostring(rand(1,2)), 1, x, LAVA_HEIGHT_THRESHOLD+10, z)
				lastBurnSoundFrameByFeatureId[fId] = n
			end	

			if (health > 0 ) then
				-- modify speed to make them float
				vx,vy,vz,_ = spGetFeatureVelocity(fId)
				if (vy and vy <= 0) then
					if (y < LAVA_HEIGHT_THRESHOLD - height/2) then
						vyMod = vy + LAVA_FLOAT_VELOCITY_DEEP
						--spAddUnitImpulse( uId, 0, 0.5, 0, 1)
						--Spring.Echo("DEEP_LAVA "..n.." vy="..vy.." vyMod="..vyMod)
					else 
						vyMod = vy + LAVA_FLOAT_VELOCITY
						--Spring.Echo("LAVA "..n.." vy="..vy.." vyMod="..vyMod)
					end
					spSetFeatureMoveCtrl(fId,false,1,1,1,1,1,1,1,1,1)
					spSetFeatureVelocity(fId,0,vyMod,0)
				end
			else
				spDestroyFeature(fId)
			end
		end
	end

	-- projectiles : make them explode
	local wd, wdId
	for _,pId in pairs(spGetProjectilesInRectangle(0,0,Game.mapSizeX,Game.mapSizeZ)) do
		x,y,z = spGetProjectilePosition(pId)
		if (y and y < LAVA_PROJECTILE_HEIGHT_THRESHOLD and (not projectileEffectTriggeredFrameById[pId] or n - projectileEffectTriggeredFrameById[pId] > PROJECTILE_EFFECT_DELAY_FRAMES) ) then
			projectileEffectTriggeredFrameById[pId] = n
			wdId = spGetProjectileDefID(pId)
			if wdId and wdId > 0 then
				wd = WeaponDefs[wdId]
			end
			if (wd and wd.damageAreaOfEffect  and wd.damageAreaOfEffect  > 0) then
				radius = wd.damageAreaOfEffect
				radius = min(radius,400)
				spSpawnCEG(burnCEG, x, LAVA_HEIGHT_THRESHOLD+10, z, 0, 1, 0,radius ,radius)
				if (radius > 100) then
					spawnOffset = radius * 0.6
					spSpawnCEG(burnCEG, x -spawnOffset + rand()*2*spawnOffset, LAVA_HEIGHT_THRESHOLD+10, z-spawnOffset + rand()*2*spawnOffset, 0, 1, 0,spawnOffset ,spawnOffset)
					spSpawnCEG(burnCEG, x -spawnOffset + rand()*2*spawnOffset, LAVA_HEIGHT_THRESHOLD+10, z-spawnOffset + rand()*2*spawnOffset, 0, 1, 0,spawnOffset ,spawnOffset)
					if (radius > 200) then
						spSpawnCEG(burnCEG, x -spawnOffset + rand()*2*spawnOffset, LAVA_HEIGHT_THRESHOLD+10, z-spawnOffset + rand()*2*spawnOffset, 0, 1, 0,spawnOffset ,spawnOffset)
						spSpawnCEG(burnCEG, x -spawnOffset + rand()*2*spawnOffset, LAVA_HEIGHT_THRESHOLD+10, z-spawnOffset + rand()*2*spawnOffset, 0, 1, 0,spawnOffset ,spawnOffset)
						if (radius > 300) then
							spSpawnCEG(burnCEG, x -spawnOffset + rand()*2*spawnOffset, LAVA_HEIGHT_THRESHOLD+10, z-spawnOffset + rand()*2*spawnOffset, 0, 1, 0,spawnOffset ,spawnOffset)
							spSpawnCEG(burnCEG, x -spawnOffset + rand()*2*spawnOffset, LAVA_HEIGHT_THRESHOLD+10, z-spawnOffset + rand()*2*spawnOffset, 0, 1, 0,spawnOffset ,spawnOffset)
						end
					end
				end
			end
			--dmgTable = spGetProjectileDamages(pId)
			spSetProjectileCollision(pId)
		end
	end
	
	-- cleanup
	for pId,f in pairs(projectileEffectTriggeredFrameById) do
		if (n > f + 300) then
			projectileEffectTriggeredFrameById[pId] = nil
		end
	end
end


function gadget:UnitDestroyed(unitId, unitDefId, unitTeam)
	if lastBurnCEGFrameByUnitId[unitId] then
		lastBurnCEGFrameByUnitId[unitId] = nil
	end
	if lastBurnSoundFrameByUnitId[unitId] then
		lastBurnSoundFrameByUnitId[unitId] = nil
	end
end


function gadget:FeatureDestroyed(featureId, allyTeam)
	if lastBurnCEGFrameByFeatureId[featureId] then
		lastBurnCEGFrameByFeatureId[featureId] = nil
	end
	if lastBurnSoundFrameByFeatureId[featureId] then
		lastBurnSoundFrameByFeatureId[featureId] = nil
	end
end


