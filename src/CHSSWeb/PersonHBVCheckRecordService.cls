Class CHSSWeb.PersonHBVCheckRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2009—07-21
/// Description:乙肝随访情况
/// Table：PersonHBVCheckRecord
/// Input: PersonHBVCheckRecord
/// Output：
/// Return：
/// Others：
ClassMethod List(PersonRowIdParref As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
      Set PersonRowIdParref=$G(PersonRowIdParref)
      Set start=$G(start)
      Set limit=$G(limit)
      Set sort=$G(sort)
      Set count=0
      Set resultString = ""
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      set HBVCheckRowId = 0
      Set tmp = ""
      
      
      
      For  Set HBVCheckRowId=$O(^CHSS.PersonHBVCheckRecordI("PersonRowIdParrefIndex",PersonRowIdParref,HBVCheckRowId)) q:HBVCheckRowId=""  d
      .
      
      .s tempPersonHBVCheckRecordInfo=##class(CHSS.PersonHBVCheckRecord).%OpenId(HBVCheckRowId)
      
      ./// 随访信息 
      .set DateCheck = tempPersonHBVCheckRecordInfo.DateCheck
      .i DateCheck '= "" d
      ..s DateCheck = $zd(DateCheck,3)
      
      .s CheckAdd = tempPersonHBVCheckRecordInfo.CheckAdd
      .s CheckDoctor = tempPersonHBVCheckRecordInfo.CheckDoctor
      
      .set StaffInput = ""
      .i tempPersonHBVCheckRecordInfo.StaffInput '= "" d
      ..s StaffInput = tempPersonHBVCheckRecordInfo.StaffInput.%Id()
      
      ./// 症状
      .
      .s Symptom = tempPersonHBVCheckRecordInfo.Symptom
      .s OtherSymptom = tempPersonHBVCheckRecordInfo.OtherSymptom
      
      ./// 体征
      .
      .s Temperature = tempPersonHBVCheckRecordInfo.Temperature
      .s Breath = tempPersonHBVCheckRecordInfo.Breath
      .s Pulse = tempPersonHBVCheckRecordInfo.Pulse
      .s nHighPressure = tempPersonHBVCheckRecordInfo.nHighPressure
      .s nLowPressure = tempPersonHBVCheckRecordInfo.nLowPressure
      .s Weight = tempPersonHBVCheckRecordInfo.Weight
      .s Height = tempPersonHBVCheckRecordInfo.Height
      
      .s BMI = tempPersonHBVCheckRecordInfo.BMI
      .s Saddle = tempPersonHBVCheckRecordInfo.Saddle
      .s Waist = tempPersonHBVCheckRecordInfo.Waist
      .s WaistlineAndSaddle = tempPersonHBVCheckRecordInfo.WaistlineAndSaddle
      .s BloodSurgeLimosis = tempPersonHBVCheckRecordInfo.BloodSurgeLimosis
      .s BloodAfterDining = tempPersonHBVCheckRecordInfo.BloodAfterDining
      .s BloodAfterDiningOfTwo = tempPersonHBVCheckRecordInfo.BloodAfterDiningOfTwo
      
      ./// 乙肝标志物
      .
      .set HbsAgName = ""
      .set HbsAg = ""
      .i tempPersonHBVCheckRecordInfo.HbsAg '= "" d
      ..s HbsAg = tempPersonHBVCheckRecordInfo.HbsAg.%Id()
      ..s HbsAgName = tempPersonHBVCheckRecordInfo.HbsAg.Description
      
      .set HbsAbName = ""
      .set HbsAb = ""
      .i tempPersonHBVCheckRecordInfo.HbsAb '= "" d
      ..s HbsAb = tempPersonHBVCheckRecordInfo.HbsAb.%Id()
      ..s HbsAbName = tempPersonHBVCheckRecordInfo.HbsAb.Description
      
      ./// 其他
      .
      .s Other = tempPersonHBVCheckRecordInfo.Other
      
      ./// 生活方式指导
      .
      .s Smoke = tempPersonHBVCheckRecordInfo.Smoke
      .s DCSC = tempPersonHBVCheckRecordInfo.DCSC
      .s Drink = tempPersonHBVCheckRecordInfo.Drink
      .s DPAC = tempPersonHBVCheckRecordInfo.DPAC
      
      .s IsExercise = tempPersonHBVCheckRecordInfo.IsExercise
      .s TimesOfExercise = tempPersonHBVCheckRecordInfo.TimesOfExercise
      .s DateOfExercisePer = tempPersonHBVCheckRecordInfo.DateOfExercisePer
      
      .set NutritionName = ""
      .set Nutrition = ""
      .i tempPersonHBVCheckRecordInfo.Nutrition '= "" d
      ..s Nutrition = tempPersonHBVCheckRecordInfo.Nutrition.%Id()
      ..s NutritionName = tempPersonHBVCheckRecordInfo.Nutrition.Description
      
      .set EntironmentName = ""
      .set Entironment = ""
      .i tempPersonHBVCheckRecordInfo.Entironment '= "" d
      ..s Entironment = tempPersonHBVCheckRecordInfo.Entironment.%Id()
      ..s EntironmentName = tempPersonHBVCheckRecordInfo.Entironment.Description
      
      .set MentalityAdjustName = ""
      .set MentalityAdjust = ""
      .i tempPersonHBVCheckRecordInfo.MentalityAdjust '= "" d
      ..s MentalityAdjust = tempPersonHBVCheckRecordInfo.MentalityAdjust.%Id()
      ..s MentalityAdjustName = tempPersonHBVCheckRecordInfo.MentalityAdjust.Description
      
      .set ComplyDoctorName = ""
      .set ComplyDoctor = ""
      .i tempPersonHBVCheckRecordInfo.ComplyDoctor '= "" d
      ..s ComplyDoctor = tempPersonHBVCheckRecordInfo.ComplyDoctor.%Id()
      ..s ComplyDoctorName = tempPersonHBVCheckRecordInfo.ComplyDoctor.Description
      
      ./// 其他相关检查
      .
      .s OtherCheckResult = tempPersonHBVCheckRecordInfo.OtherCheckResult
      
      ./// 用药情况
      .
      .set DrugRegularityRateName = ""
      .set DrugRegularityRate = ""
      .i tempPersonHBVCheckRecordInfo.DrugRegularityRate '= "" d
      ..s DrugRegularityRate = tempPersonHBVCheckRecordInfo.DrugRegularityRate.%Id()
      ..s DrugRegularityRateName = tempPersonHBVCheckRecordInfo.DrugRegularityRate.Description
      
      .s DoseComplier = tempPersonHBVCheckRecordInfo.DoseComplier
      .s bDrugAdverseReaction = tempPersonHBVCheckRecordInfo.bDrugAdverseReaction
      .s AdverseReactionDrugs = tempPersonHBVCheckRecordInfo.AdverseReactionDrugs
      
      ./// 转诊
      .
      .s bTranfer = tempPersonHBVCheckRecordInfo.bTranfer
      
      .set TransferDeptName = ""
      .set TransferDept = ""
      .i tempPersonHBVCheckRecordInfo.TransferDept '= "" d
      ..s TransferDept = tempPersonHBVCheckRecordInfo.TransferDept.%Id()
      ..s TransferDeptName = tempPersonHBVCheckRecordInfo.TransferDept.CTLOCDesc
      
      .s TransferReason = tempPersonHBVCheckRecordInfo.TransferReason
      
      ./// 下次随访信息
      .
      .s bBooking = tempPersonHBVCheckRecordInfo.bBooking
      
      .set BookingDate = tempPersonHBVCheckRecordInfo.BookingDate
      .i BookingDate '= "" d
      ..s BookingDate = $zd(BookingDate,3)
      
      .Set tmp = HBVCheckRowId_"^"_DateCheck_"^"_CheckAdd_"^"_CheckDoctor_"^"_StaffInput_"^"_Symptom_"^"_OtherSymptom_"^"_Temperature_"^"_Breath_"^"_Pulse_"^"_nHighPressure_"^"_nLowPressure_"^"_Weight_"^"_Height_"^"_BMI_"^"_Saddle_"^"_Waist_"^"_WaistlineAndSaddle_"^"_BloodSurgeLimosis_"^"_BloodAfterDining_"^"_BloodAfterDiningOfTwo_"^"_HbsAg_"^"_HbsAgName_"^"_HbsAb_"^"_HbsAbName_"^"_Other_"^"_Smoke_"^"_DCSC_"^"_Drink_"^"_DPAC_"^"_IsExercise_"^"_TimesOfExercise_"^"_DateOfExercisePer_"^"_Nutrition_"^"_NutritionName_"^"_Entironment_"^"_EntironmentName_"^"_MentalityAdjust_"^"_MentalityAdjustName_"^"_ComplyDoctor_"^"_ComplyDoctorName_"^"_OtherCheckResult_"^"_DrugRegularityRate_"^"_DrugRegularityRateName_"^"_DoseComplier_"^"_bDrugAdverseReaction_"^"_AdverseReactionDrugs_"^"_bTranfer_"^"_TransferDept_"^"_TransferDeptName_"^"_TransferReason_"^"_bBooking_"^"_BookingDate
      .Set count=count+1
      .If (count>start)&(count<=end) d
      ..d json.InsertRowData(tmp)
      .
      .
      
      Set resultString = json.getJsonData("HBVCheckRowId^DateCheck^CheckAdd^CheckDoctor^StaffInput^Symptom^OtherSymptom^Temperature^Breath^Pulse^nHighPressure^nLowPressure^Weight^Height^BMI^Saddle^Waist^WaistlineAndSaddle^BloodSurgeLimosis^BloodAfterDining^BloodAfterDiningOfTwo^HbsAg^HbsAgName^HbsAb^HbsAbName^Other^Smoke^DCSC^Drink^DPAC^IsExercise^TimesOfExercise^DateOfExercisePer^Nutrition^NutritionName^Entironment^EntironmentName^MentalityAdjust^MentalityAdjustName^ComplyDoctor^ComplyDoctorName^OtherCheckResult^DrugRegularityRate^DrugRegularityRateName^DoseComplier^bDrugAdverseReaction^AdverseReactionDrugs^bTranfer^TransferDept^TransferDeptName^TransferReason^bBooking^BookingDate",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2009—07-21
/// Description:添加乙肝随访情况
/// Table：PersonHBVCheckRecord
/// Input: PersonHBVCheckRecord
/// Output：
/// Return：
/// Others：
ClassMethod Insert(PersonRowIdParref As %Integer, DateCheck As %Date, CheckAdd As %String, CheckDoctor As %String, StaffInput As %Integer, Symptom As %String, OtherSymptom As %String, Temperature As %Float, Breath As %Numeric, Pulse As %Numeric, nHighPressure As %Numeric, nLowPressure As %Numeric, Weight As %Float, Height As %Float, BMI As %Float, Saddle As %Float, Waist As %Float, WaistlineAndSaddle As %Float, BloodSurgeLimosis As %String, BloodAfterDining As %String, BloodAfterDiningOfTwo As %String, HbsAg As %Integer, HbsAb As %Integer, Other As %String, Smoke As %String, DCSC As %Float, Drink As %String, DPAC As %Float, IsExercise As %String, TimesOfExercise As %Numeric, DateOfExercisePer As %Numeric, Nutrition As %Integer, Entironment As %Integer, MentalityAdjust As %Integer, ComplyDoctor As %Integer, OtherCheckResult As %String, DrugRegularityRate As %Integer, DoseComplier As %String, bDrugAdverseReaction As %String, AdverseReactionDrugs As %String, bTranfer As %String, TransferDept As %String, TransferReason As %String, bBooking As %String, BookingDate As %Date) As %String
{
      s tempPersonHBVCheckRecordInfo=""
      s tempPersonHBVCheckRecordInfo=##class(CHSS.PersonHBVCheckRecord).%New()
      q:(tempPersonHBVCheckRecordInfo="") 0
      
      s PersonRowIdParrefobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
      s tempPersonHBVCheckRecordInfo.PersonRowIdParref=PersonRowIdParrefobj
      
      
      /// 随访信息 
      
      i DateCheck '= "" d
      .s DateCheck=$zdh(DateCheck,3)
      s tempPersonHBVCheckRecordInfo.DateCheck=DateCheck
      
      s tempPersonHBVCheckRecordInfo.CheckAdd = CheckAdd
      s tempPersonHBVCheckRecordInfo.CheckDoctor = CheckDoctor
      
      i StaffInput '= "" d
      .s StaffInputobj=##class(User.SSUser).%OpenId(StaffInput)
      .s tempPersonHBVCheckRecordInfo.StaffInput=StaffInputobj
      
      /// 症状
      
      s tempPersonHBVCheckRecordInfo.Symptom = Symptom
      s tempPersonHBVCheckRecordInfo.OtherSymptom = OtherSymptom
        
      /// 体征
      
      s tempPersonHBVCheckRecordInfo.Temperature = Temperature
      s tempPersonHBVCheckRecordInfo.Breath = Breath
      s tempPersonHBVCheckRecordInfo.Pulse = Pulse
      s tempPersonHBVCheckRecordInfo.nHighPressure = nHighPressure
      s tempPersonHBVCheckRecordInfo.nLowPressure = nLowPressure
      s tempPersonHBVCheckRecordInfo.Weight = Weight
      s tempPersonHBVCheckRecordInfo.Height = Height
      
      s tempPersonHBVCheckRecordInfo.BMI = BMI
      s tempPersonHBVCheckRecordInfo.Saddle = Saddle
      s tempPersonHBVCheckRecordInfo.Waist = Waist
      s tempPersonHBVCheckRecordInfo.WaistlineAndSaddle = WaistlineAndSaddle
      s tempPersonHBVCheckRecordInfo.BloodSurgeLimosis = BloodSurgeLimosis
      s tempPersonHBVCheckRecordInfo.BloodAfterDining = BloodAfterDining
      s tempPersonHBVCheckRecordInfo.BloodAfterDiningOfTwo = BloodAfterDiningOfTwo
      
      /// 乙肝标志物
      
      i HbsAg '= "" d
      .s HbsAgobj=##class(CHSS.DictHBVTag).%OpenId(HbsAg)
      .s tempPersonHBVCheckRecordInfo.HbsAg=HbsAgobj
      
      i HbsAb '= "" d
      .s HbsAbobj=##class(CHSS.DictHBVTag).%OpenId(HbsAb)
      .s tempPersonHBVCheckRecordInfo.HbsAb=HbsAbobj
      
      /// 其他
      s tempPersonHBVCheckRecordInfo.Other = Other
      
      /// 生活方式指导
      
      s tempPersonHBVCheckRecordInfo.Smoke = Smoke
      s tempPersonHBVCheckRecordInfo.DCSC = DCSC
      s tempPersonHBVCheckRecordInfo.Drink = Drink
      s tempPersonHBVCheckRecordInfo.DPAC = DPAC
      
      s tempPersonHBVCheckRecordInfo.IsExercise = IsExercise
      s tempPersonHBVCheckRecordInfo.TimesOfExercise = TimesOfExercise
      s tempPersonHBVCheckRecordInfo.DateOfExercisePer = DateOfExercisePer
      
      i Nutrition '= "" d
      .s Nutritionobj=##class(CHSS.DictRationality).%OpenId(Nutrition)
      .s tempPersonHBVCheckRecordInfo.Nutrition=Nutritionobj
      
      i Entironment '= "" d
      .s Entironmentobj=##class(CHSS.DictRationality).%OpenId(Entironment)
      .s tempPersonHBVCheckRecordInfo.Entironment=Entironmentobj
      
      i MentalityAdjust '= "" d
      .s MentalityAdjustobj=##class(CHSS.DictMentalityAdjust).%OpenId(MentalityAdjust)
      .s tempPersonHBVCheckRecordInfo.MentalityAdjust=MentalityAdjustobj
      
      i ComplyDoctor '= "" d
      .s ComplyDoctorobj=##class(CHSS.DictComplyDoctor).%OpenId(ComplyDoctor)
      .s tempPersonHBVCheckRecordInfo.ComplyDoctor=ComplyDoctorobj
      
      /// 其他相关检查
      
      s tempPersonHBVCheckRecordInfo.OtherCheckResult = OtherCheckResult
      
      /// 用药情况
      
      i DrugRegularityRate '= "" d
      .s DrugRegularityRateobj=##class(CHSS.DictDrugRegularityRate).%OpenId(DrugRegularityRate)
      .s tempPersonHBVCheckRecordInfo.DrugRegularityRate=DrugRegularityRateobj
      
      s tempPersonHBVCheckRecordInfo.DoseComplier = DoseComplier
      s tempPersonHBVCheckRecordInfo.bDrugAdverseReaction = bDrugAdverseReaction
      s tempPersonHBVCheckRecordInfo.AdverseReactionDrugs = AdverseReactionDrugs
      
      /// 转诊
      
      s tempPersonHBVCheckRecordInfo.bTranfer = bTranfer
      
      i TransferDept '= "" d
      .s TransferDeptobj=##class(User.CTLoc).%OpenId(TransferDept)
      .s tempPersonHBVCheckRecordInfo.TransferDept=TransferDeptobj
      
      s tempPersonHBVCheckRecordInfo.TransferReason = TransferReason
      
      /// 下次随访信息
      
      s tempPersonHBVCheckRecordInfo.bBooking = bBooking
      
      i BookingDate '= "" d
      .s BookingDate=$zdh(BookingDate,3)
      s tempPersonHBVCheckRecordInfo.BookingDate=BookingDate
      
        
      s result=""
      s result=tempPersonHBVCheckRecordInfo.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempPersonHBVCheckRecordInfo.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempPersonHBVCheckRecordInfo.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2009—07-21
/// Description:更新乙肝随访情况
/// Table：PersonHBVCheckRecord
/// Input: PersonHBVCheckRecord
/// Output：
/// Return：
/// Others：
ClassMethod Update(HBVCheckRowId As %Integer, DateCheck As %Date, CheckAdd As %String, CheckDoctor As %String, StaffInput As %Integer, Symptom As %String, OtherSymptom As %String, Temperature As %Float, Breath As %Numeric, Pulse As %Numeric, nHighPressure As %Numeric, nLowPressure As %Numeric, Weight As %Float, Height As %Float, BMI As %Float, Saddle As %Float, Waist As %Float, WaistlineAndSaddle As %Float, BloodSurgeLimosis As %String, BloodAfterDining As %String, BloodAfterDiningOfTwo As %String, HbsAg As %Integer, HbsAb As %Integer, Other As %String, Smoke As %String, DCSC As %Float, Drink As %String, DPAC As %Float, IsExercise As %String, TimesOfExercise As %Numeric, DateOfExercisePer As %Numeric, Nutrition As %Integer, Entironment As %Integer, MentalityAdjust As %Integer, ComplyDoctor As %Integer, OtherCheckResult As %String, DrugRegularityRate As %Integer, DoseComplier As %String, bDrugAdverseReaction As %String, AdverseReactionDrugs As %String, bTranfer As %String, TransferDept As %String, TransferReason As %String, bBooking As %String, BookingDate As %Date) As %String
{
  
      q:($d(HBVCheckRowId)=0)||(HBVCheckRowId="")
      
      s tempPersonHBVCheckRecordInfo="",result=""
      s tempPersonHBVCheckRecordInfo=##class(CHSS.PersonHBVCheckRecord).%OpenId(HBVCheckRowId)
      q:(tempPersonHBVCheckRecordInfo="") 0
       
      
      /// 随访信息 
    
      i DateCheck '= "" d
      .s DateCheck=$zdh(DateCheck,3)
      s tempPersonHBVCheckRecordInfo.DateCheck=DateCheck
      
      s tempPersonHBVCheckRecordInfo.CheckAdd = CheckAdd
      s tempPersonHBVCheckRecordInfo.CheckDoctor = CheckDoctor
      
      i StaffInput '= "" d
      .s StaffInputobj=##class(User.SSUser).%OpenId(StaffInput)
      .s tempPersonHBVCheckRecordInfo.StaffInput=StaffInputobj
      
      /// 症状
      
      s tempPersonHBVCheckRecordInfo.Symptom = Symptom
      s tempPersonHBVCheckRecordInfo.OtherSymptom = OtherSymptom
        
      /// 体征
      
      s tempPersonHBVCheckRecordInfo.Temperature = Temperature
      s tempPersonHBVCheckRecordInfo.Breath = Breath
      s tempPersonHBVCheckRecordInfo.Pulse = Pulse
      s tempPersonHBVCheckRecordInfo.nHighPressure = nHighPressure
      s tempPersonHBVCheckRecordInfo.nLowPressure = nLowPressure
      s tempPersonHBVCheckRecordInfo.Weight = Weight
      s tempPersonHBVCheckRecordInfo.Height = Height
      
      s tempPersonHBVCheckRecordInfo.BMI = BMI
      s tempPersonHBVCheckRecordInfo.Saddle = Saddle
      s tempPersonHBVCheckRecordInfo.Waist = Waist
      s tempPersonHBVCheckRecordInfo.WaistlineAndSaddle = WaistlineAndSaddle
      s tempPersonHBVCheckRecordInfo.BloodSurgeLimosis = BloodSurgeLimosis
      s tempPersonHBVCheckRecordInfo.BloodAfterDining = BloodAfterDining
      s tempPersonHBVCheckRecordInfo.BloodAfterDiningOfTwo = BloodAfterDiningOfTwo
      
      /// 乙肝标志物
      
      i HbsAg '= "" d
      .s HbsAgobj=##class(CHSS.DictHBVTag).%OpenId(HbsAg)
      .s tempPersonHBVCheckRecordInfo.HbsAg=HbsAgobj
      
      i HbsAb '= "" d
      .s HbsAbobj=##class(CHSS.DictHBVTag).%OpenId(HbsAb)
      .s tempPersonHBVCheckRecordInfo.HbsAb=HbsAbobj
      
      /// 其他
      s tempPersonHBVCheckRecordInfo.Other = Other
      
      /// 生活方式指导
      
      s tempPersonHBVCheckRecordInfo.Smoke = Smoke
      s tempPersonHBVCheckRecordInfo.DCSC = DCSC
      s tempPersonHBVCheckRecordInfo.Drink = Drink
      s tempPersonHBVCheckRecordInfo.DPAC = DPAC
      
      s tempPersonHBVCheckRecordInfo.IsExercise = IsExercise
      s tempPersonHBVCheckRecordInfo.TimesOfExercise = TimesOfExercise
      s tempPersonHBVCheckRecordInfo.DateOfExercisePer = DateOfExercisePer
      
      i Nutrition '= "" d
      .s Nutritionobj=##class(CHSS.DictRationality).%OpenId(Nutrition)
      .s tempPersonHBVCheckRecordInfo.Nutrition=Nutritionobj
      
      i Entironment '= "" d
      .s Entironmentobj=##class(CHSS.DictRationality).%OpenId(Entironment)
      .s tempPersonHBVCheckRecordInfo.Entironment=Entironmentobj
      
      i MentalityAdjust '= "" d
      .s MentalityAdjustobj=##class(CHSS.DictMentalityAdjust).%OpenId(MentalityAdjust)
      .s tempPersonHBVCheckRecordInfo.MentalityAdjust=MentalityAdjustobj
      
      i ComplyDoctor '= "" d
      .s ComplyDoctorobj=##class(CHSS.DictComplyDoctor).%OpenId(ComplyDoctor)
      .s tempPersonHBVCheckRecordInfo.ComplyDoctor=ComplyDoctorobj
      
      /// 其他相关检查
      
      s tempPersonHBVCheckRecordInfo.OtherCheckResult = OtherCheckResult
      
      /// 用药情况
      
      i DrugRegularityRate '= "" d
      .s DrugRegularityRateobj=##class(CHSS.DictDrugRegularityRate).%OpenId(DrugRegularityRate)
      .s tempPersonHBVCheckRecordInfo.DrugRegularityRate=DrugRegularityRateobj
      
      s tempPersonHBVCheckRecordInfo.DoseComplier = DoseComplier
      s tempPersonHBVCheckRecordInfo.bDrugAdverseReaction = bDrugAdverseReaction
      s tempPersonHBVCheckRecordInfo.AdverseReactionDrugs = AdverseReactionDrugs
      
      /// 转诊
      
      s tempPersonHBVCheckRecordInfo.bTranfer = bTranfer
      
      i TransferDept '= "" d
      .s TransferDeptobj=##class(User.CTLoc).%OpenId(TransferDept)
      .s tempPersonHBVCheckRecordInfo.TransferDept=TransferDeptobj
      
      s tempPersonHBVCheckRecordInfo.TransferReason = TransferReason
      
      /// 下次随访信息
      
      s tempPersonHBVCheckRecordInfo.bBooking = bBooking
      
      i BookingDate '= "" d
      .s BookingDate=$zdh(BookingDate,3)
      s tempPersonHBVCheckRecordInfo.BookingDate=BookingDate
        
        
      s result=""
      s result=tempPersonHBVCheckRecordInfo.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_HBVCheckRowId_"}"
      .///w "{""success"":""true"",""info"":"_HBVCheckRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

/// Creator: lyy
/// CreatDate：2009—07-21
/// Description:删除乙肝随访情况
/// Table：PersonHBVCheckRecord
/// Input: HBVCheckRowId
/// Output：
/// Return：
/// Others：
ClassMethod Delete(HBVCheckRowId As %String) As %String
{
      &sql(delete from CHSS.PersonHBVCheckRecord where %ID=:HBVCheckRowId)
      s result=SQLCODE
      Set resultString = ""
      
      i result = "0" d
      .s resultString = "{""success"":""true"",""info"":"_HBVCheckRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
      
      q resultString
}

Storage Default
{
<Data name="PersonHBVCheckRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonHBVCheA65D</DataLocation>
<DefaultData>PersonHBVCheckRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonHBVCheA65D</IdLocation>
<IndexLocation>^CHSSWeb.PersonHBVCheA65I</IndexLocation>
<StreamLocation>^CHSSWeb.PersonHBVCheA65S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
