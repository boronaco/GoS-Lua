require('Inspired')

mainMenu = Menu("Zed | The Shadow", "Zed")
mainMenu:SubMenu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useW", "Use W in combo", true)
mainMenu.Combo:Boolean("gabW", "Use W to gapclose", true)
mainMenu.Combo:Boolean("useE", "Use E in combo", true)
mainMenu.Combo:Boolean("AutoE", "Use auto E", true)
mainMenu.Combo:Boolean("ksR", "Use R to killsteal", true)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
-----------------------------------------------------------------
mainMenu:SubMenu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)
-----------------------------------------------------------------
mainMenu:SubMenu("Drawings", "Drawings")
mainMenu.Drawings:Boolean("DrawQ", "Draw Q range", true)
mainMenu.Drawings:Boolean("DrawW", "Draw W range", true)
mainMenu.Drawings:Boolean("DrawE", "Draw E range", true)
mainMenu.Drawings:Boolean("DrawR", "Draw R range", true)
mainMenu.Drawings:Boolean("DrawWShadow", "W - Shadow Drawings", true)
mainMenu.Drawings:Boolean("DrawRShadow", "R - Shadow Drawings", true)
mainMenu.Drawings:Boolean("DrawDMG", "Draw Damage", true)


global_ticks = 0
	WPosx = 1
	WPosy = 1
	WPosz = 1
	
	RPosx = 1
	RPosy = 1
	RPosz = 1
	
OnLoop (function(myHero)

local myHeroPos = GetOrigin(myHero)
local target = GetCurrentTarget()
local AD = GetBaseDamage(myHero) + GetBonusDmg(myHero)

Killsteal()
Drawings()

-- Items
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)

-- R DMG Calc 
	USER = KeyIsDown(82)
	if USER == true then
		StartHP = GetCurrentHP(target)
		-- ArmorTarget = GetArmor(target)
		-- ArmorA = (100/(100+GetArmor(target)))-1
		-- Reduction = math.sqrt(math.pow(ArmorA,2)) + 1
		-- PrintChat("Enemy Starting HP: ".. StartHP)
		-- AD = GetBaseDamage(myHero) + GetBonusDmg(myHero)
		-- PrintChat("Lux Armor: ".. ArmorTarget)
		-- PrintChat("Lux DMG Reduction: ".. Reduction)
		-- PrintChat("AD: ".. AD)
		-- PrintChat("DPS: ".. DPS)
		-- PrintChat("trueDMGr: "..trueDMGr)
	end


	
	EndHP = GetCurrentHP(target)
if mainMenu.Drawings.DrawDMG:Value() then
if CanUseSpell(myHero,_R) == READY and GoS:ValidTarget(target, 2000) then
	DrawDmgOverHpBar(target,GetCurrentHP(target),trueDMGr,0,0xff00ff00)
	
elseif GotBuff(target,"zedulttargetmark") == 1 then
	ArmorTarget = GetArmor(target)
	ArmorA = (100/(100+GetArmor(target)))-1
	Reduction = math.sqrt(math.pow(ArmorA,2)) + 1
	extraDMG = StartHP - EndHP
	MarkDMG = GoS:CalcDamage(myHero, target, 0, ((0.15*GetCastLevel(myHero,_R) + 0.05) * (Reduction * extraDMG)) + (GetBaseDamage(myHero) + GetBonusDmg(myHero)))
	DrawDmgOverHpBar(target,GetCurrentHP(target),MarkDMG,0,0xff00ff00)
		
	-- PrintChat("Mark DMG: ".. MarkDMG)
else
	DrawDmgOverHpBar(target,GetCurrentHP(target),DPS,0,0xff00ff00)
end	
end
-- Auto E
if mainMenu.Combo.AutoE:Value() then
	if GoS:ValidTarget(target, 290) and mainMenu.Combo.AutoE:Value() then
		CastSpell(_E)
	end
-- W _E	
	if CanUseSpell(myHero,_E) == READY and mainMenu.Combo.AutoE:Value() then
		local wEPred = GetPredictionForPlayer(vWPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_E),0,false,false)
			if CanUseSpell(myHero, _E) == READY and wEPred.HitChance == 1 then
				CastSpell(_E)
			end
	end
-- R _E	
	if CanUseSpell(myHero,_E) == READY and mainMenu.Combo.AutoE:Value() then
		local rEPred = GetPredictionForPlayer(vRPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_E),0,false,false)
			if CanUseSpell(myHero, _E) == READY and rEPred.HitChance == 1 then
				CastSpell(_E)
			end
	end	
end

-- W Tracker
OnProcessSpell(function(unit, spell)
  if unit and unit == myHero and spell then
    if spell.name:lower():find("zedw") then
	WPosx = spell.endPos.x
	WPosy = spell.endPos.y
	WPosz = spell.endPos.z
	vWPos = Vector(spell.endPos.x,spell.endPos.y,spell.endPos.z)
	-- WPos = math.sqrt(math.pow((WPosx),2) + math.pow((WPosx),2) + math.pow((WPosx),2))
	elseif spell.name:lower():find("zedw2") then
	WPosx = spell.startPos.x
	WPosy = spell.startPos.y
	WPosz = spell.startPos.z
	vWPos = Vector(spell.startPos.x,spell.startPos.y,spell.startPos.z)
	-- WPos = math.sqrt(math.pow((WPosx),2) + math.pow((WPosx),2) + math.pow((WPosx),2))
	elseif CanUseSpell(myHero,_W) == ONCOOLDOWN then
	
	WPosx = 1
	WPosy = 1
	WPosz = 1
	vWPos = Vector(WPosx,WPosy,WPosz)
	end  
  end
end)

-- R Tracker
OnProcessSpell(function(unit, spell)
  if unit and unit == myHero and spell then
    if spell.name:lower():find("zedult") then
	RPosx = spell.startPos.x
	RPosy = spell.startPos.y
	RPosz = spell.startPos.z
	vRPos = Vector(RPosx,RPosy,spell.RPosz)
	
	elseif spell.name:lower():find("zedr2") then
	RPosx = spell.startPos.x
	RPosy = spell.startPos.y
	RPosz = spell.startPos.z
	vRPos = Vector(RPosx,RPosy,RPosz)
	
	elseif CanUseSpell(myHero,_R) == ONCOOLDOWN then
	
	RPosx = 1
	RPosy = 1
	RPosz = 1
	vRPos = Vector(RPosx,RPosy,RPosz)
	end  
  end
end)

-- Draw R Shadow
if mainMenu.Drawings.DrawRShadow:Value() then
if RPosx > 1 and CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_E) == READY then
	DrawCircle(RPosx,RPosy,RPosz,GetCastRange(myHero,_Q),1,50,0xff0ffff0)
	DrawCircle(RPosx,RPosy,RPosz,GetCastRange(myHero,_E),1,50,0xff0ffff0)
	DrawCircle(RPosx,RPosy,RPosz,100,1,50,0xff0ffff0)
elseif RPosx > 1 and CanUseSpell(myHero,_Q) == READY then
	DrawCircle(RPosx,RPosy,RPosz,GetCastRange(myHero,_Q),1,50,0xff0ffff0)
	DrawCircle(RPosx,RPosy,RPosz,100,1,50,0xff0ffff0)
elseif RPosx > 1 and CanUseSpell(myHero,_E) == READY then
	DrawCircle(RPosx,RPosy,RPosz,GetCastRange(myHero,_E),1,50,0xff0ffff0)
	DrawCircle(RPosx,RPosy,RPosz,100,1,50,0xff0ffff0)	
elseif RPosx > 1 then
	DrawCircle(RPosx,RPosy,RPosz,100,1,50,0xff0ffff0)
elseif RPosx == 1 then
	-- DrawCircle(RPosx,RPosy,RPosz,50,1,50,0xff0ffff0)	
end	
end

-- Draw W Shadow
if mainMenu.Drawings.DrawWShadow:Value() then
if WPosx > 1 and CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_E) == READY then
	DrawCircle(WPosx,WPosy,WPosz,GetCastRange(myHero,_Q),1,50,0xff00ff00)
	DrawCircle(WPosx,WPosy,WPosz,GetCastRange(myHero,_E),1,50,0xff00ff00)
	DrawCircle(WPosx,WPosy,WPosz,100,1,50,0xff00ff00)
elseif WPosx > 1 and CanUseSpell(myHero,_Q) == READY then
	DrawCircle(WPosx,WPosy,WPosz,GetCastRange(myHero,_Q),1,50,0xff00ff00)
	DrawCircle(WPosx,WPosy,WPosz,100,1,50,0xff00ff00)
elseif WPosx > 1 and CanUseSpell(myHero,_E) == READY then
	DrawCircle(WPosx,WPosy,WPosz,GetCastRange(myHero,_E),1,50,0xff00ff00)
	DrawCircle(WPosx,WPosy,WPosz,100,1,50,0xff00ff00)	
elseif WPosx > 1 then
	DrawCircle(WPosx,WPosy,WPosz,100,1,50,0xff00ff00)
elseif WPosx == 1 then
	-- DrawCircle(WPosx,WPosy,WPosz,100,1,50,0xff00ff00)	
end			
end

-- Combo
if mainMenu.Combo.Combo1:Value() then

--- Items
	if CutBlade >= 1 and GoS:ValidTarget(target,550) and mainMenu.Items.useCut:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3144)) == READY then
			CastTargetSpell(target, GetItemSlot(myHero,3144))
		end	
	elseif bork >= 1 and GoS:ValidTarget(target,550) and (GetMaxHP(myHero) / GetCurrentHP(myHero)) >= 1.25 and mainMenu.Items.useBork:Value() then 
		if CanUseSpell(myHero,GetItemSlot(myHero,3153)) == READY then
			CastTargetSpell(target,GetItemSlot(myHero,3153))
		end
	end

	if ghost >= 1 and GoS:ValidTarget(target,550) and mainMenu.Items.useGhost:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3142)) == READY then
			CastSpell(GetItemSlot(myHero,3142))
		end
	end
	
	if redpot >= 1 and GoS:ValidTarget(target,550) and mainMenu.Items.useRedPot:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,2140)) == READY then
			CastSpell(GetItemSlot(myHero,2140))
		end
	end
---


	if GoS:ValidTarget(target, 2000) then
	Ticker = GetTickCount()	

-- W Gab Combo
if mainMenu.Combo.useW:Value() and mainMenu.Combo.gabW:Value() then

-- W
	if CanUseSpell(myHero,_W) == READY and mainMenu.Combo.useW:Value() and mainMenu.Combo.gabW:Value() then
		local WPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),300,300,GetCastRange(myHero,_W),250,false,false)
            if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 and GoS:ValidTarget(target, GetCastRange(myHero,_W)) then
				CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
				end
			end
-- W _Q	
	if CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() and mainMenu.Combo.useW:Value() then
		local wQPred = GetPredictionForPlayer(vWPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_Q),50,false,false)
            if CanUseSpell(myHero, _Q) == READY and wQPred.HitChance == 1 then
                CastSkillShot(_Q,wQPred.PredPos.x,wQPred.PredPos.y,wQPred.PredPos.z)
		end     
	end	

-- R _Q	
	if CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() then
		local rQPred = GetPredictionForPlayer(vRPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_Q),50,false,false)
            if CanUseSpell(myHero, _Q) == READY and rQPred.HitChance == 1 then
                CastSkillShot(_Q,rQPred.PredPos.x,rQPred.PredPos.y,rQPred.PredPos.z)
		end     
	end		
			
-- Q
	if CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() then
		local QPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_Q),50,false,false)
            if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and GoS:ValidTarget(target, GetCastRange(myHero,_Q)) then
                CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end     
	end

-- W _E	
	if CanUseSpell(myHero,_E) == READY and mainMenu.Combo.useE:Value() and mainMenu.Combo.useW:Value() then
		local wEPred = GetPredictionForPlayer(vWPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_E),0,false,false)
			if CanUseSpell(myHero, _E) == READY and wEPred.HitChance == 1 then
				CastSpell(_E)
			end
	end	

-- R _E	
	if CanUseSpell(myHero,_E) == READY and mainMenu.Combo.useE:Value() then
		local rEPred = GetPredictionForPlayer(vRPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_E),0,false,false)
			if CanUseSpell(myHero, _E) == READY and rEPred.HitChance == 1 then
				CastSpell(_E)
			end
	end	
	
-- E
	if CanUseSpell(myHero,_E) == READY and GoS:ValidTarget(target, 200) and mainMenu.Combo.useE:Value() then
		CastSpell(_E)
	end
end		
										
-- W Once Combo
if mainMenu.Combo.useW:Value() and not mainMenu.Combo.gabW:Value() then

-- W with ticker
	if CanUseSpell(myHero,_W) == READY and GotBuff(myHero,"zedwhandler") == 0 and mainMenu.Combo.useW:Value() then
		 local WPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),300,300,GetCastRange(myHero,_W),250,false,false)

		 if (global_ticks + 5000) < Ticker then
            if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 and GoS:ValidTarget(target, GetCastRange(myHero,_W)) and mainMenu.Combo.useW:Value() then
				CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)

						global_ticks = Ticker
						-- PrintChat("Test!")
				end
			end
	end	
	
-- Q
	if CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() then
		local QPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_Q),50,false,false)
            if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and GoS:ValidTarget(target, GetCastRange(myHero,_Q)) then
                CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end     
	end
	
-- W _Q	
	if CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() and mainMenu.Combo.useW:Value() then
		local wQPred = GetPredictionForPlayer(vWPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_Q),50,false,false)
            if CanUseSpell(myHero, _Q) == READY and wQPred.HitChance == 1 then
                CastSkillShot(_Q,wQPred.PredPos.x,wQPred.PredPos.y,wQPred.PredPos.z)
		end     
	end

-- R _Q	
	if CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() then
		local rQPred = GetPredictionForPlayer(vRPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_Q),50,false,false)
            if CanUseSpell(myHero, _Q) == READY and rQPred.HitChance == 1 then
                CastSkillShot(_Q,rQPred.PredPos.x,rQPred.PredPos.y,rQPred.PredPos.z)
		end     
	end	
	
-- W _E
	if CanUseSpell(myHero,_E) == READY and mainMenu.Combo.useE:Value() and mainMenu.Combo.useW:Value() then
		local wEPred = GetPredictionForPlayer(vWPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_E),0,false,false)
			if CanUseSpell(myHero, _E) == READY and wEPred.HitChance == 1 then
				CastSpell(_E)
			end
	end

-- R _E	
	if CanUseSpell(myHero,_E) == READY and mainMenu.Combo.useE:Value() then
		local rEPred = GetPredictionForPlayer(vRPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_E),0,false,false)
			if CanUseSpell(myHero, _E) == READY and rEPred.HitChance == 1 then
				CastSpell(_E)
			end
	end		
	
-- E
	if CanUseSpell(myHero,_E) == READY and GoS:ValidTarget(target, 200) and mainMenu.Combo.useE:Value() then
		CastSpell(_E)
	end
end

-- Manual W
if not mainMenu.Combo.useW:Value() and not mainMenu.Combo.gabW:Value() then

-- Q
	if CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() then
		local QPred = GetPredictionForPlayer(myHeroPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_Q),50,false,false)
            if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and GoS:ValidTarget(target, GetCastRange(myHero,_Q)) then
                CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end     
	end
	
-- W _Q	
	if CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() then
		local wQPred = GetPredictionForPlayer(vWPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_Q),50,false,false)
            if CanUseSpell(myHero, _Q) == READY and wQPred.HitChance == 1 then
                CastSkillShot(_Q,wQPred.PredPos.x,wQPred.PredPos.y,wQPred.PredPos.z)
		end     
	end

-- R _Q	
	if CanUseSpell(myHero,_Q) == READY and mainMenu.Combo.useQ:Value() then
		local rQPred = GetPredictionForPlayer(vRPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_Q),50,false,false)
            if CanUseSpell(myHero, _Q) == READY and rQPred.HitChance == 1 then
                CastSkillShot(_Q,rQPred.PredPos.x,rQPred.PredPos.y,rQPred.PredPos.z)
		end     
	end	
	
-- W _E
	if CanUseSpell(myHero,_E) == READY and mainMenu.Combo.useE:Value() then
		local wEPred = GetPredictionForPlayer(vWPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_E),0,false,false)
			if CanUseSpell(myHero, _E) == READY and wEPred.HitChance == 1 then
				CastSpell(_E)
			end
	end
	
-- E
	if CanUseSpell(myHero,_E) == READY and GoS:ValidTarget(target, 200) and mainMenu.Combo.useE:Value() then
		CastSpell(_E)
	end

-- R _E	
	if CanUseSpell(myHero,_E) == READY and mainMenu.Combo.useE:Value() then
		local rEPred = GetPredictionForPlayer(vRPos,target,GetMoveSpeed(target),1700,250,GetCastRange(myHero,_E),0,false,false)
			if CanUseSpell(myHero, _E) == READY and rEPred.HitChance == 1 then
				CastSpell(_E)
			end
	end		
	
end	
end
end
end)

function Killsteal()
       for i,enemy in pairs(GoS:GetEnemyHeroes()) do
			
			if CanUseSpell(myHero,_Q) == READY then 
				qDMG = GoS:CalcDamage(myHero, enemy, 0, (24*GetCastLevel(myHero,_Q)+21+(0.6*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))))
				qDMGpre = (24*GetCastLevel(myHero,_Q)+21+(0.6*(GetBaseDamage(myHero) + GetBonusDmg(myHero))))
			else qDMG = 0
				 qDMGpre = 0
			end
			
			if CanUseSpell(myHero,_E) == READY then 
				eDMG = GoS:CalcDamage(myHero, enemy, 0, (30*GetCastLevel(myHero,_E)+30+(0.8*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))))
				eDMGpre = (30*GetCastLevel(myHero,_E)+30+(0.8*(GetBaseDamage(myHero) + GetBonusDmg(myHero))))
			else eDMG = 0
				 eDMGpre = 0
			end
			
			DPS = qDMG + eDMG
			DPSpre = qDMGpre + eDMGpre
			
			if CanUseSpell(myHero,_R) == READY then
				AADMG = GoS:CalcDamage(myHero, enemy, 0, (GetBaseDamage(myHero) + GetBonusDmg(myHero)))
				trueDMGr = GoS:CalcDamage(myHero, enemy, 0, (((0.15*GetCastLevel(myHero,_R) + 0.05) * DPSpre ) + (GetBaseDamage(myHero) + GetBonusDmg(myHero)) + AADMG)) + DPSpre
			else trueDMGr = 0
			end
			
            if CanUseSpell(myHero, _R) == READY and GoS:ValidTarget(enemy,GetCastRange(myHero,_R)) and mainMenu.Combo.ksR:Value() and GetCurrentHP(enemy) < trueDMGr then
            CastTargetSpell(enemy, _R)
			StartHP = GetCurrentHP(enemy)
            end
      end
end

function Drawings()
myHeroPos = GetOrigin(myHero)
if CanUseSpell(myHero, _Q) == READY and mainMenu.Drawings.DrawQ:Value() then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_Q),1,100,0xff00ff00)
	elseif CanUseSpell(myHero, _Q) == ONCOOLDOWN and mainMenu.Drawings.DrawQ:Value() then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_Q),1,100,0xffff0000)
	end
if CanUseSpell(myHero, _W) == READY and mainMenu.Drawings.DrawW:Value() then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_W),1,100,0xff00ff00)
	elseif CanUseSpell(myHero, _W) == ONCOOLDOWN and mainMenu.Drawings.DrawW:Value() then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_W),1,100,0xffff0000)
	end
if CanUseSpell(myHero, _E) == READY and mainMenu.Drawings.DrawE:Value() then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_E),1,100,0xff00ff00) 
	elseif CanUseSpell(myHero, _E) == ONCOOLDOWN and mainMenu.Drawings.DrawE:Value() then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_E),1,100,0xffff0000)
	end
if CanUseSpell(myHero, _R) == READY and mainMenu.Drawings.DrawR:Value() then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_R),2,100,0xff00ff00) 
	elseif CanUseSpell(myHero, _R) == ONCOOLDOWN and mainMenu.Drawings.DrawR:Value() then DrawCircle(myHeroPos.x,myHeroPos.y,myHeroPos.z,GetCastRange(myHero,_R),1,100,0xffff0000)
	end
end

PrintChat("Zed - The Shadow loaded.")
PrintChat("by Noddy")
