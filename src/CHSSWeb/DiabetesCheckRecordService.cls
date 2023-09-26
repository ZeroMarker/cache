Class CHSSWeb.DiabetesCheckRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod DiabetesCheckRecordList(PersonRowIdParref As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
		
		Set PersonRowIdParref=$G(PersonRowIdParref)
		s PersonRowIdParref=PersonRowIdParref
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set RowId = 0
		For  Set RowId=$O(^CHSS.DiabetesCheckRecordI("PersonRowIdParrefIndex",PersonRowIdParref,RowId)) q:RowId=""  d
		.s tempDiabetesCheckRecord=##class(CHSS.DiabetesCheckRecord).%OpenId(RowId)
		.s DateCheck = tempDiabetesCheckRecord.DateCheck
	    .i DateCheck '= "" d
		..s DateCheck=$zd(DateCheck,3)
		.set CheckAdd = tempDiabetesCheckRecord.CheckAdd
		.set CheckDoctor = tempDiabetesCheckRecord.CheckDoctor
		.set Symptom = tempDiabetesCheckRecord.Symptom
		.set OtherSymptom = tempDiabetesCheckRecord.OtherSymptom
		.//set Temperature = tempDiabetesCheckRecord.Temperature
		.//set Breath = tempDiabetesCheckRecord.Breath
		.//set Pulse = tempDiabetesCheckRecord.Pulse
		.set nHighPressure = tempDiabetesCheckRecord.nHighPressure
		.set nLowPressure = tempDiabetesCheckRecord.nLowPressure
		.set HeartRate = tempDiabetesCheckRecord.HeartRate
		.set OtherCheck = tempDiabetesCheckRecord.OtherCheck
		.set Weight = tempDiabetesCheckRecord.Weight
		.set Height = tempDiabetesCheckRecord.Height
		.set BMI = tempDiabetesCheckRecord.BMI
		.set FootArteryThrob = tempDiabetesCheckRecord.FootArteryThrob
		
		
		.set Food=""
		.set FoodName=""
		.i tempDiabetesCheckRecord.Food '= "" d
		..set FoodName = tempDiabetesCheckRecord.Food.Description
		..set Food = tempDiabetesCheckRecord.Food.%Id()
		
		
		
		.s DateOfStopSmoke = tempDiabetesCheckRecord.DateOfStopSmoke
	    .i DateOfStopSmoke '= "" d
		..s DateOfStopSmoke=$zd(DateOfStopSmoke,3)
		.set bDrink = tempDiabetesCheckRecord.bDrink
		.set Drink = tempDiabetesCheckRecord.Drink
		.set DrinkQuentity = tempDiabetesCheckRecord.DrinkQuentity
		.set Exercise = tempDiabetesCheckRecord.Exercise
		.set Other = tempDiabetesCheckRecord.Other
		.set WaistlineStern = tempDiabetesCheckRecord.WaistlineStern
		.set Waistline = tempDiabetesCheckRecord.Waistline
		.set Stern = tempDiabetesCheckRecord.Stern
	    .s BookingDate = tempDiabetesCheckRecord.BookingDate
	    .i BookingDate '= "" d
		..s BookingDate=$zd(BookingDate,3)
		.set bBooking = tempDiabetesCheckRecord.bBooking
		.set Smoke= tempDiabetesCheckRecord.Smoke
		.set ExerciseNum = tempDiabetesCheckRecord.ExerciseNum
		.set ExerciseMin = tempDiabetesCheckRecord.ExerciseMin
		.set DrugSideEffect = tempDiabetesCheckRecord.DrugSideEffect
		.set DoseComplier = tempDiabetesCheckRecord.DoseComplier
	    .set BloodAfterDining = tempDiabetesCheckRecord.BloodAfterDining
	    .set BloodAfterDiningOfTwo = tempDiabetesCheckRecord.BloodAfterDiningOfTwo
	    .set BloodSurgeLimosis = tempDiabetesCheckRecord.BloodSurgeLimosis
	    .set Cholesterin = tempDiabetesCheckRecord.Cholesterin
	    .set HbAlC = tempDiabetesCheckRecord.HbAlC
	    .set OtherOfBlood = tempDiabetesCheckRecord.OtherOfBlood
	    .set Hb = tempDiabetesCheckRecord.Hb
	    .set NAlbumen = tempDiabetesCheckRecord.NAlbumen
	    .set NOther = tempDiabetesCheckRecord.NOther
	    .set SugarInDay = tempDiabetesCheckRecord.SugarInDay
	    .set UniteIll = tempDiabetesCheckRecord.UniteIll
	    .set CaseType = tempDiabetesCheckRecord.CaseType
		.set bCaseTrans = tempDiabetesCheckRecord.bCaseTrans
		.set BloodSurgeRate = ""
		.set BloodSurgeRateName = ""
		.i tempDiabetesCheckRecord.BloodSurgeRate '= "" d
		..set BloodSurgeRateName = tempDiabetesCheckRecord.BloodSurgeRate.Description
		..set BloodSurgeRate = tempDiabetesCheckRecord.BloodSurgeRate.%Id()
		.set Eyeground = ""
		.set EyegroundName = ""
		.i tempDiabetesCheckRecord.Eyeground '= "" d
		..set EyegroundName = tempDiabetesCheckRecord.Eyeground.Description
		..set Eyeground = tempDiabetesCheckRecord.Eyeground.%Id()
	    .set ComplyDoctor = ""
		.set ComplyDoctorName = ""
		.i tempDiabetesCheckRecord.ComplyDoctor '= "" d
		..set ComplyDoctortName = tempDiabetesCheckRecord.ComplyDoctor.Description
		..set ComplyDoctor = tempDiabetesCheckRecord.ComplyDoctor.%Id()
		.set MentalityAdjust = ""
		.set MentalityAdjustName = ""
		.i tempDiabetesCheckRecord.MentalityAdjust '= "" d
		..set MentalityAdjustName = tempDiabetesCheckRecord.MentalityAdjust.Description
		..set MentalityAdjust = tempDiabetesCheckRecord.MentalityAdjust.%Id()
		.set bAdverseEffects = tempDiabetesCheckRecord.bAdverseEffects
		.set DrugOfAdverseEffects = tempDiabetesCheckRecord.DrugOfAdverseEffects
		
		.set CheckType = ""
		.set CheckTypeName = ""
		.i tempDiabetesCheckRecord.CheckType '= "" d
		..set CheckTypeName = tempDiabetesCheckRecord.CheckType.Description
		..set CheckType = tempDiabetesCheckRecord.CheckType.%Id()
		
		
		.set CheckResult = ""
		.set CheckResultName = ""
		.i tempDiabetesCheckRecord.CheckResult '= "" d
		..set CheckResultName = tempDiabetesCheckRecord.CheckResult.Description
		..set CheckResult = tempDiabetesCheckRecord.CheckResult.%Id()
		.set EatDrug = tempDiabetesCheckRecord.EatDrug
		.set MentalStatus = tempDiabetesCheckRecord.MentalStatus
		.set Direction = tempDiabetesCheckRecord.Direction
		.set Remark = tempDiabetesCheckRecord.Remark
		.set SmokeNum = tempDiabetesCheckRecord.SmokeNum
		.set bTranfer = tempDiabetesCheckRecord.bTranfer
		.set TransferDept = ""
		.set TransferDeptName = ""
		.i tempDiabetesCheckRecord.TransferDept '= "" d
		..set TransferDeptName = tempDiabetesCheckRecord.TransferDept.CTLOCDesc
		..set TransferDept = tempDiabetesCheckRecord.TransferDept.%Id()
		.set TransferReason = tempDiabetesCheckRecord.TransferReason 
		.set ComplyDoctor = ""
		.set ComplyDoctorName = ""
		.i tempDiabetesCheckRecord.ComplyDoctor '= "" d
		..set ComplyDoctorName = tempDiabetesCheckRecord.ComplyDoctor.Description
		..set ComplyDoctor = tempDiabetesCheckRecord.ComplyDoctor.%Id()
		.set DrugRegularityRate = ""
		.set DrugRegularityRateName = ""
		.i tempDiabetesCheckRecord.DrugRegularityRate '= "" d
		..set DrugRegularityRateName = tempDiabetesCheckRecord.DrugRegularityRate.Description
		..set DrugRegularityRate = tempDiabetesCheckRecord.DrugRegularityRate.%Id()
		.set Deal = tempDiabetesCheckRecord.Deal
		.s DateOfInput = tempDiabetesCheckRecord.DateOfInput
	    .i DateOfInput '= "" d
		..s DateOfInput=$zd(DateOfInput,3)
		.s DateOfStopDrink = tempDiabetesCheckRecord.DateOfStopDrink
	    .i DateOfStopDrink '= "" d
		..s DateOfStopDrink=$zd(DateOfStopDrink,3)
		.s DateOfUpdate = tempDiabetesCheckRecord.DateOfUpdate
	    .i DateOfUpdate '= "" d
		..s DateOfUpdate=$zd(DateOfUpdate,3)
		.Set tmp= RowId_"^"_DateCheck_"^"_CheckAdd_"^"_CheckDoctor_"^"_Symptom_"^"_OtherSymptom_"^"_HeartRate_"^"_OtherCheck_"^"_Weight_"^"_Height_"^"_BMI_"^"_FootArteryThrob_"^"_Food_"^"_FoodName_"^"_DateOfStopSmoke_"^"_Drink_"^"_DrinkQuentity_"^"_Exercise_"^"_Other_"^"_WaistlineStern_"^"_BookingDate_"^"_bBooking_"^"_ExerciseNum_"^"_ExerciseMin_"^"_DrugSideEffect_"^"_DoseComplier_"^"_BloodAfterDining_"^"_BloodAfterDiningOfTwo_"^"_BloodSurgeLimosis_"^"_Cholesterin_"^"_HbAlC_"^"_OtherOfBlood_"^"_Hb_"^"_NAlbumen_"^"_NOther_"^"_SugarInDay_"^"_UniteIll_"^"_ComplyDoctor_"^"_ComplyDoctorName_"^"_MentalityAdjust_"^"_MentalityAdjustName_"^"_bAdverseEffects_"^"_DrugOfAdverseEffects_"^"_CheckResult_"^"_CheckResultName_"^"_EatDrug_"^"_Direction_"^"_Remark_"^"_bTranfer_"^"_TransferDept_"^"_TransferDeptName_"^"_TransferReason_"^"_DrugRegularityRate_"^"_DrugRegularityRateName_"^"_Deal_"^"_DateOfInput_"^"_DateOfUpdate_"^"_nHighPressure_"^"_nLowPressure_"^"_Smoke_"^"_SmokeNum_"^"_bDrink_"^"_DateOfStopDrink_"^"_CaseType_"^"_bCaseTrans_"^"_BloodSurgeRate_"^"_BloodSurgeRateName_"^"_Eyeground_"^"_EyegroundName_"^"_MentalStatus_"^"_Waistline_"^"_Stern_"^"_CheckType_"^"_CheckTypeName
	    .Set count=count+1
	    .If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("RowId^DateCheck^CheckAdd^CheckDoctor^Symptom^OtherSymptom^HeartRate^OtherCheck^Weight^Height^BMI^FootArteryThrob^Food^FoodName^DateOfStopSmoke^Drink^DrinkQuentity^Exercise^Other^WaistlineStern^BookingDate^bBooking^ExerciseNum^ExerciseMin^DrugSideEffect^DoseComplier^BloodAfterDining^BloodAfterDiningOfTwo^BloodSurgeLimosis^Cholesterin^HbAlC^OtherOfBlood^Hb^NAlbumen^NOther^SugarInDay^UniteIll^ComplyDoctor^ComplyDoctorName^MentalityAdjust^MentalityAdjustName^bAdverseEffects^DrugOfAdverseEffects^CheckResult^CheckResultName^EatDrug^Direction^Remark^bTranfer^TransferDept^TransferDeptName^TransferReason^DrugRegularityRate^DrugRegularityRateName^Deal^DateOfInput^DateOfUpdate^nHighPressure^nLowPressure^Smoke^SmokeNum^bDrink^DateOfStopDrink^CaseType^bCaseTrans^BloodSurgeRate^BloodSurgeRateName^Eyeground^EyegroundName^MentalStatus^Waistline^Stern^CheckType^CheckTypeName",count)
	 	k json
		Quit resultString
}

ClassMethod Insert(RowId As %Integer, PersonRowIdParref As %Integer, DateCheck As %Date, CheckAdd As %String, Symptom As %String, OtherSymptom As %String, CheckDoctor As %String, nHighPressure As %Numeric, nLowPressure As %Numeric, HeartRate As %Numeric, OtherCheck As %String, Weight As %Float, Height As %Float, BMI As %Float, FootArteryThrob As %String, Food As %Integer, DateOfStopSmoke As %Date, bSmoke As %String, Smoke As %String, SmokeNum As %Numeric, DateOfStopDrink As %Date, bDrink As %String, Drink As %String, DrinkQuentity As %Float, Exercise As %String, Other As %String, WaistlineStern As %Float, BookingDate As %Date, bBooking As %String, ExerciseNum As %Numeric, ExerciseMin As %Numeric, DrugSideEffect As %String, DoseComplier As %String, BloodAfterDining As %String, BloodAfterDiningOfTwo As %String, BloodSurgeLimosis As %String, Cholesterin As %String, HbAlC As %String, OtherOfBlood As %String, Hb As %String, NAlbumen As %String, NOther As %String, SugarInDay As %String, UniteIll As %String, ComplyDoctor As %Integer, MentalityAdjust As %Integer, bAdverseEffects As %String, DrugOfAdverseEffects As %String, CheckResult As %Integer, EatDrug As %String, Direction As %String, Remark As %String, bTranfer As %String, TransferDept As %Integer, TransferReason As %String, DrugRegularityRate As %Integer, Deal As %String, StaffInput As %Integer, DateOfInput As %Date, DateOfUpdate As %Date, CaseType As %String, bCaseTrans As %String, BloodSurgeRate As %Integer, Eyeground As %Integer, MentalStatus As %String, Waistline As %Float, Stern As %Float, CheckType) As %String
{
    s result =""
	s tempDiabetesCheckRecord=""
    s tempDiabetesCheckRecord=##class(CHSS.DiabetesCheckRecord).%New()
    q:(tempDiabetesCheckRecord="") 0
	 i PersonRowIdParref '="" d
    .s PersonRowIdParrefobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
    .s tempDiabetesCheckRecord.PersonRowIdParref=PersonRowIdParrefobj
	i DateCheck '="" d
	.s DateCheck=$zdh(DateCheck,3)
	.s tempDiabetesCheckRecord.DateCheck=DateCheck 
	i DateOfInput '="" d
	.s DateOfInput=$zdh(DateOfInput,3)
	.s tempDiabetesCheckRecord.DateOfInput=DateOfInput 
	//i DateOfUpdate '="" d
	//.s DateOfUpdate=$zdh(DateOfUpdate,3)
	//.s tempDiabetesCheckRecord.DateOfUpdate=DateOfUpdate 
	 s tempDiabetesCheckRecord.Remark=Remark
	 s tempDiabetesCheckRecord.Deal=Deal
	 s tempDiabetesCheckRecord.Direction=Direction
	 s tempDiabetesCheckRecord.BloodAfterDiningOfTwo=BloodAfterDiningOfTwo
	 s tempDiabetesCheckRecord.bAdverseEffects=bAdverseEffects
	 s tempDiabetesCheckRecord.BloodSurgeLimosis=BloodSurgeLimosis
	 s tempDiabetesCheckRecord.BloodAfterDining=BloodAfterDining
	 s tempDiabetesCheckRecord.EatDrug=EatDrug
	 s tempDiabetesCheckRecord.bDrink=bDrink
	 s tempDiabetesCheckRecord.Hb=Hb
	 s tempDiabetesCheckRecord.SugarInDay=SugarInDay
	 s tempDiabetesCheckRecord.NOther=NOther
	 s tempDiabetesCheckRecord.MentalStatus=MentalStatus
	 s tempDiabetesCheckRecord.DrugOfAdverseEffects=DrugOfAdverseEffects
	 s tempDiabetesCheckRecord.OtherOfBlood=OtherOfBlood
	 s tempDiabetesCheckRecord.HbAlC=HbAlC
	 s tempDiabetesCheckRecord.UniteIll=UniteIll
	 s tempDiabetesCheckRecord.NAlbumen=NAlbumen
     s tempDiabetesCheckRecord.SmokeNum=SmokeNum
	 s tempDiabetesCheckRecord.Cholesterin=Cholesterin
	 s tempDiabetesCheckRecord.FootArteryThrob=FootArteryThrob
	 s tempDiabetesCheckRecord.OtherCheck= OtherCheck
	 s tempDiabetesCheckRecord.DrugSideEffect= DrugSideEffect
     s tempDiabetesCheckRecord.CheckAdd= CheckAdd
	 s tempDiabetesCheckRecord.Exercise= Exercise
	
	
     i Food '= "" d
	.s Foodobj=##class(CHSS.DictFood).%OpenId(Food)
	.s tempDiabetesCheckRecord.Food=Foodobj
	 
	 i CheckType '= "" d
	.s CheckTypeobj=##class(CHSS.DictCheckType).%OpenId(CheckType)
	.s tempDiabetesCheckRecord.CheckType=CheckTypeobj
	
	
	 s tempDiabetesCheckRecord.bSmoke= bSmoke
     s tempDiabetesCheckRecord.Symptom= Symptom
     s tempDiabetesCheckRecord.OtherSymptom=OtherSymptom
     s tempDiabetesCheckRecord.CheckDoctor= CheckDoctor
	 s tempDiabetesCheckRecord.ExerciseNum= $Number(ExerciseNum)
	 s tempDiabetesCheckRecord.ExerciseMin= $Number(ExerciseMin)
	 s tempDiabetesCheckRecord.WaistlineStern= $Number(WaistlineStern)
	 s tempDiabetesCheckRecord.Waistline= $Number(Waistline)
	 s tempDiabetesCheckRecord.Stern= $Number(Stern)
	 s tempDiabetesCheckRecord.DrinkQuentity= $Number(DrinkQuentity)
     s tempDiabetesCheckRecord.nHighPressure= $Number(nHighPressure)
     s tempDiabetesCheckRecord.nLowPressure= $Number(nLowPressure)
     s tempDiabetesCheckRecord.HeartRate= HeartRate
     //s tempDiabetesCheckRecord.Temperature= Temperature
     //s tempDiabetesCheckRecord.Breath=$Number(Breath)
     //s tempDiabetesCheckRecord.Pulse= $Number(Pulse)
     s tempDiabetesCheckRecord.Weight= $Number(Weight)
     s tempDiabetesCheckRecord.Height= $Number(Height)
     s tempDiabetesCheckRecord.BMI= BMI
     //s tempDiabetesCheckRecord.Saddle= Saddle
     //s tempDiabetesCheckRecord.Waist= Waist
     //s tempDiabetesCheckRecord.WaistlineAndSaddle= WaistlineAndSaddle
     //s tempDiabetesCheckRecord.OtherCheckResult= OtherCheckResult
     s tempDiabetesCheckRecord.Smoke= Smoke
     //s tempDiabetesCheckRecord.DCSC= DCSC
     s tempDiabetesCheckRecord.Drink= Drink
     //s tempDiabetesCheckRecord.DPAC= DPAC
     //s tempDiabetesCheckRecord.IsExercise= IsExercise
     //s tempDiabetesCheckRecord.DateOfExercisePer= $Number(DateOfExercisePer)
     //s tempDiabetesCheckRecord.TimesOfExercise= $Number(TimesOfExercise)
     i ComplyDoctor '= "" d
	.s ComplyDoctorobj=##class(CHSS.DictComplyDoctor).%OpenId(ComplyDoctor)
	.s tempDiabetesCheckRecord.ComplyDoctor=ComplyDoctorobj
	 s tempDiabetesCheckRecord.CaseType= CaseType
	 s tempDiabetesCheckRecord.bCaseTrans= bCaseTrans
	 i BloodSurgeRate '= "" d
	.s BloodSurgeRateobj=##class(CHSS.DictBloodSurgeRate).%OpenId(BloodSurgeRate)
	.s tempDiabetesCheckRecord.BloodSurgeRate=BloodSurgeRateobj
	 i Eyeground '= "" d
	.s Eyegroundobj=##class(CHSS.DictEyeground).%OpenId(Eyeground)
	.s tempDiabetesCheckRecord.Eyeground=Eyegroundobj
	 i MentalityAdjust '= "" d
	.s MentalityAdjustobj=##class(CHSS.DictMentalityAdjust).%OpenId(MentalityAdjust)
	.s tempDiabetesCheckRecord.MentalityAdjust=MentalityAdjustobj
	 s tempDiabetesCheckRecord.Other= Other
	 //i Nutrition '= "" d
	//.s Nutritionobj=##class(CHSS.DictRationality).%OpenId(Nutrition)
	//.s tempDiabetesCheckRecord.Nutrition=Nutritionobj
	 //i Entironment '= "" d
	//.s Entironmentobj=##class(CHSS.DictRationality).%OpenId(Entironment)
	//.s tempDiabetesCheckRecord.Entironment=Entironmentobj
	 s tempDiabetesCheckRecord.bTranfer= bTranfer
	 i TransferDept'="" d
	.s TransferDeptobj=##class(User.CTLoc).%OpenId(TransferDept)
	.s tempDiabetesCheckRecord.TransferDept= TransferDeptobj
	 s tempDiabetesCheckRecord.TransferReason= TransferReason
	 //s tempDiabetesCheckRecord.Chemotherapy= Chemotherapy
	 i DrugRegularityRate'="" d
	.s DrugRegularityRateobj=##class(CHSS.DictDrugRegularityRate).%OpenId(DrugRegularityRate)
	.s tempDiabetesCheckRecord.DrugRegularityRate= DrugRegularityRateobj
	i CheckResult'="" d
	.s CheckResultobj=##class(CHSS.DictCheckResult).%OpenId(CheckResult)
	.s tempDiabetesCheckRecord.CheckResult= CheckResultobj
	 s tempDiabetesCheckRecord.DoseComplier= DoseComplier
	 //s tempDiabetesCheckRecord.bDrugAdverseReaction= bDrugAdverseReaction
	 //s tempDiabetesCheckRecord.AdverseReactionDrugs= AdverseReactionDrugs
	 i DateOfStopDrink '="" d
	.s DateOfStopDrink=$zdh(DateOfStopDrink,3)
	.s tempDiabetesCheckRecord.DateOfStopDrink=DateOfStopDrink
	s BookingStr = BookingDate
	 i BookingDate '="" d
	.s BookingDate=$zdh(BookingDate,3)
	.s tempDiabetesCheckRecord.BookingDate=BookingDate 
	 i DateOfStopSmoke '="" d
	.s DateOfStopSmoke=$zdh(DateOfStopSmoke,3)
	.s tempDiabetesCheckRecord.DateOfStopSmoke=DateOfStopSmoke 
	 s tempDiabetesCheckRecord.bBooking= bBooking
	 i StaffInput '="" d
	.;s StaffInputobj=##class(User.SSUser).%OpenId(StaffInput)
	.;s tempDiabetesCheckRecord.StaffInput=StaffInputobj
	s result=tempDiabetesCheckRecord.%Save()
	
	i result = "1" d
    .w "{""success"":""true"",""info"":"_tempDiabetesCheckRecord.%Id()_"}"
    .d ##class(CHSSWeb.PersonBookingCheckService).Insert(PersonRowIdParref, 2, tempDiabetesCheckRecord.%Id(), BookingStr, 0)
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

ClassMethod Update(RowId As %Integer, PersonRowIdParref As %Integer, DateCheck As %Date, CheckAdd As %String, Symptom As %String, OtherSymptom As %String, CheckDoctor As %String, nHighPressure As %Numeric, nLowPressure As %Numeric, HeartRate As %Numeric, OtherCheck As %String, Weight As %Float, Height As %Float, BMI As %Float, FootArteryThrob As %String, Food As %Integer, DateOfStopSmoke As %Date, bSmoke As %String, Smoke As %String, SmokeNum As %Numeric, DateOfStopDrink As %Date, bDrink As %String, Drink As %String, DrinkQuentity As %Float, Exercise As %String, Other As %String, WaistlineStern As %Float, BookingDate As %Date, bBooking As %String, ExerciseNum As %Numeric, ExerciseMin As %Numeric, DrugSideEffect As %String, DoseComplier As %String, BloodAfterDining As %String, BloodAfterDiningOfTwo As %String, BloodSurgeLimosis As %String, Cholesterin As %String, HbAlC As %String, OtherOfBlood As %String, Hb As %String, NAlbumen As %String, NOther As %String, SugarInDay As %String, UniteIll As %String, ComplyDoctor As %Integer, MentalityAdjust As %Integer, bAdverseEffects As %String, DrugOfAdverseEffects As %String, CheckResult As %Integer, EatDrug As %String, Direction As %String, Remark As %String, bTranfer As %String, TransferDept As %Integer, TransferReason As %String, DrugRegularityRate As %Integer, Deal As %String, StaffInput As %Integer, DateOfInput As %Date, DateOfUpdate As %Date, CaseType As %String, bCaseTrans As %String, BloodSurgeRate As %Integer, Eyeground As %Integer, MentalStatus As %String, Waistline As %Float, Stern As %Float, CheckType) As %String
{
   q:($d(RowId)=0)||(RowId="")
    s tempDiabetesCheckRecord="",result=""
	s tempDiabetesCheckRecord=##class(CHSS.DiabetesCheckRecord).%OpenId(RowId)
	q:(tempDiabetesCheckRecord="") 0
	i DateCheck '="" d
	.s DateCheck=$zdh(DateCheck,3)
	.s tempDiabetesCheckRecord.DateCheck=DateCheck 
	i DateOfInput '="" d
	.s DateOfInput=$zdh(DateOfInput,3)
	.s tempDiabetesCheckRecord.DateOfInput=DateOfInput 
	//i DateOfUpdate '="" d
	//.s DateOfUpdate=$zdh(DateOfUpdate,3)
	//.s tempDiabetesCheckRecord.DateOfUpdate=DateOfUpdate 
	 s tempDiabetesCheckRecord.Remark=Remark
	 s tempDiabetesCheckRecord.Deal=Deal
	 s tempDiabetesCheckRecord.Direction=Direction
	 s tempDiabetesCheckRecord.BloodAfterDiningOfTwo=BloodAfterDiningOfTwo
	 s tempDiabetesCheckRecord.bAdverseEffects=bAdverseEffects
	 s tempDiabetesCheckRecord.BloodSurgeLimosis=BloodSurgeLimosis
	 s tempDiabetesCheckRecord.BloodAfterDining=BloodAfterDining
	 s tempDiabetesCheckRecord.EatDrug=EatDrug
	 s tempDiabetesCheckRecord.bDrink=bDrink
	 s tempDiabetesCheckRecord.Hb=Hb
	 s tempDiabetesCheckRecord.SugarInDay=SugarInDay
	 s tempDiabetesCheckRecord.NOther=NOther
	 s tempDiabetesCheckRecord.MentalStatus=MentalStatus
	 s tempDiabetesCheckRecord.DrugOfAdverseEffects=DrugOfAdverseEffects
	 s tempDiabetesCheckRecord.OtherOfBlood=OtherOfBlood
	 s tempDiabetesCheckRecord.HbAlC=HbAlC
	 s tempDiabetesCheckRecord.UniteIll=UniteIll
	 s tempDiabetesCheckRecord.NAlbumen=NAlbumen
     s tempDiabetesCheckRecord.SmokeNum=SmokeNum
	 s tempDiabetesCheckRecord.Cholesterin=Cholesterin
	 s tempDiabetesCheckRecord.FootArteryThrob=FootArteryThrob
	 s tempDiabetesCheckRecord.OtherCheck= OtherCheck
	 s tempDiabetesCheckRecord.DrugSideEffect= DrugSideEffect
     s tempDiabetesCheckRecord.CheckAdd= CheckAdd
	 s tempDiabetesCheckRecord.Exercise= Exercise
	 
	 
	  i Food '= "" d
	.s Foodobj=##class(CHSS.DictFood).%OpenId(Food)
	.s tempDiabetesCheckRecord.Food=Foodobj
	 
	  i CheckType '= "" d
	.s CheckTypeobj=##class(CHSS.DictCheckType).%OpenId(CheckType)
	.s tempDiabetesCheckRecord.CheckType=CheckTypeobj
	 
	 s tempDiabetesCheckRecord.bSmoke= bSmoke
     s tempDiabetesCheckRecord.Symptom= Symptom
     s tempDiabetesCheckRecord.OtherSymptom=OtherSymptom
     s tempDiabetesCheckRecord.CheckDoctor= CheckDoctor
	 s tempDiabetesCheckRecord.ExerciseNum= $Number(ExerciseNum)
	 s tempDiabetesCheckRecord.ExerciseMin= $Number(ExerciseMin)
	 s tempDiabetesCheckRecord.WaistlineStern= $Number(WaistlineStern)
	 s tempDiabetesCheckRecord.Waistline= $Number(Waistline)
	 s tempDiabetesCheckRecord.Stern= $Number(Stern)
	 w Stern,!
	 s tempDiabetesCheckRecord.DrinkQuentity= $Number(DrinkQuentity)
     s tempDiabetesCheckRecord.nHighPressure= $Number(nHighPressure)
     s tempDiabetesCheckRecord.nLowPressure= $Number(nLowPressure)
     s tempDiabetesCheckRecord.HeartRate= HeartRate
     //s tempDiabetesCheckRecord.Temperature= Temperature
     //s tempDiabetesCheckRecord.Breath=$Number(Breath)
     //s tempDiabetesCheckRecord.Pulse= $Number(Pulse)
     s tempDiabetesCheckRecord.Weight= $Number(Weight)
     s tempDiabetesCheckRecord.Height= $Number(Height)
     s tempDiabetesCheckRecord.BMI= BMI
     //s tempDiabetesCheckRecord.Saddle= Saddle
     //s tempDiabetesCheckRecord.Waist= Waist
     //s tempDiabetesCheckRecord.WaistlineAndSaddle= WaistlineAndSaddle
     //s tempDiabetesCheckRecord.OtherCheckResult= OtherCheckResult
     s tempDiabetesCheckRecord.Smoke= Smoke
     //s tempDiabetesCheckRecord.DCSC= DCSC
     s tempDiabetesCheckRecord.Drink= Drink
     //s tempDiabetesCheckRecord.DPAC= DPAC
     //s tempDiabetesCheckRecord.IsExercise= IsExercise
     //s tempDiabetesCheckRecord.DateOfExercisePer= $Number(DateOfExercisePer)
     //s tempDiabetesCheckRecord.TimesOfExercise= $Number(TimesOfExercise)
     i ComplyDoctor '= "" d
	.s ComplyDoctorobj=##class(CHSS.DictComplyDoctor).%OpenId(ComplyDoctor)
	.s tempDiabetesCheckRecord.ComplyDoctor=ComplyDoctorobj
	 s tempDiabetesCheckRecord.CaseType= CaseType
	 
	
	 s tempDiabetesCheckRecord.bCaseTrans= bCaseTrans
	 i BloodSurgeRate '= "" d
	.s BloodSurgeRateobj=##class(CHSS.DictBloodSurgeRate).%OpenId(BloodSurgeRate)
	.s tempDiabetesCheckRecord.BloodSurgeRate=BloodSurgeRateobj
	 i Eyeground '= "" d
	.s Eyegroundobj=##class(CHSS.DictEyeground).%OpenId(Eyeground)
	.s tempDiabetesCheckRecord.Eyeground=Eyegroundobj
	 i MentalityAdjust '= "" d
	.s MentalityAdjustobj=##class(CHSS.DictMentalityAdjust).%OpenId(MentalityAdjust)
	.s tempDiabetesCheckRecord.MentalityAdjust=MentalityAdjustobj
	 s tempDiabetesCheckRecord.Other= Other
	 //i Nutrition '= "" d
	//.s Nutritionobj=##class(CHSS.DictRationality).%OpenId(Nutrition)
	//.s tempDiabetesCheckRecord.Nutrition=Nutritionobj
	 //i Entironment '= "" d
	//.s Entironmentobj=##class(CHSS.DictRationality).%OpenId(Entironment)
	//.s tempDiabetesCheckRecord.Entironment=Entironmentobj
	 s tempDiabetesCheckRecord.bTranfer= bTranfer
	 i TransferDept'="" d
	.s TransferDeptobj=##class(User.CTLoc).%OpenId(TransferDept)
	.s tempDiabetesCheckRecord.TransferDept= TransferDeptobj
	 s tempDiabetesCheckRecord.TransferReason= TransferReason
	 //s tempDiabetesCheckRecord.Chemotherapy= Chemotherapy
	 i DrugRegularityRate'="" d
	.s DrugRegularityRateobj=##class(CHSS.DictDrugRegularityRate).%OpenId(DrugRegularityRate)
	.s tempDiabetesCheckRecord.DrugRegularityRate= DrugRegularityRateobj
	i CheckResult'="" d
	.s CheckResultobj=##class(CHSS.DictCheckResult).%OpenId(CheckResult)
	.s tempDiabetesCheckRecord.CheckResult= CheckResultobj
	 s tempDiabetesCheckRecord.DoseComplier= DoseComplier
	 //s tempDiabetesCheckRecord.bDrugAdverseReaction= bDrugAdverseReaction
	 //s tempDiabetesCheckRecord.AdverseReactionDrugs= AdverseReactionDrugs
	 i DateOfStopDrink '="" d
	.s DateOfStopDrink=$zdh(DateOfStopDrink,3)
	.s tempDiabetesCheckRecord.DateOfStopDrink=DateOfStopDrink
	s BookingStr = BookingDate
	 i BookingDate '="" d
	.s BookingDate=$zdh(BookingDate,3)
	.s tempDiabetesCheckRecord.BookingDate=BookingDate 
	 i DateOfStopSmoke '="" d
	.s DateOfStopSmoke=$zdh(DateOfStopSmoke,3)
	.s tempDiabetesCheckRecord.DateOfStopSmoke=DateOfStopSmoke 
	 s tempDiabetesCheckRecord.bBooking= bBooking
	 i StaffInput '="" d
	.;s StaffInputobj=##class(User.SSUser).%OpenId(StaffInput)
	.;s tempDiabetesCheckRecord.StaffInput=StaffInputobj
	
	s result=tempDiabetesCheckRecord.%Save()
	 i result = "1" d
      .w "{""success"":""true"",""info"":"_RowId_"}"
      .d ##class(CHSSWeb.PersonBookingCheckService).Insert(PersonRowIdParref, 2, RowId, BookingStr, 0)
      e  d
      .w "{""success"":""false"",""info"":""数据保存出错!""}"
      q ""
}

/// 添加
ClassMethod existPersonRowIdParref(PersonRowIdParref) As %String
{
	q:PersonRowIdParref="" "-1"
	q:$d(^CHSS.DiabetesCheckRecordI("PersonRowIdParrefIndex",PersonRowIdParref)) "1"
	q "0"
}

ClassMethod delete(RowId, PersonRowIdParref) As %String
{
	&sql(delete from CHSS.DiabetesCheckRecord where %ID=:RowId)
	d ##class(CHSSWeb.PersonBookingCheckService).DeleteBooking(PersonRowIdParref, 1,RowId)
	
	q SQLCODE
}

Storage Default
{
<Data name="DiabetesCheckRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DiabetesChecA2FD</DataLocation>
<DefaultData>DiabetesCheckRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.DiabetesChecA2FD</IdLocation>
<IndexLocation>^CHSSWeb.DiabetesChecA2FI</IndexLocation>
<StreamLocation>^CHSSWeb.DiabetesChecA2FS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
