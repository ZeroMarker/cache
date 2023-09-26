Class CHSSWeb.PersonLifeStyleService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//检索

ClassMethod List(PersonRowIdParref, Start, Limit)
{
	Set PersonRowIdParref=$G(PersonRowIdParref)
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	s RelateROWID=0
	
	
    For  Set RelateROWID=$O(^CHSS.PersonLifeStyleI("PersonIndex",PersonRowIdParref,RelateROWID)) q:RelateROWID=""  d
	.s tempPerson=##class(CHSS.PersonLifeStyle).%OpenId(RelateROWID)
	
	
	.s DoctorRegister=tempPerson.DoctorRegister
	
	.s IsExercise=""
	.s IsExerciseName=""
	.i tempPerson.IsExercise'="" d
	..s IsExercise=tempPerson.IsExercise.%Id()
	..s IsExerciseName=tempPerson.IsExercise.Description
	
	.s ExerciseInfoDR=""
	.s ExerciseInfoDRName=""
	.i tempPerson.ExerciseInfoDR '="" d
	..s ExerciseInfoDR=tempPerson.ExerciseInfoDR.%Id()
	..s ExerciseInfoDRName = tempPerson.ExerciseInfoDR.Description
	
	.s ExerciseTypeDR=tempPerson.ExerciseTypeDR
	.s ExercisePlace = tempPerson.ExercisePlace
	.
	.s DateOfExercisePer=tempPerson.DateOfExercisePer
	.s YearOfExercise=tempPerson.YearOfExercise
	.
	.s MiddleWorkDays=tempPerson.MiddleWorkDays 
	.
	.s TimeOfMiddleWork=tempPerson.TimeOfMiddleWork
	.
	.s MiddleExercise=tempPerson.MiddleExercise
	.
	.s TimeOfMiddleExer=tempPerson.TimeOfMiddleExer
	.s TemperType = tempPerson.TemperType
	.s Doings=tempPerson.Doings
	.
	.s SleepStatus=""
	.s SleepStatusName = ""
	.i tempPerson.SleepStatus '= "" d
	..s SleepStatus = tempPerson.SleepStatus.%Id()
	..s SleepStatusName = tempPerson.SleepStatus.Description
	.
	.s SleepHour=tempPerson.SleepHour
	.
	.s DietHabit=""
	.s DietHabitName=""
	.i tempPerson.DietHabit '="" d
	..s DietHabit = tempPerson.DietHabit.%Id()
	..s DietHabitName = tempPerson.DietHabit.Description
	.
	.s DietNotEat=tempPerson.DietNotEat
	
	.s Smoke=""
	.s SmokeName=""
	.i tempPerson.Smoke'="" d
	..s Smoke=tempPerson.Smoke.%Id()
	..s SmokeName=tempPerson.Smoke.Description
	
	.s DateOfStartSmoke=tempPerson.DateOfStartSmoke
	.s DateOfEndSmoke=tempPerson.DateOfEndSmoke
	.s YearsOfEndSmoke=tempPerson.YearsOfEndSmoke
	
	.s NumOfSmoke=tempPerson.NumOfSmoke
	.s DCSC=tempPerson.DCSC
	.
	.s Drink=""
	.s DrinkName=""
	.i tempPerson.Drink'="" d
	..s Drink=tempPerson.Drink.%Id()
	..s DrinkName=tempPerson.Drink.Description
	.
	.s DPAC=tempPerson.DPAC
	.s DPACofYear=tempPerson.DPACofYear
	.s DPACofMonth=tempPerson.DPACofMonth
	
	.s DrinkFrequencyDR = ""
	.s DrinkFrequencyDRName = ""
	.i tempPerson.DrinkFrequencyDR '= "" d
	..s DrinkFrequencyDR=tempPerson.DrinkFrequencyDR.%Id()
	..s DrinkFrequencyDRName=tempPerson.DrinkFrequencyDR.Description
	.
	.s DateOfStartDrink=tempPerson.DateOfStartDrink
	.i DateOfStartDrink'="" d
	..s DateOfStartDrink=$zd(DateOfStartDrink,3)
	.
	.s AgeOfStartDrink=tempPerson.AgeOfStartDrink
	.
	.s DateOfEndDrink=tempPerson.DateOfEndDrink
	.i DateOfEndDrink'="" d
	..s DateOfEndDrink=$zd(DateOfEndDrink,3)
	.
	.s DrinkType=tempPerson.DrinkType
	.s DrinkTypeName=tempPerson.DrinkTypeName
	
	.
	.s bDryOut=tempPerson.bDryOut
	.s AgeOfEndDrink=tempPerson.AgeOfEndDrink
	.s MentalStatus=tempPerson.MentalStatus
	.s bConfide=tempPerson.bConfide
	.s bFeelPressure=tempPerson.bFeelPressure
	.s PsychologicStatus=tempPerson.PsychologicStatus
	
	.s ComplyDoctor = ""
	.s ComplyDoctorName = ""
	.i tempPerson.ComplyDoctor '= "" d
	..s ComplyDoctor=tempPerson.ComplyDoctor.%Id()
	..s ComplyDoctorName=tempPerson.ComplyDoctor.Description
	.
	.s OtherCustom=tempPerson.OtherCustom
	.s Salinity=tempPerson.Salinity
	.s DietTime=tempPerson.DietTime
	.s OilQuantity=tempPerson.OilQuantity
	.s OxygenHour=tempPerson.OxygenHour
	.s FluBacterin=tempPerson.FluBacterin
	.
	.s Pneumococcus=""
	.s PneumococcusName = ""
	.i tempPerson.Pneumococcus '= "" d
	..s Pneumococcus = tempPerson.Pneumococcus.%Id()
	..s PneumococcusName = tempPerson.Pneumococcus.Description
	.
	.s bFamilyCoal=tempPerson.bFamilyCoal
	.s FamilyCoalYears=tempPerson.FamilyCoalYears
	.s bFamilySmoke=tempPerson.bFamilySmoke
	.s PlaceOfResidence=tempPerson.PlaceOfResidence
	.
	.s DateOfYearCheck=tempPerson.DateOfYearCheck
    .i DateOfYearCheck'="" d
    ..s DateOfYearCheck=$zd(DateOfYearCheck,3)
    .
	.s DateOfUpdate=tempPerson.DateOfUpdate
	.i DateOfUpdate'="" d
	..s DateOfUpdate=$zd(DateOfUpdate,3)
	.
	.s StaffOfUpdate=tempPerson.StaffOfUpdate
	.s EatFatDays=tempPerson.EatFatDays
	.s EatDeepFryDays=tempPerson.EatDeepFryDays
	.s EatPickleDays=tempPerson.EatPickleDays
	.s EatSweetmeatDays=tempPerson.EatSweetmeatDays
	.s EatFruitQuantity=tempPerson.EatFruitQuantity
	.s FoodFavor=tempPerson.FoodFavor
	.s TimesOfWeekly=tempPerson.TimesOfWeekly
	
	.s tmp=""
	.s tmp=RelateROWID_"^"_PersonRowIdParref_"^"_DoctorRegister_"^"_IsExercise_"^"_IsExerciseName_"^"_ExerciseInfoDR_"^"_ExerciseInfoDRName_"^"_ExerciseTypeDR_"^"_ExercisePlace_"^"_DateOfExercisePer_"^"_YearOfExercise_"^"_MiddleWorkDays_"^"_TimeOfMiddleWork_"^"_MiddleExercise_"^"_TimeOfMiddleExer_"^"_TemperType_"^"_Doings_"^"_SleepStatus_"^"_SleepStatusName_"^"_SleepHour_"^"_DietHabit_"^"_DietHabitName_"^"_DietNotEat_"^"_Smoke_"^"_SmokeName_"^"_DateOfStartSmoke_"^"_DateOfEndSmoke_"^"_YearsOfEndSmoke_"^"_NumOfSmoke_"^"_DCSC_"^"_Drink_"^"_DrinkName_"^"_DPAC_"^"_DPACofYear_"^"_DPACofMonth_"^"_DrinkFrequencyDR_"^"_DrinkFrequencyDRName_"^"_DateOfStartDrink_"^"_AgeOfStartDrink_"^"_DateOfEndDrink_"^"_DrinkType_"^"_DrinkTypeName_"^"_bDryOut_"^"_AgeOfEndDrink_"^"_MentalStatus_"^"_bConfide_"^"_bFeelPressure_"^"_PsychologicStatus_"^"_ComplyDoctor_"^"_ComplyDoctorName_"^"_OtherCustom_"^"_Salinity_"^"_DietTime_"^"_OilQuantity_"^"_OxygenHour_"^"_FluBacterin_"^"_Pneumococcus_"^"_PneumococcusName_"^"_bFamilyCoal_"^"_FamilyCoalYears_"^"_bFamilySmoke_"^"_PlaceOfResidence_"^"_DateOfYearCheck_"^"_DateOfUpdate_"^"_StaffOfUpdate_"^"_EatFatDays_"^"_EatDeepFryDays_"^"_EatPickleDays_"^"_EatSweetmeatDays_"^"_EatFruitQuantity_"^"_FoodFavor_"^"_TimesOfWeekly
	.s count=count+1
	.i (count>start)&(count<=end) d
    ..d json.InsertRowData(tmp)
	s resultString = json.getJsonData("RelateROWID^PersonRowIdParref^DoctorRegister1^IsExercise^IsExerciseName^ExerciseInfoDR^ExerciseInfoDRName^ExerciseTypeDR^ExercisePlace^DateOfExercisePer^YearOfExercise^MiddleWorkDays^TimeOfMiddleWork^MiddleExercise^TimeOfMiddleExer^TemperType^Doings^SleepStatus^SleepStatusName^SleepHour^DietHabit^DietHabitName^DietNotEat^Smoke^SmokeName^DateOfStartSmoke^DateOfEndSmoke^YearsOfEndSmoke^NumOfSmoke^DCSC^Drink^DrinkName^DPAC^DPACofYear^DPACofMonth^DrinkFrequencyDR^DrinkFrequencyDRName^DateOfStartDrink^AgeOfStartDrink^DateOfEndDrink^DrinkType^DrinkTypeName^bDryOut^AgeOfEndDrink^MentalStatus^bConfide^bFeelPressure^PsychologicStatus^ComplyDoctor^ComplyDoctorName^OtherCustom^Salinity^DietTime^OilQuantity^OxygenHour^FluBacterin^Pneumococcus^PneumococcusName^bFamilyCoal^FamilyCoalYears^bFamilySmoke^PlaceOfResidence^DateOfYearCheck^DateOfUpdate1^StaffOfUpdate^EatFatDays^EatDeepFryDays^EatPickleDays^EatSweetmeatDays^EatFruitQuantity^FoodFavor^TimesOfWeekly",count)
	k json	
	Quit resultString
}

ClassMethod GetListWithPYCRowId(YearCheckRowIdParref, PersonRowIdParref)
{
	Set count=0
	Set resultString = ""
	d ..insertWithRowId(PersonRowIdParref,YearCheckRowIdParref)
	Set json = ##class(Code.JsonObj).%New()
	s RelateROWID=0
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RelateROWID  FROM CHSS.PersonLifeStyle where YearCheckRowIdParref = "_YearCheckRowIdParref
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RelateROWID = result.Data("RelateROWID")
	}
	d result.Close()
	q:(RelateROWID=0) ""
    i RelateROWID '= "" d
	.s tempPerson=##class(CHSS.PersonLifeStyle).%OpenId(RelateROWID)
	
	
	.s DoctorRegister=""
	
	.s IsExercise=""
	.s IsExerciseName=""
	.i tempPerson.IsExercise'="" d
	..s IsExercise=tempPerson.IsExercise.%Id()
	..s IsExerciseName=tempPerson.IsExercise.Description
	
	.s ExerciseInfoDR=""
	.s ExerciseInfoDRName=""
	.i tempPerson.ExerciseInfoDR '="" d
	..s ExerciseInfoDR=tempPerson.ExerciseInfoDR.%Id()
	..s ExerciseInfoDRName = tempPerson.ExerciseInfoDR.Description
	
	.s ExerciseTypeDR=tempPerson.ExerciseTypeDR
	.s ExercisePlace = tempPerson.ExercisePlace
	.
	.s DateOfExercisePer=tempPerson.DateOfExercisePer
	.s YearOfExercise=tempPerson.YearOfExercise
	.
	.s MiddleWorkDays=tempPerson.MiddleWorkDays 
	.
	.s TimeOfMiddleWork=tempPerson.TimeOfMiddleWork
	.
	.s MiddleExercise=tempPerson.MiddleExercise
	.
	.s TimeOfMiddleExer=tempPerson.TimeOfMiddleExer
	.s TemperType = tempPerson.TemperType
	.s Doings=tempPerson.Doings
	.
	.s SleepStatus=""
	.s SleepStatusName = ""
	.i tempPerson.SleepStatus '= "" d
	..s SleepStatus = tempPerson.SleepStatus.%Id()
	..s SleepStatusName = tempPerson.SleepStatus.Description
	.
	.s SleepHour=tempPerson.SleepHour
	.
	.s DietHabit=""
	.s DietHabitName=""
	.i tempPerson.DietHabit '="" d
	..s DietHabit = tempPerson.DietHabit.%Id()
	..s DietHabitName = tempPerson.DietHabit.Description
	.
	.s DietNotEat=tempPerson.DietNotEat
	
	.s Smoke=""
	.s SmokeName=""
	.i tempPerson.Smoke'="" d
	..s Smoke=tempPerson.Smoke.%Id()
	..s SmokeName=tempPerson.Smoke.Description
	
	.s DateOfStartSmoke=tempPerson.DateOfStartSmoke
	.s DateOfEndSmoke=tempPerson.DateOfEndSmoke
	.s YearsOfEndSmoke=tempPerson.YearsOfEndSmoke
	
	.s NumOfSmoke=tempPerson.NumOfSmoke
	.s DCSC=tempPerson.DCSC
	.
	.s Drink=""
	.s DrinkName=""
	.i tempPerson.Drink'="" d
	..s Drink=tempPerson.Drink.%Id()
	..s DrinkName=tempPerson.Drink.Description
	.
	.s DPAC=tempPerson.DPAC
	.s DPACofYear=tempPerson.DPACofYear
	.s DPACofMonth=tempPerson.DPACofMonth
	
	.s DrinkFrequencyDR = ""
	.s DrinkFrequencyDRName = ""
	.i tempPerson.DrinkFrequencyDR '= "" d
	..s DrinkFrequencyDR=tempPerson.DrinkFrequencyDR.%Id()
	..s DrinkFrequencyDRName=tempPerson.DrinkFrequencyDR.Description
	.
	.s DateOfStartDrink=tempPerson.DateOfStartDrink
	.i DateOfStartDrink'="" d
	..s DateOfStartDrink=$zd(DateOfStartDrink,3)
	.
	.s AgeOfStartDrink=tempPerson.AgeOfStartDrink
	.
	.s DateOfEndDrink=tempPerson.DateOfEndDrink
	.i DateOfEndDrink'="" d
	..s DateOfEndDrink=$zd(DateOfEndDrink,3)
	.
	.s DrinkType=tempPerson.DrinkType
	.s DrinkTypeName=tempPerson.DrinkTypeName
	
	.
	.s bDryOut=tempPerson.bDryOut
	.s AgeOfEndDrink=tempPerson.AgeOfEndDrink
	.s MentalStatus=tempPerson.MentalStatus
	.s bConfide=tempPerson.bConfide
	.s bFeelPressure=tempPerson.bFeelPressure
	.s PsychologicStatus=tempPerson.PsychologicStatus
	
	.s ComplyDoctor = ""
	.s ComplyDoctorName = ""
	.i tempPerson.ComplyDoctor '= "" d
	..s ComplyDoctor=tempPerson.ComplyDoctor.%Id()
	..s ComplyDoctorName=tempPerson.ComplyDoctor.Description
	.
	.s OtherCustom=tempPerson.OtherCustom
	.s Salinity=tempPerson.Salinity
	.s DietTime=tempPerson.DietTime
	.s OilQuantity=tempPerson.OilQuantity
	.s OxygenHour=tempPerson.OxygenHour
	.s FluBacterin=tempPerson.FluBacterin
	.
	.s Pneumococcus=""
	.s PneumococcusName = ""
	.i tempPerson.Pneumococcus '= "" d
	..s Pneumococcus = tempPerson.Pneumococcus.%Id()
	..s PneumococcusName = tempPerson.Pneumococcus.Description
	.
	.s bFamilyCoal=tempPerson.bFamilyCoal
	.s FamilyCoalYears=tempPerson.FamilyCoalYears
	.s bFamilySmoke=tempPerson.bFamilySmoke
	.s PlaceOfResidence=tempPerson.PlaceOfResidence
	.
	.s DateOfYearCheck=tempPerson.DateOfYearCheck
    .i DateOfYearCheck'="" d
    ..s DateOfYearCheck=$zd(DateOfYearCheck,3)
    .
	.s DateOfUpdate=tempPerson.DateOfUpdate
	.i DateOfUpdate'="" d
	..s DateOfUpdate=$zd(DateOfUpdate,3)
	.
	.s StaffOfUpdate=tempPerson.StaffOfUpdate
	.s EatFatDays=tempPerson.EatFatDays
	.s EatDeepFryDays=tempPerson.EatDeepFryDays
	.s EatPickleDays=tempPerson.EatPickleDays
	.s EatSweetmeatDays=tempPerson.EatSweetmeatDays
	.s EatFruitQuantity=tempPerson.EatFruitQuantity
	.s FoodFavor=tempPerson.FoodFavor
	.s TimesOfWeekly=tempPerson.TimesOfWeekly
	.s OtherDrinkType = tempPerson.OtherDrinkType
	.s tmp=""
	.s tmp=RelateROWID_"^"_PersonRowIdParref_"^"_DoctorRegister_"^"_IsExercise_"^"_IsExerciseName_"^"_ExerciseInfoDR_"^"_ExerciseInfoDRName_"^"_ExerciseTypeDR_"^"_ExercisePlace_"^"_DateOfExercisePer_"^"_YearOfExercise_"^"_MiddleWorkDays_"^"_TimeOfMiddleWork_"^"_MiddleExercise_"^"_TimeOfMiddleExer_"^"_TemperType_"^"_Doings_"^"_SleepStatus_"^"_SleepStatusName_"^"_SleepHour_"^"_DietHabit_"^"_DietHabitName_"^"_DietNotEat_"^"_Smoke_"^"_SmokeName_"^"_DateOfStartSmoke_"^"_DateOfEndSmoke_"^"_YearsOfEndSmoke_"^"_NumOfSmoke_"^"_DCSC_"^"_Drink_"^"_DrinkName_"^"_DPAC_"^"_DPACofYear_"^"_DPACofMonth_"^"_DrinkFrequencyDR_"^"_DrinkFrequencyDRName_"^"_DateOfStartDrink_"^"_AgeOfStartDrink_"^"_DateOfEndDrink_"^"_DrinkType_"^"_DrinkTypeName_"^"_bDryOut_"^"_AgeOfEndDrink_"^"_MentalStatus_"^"_bConfide_"^"_bFeelPressure_"^"_PsychologicStatus_"^"_ComplyDoctor_"^"_ComplyDoctorName_"^"_OtherCustom_"^"_Salinity_"^"_DietTime_"^"_OilQuantity_"^"_OxygenHour_"^"_FluBacterin_"^"_Pneumococcus_"^"_PneumococcusName_"^"_bFamilyCoal_"^"_FamilyCoalYears_"^"_bFamilySmoke_"^"_PlaceOfResidence_"^"_DateOfYearCheck_"^"_DateOfUpdate_"^"_StaffOfUpdate_"^"_EatFatDays_"^"_EatDeepFryDays_"^"_EatPickleDays_"^"_EatSweetmeatDays_"^"_EatFruitQuantity_"^"_FoodFavor_"^"_TimesOfWeekly_"^"_OtherDrinkType
	.s count=count+1
	.d json.InsertRowData(tmp)
	s resultString = json.getJsonData("RelateROWID^PersonRowIdParref^DoctorRegister1^IsExercise^IsExerciseName^ExerciseInfoDR^ExerciseInfoDRName^ExerciseTypeDR^ExercisePlace^DateOfExercisePer^YearOfExercise^MiddleWorkDays^TimeOfMiddleWork^MiddleExercise^TimeOfMiddleExer^TemperType^Doings^SleepStatus^SleepStatusName^SleepHour^DietHabit^DietHabitName^DietNotEat^Smoke^SmokeName^DateOfStartSmoke^DateOfEndSmoke^YearsOfEndSmoke^NumOfSmoke^DCSC^Drink^DrinkName^DPAC^DPACofYear^DPACofMonth^DrinkFrequencyDR^DrinkFrequencyDRName^DateOfStartDrink^AgeOfStartDrink^DateOfEndDrink^DrinkType^DrinkTypeName^bDryOut^AgeOfEndDrink^MentalStatus^bConfide^bFeelPressure^PsychologicStatus^ComplyDoctor^ComplyDoctorName^OtherCustom^Salinity^DietTime^OilQuantity^OxygenHour^FluBacterin^Pneumococcus^PneumococcusName^bFamilyCoal^FamilyCoalYears^bFamilySmoke^PlaceOfResidence^DateOfYearCheck^DateOfUpdate1^StaffOfUpdate^EatFatDays^EatDeepFryDays^EatPickleDays^EatSweetmeatDays^EatFruitQuantity^FoodFavor^TimesOfWeekly^OtherDrinkType",count)
	k json	
	Quit resultString
}

//添加/修改

ClassMethod insertupdate(RelateROWID, PersonRowIdParref, DoctorRegister, IsExercise, ExerciseInfoDR, ExerciseTypeDR, ExercisePlace, DateOfExercisePer, YearOfExercise, MiddleWorkDays, TimeOfMiddleWork, MiddleExercise, TimeOfMiddleExer, TemperType, Doings, SleepStatus, SleepHour, DietHabit, DietNotEat, Smoke, DateOfStartSmoke, YearsOfEndSmoke, DateOfEndSmoke, NumOfSmoke, DCSC, Drink, DPAC, DPACofYear, DPACofMonth, DrinkFrequencyDR, DateOfStartDrink, AgeOfStartDrink, DateOfEndDrink, DrinkType, bDryOut, AgeOfEndDrink, MentalStatus, bConfide, bFeelPressure, PsychologicStatus, ComplyDoctor, OtherCustom, Salinity, DietTime, OilQuantity, OxygenHour, FluBacterin, Pneumococcus, bFamilyCoal, FamilyCoalYears, bFamilySmoke, PlaceOfResidence, DateOfYearCheck, DateOfUpdate, StaffOfUpdate, EatFatDays, EatDeepFryDays, EatPickleDays, EatSweetmeatDays, EatFruitQuantity, FoodFavor, TimesOfWeekly, OtherDrinkType)
{
	s tempPerson = ""
	
	i RelateROWID '="" d
	.s tempPerson=##class(CHSS.PersonLifeStyle).%OpenId(RelateROWID)
	e  d
	.s tempPerson =##class(CHSS.PersonLifeStyle).%New()
	
    i PersonRowIdParref '="" d
    .s PersonRowIdDRobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
    .s tempPerson.PersonRowIdParref=PersonRowIdDRobj
    
	s tempPerson.DoctorRegister=DoctorRegister
	
	i IsExercise'="" d
	.s tempPerson.IsExercise=##class(CHSS.DictExercise).%OpenId(IsExercise)
	
	i ExerciseInfoDR'="" d
	.s tempPerson.ExerciseInfoDR=##class(CHSS.DictExerciseFre).%OpenId(ExerciseInfoDR)
	
	s tempPerson.ExerciseTypeDR=ExerciseTypeDR
	s tempPerson.ExercisePlace=ExercisePlace
	
	s tempPerson.DateOfExercisePer=DateOfExercisePer
	s tempPerson.YearOfExercise=YearOfExercise
	
	s tempPerson.MiddleWorkDays=MiddleWorkDays
	s tempPerson.TimeOfMiddleWork=TimeOfMiddleWork
	s tempPerson.MiddleExercise=MiddleExercise
	s tempPerson.TimeOfMiddleExer=TimeOfMiddleExer
	s tempPerson.TemperType=TemperType
	
	s tempPerson.Doings=Doings
	
	i SleepStatus'="" d
	.s tempPerson.SleepStatus=##class(CHSS.DictSleepStatus).%OpenId(SleepStatus)
	
	s tempPerson.SleepHour=SleepHour
	
	i DietHabit'="" d
	.s tempPerson.DietHabit=##class(CHSS.DictDietHabit).%OpenId(DietHabit)
	
	s tempPerson.DietNotEat=DietNotEat
	
	i Smoke'="" d
	.s tempPerson.Smoke=##class(CHSS.DictSmoke).%OpenId(Smoke)

	s tempPerson.DateOfStartSmoke=DateOfStartSmoke
	s tempPerson.DateOfEndSmoke=DateOfEndSmoke
	s tempPerson.YearsOfEndSmoke=YearsOfEndSmoke
	
	s tempPerson.NumOfSmoke=NumOfSmoke
	s tempPerson.DCSC=DCSC
	
	i Drink'="" d
	.s tempPerson.Drink=##class(CHSS.DictDrink).%OpenId(Drink)
	s tempPerson.DPAC=DPAC
	s tempPerson.DPACofYear=DPACofYear
	s tempPerson.DPACofMonth=DPACofMonth
	
	i DrinkFrequencyDR'="" d
	.s tempPerson.DrinkFrequencyDR=##class(CHSS.DictDrinkFrequency).%OpenId(DrinkFrequencyDR)
	
	i DateOfStartDrink'="" d
	.s tempPerson.DateOfStartDrink=$zdh(DateOfStartDrink,3)
	
	s tempPerson.AgeOfStartDrink=AgeOfStartDrink
	
	i DateOfEndDrink'="" d
	.s tempPerson.DateOfEndDrink=$zdh(DateOfEndDrink,3)
	
	
	s tempPerson.DrinkType=DrinkType
	
	s tempPerson.bDryOut=bDryOut
	s tempPerson.AgeOfEndDrink=AgeOfEndDrink
	s tempPerson.MentalStatus=MentalStatus
	s tempPerson.bConfide=bConfide
	s tempPerson.bFeelPressure=bFeelPressure
	s tempPerson.PsychologicStatus=PsychologicStatus
	
	i ComplyDoctor '= "" d
	.s tempPerson.ComplyDoctor=##class(CHSS.DictComplyDoctor).%OpenId(ComplyDoctor)
	
	s tempPerson.OtherCustom=OtherCustom
	s tempPerson.Salinity=Salinity
	s tempPerson.DietTime=DietTime
	s tempPerson.OilQuantity=OilQuantity
	s tempPerson.OxygenHour=OxygenHour
	s tempPerson.FluBacterin=FluBacterin
	
	i Pneumococcus'="" d
	.s tempPerson.Pneumococcus=##class(CHSS.DictPneumococcus).%OpenId(Pneumococcus)
	
	s tempPerson.bFamilyCoal=bFamilyCoal
	s tempPerson.FamilyCoalYears=FamilyCoalYears
	s tempPerson.bFamilySmoke=bFamilySmoke
	s tempPerson.PlaceOfResidence=PlaceOfResidence
	
	i DateOfYearCheck'="" d
	.s tempPerson.DateOfYearCheck=$zdh(DateOfYearCheck,3)
	
	i DateOfUpdate'="" d
	.s tempPerson.DateOfUpdate=$zdh(DateOfUpdate,3)
	
	s tempPerson.StaffOfUpdate=StaffOfUpdate
	s tempPerson.EatFatDays=EatFatDays
	s tempPerson.EatDeepFryDays=EatDeepFryDays
	s tempPerson.EatPickleDays=EatPickleDays
	s tempPerson.EatSweetmeatDays=EatSweetmeatDays
	s tempPerson.EatFruitQuantity=EatFruitQuantity
	s tempPerson.FoodFavor=FoodFavor
	s tempPerson.TimesOfWeekly=TimesOfWeekly
	s tempPerson.OtherDrinkType = OtherDrinkType
    s result=""
    s result=tempPerson.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempPerson.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod delete(RowId)
{
	q:(RowId = "") ""
	s tempPerson=##class(CHSS.PersonLifeStyle).%OpenId(RowId)
	q:(tempPerson="") ""
	
	s result=tempPerson.%DeleteId(RowId)
	
	i result = "1" d
    .w "{""success"":""true"",""info"":""数据删除成功！""}"
    .
    e  d
    .w "{""success"":""false"",""info"":""数据删除出错！""}"
    .
    q ""
}

ClassMethod ShowDrink(RelateROWID, Start, Limit)
{
	Set RelateROWID=$G(RelateROWID)
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set startStr = "'"
	s tmp=""
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT DrinkRowId,DrinkType,YearDrink,TimesOfMonth,QuanityOfDrink  FROM CHSS.PersonDrinkInfo where RelateROWID ="_RelateROWID

	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
	s DrinkType = result.Data("DrinkType")
	s YearDrink= result.Data("YearDrink")
	s TimesOfMonth= result.Data("TimesOfMonth")
	s QuanityOfDrink= result.Data("QuanityOfDrink")
	
	s tmp=tmp_startStr_DrinkType_","_YearDrink_"月/年,"_TimesOfMonth_"次/月,"_QuanityOfDrink_"量/次"
	s startStr = "\r\n"
	}
	i tmp '= "" d
	.s tmp = tmp_"'"
	.
	e  d
	.s tmp = """"""
	w "{""success"":""true"",""info"":"_tmp_"}"
	q ""
}

ClassMethod insertWithRowId(PersonRowId As %Integer, YearCheckRowId As %Integer) As %String
{
	s RelateROWID = ""
	&SQL(select RelateROWID into :RelateROWID from CHSS.PersonLifeStyle where YearCheckRowIdParref=:YearCheckRowId)
   	;w PersonRowId,!
   	;w YearCheckRowId,!
    i RelateROWID = "" d
	.&SQL(insert into CHSS.PersonLifeStyle (YearCheckRowIdParref,PersonRowIdParref) values (:YearCheckRowId,:PersonRowId))
    q ""
}

Storage Default
{
<Data name="PersonLifeStyleServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonLifeSt8D9D</DataLocation>
<DefaultData>PersonLifeStyleServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonLifeSt8D9D</IdLocation>
<IndexLocation>^CHSSWeb.PersonLifeSt8D9I</IndexLocation>
<StreamLocation>^CHSSWeb.PersonLifeSt8D9S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
