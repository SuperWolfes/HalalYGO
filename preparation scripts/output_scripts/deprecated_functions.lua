if not load then
	return
end
local function make_deprecated_function_alias(old_funcname,new_funcname)
	load(old_funcname .. [[= function(...)
		Debug.PrintStacktrace()
		Debug.Message("]] .. old_funcname .. [[ is deprecated, use ]] .. new_funcname .. [[ instead")
		return load("return ]] .. new_funcname .. [[(...)")(...)
	end]],"make_deprecated_function_alias")()
end
--Functions deprecated since version 40.0:
make_deprecated_function_alias("Auxiliary.AskAny","Duel.AskAny")
make_deprecated_function_alias("Auxiliary.AskEveryone","Duel.AskEveryone")
make_deprecated_function_alias("Auxiliary.AnnounceAnotherAttribute","Duel.AnnounceAnotherAttribute")
make_deprecated_function_alias("Auxiliary.AnnounceAnotherRace","Duel.AnnounceAnotherRace")
make_deprecated_function_alias("Auxiliary.SelectEffect","Duel.SelectEffect")
make_deprecated_function_alias("Auxiliary.PlayFieldActional","Duel.ActivateFieldActional")
make_deprecated_function_alias("Auxiliary.CheckPendulumZones","Duel.CheckPendulumZones")
make_deprecated_function_alias("Auxiliary.nzatk","Card.HasNonZeroAttack")
make_deprecated_function_alias("Auxiliary.nzdef","Card.HasNonZeroDefense")
make_deprecated_function_alias("Auxiliary.disfilter1","Card.IsNegatableMonster")
make_deprecated_function_alias("Auxiliary.disfilter2","Card.IsNegatableActionalTrap")
make_deprecated_function_alias("Auxiliary.disfilter3","Card.IsNegatable")
make_deprecated_function_alias("Auxiliary.HasCounterListed","Card.ListsCounter")
make_deprecated_function_alias("Auxiliary.CanPlaceCounter","Card.PlacesCounter")
make_deprecated_function_alias("Auxiliary.EquipByEffectLimit","Card.EquipByEffectLimit")
make_deprecated_function_alias("Auxiliary.EquipByEffectAndLimitRegister","Card.EquipByEffectAndLimitRegister")
make_deprecated_function_alias("Auxiliary.IsMaterialListCode","Card.ListsCodeAsMaterial")
make_deprecated_function_alias("Auxiliary.IsMaterialListSetCard","Card.ListsArchetypeAsMaterial")
make_deprecated_function_alias("Auxiliary.IsArchetypeCodeListed","Card.ListsCodeWithArchetype")
make_deprecated_function_alias("Auxiliary.IsCodeListed","Card.ListsCode")
make_deprecated_function_alias("Auxiliary.IsCardTypeListed","Card.ListsCardType")
make_deprecated_function_alias("Auxiliary.HasListedSetCode","Card.ListsArchetype")
make_deprecated_function_alias("Auxiliary.IsDualState","Dual.EffectStatusCondition")
make_deprecated_function_alias("Auxiliary.IsNotDualState","Auxiliary.NOT(Dual.EffectStatusCondition)")
make_deprecated_function_alias("Auxiliary.DualNormalCondition","Dual.NormalStatusCondition")
make_deprecated_function_alias("Auxiliary.EnableDualAttribute","Dual.AddProcedure")
make_deprecated_function_alias("Auxiliary.EnableGuardianReturn","Guardian.AddProcedure")
make_deprecated_function_alias("Auxiliary.GuardianReturnReg","Guardian.SummonRegister")
make_deprecated_function_alias("Auxiliary.GuardianReturnOperation","Guardian.ReturnOperation")
make_deprecated_function_alias("Auxiliary.FilterFaceupFunction","Auxiliary.FaceupFilter")
make_deprecated_function_alias("Auxiliary.MZFilter","Card.IsInMainMZone")
make_deprecated_function_alias("Card.IsDifferentAttribute","Card.IsAttributeExcept")

local function make_deleted_function(funcname,message)
	load(funcname .. [[= function()
		error("]].. funcname ..[[ was deleted. ]] .. message .. [[",2)
	end]])()
end
--Deleted functions
make_deleted_function("Auxiliary.CallToken","Use Duel.LoadCardScript or Duel.LoadScript instead.")
make_deleted_function("Auxiliary.GuardianReturnCondition","Check Guardian.MandatoryReturnCondition and Guardian.OptionalReturnCondition for more details.")
make_deleted_function("Auxiliary.GuardianReturnTarget","Check Guardian.MandatoryReturnTarget and Guardian.OptionalReturnTarget for more details.")