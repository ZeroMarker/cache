Class CHSSWeb.PersonTBCheckRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod PersonTBCheckRecordList(PersonRowIdParref As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
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
		For  Set RowId=$O(^CHSS.PersonTBCheckRecordI("PersonRowIdParrefIndex",PersonRowIdParref,RowId)) q:RowId=""  d
		.s tempPersonTBCheckRecord=##class(CHSS.PersonTBCheckRecord).%OpenId(RowId)
		.s DateCheck = tempPersonTBCheckRecord.DateCheck
	    .i DateCheck '= "" d
		..s DateCheck=$zd(DateCheck,3)
		.set CheckAdd = tempPersonTBCheckRecord.CheckAdd
		.set CheckDoctor = tempPersonTBCheckRecord.CheckDoctor
		.set Symptom = tempPersonTBCheckRecord.Symptom
		.set OtherSymptom = tempPersonTBCheckRecord.OtherSymptom
		.set Temperature = tempPersonTBCheckRecord.Temperature
		.set Breath = tempPersonTBCheckRecord.Breath
		.set Pulse = tempPersonTBCheckRecord.Pulse
		.set nHighPressure = tempPersonTBCheckRecord.nHighPressure
		.set nLowPressure = tempPersonTBCheckRecord.nLowPressure
		.set Weight = tempPersonTBCheckRecord.Weight
		.set Height = tempPersonTBCheckRecord.Height
		.set BMI = tempPersonTBCheckRecord.BMI
		.set Saddle = tempPersonTBCheckRecord.Saddle
		.set Waist = tempPersonTBCheckRecord.Waist
		.set WaistlineAndSaddle = tempPersonTBCheckRecord.WaistlineAndSaddle
		.set OtherCheckResult = tempPersonTBCheckRecord.OtherCheckResult
		.set Smoke = tempPersonTBCheckRecord.Smoke
		.set DCSC = tempPersonTBCheckRecord.DCSC
		.set Drink = tempPersonTBCheckRecord.Drink
		.set DPAC = tempPersonTBCheckRecord.DPAC
		.set IsExercise = tempPersonTBCheckRecord.IsExercise
	    .set DateOfExercisePer = tempPersonTBCheckRecord.DateOfExercisePer
	    .set TimesOfExercise = tempPersonTBCheckRecord.TimesOfExercise
	    .set ComplyDoctor = ""
		.set ComplyDoctorName = ""
		.i tempPersonTBCheckRecord.ComplyDoctor '= "" d
		..set ComplyDoctorName = tempPersonTBCheckRecord.ComplyDoctor.Description
		..set ComplyDoctor = tempPersonTBCheckRecord.ComplyDoctor.%Id()
		.set MentalityAdjust = ""
		.set MentalityAdjustName = ""
		.i tempPersonTBCheckRecord.MentalityAdjust '= "" d
		..set MentalityAdjustName = tempPersonTBCheckRecord.MentalityAdjust.Description
		..set MentalityAdjust = tempPersonTBCheckRecord.MentalityAdjust.%Id()
		.set Other = tempPersonTBCheckRecord.Other
		.set Nutrition = ""
		.set NutritionName = ""
		.i tempPersonTBCheckRecord.Nutrition '= "" d
		..set NutritionName = tempPersonTBCheckRecord.Nutrition.Description
		..set Nutrition = tempPersonTBCheckRecord.Nutrition.%Id()
	    .set Entironment = ""
		.set EntironmentName = ""
		.i tempPersonTBCheckRecord.Entironment '= "" d
		..set EntironmentName = tempPersonTBCheckRecord.Entironment.Description
		..set Entironment = tempPersonTBCheckRecord.Entironment.%Id()
		.set bTranfer = tempPersonTBCheckRecord.bTranfer
		.set TransferDept = ""
		.set TransferDeptName = ""
		.i tempPersonTBCheckRecord.TransferDept '= "" d
		..set TransferDept = tempPersonTBCheckRecord.TransferDept.%Id()
		..set TransferDeptName =  tempPersonTBCheckRecord.TransferDept.CTLOCDesc
		.set TransferReason = tempPersonTBCheckRecord.TransferReason
		.set Chemotherapy = tempPersonTBCheckRecord.Chemotherapy
		.set DrugRegularityRate = ""
		.set DrugRegularityRateName = ""
		.i tempPersonTBCheckRecord.DrugRegularityRate '= "" d
		..set DrugRegularityRateName = tempPersonTBCheckRecord.DrugRegularityRate.Description
		..set DrugRegularityRate = tempPersonTBCheckRecord.DrugRegularityRate.%Id()
	    .set DoseComplier = tempPersonTBCheckRecord.DoseComplier
	    .set bDrugAdverseReaction = tempPersonTBCheckRecord.bDrugAdverseReaction
	    .set AdverseReactionDrugs = tempPersonTBCheckRecord.AdverseReactionDrugs
	    .s BookingDate = tempPersonTBCheckRecord.BookingDate
	    .i BookingDate '= "" d
		..s BookingDate=$zd(BookingDate,3)
		.set bBooking = tempPersonTBCheckRecord.bBooking
		..set StaffInput = tempPersonTBCheckRecord.StaffInput.%Id()
		.Set tmp= RowId_"^"_DateCheck_"^"_CheckAdd_"^"_CheckDoctor_"^"_Symptom_"^"_OtherSymptom_"^"_Temperature_"^"_Breath_"^"_Pulse_"^"_nHighPressure_"^"_nLowPressure_"^"_Weight_"^"_Height_"^"_BMI_"^"_Saddle_"^"_Waist_"^"_WaistlineAndSaddle_"^"_OtherCheckResult_"^"_Smoke_"^"_DCSC_"^"_Drink_"^"_DPAC_"^"_IsExercise_"^"_DateOfExercisePer_"^"_TimesOfExercise_"^"_ComplyDoctor_"^"_ComplyDoctorName_"^"_MentalityAdjust_"^"_MentalityAdjustName_"^"_Other_"^"_Nutrition_"^"_NutritionName_"^"_Entironment_"^"_EntironmentName_"^"_bTranfer_"^"_TransferDept_"^"_TransferDeptName_"^"_TransferReason_"^"_Chemotherapy_"^"_DrugRegularityRate_"^"_DrugRegularityRateName_"^"_DoseComplier_"^"_bDrugAdverseReaction_"^"_AdverseReactionDrugs_"^"_BookingDate_"^"_bBooking
	    .Set count=count+1
	    .If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("RowId^DateCheck^CheckAdd^CheckDoctor^Symptom^OtherSymptom^Temperature^Breath^Pulse^nHighPressure^nLowPressure^Weight^Height^BMI^Saddle^Waist^WaistlineAndSaddle^OtherCheckResult^Smoke^DCSC^Drink^DPAC^IsExercise^DateOfExercisePer^TimesOfExercise^ComplyDoctor^ComplyDoctorName^MentalityAdjust^MentalityAdjustName^Other^Nutrition^NutritionName^Entironment^EntironmentName^bTranfer^TransferDept^TransferDeptName^TransferReason^Chemotherapy^DrugRegularityRate^DrugRegularityRateName^DoseComplier^bDrugAdverseReaction^AdverseReactionDrugs^BookingDate^bBooking",count)
	 	k json
	 	
		Quit resultString
}

/// 添加
ClassMethod Insert(RowId As %Integer, PersonRowIdParref As %Integer, DateCheck As %Date, CheckAdd As %String, CheckDoctor As %String, Symptom As %String, OtherSymptom As %String, Temperature As %Float, Breath As %Numeric, Pulse As %Numeric, nHighPressure As %Numeric, nLowPressure As %Numeric, Weight As %Float, Height As %Float, BMI As %Float, Saddle As %Float, Waist As %Float, WaistlineAndSaddle As %Float, OtherCheckResult As %String, Smoke As %String, DCSC As %Float, Drink As %String, DPAC As %Float, IsExercise As %String, DateOfExercisePer As %Numeric, TimesOfExercise As %Numeric, ComplyDoctor As %Integer, MentalityAdjust As %String, Other As %String, Nutrition As %Integer, Entironment As %Integer, bTranfer As %String, TransferDept As %Integer, TransferReason As %String, Chemotherapy As %String, DrugRegularityRate As %Integer, OtherDiedBefore As %Numeric, DoseComplier As %String, bDrugAdverseReaction As %String, AdverseReactionDrugs As %String, BookingDate As %Date, bBooking As %String, StaffInput As %Integer) As %String
{
	s tempPersonTBCheckRecord=""
	i (RowId'="") d 
	.q:($d(PersonRowIdParref)=0)||(PersonRowIdParref="")
	.s result=""
	.s tempPersonTBCheckRecord=##class(CHSS.PersonTBCheckRecord).%OpenId(RowId)
	e  d
	.s tempPersonTBCheckRecord=##class(CHSS.PersonTBCheckRecord).%New()
	 i PersonRowIdParref '="" d
    .s PersonRowIdParrefobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
    .s tempPersonTBCheckRecord.PersonRowIdParref=PersonRowIdParrefobj
	i DateCheck '="" d
	.s DateCheck=$zdh(DateCheck,3)
	.s tempPersonTBCheckRecord.DateCheck=DateCheck
     s tempPersonTBCheckRecord.CheckAdd= CheckAdd
     s tempPersonTBCheckRecord.CheckDoctor= CheckDoctor
     s tempPersonTBCheckRecord.Symptom= Symptom
     s tempPersonTBCheckRecord.OtherSymptom=OtherSymptom
     s tempPersonTBCheckRecord.Temperature= Temperature
     s tempPersonTBCheckRecord.Breath=$Number(Breath)
     s tempPersonTBCheckRecord.Pulse= $Number(Pulse)
     s tempPersonTBCheckRecord.nHighPressure= $Number(nHighPressure)
     s tempPersonTBCheckRecord.nLowPressure= $Number(nLowPressure)
     s tempPersonTBCheckRecord.Weight= $Number(Weight)
     s tempPersonTBCheckRecord.Height= $Number(Height)
     s tempPersonTBCheckRecord.BMI= BMI
     s tempPersonTBCheckRecord.Saddle= Saddle
     s tempPersonTBCheckRecord.Waist= Waist
     s tempPersonTBCheckRecord.WaistlineAndSaddle= WaistlineAndSaddle
     s tempPersonTBCheckRecord.OtherCheckResult= OtherCheckResult
     s tempPersonTBCheckRecord.Smoke= Smoke
     s tempPersonTBCheckRecord.DCSC= DCSC
     s tempPersonTBCheckRecord.Drink= Drink
     s tempPersonTBCheckRecord.DPAC= DPAC
     s tempPersonTBCheckRecord.IsExercise= IsExercise
     s tempPersonTBCheckRecord.DateOfExercisePer= $Number(DateOfExercisePer)
     s tempPersonTBCheckRecord.TimesOfExercise= $Number(TimesOfExercise)
     i ComplyDoctor '= "" d
	.s ComplyDoctorobj=##class(CHSS.DictComplyDoctor).%OpenId(ComplyDoctor)
	.s tempPersonTBCheckRecord.ComplyDoctor=ComplyDoctorobj
	 i MentalityAdjust '= "" d
	.s MentalityAdjustobj=##class(CHSS.DictMentalityAdjust).%OpenId(MentalityAdjust)
	.s tempPersonTBCheckRecord.MentalityAdjust=MentalityAdjustobj
	 s tempPersonTBCheckRecord.Other= Other
	 i Nutrition '= "" d
	.s Nutritionobj=##class(CHSS.DictRationality).%OpenId(Nutrition)
	.s tempPersonTBCheckRecord.Nutrition=Nutritionobj
	 i Entironment '= "" d
	.s Entironmentobj=##class(CHSS.DictRationality).%OpenId(Entironment)
	.s tempPersonTBCheckRecord.Entironment=Entironmentobj
	 s tempPersonTBCheckRecord.bTranfer= bTranfer
	 i TransferDept'="" d
	.s TransferDeptobj=##class(User.CTLoc).%OpenId(TransferDept)
	.s tempPersonTBCheckRecord.TransferDept= TransferDeptobj
	 s tempPersonTBCheckRecord.TransferReason= TransferReason
	 s tempPersonTBCheckRecord.Chemotherapy= Chemotherapy
	 i DrugRegularityRate'="" d
	.s DrugRegularityRateobj=##class(CHSS.DictDrugRegularityRate).%OpenId(DrugRegularityRate)
	.s tempPersonTBCheckRecord.DrugRegularityRate= DrugRegularityRateobj
	 s tempPersonTBCheckRecord.DoseComplier= DoseComplier
	 s tempPersonTBCheckRecord.bDrugAdverseReaction= bDrugAdverseReaction
	 s tempPersonTBCheckRecord.AdverseReactionDrugs= AdverseReactionDrugs
	 i BookingDate '="" d
	.s BookingDate=$zdh(BookingDate,3)
	.s tempPersonTBCheckRecord.BookingDate=BookingDate 
	 s tempPersonTBCheckRecord.bBooking= bBooking
	 i StaffInput '="" d
	.s StaffInputobj=##class(User.SSUser).%OpenId(StaffInput)
	.s tempPersonTBCheckRecord.StaffInput=StaffInputobj
	s result=tempPersonTBCheckRecord.%Save()
	i result = "1" d
    .w "{""success"":""true"",""info"":"_tempPersonTBCheckRecord.%Id()_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    .
    q ""
}

ClassMethod existPersonRowIdParref(PersonRowIdParref) As %String
{
	q:PersonRowIdParref="" "-1"
	q:$d(^CHSS.PersonTBCheckRecordI("PersonRowIdParrefIndex",PersonRowIdParref)) "1"
	q "0"
}

ClassMethod delete(RowId) As %String
{
	&sql(delete from CHSS.PersonTBCheckRecord where %ID=:RowId)
	q SQLCODE
}

Storage Default
{
<Data name="PersonTBCheckRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonTBChecA1BD</DataLocation>
<DefaultData>PersonTBCheckRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonTBChecA1BD</IdLocation>
<IndexLocation>^CHSSWeb.PersonTBChecA1BI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonTBChecA1BS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
