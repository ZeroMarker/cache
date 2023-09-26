Class CHSSWeb.HISInterface.PersonLifeStyleInterface Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lihongquan
/// CreatDate：2010—02-24
/// Description:个人档案接口--检索身份证号返回个人生活方式信息(HIS调用)
/// Table：PersonLifeStyleInfo
/// Input:IDCard
/// Output：
/// Return：
/// Others：
ClassMethod GetData(IDCard As %String)
{
	;n (IDCard)
	set returnData = ""
	Set IDCard=$G(IDCard)
	Set reportReportData = ##class(CHSSWeb.HISInterface.PersonLifeStyleInfoData).%New()
	s IDCard=" "_IDCard
	Set start=$G(start)
	Set limit=$G(limit)
	Set sort=$G(sort)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	set PersonRowId = 0
	set RelateROWID = 0
	s reportData = ""
		
	Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("IDCardIndex",IDCard,PersonRowId))
	q:PersonRowId="" ""
	For  Set RelateROWID=$O(^CHSS.PersonLifeStyleI("PersonIndex",PersonRowId,RelateROWID)) q:RelateROWID=""  d
	.
	.s tempPerson=##class(CHSS.PersonLifeStyle).%OpenId(RelateROWID)
	.s reportData = ##class(CHSSWeb.HISInterface.PersonLifeStyleInfo).%New()
	.
	.i tempPerson.PersonRowIdParref'="" d
	..s reportData.PersonRowId = tempPerson.PersonRowIdParref.%Id()
	..s reportData.PersonCode = tempPerson.PersonRowIdParref.PersonCode
	..s reportData.PersonName = tempPerson.PersonRowIdParref.PersonName
	..
	..i tempPerson.PersonRowIdParref.SexDR '= "" d
	...s reportData.SexName = tempPerson.PersonRowIdParref.SexDR.CTSEXDesc
	..
	..set Birth = tempPerson.PersonRowIdParref.Birth
	..i Birth '= "" d
	...s reportData.Birth = $zd(Birth,3)
	.
	.s reportData.DoctorRegister = tempPerson.DoctorRegister
	.
	.i tempPerson.IsExercise '="" d
	..s IsExerciseName=tempPerson.IsExercise.Description
	..s reportData.IsExercise=IsExerciseName
	.
	.i tempPerson.ExerciseInfoDR'="" d
	..s reportData.ExerciseInfoDR= tempPerson.ExerciseInfoDR.Description
	.
	.s reportData.ExercisePlace = tempPerson.ExercisePlace 
	.s reportData.DateOfExercisePer = tempPerson.DateOfExercisePer 
	.s reportData.YearOfExercise = tempPerson.YearOfExercise 
	.s reportData.MiddleWorkDays = tempPerson.MiddleWorkDays 
	.s reportData.TimeOfMiddleWork = tempPerson.TimeOfMiddleWork 
	.s reportData.MiddleExercise = tempPerson.MiddleExercise 
	.s reportData.TimeOfMiddleExer = tempPerson.TimeOfMiddleExer 
	.s reportData.TemperType  = tempPerson.TemperType 
	.s reportData.Doings = tempPerson.Doings 
	.
	.i tempPerson.SleepStatus'="" d
	..s reportData.SleepStatus = tempPerson.SleepStatus.Description  
	.
	.s reportData.SleepHour = tempPerson.SleepHour 
	.
	.i tempPerson.DietHabit '= "" d
	.s reportData.DietHabit  = tempPerson.DietHabit.Description
	.
	.s reportData.DietNotEat = tempPerson.DietNotEat 
	.
	.i tempPerson.Smoke '= "" d
	..s reportData.Smoke = tempPerson.Smoke.Description
	.
	.s DateOfStartSmoke = tempPerson.DateOfStartSmoke 
	.i DateOfStartSmoke '= "" d
	..s reportData.DateOfStartSmoke = $zd(DateOfStartSmoke,3)
	.
	.s reportData.YearsOfEndSmoke = tempPerson.YearsOfEndSmoke 
	.s DateOfEndSmoke = tempPerson.DateOfEndSmoke 
	.i DateOfEndSmoke '= "" d
	..s reportData.DateOfEndSmoke = $zd(DateOfEndSmoke,3)
	.
	.s reportData.NumOfSmoke = tempPerson.NumOfSmoke  
	.s reportData.DCSC = tempPerson.DCSC 
	.
	.i tempPerson.Drink '= "" d 
	..s reportData.Drink = tempPerson.Drink.Description
	.
	.s reportData.DPAC = tempPerson.DPAC 
	.s reportData.DPACofYear = tempPerson.DPACofYear 
	.s reportData.DPACofMonth = tempPerson.DPACofMonth 
	.
	.i tempPerson.DrinkFrequencyDR '="" d
	..s reportData.DrinkFrequencyDR = tempPerson.DrinkFrequencyDR.Description
	.
	.s DateOfStartDrink = tempPerson.DateOfStartDrink
	.i DateOfStartDrink '="" d
	..s reportData.DateOfStartDrink = $zd(DateOfStartDrink,3)
	.
	.s reportData.AgeOfStartDrink = tempPerson.AgeOfStartDrink 
	.s DateOfEndDrink = tempPerson.DateOfEndDrink 
	.i DateOfEndDrink '="" d
	..s reportData.DateOfEndDrink = $zd(DateOfEndDrink,3)
	.
	.s reportData.DrinkType = tempPerson.DrinkType 
	.s reportData.DrinkTypeName = tempPerson.DrinkTypeName 
	.s reportData.bDryOut = tempPerson.bDryOut 
	.s reportData.AgeOfEndDrink = tempPerson.AgeOfEndDrink 
	.s reportData.MentalStatus = tempPerson.MentalStatus 
	.s reportData.bConfide = tempPerson.bConfide 
	.s reportData.bFeelPressure = tempPerson.bFeelPressure 
	.s reportData.PsychologicStatus = tempPerson.PsychologicStatus 
	.
	.i tempPerson.ComplyDoctor '= "" d
	..s reportData.ComplyDoctor = tempPerson.ComplyDoctor.Description
	.
	.s reportData.OtherCustom = tempPerson.OtherCustom 
	.s reportData.Salinity = tempPerson.Salinity 
	.s reportData.DietTime = tempPerson.DietTime 
	.s reportData.OilQuantity = tempPerson.OilQuantity 
	.s reportData.OxygenHour = tempPerson.OxygenHour 
	.s reportData.FluBacterin = tempPerson.FluBacterin 
	.
	.i tempPerson.Pneumococcus '="" d
	..s reportData.Pneumococcus =tempPerson.Pneumococcus.Description
	.  
	.s reportData.bFamilyCoal = tempPerson.bFamilyCoal 
	.s reportData.FamilyCoalYears =tempPerson.FamilyCoalYears 
	.s reportData.bFamilySmoke = tempPerson.bFamilySmoke 
	.s reportData.PlaceOfResidence = tempPerson.PlaceOfResidence 
	.
	.s DateOfYearCheck = tempPerson.DateOfYearCheck 
	.i DateOfYearCheck '="" d
	..s reportData.DateOfYearCheck =$zd(DateOfYearCheck,3)
	.
	.s DateOfUpdate = tempPerson.DateOfUpdate 
	.i DateOfUpdate '="" d
	..s reportData.DateOfUpdate = $zd(DateOfUpdate,3)
	.
	.s reportData.StaffOfUpdate = tempPerson.StaffOfUpdate 
	.s reportData.EatFatDays = tempPerson.EatFatDays 
	.s reportData.EatDeepFryDays = tempPerson.EatDeepFryDays 
	.s reportData.EatPickleDays = tempPerson.EatPickleDays 
	.s reportData.EatSweetmeatDays = tempPerson.EatSweetmeatDays 
	.s reportData.EatFruitQuantity = tempPerson.EatFruitQuantity 
	.s reportData.FoodFavor = tempPerson.FoodFavor
	.s reportData.TimesOfWeekly = tempPerson.TimesOfWeekly
	.
	.
	.;第二种方法：手工拼写
	.Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.PersonLifeStyleInfo")
 	.s returnData =returnData_"<PersonLifeSyleInfo>"
	. // get list of properties
	.;Write "---Properties---",!
	.Set count = cdef.Properties.Count()
	.For i = 1:1:count d
    ..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	..s returnData = returnData_"</PersonLifeSyleInfo>"
 	.

 	Quit returnData
}

/// Creator:jinming
/// CreateDate:2011-05-20
ClassMethod PersonLifeStyleInfo(personRowId As %String, checkRowId As %String) As %String
{
	set returnData = ""
	Set personRowId=$G(personRowId)
	s checkRowId = $g(checkRowId)
	Set reportReportData = ##class(CHSSWeb.HISInterface.PersonLifeStyleInfoData).%New()
	s reportData = ""
	q:personRowId="" ""
	s RelateROWID = 0
	f  s RelateROWID=$o(^CHSS.PersonLifeStyleI("PersonIndex",personRowId,RelateROWID)) q:RelateROWID=""  d
	.s tempPerson=##class(CHSS.PersonLifeStyle).%OpenId(RelateROWID)
	.s reportData = ##class(CHSSWeb.HISInterface.PersonLifeStyleInfo).%New()
	.q:tempPerson.YearCheckRowIdParref'=checkRowId  d
	.i tempPerson.PersonRowIdParref'="" d
	..s reportData.PersonRowId = tempPerson.PersonRowIdParref.%Id()
	..s reportData.PersonCode = tempPerson.PersonRowIdParref.PersonCode
	..s reportData.PersonName = tempPerson.PersonRowIdParref.PersonName
	..i tempPerson.PersonRowIdParref.SexDR '= "" d
	...s reportData.SexName = tempPerson.PersonRowIdParref.SexDR.CTSEXDesc
	..set Birth = tempPerson.PersonRowIdParref.Birth
	..i Birth '= "" d
	...s reportData.Birth = $zd(Birth,3)
	.s reportData.DoctorRegister = tempPerson.DoctorRegister
	.i tempPerson.IsExercise '="" d
	..s IsExerciseName=tempPerson.IsExercise.Description
	..s reportData.IsExercise=IsExerciseName
	.i tempPerson.ExerciseInfoDR'="" d
	..s reportData.ExerciseInfoDR= tempPerson.ExerciseInfoDR.Description
	.s reportData.DateOfExercisePer = tempPerson.DateOfExercisePer 
	.s reportData.YearOfExercise = tempPerson.YearOfExercise 
	.s reportData.MiddleWorkDays = tempPerson.MiddleWorkDays 
	.s reportData.TimeOfMiddleWork = tempPerson.TimeOfMiddleWork 
	.s reportData.MiddleExercise = tempPerson.MiddleExercise 
	.s reportData.TimeOfMiddleExer = tempPerson.TimeOfMiddleExer 
	.s reportData.TemperType  = tempPerson.TemperType 
	.s reportData.Doings = tempPerson.Doings 
	.i tempPerson.SleepStatus'="" d
	..s reportData.SleepStatus = tempPerson.SleepStatus.Description  
	.s reportData.SleepHour = tempPerson.SleepHour 
	.i tempPerson.DietHabit '= "" d
	.s reportData.DietHabit  = tempPerson.DietHabit.Description
	.s reportData.DietNotEat = tempPerson.DietNotEat 
	.i tempPerson.Smoke '= "" d
	..s reportData.Smoke = tempPerson.Smoke.Description
	.s DateOfStartSmoke = tempPerson.DateOfStartSmoke 
	.i DateOfStartSmoke '= "" d
	..s reportData.DateOfStartSmoke = $zd(DateOfStartSmoke,3)
	.s reportData.YearsOfEndSmoke = tempPerson.YearsOfEndSmoke 
	.s DateOfEndSmoke = tempPerson.DateOfEndSmoke 
	.i DateOfEndSmoke '= "" d
	..s reportData.DateOfEndSmoke = $zd(DateOfEndSmoke,3)
	.s reportData.NumOfSmoke = tempPerson.NumOfSmoke  
	.s reportData.DCSC = tempPerson.DCSC 
	.i tempPerson.Drink '= "" d 
	..s reportData.Drink = tempPerson.Drink.Description
	.s reportData.DPAC = tempPerson.DPAC 
	.s reportData.DPACofYear = tempPerson.DPACofYear 
	.s reportData.DPACofMonth = tempPerson.DPACofMonth 
	.i tempPerson.DrinkFrequencyDR '="" d
	..s reportData.DrinkFrequencyDR = tempPerson.DrinkFrequencyDR.Description
	.s DateOfStartDrink = tempPerson.DateOfStartDrink
	.i DateOfStartDrink '="" d
	..s reportData.DateOfStartDrink = $zd(DateOfStartDrink,3)
	.s reportData.AgeOfStartDrink = tempPerson.AgeOfStartDrink 
	.s DateOfEndDrink = tempPerson.DateOfEndDrink 
	.i DateOfEndDrink '="" d
	..s reportData.DateOfEndDrink = $zd(DateOfEndDrink,3)
	.s reportData.bDryOut = tempPerson.bDryOut 
	.s reportData.AgeOfEndDrink = tempPerson.AgeOfEndDrink 
	.s reportData.MentalStatus = tempPerson.MentalStatus 
	.s reportData.bConfide = tempPerson.bConfide 
	.s reportData.bFeelPressure = tempPerson.bFeelPressure 
	.s reportData.PsychologicStatus = tempPerson.PsychologicStatus 
	.i tempPerson.ComplyDoctor '= "" d
	..s reportData.ComplyDoctor = tempPerson.ComplyDoctor.Description
	.s reportData.OtherCustom = tempPerson.OtherCustom 
	.s reportData.Salinity = tempPerson.Salinity 
	.s reportData.DietTime = tempPerson.DietTime 
	.s reportData.OilQuantity = tempPerson.OilQuantity 
	.s reportData.OxygenHour = tempPerson.OxygenHour 
	.s reportData.FluBacterin = tempPerson.FluBacterin 
	.i tempPerson.Pneumococcus '="" d
	..s reportData.Pneumococcus =tempPerson.Pneumococcus.Description
	.s reportData.bFamilyCoal = tempPerson.bFamilyCoal 
	.s reportData.FamilyCoalYears =tempPerson.FamilyCoalYears 
	.s reportData.bFamilySmoke = tempPerson.bFamilySmoke 
	.s reportData.PlaceOfResidence = tempPerson.PlaceOfResidence 
	.s DateOfYearCheck = tempPerson.DateOfYearCheck 
	.i DateOfYearCheck '="" d
	..s reportData.DateOfYearCheck =$zd(DateOfYearCheck,3)
	.s DateOfUpdate = tempPerson.DateOfUpdate 
	.i DateOfUpdate '="" d
	..s reportData.DateOfUpdate = $zd(DateOfUpdate,3)
	.s reportData.StaffOfUpdate = tempPerson.StaffOfUpdate 
	.s reportData.EatFatDays = tempPerson.EatFatDays 
	.s reportData.EatDeepFryDays = tempPerson.EatDeepFryDays 
	.s reportData.EatPickleDays = tempPerson.EatPickleDays 
	.s reportData.EatSweetmeatDays = tempPerson.EatSweetmeatDays 
	.s reportData.EatFruitQuantity = tempPerson.EatFruitQuantity 
	.s reportData.TimesOfWeekly = tempPerson.TimesOfWeekly
	
	.s reportData.ExerciseTypeDRName = ""
	.i tempPerson.ExerciseTypeDR '= "" d
	..s reportData.ExerciseTypeDR = tempPerson.ExerciseTypeDR
	..s tempExerciseType = tempPerson.ExerciseTypeDR
	..s reportData.ExerciseTypeDRName=##class(CHSSWeb.HISInterface.DictQuery).GetDictQuery(tempExerciseType,"DictExerciseType")
	
	.s reportData.ExercisePlaceName = ""
	.i tempPerson.ExercisePlace '= "" d
	..s reportData.ExercisePlace = tempPerson.ExercisePlace
	..s tempExerciseP = tempPerson.ExercisePlace
	..s reportData.ExercisePlaceName=##class(CHSSWeb.HISInterface.DictQuery).GetDictQuery(tempExerciseP,"DictExercisePlace")
	
	.s reportData.FoodFavorValue = ""
	.i tempPerson.FoodFavor '= "" d
	..s reportData.FoodFavor = tempPerson.FoodFavor
	..s tempFoodFavor = tempPerson.FoodFavor
	..s reportData.FoodFavorValue=##class(CHSSWeb.HISInterface.DictQuery).GetDictQuery(tempFoodFavor,"DictDietHabit")
		
	.s reportData.DrinkTypeName = ""
	.i tempPerson.DrinkType '= "" d
	..s reportData.DrinkType = tempPerson.DrinkType
	..s tempDrinkType = tempPerson.DrinkType
	..s reportData.DrinkTypeName=##class(CHSSWeb.HISInterface.DictQuery).GetDictQuery(tempDrinkType,"DictDrinkType")
	
	.Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.PersonLifeStyleInfo")
 	.s returnData =returnData_"<PersonLifeSyleInfo>"
	.Set count = cdef.Properties.Count()
	.For i = 1:1:count d
    ..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	.s returnData = returnData_"</PersonLifeSyleInfo>"
 	q returnData
}

Storage Default
{
<Data name="PersonLifeStyleInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonLifeSt999D</DataLocation>
<DefaultData>PersonLifeStyleInterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonLifeSt999D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonLifeSt999I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonLifeSt999S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
