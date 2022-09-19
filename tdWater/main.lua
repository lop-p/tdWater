--Place a configurable smoke emitter in the world

function init()
	RegisterTool("tdwater", "TeardownWater", "MOD/vox/smokegun.vox")
	SetBool("game.tool.tdwater.enabled", true)

	snd = LoadLoop("MOD/snd/watta.ogg")

	emit = false
	ui = false
end


--Helper to return a random vector of particular length
function rndVec(length)
	local v = VecNormalize(Vec(math.random(-100,100), math.random(-100,100), math.random(-100,100)))
	return VecScale(v, length)	
end


--Helper to return a random number in range mi to ma
function rnd(mi, ma)
	return math.random(1000)/1000*(ma-mi) + mi
end
function update(dt)
	if emit then
		local radius = 0.7
		local life = 20 
		local emitPeriod = 10000
		local count = 3
		local vel = 10
		local drag = 1.0
		local gravity = -30  --probably the worst way i could've done this but it kinda works
		local red = 0
		local green = 0.498
		local blue = 1
		local vol = 0.3
		local alpha = 1

		local propColor = GetString("savegame.mod.color")
		if propColor == "Classic tdWater" then
			red = 0
			green = 0
			blue = 1
		elseif propColor == "Toxic Chemicals" then
			red = 0
			green = 1
			blue = 0
		end

		
		local bt = GetBodyTransform(emitBody)
		local pos = TransformToParentPoint(bt, emitPos)
		local dir = TransformToParentVec(bt, emitDir)
		PlayLoop(snd, pos, vol)
		
		--Set up the particle state
		ParticleReset()
		ParticleType("smoke")
		ParticleRadius(radius)
		ParticleAlpha(alpha, alpha)	-- Ramp up fast, ramp down after 50%
		ParticleGravity(gravity)				-- Slightly randomized gravity looks better
		ParticleDrag(drag)
		ParticleColor(red, green, blue)			-- no
		

		--Emit particles
		for i=1, count do


			--Randomize position slightly. This is important when spawning multiple particles at the same time
			local p = VecAdd(pos, VecAdd(VecScale(dir, radius), rndVec(radius)))
			
			--Randomize velocity slightly
			local v = VecScale(VecAdd(dir, rndVec(0.2)), vel)
			--Include some of the movement of the attachment body
			v = VecAdd(v, VecScale(GetBodyVelocityAtPos(emitBody, pos), 0.5))
			
			--Randomize lifetime
			local l = rnd(life*0.5, life*1.5)

			--Spawn particle into the world
			SpawnParticle(p, v, l)

		end

		--Check if we should stop emitting
		emitTimer = emitTimer + dt
		if shutup then
			emit = false
		end
	end
end


--Main tick function handles tool logic
function tick(dt)
	SetString("game.tool.tdwater.ammo.display", "Click to start pouring")

	--Check if smokegun is selected
	if GetString("game.player.tool") == "tdwater" then
		if GetBool("game.player.canusetool") and InputPressed("usetool") then
			
			local ct = GetCameraTransform();
			local pos = ct.pos
			local dir = TransformToParentVec(ct, Vec(0, 0, -1))
			local hit, dist, normal, shape = QueryRaycast(pos, dir, 500)
			if hit then
				local hitPoint = VecAdd(pos, VecScale(dir, dist))
				local b = GetShapeBody(shape)
				local t = GetBodyTransform(b)
				emitBody = b
				emitPos = TransformToLocalPoint(t, hitPoint)
				emitDir = TransformToLocalVec(t, normal)
				emitTimer = 0
				emit = true
				shutup = false
			end
		end
	end


	
	if PauseMenuButton("Stop emitting (tdWater)") then
		shutup = true
	end



end


--Update function handles smoke emission
--It is important to put it in update and not tick for constant emission rate


