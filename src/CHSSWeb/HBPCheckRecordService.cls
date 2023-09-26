Class CHSSWeb.HBPCheckRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod HBPCheckRecordList(PersonRowIdParref As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
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
		For  Set RowId=$O(^CHSS.HBPCheckRecordI("PersonRowIdParrefIndex",PersonRowIdParref,RowId)) q:RowId=""  d
		.s tempHBPCheckRecord=##class(CHSS.HBPCheckRecord).%OpenId(RowId)
	    .s DateCheck = tempHBPCheckRecord.DateCheck
	    .i DateCheck '= "" d
		..s DateCheck=$zd(DateCheck,3)
		.set CheckAdd = tempHBPCheckRecord.CheckAdd
		.set Symptom = tempHBPCheckRecord.Symptom
		.set OtherSymptom = tempHBPCheckRecord.OtherSymptom
		.//set Temperature = tempHBPCheckRecord.Temperature
		.//set Breath = tempHBPCheckRecord.Breath
		.//set Pulse = tempHBPCheckRecord.Pulse
		.set CheckDoctor = tempHBPCheckRecord.CheckDoctor
		.set nHighPressure = tempHBPCheckRecord.nHighPressure
		.set nLowPressure = tempHBPCheckRecord.nLowPressure
		.set HeartRate = tempHBPCheckRecord.HeartRate
		.set OtherCheck = tempHBPCheckRecord.OtherCheck
		.set Checker = tempHBPCheckRecord.Checker
		.set Weight = tempHBPCheckRecord.Weight
		.set Height = tempHBPCheckRecord.Height
		.set Smoke = tempHBPCheckRecord.Smoke
		.set BMI = tempHBPCheckRecord.BMI
		.set FootArteryThrob = tempHBPCheckRecord.FootArteryThrob
		.set Food = tempHBPCheckRecord.Food
		.s DateOfStopSmoke = tempHBPCheckRecord.DateOfStopSmoke
	    .i DateOfStopSmoke '= "" d
		..s DateOfStopSmoke=$zd(DateOfStopSmoke,3) 
		.s DateOfCheck = tempHBPCheckRecord.DateOfCheck
	    .i DateOfCheck '= "" d
		..s DateOfCheck=$zd(DateOfCheck,3)
		.set bDrink = tempHBPCheckRecord.bDrink
		.set Drink = tempHBPCheckRecord.Drink
		.set DrinkQuentity = tempHBPCheckRecord.DrinkQuentity
		.set Exercise = tempHBPCheckRecord.Exercise
		.set Other = tempHBPCheckRecord.Other
		.set WaistlineStern = tempHBPCheckRecord.WaistlineStern
	    .s BookingDate = tempHBPCheckRecord.BookingDate
	    .i BookingDate '= "" d
		..s BookingDate=$zd(BookingDate,3)
		.set bBooking = tempHBPCheckRecord.bBooking
		.set ExerciseNum = tempHBPCheckRecord.ExerciseNum
		.set ExerciseMin = tempHBPCheckRecord.ExerciseMin
		.set DrugSideEffect = tempHBPCheckRecord.DrugSideEffect
		.set DoseComplier = tempHBPCheckRecord.DoseComplier
	    .set BloodAfterDining = tempHBPCheckRecord.BloodAfterDining
	    .set BloodAfterDiningOfTwo = tempHBPCheckRecord.BloodAfterDiningOfTwo
	    .set BloodSurgeLimosis = tempHBPCheckRecord.BloodSurgeLimosis
	    .set Cholesterin = tempHBPCheckRecord.Cholesterin
	    .set HbAlC = tempHBPCheckRecord.HbAlC
	    .set DangerousFactor = tempHBPCheckRecord.DangerousFactor
	    .set NonDrugTherapy = tempHBPCheckRecord.NonDrugTherapy
	    .set OtherOfBlood = tempHBPCheckRecord.OtherOfBlood
	    .set Hb = tempHBPCheckRecord.Hb
	    .set NAlbumen = tempHBPCheckRecord.NAlbumen
	    .set NOther = tempHBPCheckRecord.NOther
	    .set SugarInDay = tempHBPCheckRecord.SugarInDay
	    .set UniteIll = tempHBPCheckRecord.UniteIll
	    .set SmokeNum = tempHBPCheckRecord.SmokeNum
	    .set ComplyDoctor = ""
		.set ComplyDoctorName = ""
		.i tempHBPCheckRecord.ComplyDoctor '= "" d
		..set ComplyDoctorName = tempHBPCheckRecord.ComplyDoctor.Description
		..set ComplyDoctor = tempHBPCheckRecord.ComplyDoctor.%Id()
		.set CheckType = ""
		.set CheckTypeName = ""
		.i tempHBPCheckRecord.CheckType '= "" d
		..set CheckTypeName = tempHBPCheckRecord.CheckType.Description
		..set CheckType = tempHBPCheckRecord.CheckType.%Id()
		.set MentalityAdjust = ""
		.set MentalityAdjustName = ""
		.i tempHBPCheckRecord.MentalityAdjust '= "" d
		..set MentalityAdjustName = tempHBPCheckRecord.MentalityAdjust.Description
		..set MentalityAdjust = tempHBPCheckRecord.MentalityAdjust.%Id()
		.set bAdverseEffects = tempHBPCheckRecord.bAdverseEffects
		.set DrugOfAdverseEffects = tempHBPCheckRecord.DrugOfAdverseEffects
		.set CheckResult = ""
		.set CheckResultName = ""
		.i tempHBPCheckRecord.CheckResult '= "" d
		..set CheckResultName = tempHBPCheckRecord.CheckResult.Description
		..set CheckResult = tempHBPCheckRecord.CheckResult.%Id()
		.set EatDrug = tempHBPCheckRecord.EatDrug
		.set Direction = tempHBPCheckRecord.Direction
		.set Remark = tempHBPCheckRecord.Remark
		.set bTranfer = tempHBPCheckRecord.bTranfer
		.set TransferDept = ""
		.set TransferDeptName = ""
		.i tempHBPCheckRecord.TransferDept '= "" d
		..set TransferDeptName = tempHBPCheckRecord.TransferDept.CTLOCDesc
		..set TransferDept = tempHBPCheckRecord.TransferDept.%Id()
		.set TransferReason = tempHBPCheckRecord.TransferReason
		.set DrugRegularityRate = ""
		.set DrugRegularityRateName = ""
		.i tempHBPCheckRecord.DrugRegularityRate '= "" d
		..set DrugRegularityRateName = tempHBPCheckRecord.DrugRegularityRate.Description
		..set DrugRegularityRate = tempHBPCheckRecord.DrugRegularityRate.%Id()
		.set Deal = tempHBPCheckRecord.Deal
		.s DateOfInput = tempHBPCheckRecord.DateOfInput
	    .i DateOfInput '= "" d
		..s DateOfInput=$zd(DateOfInput,3)
		.s DateOfStopDrink = tempHBPCheckRecord.DateOfStopDrink
	    .i DateOfStopDrink '= "" d
		..s DateOfStopDrink=$zd(DateOfStopDrink,3)
		.s DateOfUpdate = tempHBPCheckRecord.DateOfUpdate
	    .i DateOfUpdate '= "" d
		..s DateOfUpdate=$zd(DateOfUpdate,3)
		.Set tmp= RowId_"^"_DateCheck_"^"_CheckAdd_"^"_CheckDoctor_"^"_Symptom_"^"_OtherSymptom_"^"_HeartRate_"^"_OtherCheck_"^"_Weight_"^"_Height_"^"_BMI_"^"_FootArteryThrob_"^"_Food_"^"_DateOfStopSmoke_"^"_Drink_"^"_DrinkQuentity_"^"_Exercise_"^"_Other_"^"_WaistlineStern_"^"_BookingDate_"^"_bBooking_"^"_ExerciseNum_"^"_ExerciseMin_"^"_DrugSideEffect_"^"_DoseComplier_"^"_BloodAfterDining_"^"_BloodAfterDiningOfTwo_"^"_BloodSurgeLimosis_"^"_Cholesterin_"^"_HbAlC_"^"_OtherOfBlood_"^"_Hb_"^"_NAlbumen_"^"_NOther_"^"_SugarInDay_"^"_UniteIll_"^"_ComplyDoctor_"^"_ComplyDoctorName_"^"_MentalityAdjust_"^"_MentalityAdjustName_"^"_bAdverseEffects_"^"_DrugOfAdverseEffects_"^"_CheckResult_"^"_CheckResultName_"^"_EatDrug_"^"_Direction_"^"_Remark_"^"_bTranfer_"^"_TransferDept_"^"_TransferDeptName_"^"_TransferReason_"^"_DrugRegularityRate_"^"_DrugRegularityRateName_"^"_Deal_"^"_DateOfInput_"^"_DateOfUpdate_"^"_nHighPressure_"^"_nLowPressure_"^"_Smoke_"^"_SmokeNum_"^"_DateOfStopDrink_"^"_bDrink_"^"_DangerousFactor_"^"_NonDrugTherapy_"^"_Checker_"^"_DateOfCheck_"^"_CheckType_"^"_CheckTypeName
	    .Set count=count+1
	    .If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("RowId^DateCheck^CheckAdd^CheckDoctor^Symptom^OtherSymptom^HeartRate^OtherCheck^Weight^Height^BMI^FootArteryThrob^Food^DateOfStopSmoke^Drink^DrinkQuentity^Exercise^Other^WaistlineStern^BookingDate^bBooking^ExerciseNum^ExerciseMin^DrugSideEffect^DoseComplier^BloodAfterDining^BloodAfterDiningOfTwo^BloodSurgeLimosis^Cholesterin^HbAlC^OtherOfBlood^Hb^NAlbumen^NOther^SugarInDay^UniteIll^ComplyDoctor^ComplyDoctorName^MentalityAdjust^MentalityAdjustName^bAdverseEffects^DrugOfAdverseEffects^CheckResult^CheckResultName^EatDrug^Direction^Remark^bTranfer^TransferDept^TransferDeptName^TransferReason^DrugRegularityRate^DrugRegularityRateName^Deal^DateOfInput^DateOfUpdate^nHighPressure^nLowPressure^Smoke^SmokeNum^DateOfStopDrink^bDrink^DangerousFactor^NonDrugTherapy^Checker^DateOfCheck^CheckType^CheckTypeName",count)
	 	k json
		Quit resultString
}

/// 添加
ClassMethod Insert(RowId As %Integer, PersonRowIdParref As %Integer, DateCheck As %Date, CheckAdd As %String, Symptom As %String, OtherSymptom As %String, CheckDoctor As %String, nHighPressure As %Numeric, nLowPressure As %Numeric, HeartRate As %Numeric, OtherCheck As %String, Weight As %Float, Height As %Float, BMI As %Float, FootArteryThrob As %String, Food As %Integer, DateOfStopSmoke As %Date, bSmoke As %String, Smoke As %String, SmokeNum As %Numeric, DateOfStopDrink As %Date, bDrink As %String, Drink As %String, DrinkQuentity As %Float, Exercise As %String, Other As %String, WaistlineStern As %Float, BookingDate As %Date, bBooking As %String, ExerciseNum As %Numeric, ExerciseMin As %Numeric, DrugSideEffect As %String, DoseComplier As %String, BloodAfterDining As %String, BloodAfterDiningOfTwo As %String, BloodSurgeLimosis As %String, Cholesterin As %String, HbAlC As %String, OtherOfBlood As %String, Hb As %String, NAlbumen As %String, ComplyDoctor As %Integer, MentalityAdjust As %Integer, bTranfer As %String, TransferDept As %Integer, TransferReason As %String, DrugRegularityRate As %Integer, StaffInput As %Integer, DateOfInput As %Date, DateOfUpdate As %Date, UniteIll As %String, NOther As %String, Remark As %String, Direction As %String, EatDrug As %String, bAdverseEffects As %String, DrugOfAdverseEffects As %String, SugarInDay As %String, Deal As %String, DangerousFactor As %String, NonDrugTherapy As %String, Checker As %String, DateOfCheck As %Date, CheckType As %Integer, CheckResult As %Integer) As %String
{
    s result =""
	s tempHBPCheckRecord=""
    s tempHBPCheckRecord=##class(CHSS.HBPCheckRecord).%New()
    q:(tempHBPCheckRecord="") 0
	 i PersonRowIdParref '="" d
    .s PersonRowIdParrefobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
    .s tempHBPCheckRecord.PersonRowIdParref=PersonRowIdParrefobj
	i DateCheck'="" d
	.s DateCheck=$zdh(DateCheck,3)
	.s tempHBPCheckRecord.DateCheck=DateCheck
	i DateOfCheck'="" d
	.s DateOfCheck=$zdh(DateOfCheck,3)
	.s tempHBPCheckRecord.DateOfCheck=DateOfCheck  
	i DateOfInput'="" d
	.s DateOfInput=$zdh(DateOfInput,3)
	.s tempHBPCheckRecord.DateOfInput=DateOfInput 
	i DateOfUpdate'="" d
	.s DateOfUpdate=$zdh(DateOfUpdate,3)
	.s tempHBPCheckRecord.DateOfUpdate=DateOfUpdate 
	 s tempHBPCheckRecord.Remark=Remark
	 s tempHBPCheckRecord.Deal=Deal
	 s tempHBPCheckRecord.Direction=Direction
	 s tempHBPCheckRecord.DangerousFactor=DangerousFactor
	 s tempHBPCheckRecord.NonDrugTherapy=NonDrugTherapy
	 s tempHBPCheckRecord.BloodAfterDiningOfTwo=BloodAfterDiningOfTwo
	 s tempHBPCheckRecord.bAdverseEffects=bAdverseEffects
	 s tempHBPCheckRecord.BloodSurgeLimosis=BloodSurgeLimosis
	 s tempHBPCheckRecord.BloodAfterDining=BloodAfterDining
	 s tempHBPCheckRecord.EatDrug=EatDrug
	 s tempHBPCheckRecord.bDrink=bDrink
	 s tempHBPCheckRecord.Checker=Checker
	 s tempHBPCheckRecord.Hb=Hb
	 s tempHBPCheckRecord.SugarInDay=SugarInDay
	 s tempHBPCheckRecord.NOther=NOther
	 s tempHBPCheckRecord.DrugOfAdverseEffects=DrugOfAdverseEffects
	 s tempHBPCheckRecord.OtherOfBlood=OtherOfBlood
	 s tempHBPCheckRecord.HbAlC=HbAlC
	 s tempHBPCheckRecord.UniteIll=UniteIll
	 s tempHBPCheckRecord.NAlbumen=NAlbumen
     s tempHBPCheckRecord.SmokeNum=SmokeNum
	 s tempHBPCheckRecord.Cholesterin=Cholesterin
	 s tempHBPCheckRecord.FootArteryThrob=FootArteryThrob
	 s tempHBPCheckRecord.OtherCheck= OtherCheck
	 s tempHBPCheckRecord.DrugSideEffect= DrugSideEffect
     s tempHBPCheckRecord.CheckAdd= CheckAdd
	 s tempHBPCheckRecord.Exercise= Exercise
	 s tempHBPCheckRecord.Food= Food
	 s tempHBPCheckRecord.bSmoke= bSmoke
     s tempHBPCheckRecord.Symptom= Symptom
     s tempHBPCheckRecord.OtherSymptom=OtherSymptom
     s tempHBPCheckRecord.CheckDoctor= CheckDoctor
	 s tempHBPCheckRecord.ExerciseNum= ExerciseNum
	 s tempHBPCheckRecord.ExerciseMin= $Number(ExerciseMin)
	 s tempHBPCheckRecord.WaistlineStern= $Number(WaistlineStern)
	 s tempHBPCheckRecord.DrinkQuentity= $Number(DrinkQuentity)
     s tempHBPCheckRecord.nHighPressure= $Number(nHighPressure)
     s tempHBPCheckRecord.nLowPressure= $Number(nLowPressure)
     s tempHBPCheckRecord.HeartRate= HeartRate
     s tempHBPCheckRecord.Weight= $Number(Weight)
     s tempHBPCheckRecord.Height= $Number(Height)
     s tempHBPCheckRecord.BMI= BMI
     s tempHBPCheckRecord.Smoke= Smoke
     s tempHBPCheckRecord.Drink= Drink
     i ComplyDoctor '= "" d
	.s ComplyDoctorobj=##class(CHSS.DictComplyDoctor).%OpenId(ComplyDoctor)
	.s tempHBPCheckRecord.ComplyDoctor=ComplyDoctorobj
	 i CheckType '= "" d
	.s CheckTypeobj=##class(CHSS.DictCheckType).%OpenId(CheckType)
	.s tempHBPCheckRecord.CheckType=CheckTypeobj
	 i MentalityAdjust '= "" d
	.s MentalityAdjustobj=##class(CHSS.DictMentalityAdjust).%OpenId(MentalityAdjust)
	.s tempHBPCheckRecord.MentalityAdjust=MentalityAdjustobj
	 s tempHBPCheckRecord.Other= Other
	 s tempHBPCheckRecord.bTranfer= bTranfer
	 i TransferDept'="" d
	.s TransferDeptobj=##class(User.CTLoc).%OpenId(TransferDept)
	.s tempHBPCheckRecord.TransferDept= TransferDeptobj
	 s tempHBPCheckRecord.TransferReason= TransferReason
	 i DrugRegularityRate'="" d
	.s DrugRegularityRateobj=##class(CHSS.DictDrugRegularityRate).%OpenId(DrugRegularityRate)
	.s tempHBPCheckRecord.DrugRegularityRate= DrugRegularityRateobj
	 s tempHBPCheckRecord.DoseComplier= DoseComplier
	 i DateOfStopDrink '="" d
	.s DateOfStopDrink=$zdh(DateOfStopDrink,3)
	.s tempHBPCheckRecord.DateOfStopDrink=DateOfStopDrink 
	s BookingStr = BookingDate
	 i BookingDate '="" d
	.s BookingDate=$zdh(BookingDate,3)
	.s tempHBPCheckRecord.BookingDate=BookingDate 
	 i DateOfStopSmoke '="" d
	.s DateOfStopSmoke=$zdh(DateOfStopSmoke,3)
	.s tempHBPCheckRecord.DateOfStopSmoke=DateOfStopSmoke 
	 s tempHBPCheckRecord.bBooking= bBooking
	 i StaffInput '="" d
	.;s StaffInputobj=##class(User.SSUser).%OpenId(StaffInput)
	.;s tempHBPCheckRecord.StaffInput=StaffInputobj
	i CheckResult'="" d
	.s CheckResultobj=##class(CHSS.DictCheckResult).%OpenId(CheckResult)
	.s tempHBPCheckRecord.CheckResult= CheckResultobj
	s result=tempHBPCheckRecord.%Save()

	i result = "1" d
    .w "{""success"":""true"",""info"":"_tempHBPCheckRecord.%Id()_"}"
    .d ##class(CHSSWeb.PersonBookingCheckService).Insert(PersonRowIdParref, 1, tempHBPCheckRecord.%Id(), BookingStr, 0)
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

/// 更新
ClassMethod Update(RowId As %Integer, PersonRowIdParref As %Integer, DateCheck As %Date, CheckAdd As %String, Symptom As %String, OtherSymptom As %String, CheckDoctor As %String, nHighPressure As %Numeric, nLowPressure As %Numeric, HeartRate As %Numeric, OtherCheck As %String, Weight As %Float, Height As %Float, BMI As %Float, FootArteryThrob As %String, Food As %Integer, DateOfStopSmoke As %Date, bSmoke As %String, Smoke As %String, SmokeNum As %Numeric, DateOfStopDrink As %Date, bDrink As %String, Drink As %String, DrinkQuentity As %Float, Exercise As %String, Other As %String, WaistlineStern As %Float, BookingDate As %Date, bBooking As %String, ExerciseNum As %Numeric, ExerciseMin As %Numeric, DrugSideEffect As %String, DoseComplier As %String, BloodAfterDining As %String, BloodAfterDiningOfTwo As %String, BloodSurgeLimosis As %String, Cholesterin As %String, HbAlC As %String, OtherOfBlood As %String, Hb As %String, NAlbumen As %String, ComplyDoctor As %Integer, MentalityAdjust As %Integer, bTranfer As %String, TransferDept As %Integer, TransferReason As %String, DrugRegularityRate As %Integer, StaffInput As %Integer, DateOfInput As %Date, DateOfUpdate As %Date, UniteIll As %String, NOther As %String, Remark As %String, Direction As %String, EatDrug As %String, bAdverseEffects As %String, DrugOfAdverseEffects As %String, SugarInDay As %String, Deal As %String, DangerousFactor As %String, NonDrugTherapy As %String, Checker As %String, DateOfCheck As %Date, CheckType As %Integer, CheckResult As %Integer) As %String
{
   
    q:($d(RowId)=0)||(RowId="")
    s tempHBPCheckRecord="",result=""
    s tempHBPCheckRecord=##class(CHSS.HBPCheckRecord).%OpenId(RowId)
    q:(tempHBPCheckRecord="") 0
	i DateCheck'="" d
	.s DateCheck=$zdh(DateCheck,3)
	s tempHBPCheckRecord.DateCheck=DateCheck
	i DateOfCheck'="" d
	.s DateOfCheck=$zdh(DateOfCheck,3)
	.s tempHBPCheckRecord.DateOfCheck=DateOfCheck  
	i DateOfInput'="" d
	.s DateOfInput=$zdh(DateOfInput,3)
	.s tempHBPCheckRecord.DateOfInput=DateOfInput 
	i DateOfUpdate'="" d
	.s DateOfUpdate=$zdh(DateOfUpdate,3)
	.s tempHBPCheckRecord.DateOfUpdate=DateOfUpdate 
	 s tempHBPCheckRecord.Remark=Remark
	 s tempHBPCheckRecord.Deal=Deal
	 s tempHBPCheckRecord.Direction=Direction
	 s tempHBPCheckRecord.DangerousFactor=DangerousFactor
	 s tempHBPCheckRecord.NonDrugTherapy=NonDrugTherapy
	 s tempHBPCheckRecord.BloodAfterDiningOfTwo=BloodAfterDiningOfTwo
	 s tempHBPCheckRecord.bAdverseEffects=bAdverseEffects
	 s tempHBPCheckRecord.BloodSurgeLimosis=BloodSurgeLimosis
	 s tempHBPCheckRecord.BloodAfterDining=BloodAfterDining
	 s tempHBPCheckRecord.EatDrug=EatDrug
	 s tempHBPCheckRecord.bDrink=bDrink
	 s tempHBPCheckRecord.Checker=Checker
	 s tempHBPCheckRecord.Hb=Hb
	 s tempHBPCheckRecord.SugarInDay=SugarInDay
	 s tempHBPCheckRecord.NOther=NOther
	 s tempHBPCheckRecord.DrugOfAdverseEffects=DrugOfAdverseEffects
	 s tempHBPCheckRecord.OtherOfBlood=OtherOfBlood
	 s tempHBPCheckRecord.HbAlC=HbAlC
	 s tempHBPCheckRecord.UniteIll=UniteIll
	 s tempHBPCheckRecord.NAlbumen=NAlbumen
     s tempHBPCheckRecord.SmokeNum=SmokeNum
	 s tempHBPCheckRecord.Cholesterin=Cholesterin
	 s tempHBPCheckRecord.FootArteryThrob=FootArteryThrob
	 s tempHBPCheckRecord.OtherCheck= OtherCheck
	 s tempHBPCheckRecord.DrugSideEffect= DrugSideEffect
     s tempHBPCheckRecord.CheckAdd= CheckAdd
	 s tempHBPCheckRecord.Exercise= Exercise
	 s tempHBPCheckRecord.Food= Food
	 s tempHBPCheckRecord.bSmoke= bSmoke
     s tempHBPCheckRecord.Symptom= Symptom
     s tempHBPCheckRecord.OtherSymptom=OtherSymptom
     s tempHBPCheckRecord.CheckDoctor= CheckDoctor
	 s tempHBPCheckRecord.ExerciseNum= ExerciseNum
	 s tempHBPCheckRecord.ExerciseMin= $Number(ExerciseMin)
	 s tempHBPCheckRecord.WaistlineStern= $Number(WaistlineStern)
	 s tempHBPCheckRecord.DrinkQuentity= $Number(DrinkQuentity)
     s tempHBPCheckRecord.nHighPressure= $Number(nHighPressure)
     s tempHBPCheckRecord.nLowPressure= $Number(nLowPressure)
     s tempHBPCheckRecord.HeartRate= HeartRate
     s tempHBPCheckRecord.Weight= $Number(Weight)
     s tempHBPCheckRecord.Height= $Number(Height)
     s tempHBPCheckRecord.BMI= BMI
     s tempHBPCheckRecord.Smoke= Smoke
     s tempHBPCheckRecord.Drink= Drink
     i ComplyDoctor '= "" d
	.s ComplyDoctorobj=##class(CHSS.DictComplyDoctor).%OpenId(ComplyDoctor)
	.s tempHBPCheckRecord.ComplyDoctor=ComplyDoctorobj
	 i CheckType '= "" d
	.s CheckTypeobj=##class(CHSS.DictCheckType).%OpenId(CheckType)
	.s tempHBPCheckRecord.CheckType=CheckTypeobj
	 i MentalityAdjust '= "" d
	.s MentalityAdjustobj=##class(CHSS.DictMentalityAdjust).%OpenId(MentalityAdjust)
	.s tempHBPCheckRecord.MentalityAdjust=MentalityAdjustobj
	 s tempHBPCheckRecord.Other= Other
	 s tempHBPCheckRecord.bTranfer= bTranfer
	 i TransferDept'="" d
	.s TransferDeptobj=##class(User.CTLoc).%OpenId(TransferDept)
	.s tempHBPCheckRecord.TransferDept= TransferDeptobj
	 s tempHBPCheckRecord.TransferReason= TransferReason
	 i DrugRegularityRate'="" d
	.s DrugRegularityRateobj=##class(CHSS.DictDrugRegularityRate).%OpenId(DrugRegularityRate)
	.s tempHBPCheckRecord.DrugRegularityRate= DrugRegularityRateobj
	 s tempHBPCheckRecord.DoseComplier= DoseComplier
	 i DateOfStopDrink '="" d
	.s DateOfStopDrink=$zdh(DateOfStopDrink,3)
	.s tempHBPCheckRecord.DateOfStopDrink=DateOfStopDrink 
	s BookingStr = BookingDate
	 i BookingDate '="" d
	.s BookingDate=$zdh(BookingDate,3)
	s tempHBPCheckRecord.BookingDate=BookingDate 
	 i DateOfStopSmoke '="" d
	.s DateOfStopSmoke=$zdh(DateOfStopSmoke,3)
	.s tempHBPCheckRecord.DateOfStopSmoke=DateOfStopSmoke 
	 s tempHBPCheckRecord.bBooking= bBooking
	 i StaffInput '="" d
	.s StaffInputobj=##class(User.SSUser).%OpenId(StaffInput)
	.s tempHBPCheckRecord.StaffInput=StaffInputobj
	
	
    i CheckResult'="" d
	.s CheckResultobj=##class(CHSS.DictCheckResult).%OpenId(CheckResult)
	.s tempHBPCheckRecord.CheckResult= CheckResultobj
	s result=tempHBPCheckRecord.%Save()
	
      i result = "1" d
      .w "{""success"":""true"",""info"":"_RowId_"}"
      .d ##class(CHSSWeb.PersonBookingCheckService).Insert(PersonRowIdParref, 1,RowId, BookingStr, 0)
      e  d
      .w "{""success"":""false"",""info"":""数据保存出错!""}"
      q ""
}

ClassMethod existPersonRowIdParref(PersonRowIdParref) As %String
{
	q:PersonRowIdParref="" "-1"
	q:$d(^CHSS.HBPCheckRecordI("PersonRowIdParrefIndex",PersonRowIdParref)) "1"
	q "0"
}

ClassMethod delete(RowId, PersonRowIdParref) As %String
{
	&sql(delete from CHSS.HBPCheckRecord where %ID=:RowId)
	d ##class(CHSSWeb.PersonBookingCheckService).DeleteBooking(PersonRowIdParref, 1,RowId)

	q SQLCODE
}

ClassMethod Test(Rowid As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
    Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit  
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
    
  
    s result = ##class(%Library.ResultSet).%New()
    
        
    s sqlStr = "select a.PersonRowIdParref->PersonCode,a.PersonRowIdParref->PersonName, a.* "

    s sqlStr = sqlStr_" from CHSS.HBPCheckRecord a "

    s sqlStr = sqlStr_" where a.RowId = "_Rowid
    
			
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
	
	    s PersonCode=result.Data("PersonCode")
		s PersonName=result.Data("PersonName")
		s nHighPressure=result.Data("nHighPressure")
				
		Set tmp = PersonCode_"^"_PersonName_"^"_nHighPressure
    
     	Set count=count+1
     	If (count>start)&(count<=end) d
     	.d json.InsertRowData(tmp)
    }
    
    d result.Close()
    
    
     
    Set resultString = json.getJsonData("PersonCode^PersonName^nHighPressure",count)
    k json
      
    Quit resultString
}

ClassMethod Test2(Rowid As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
    Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit  
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
    
  
    s result = ##class(%Library.ResultSet).%New()
    
        
    s sqlStr = "select WomanRowId, PersonName as PersonName1, SpellCode as SpellCode1 , WoAge, Birth as Birth1, WomanHandBookCode, WorkUnit, TelPhone , CellPhone, Email, HusbandName, HusbandBirth, HusbandWorkUnit, HusbandTele, HusbandMobTele, HusbandEmail, ResidenceAddress, AfMaAddress, AftBeAddress, bDose, IdCard, Card, CardType, InHosCode, EBPeriod, EBPeriod->Description as EBPeriodName, EBPeriodDes,"
    s sqlStr = sqlStr_" EBTime, EBunit, EBbefore, EBnum, EBfrontCode, FinishTable, Operator, Operator->SSUSR_Name as OperatorName,"
    s sqlStr = sqlStr_" OperateDate, FinishIdentifier, PersonRowIdParref"
    s sqlStr = sqlStr_" from CHSS.WomenBaseInfo a "

    s sqlStr = sqlStr_" where a.PersonRowIdParref = "_Rowid
    
    ;w sqlStr,!
			
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
	
	    s PersonName1=result.Data("PersonName1")
		s EBPeriodName=result.Data("EBPeriodName")
		s OperatorName=result.Data("OperatorName")
				
		Set tmp = PersonName1_"^"_EBPeriodName_"^"_OperatorName
    
     	Set count=count+1
     	If (count>start)&(count<=end) d
     	.d json.InsertRowData(tmp)
    }
    
    d result.Close()
    
    
     
    Set resultString = json.getJsonData("PersonName1^EBPeriodName^OperatorName",count)
    k json
      
    Quit resultString
}

Storage Default
{
<Data name="HBPCheckRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HBPCheckRecordServiceD</DataLocation>
<DefaultData>HBPCheckRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HBPCheckRecordServiceD</IdLocation>
<IndexLocation>^CHSSWeb.HBPCheckRecordServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.HBPCheckRecordServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
