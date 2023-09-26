Class CHSSWeb.ElerlyHealthCheckRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2009-11-
/// Description:老年人健康随访信息
/// Table：ElerlyHealthCheckRecord
/// Input: ElerlyHealthCheckRecord
/// Output：
/// Return：
/// Others：
ClassMethod List(PersonRowId As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
      Set PersonRowId=$G(PersonRowId)
      Set start=$G(start)
      Set limit=$G(limit)
      Set sort=$G(sort)
      Set count=0
      Set resultString = ""
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      set CheckRowId = 0
      Set tmp = ""
      
      
      For  Set CheckRowId=$O(^CHSS.ElerlyHealthCheckRecordI("PersonRowIdIndex",PersonRowId,CheckRowId)) q:CheckRowId=""  d
      .
      
      .s tempElerlyHealthCheckRecord=##class(CHSS.ElerlyHealthCheckRecord).%OpenId(CheckRowId)
      .

      ./// 随访信息
      
      .set DateCheck = tempElerlyHealthCheckRecord.DateCheck
      .i DateCheck '= "" d
      ..s DateCheck = $zd(DateCheck,3)

      .s CheckAdd = tempElerlyHealthCheckRecord.CheckAdd
      .s CheckDoctor = tempElerlyHealthCheckRecord.CheckDoctor

      .set StaffInputName = ""
      .set StaffInput = ""
      .i tempElerlyHealthCheckRecord.StaffInput '= "" d
      ..s StaffInput = tempElerlyHealthCheckRecord.StaffInput.%Id()
      ..s StaffInputName = tempElerlyHealthCheckRecord.StaffInput.SSUSRName

      .set DateOfInput = tempElerlyHealthCheckRecord.DateOfInput
      .i DateOfInput '= "" d
      ..s DateOfInput = $zd(DateOfInput,3)

      .set DateOfUpdate = tempElerlyHealthCheckRecord.DateOfUpdate
      .i DateOfUpdate '= "" d
      ..s DateOfUpdate = $zd(DateOfUpdate,3)

      .s TargetOfNextCheck = tempElerlyHealthCheckRecord.TargetOfNextCheck


      .set BookingDate = tempElerlyHealthCheckRecord.BookingDate
      .i BookingDate '= "" d
      ..s BookingDate = $zd(BookingDate,3)

      .s bBooking = tempElerlyHealthCheckRecord.bBooking
      
      
      ./// 老年人健康信息

      .set SymptomName = ""
      .set Symptom = ""
      .i tempElerlyHealthCheckRecord.Symptom '= "" d
      ..s Symptom = tempElerlyHealthCheckRecord.Symptom.%Id()
      ..s SymptomName = tempElerlyHealthCheckRecord.Symptom.Description

      .s NewSymptom = tempElerlyHealthCheckRecord.NewSymptom
      .s OlsSymptom = tempElerlyHealthCheckRecord.OlsSymptom
      .s MentalStatus = tempElerlyHealthCheckRecord.MentalStatus

      .set PsychologyStatusName = ""
      .set PsychologyStatus = ""
      .i tempElerlyHealthCheckRecord.PsychologyStatus '= "" d
      ..s PsychologyStatus = tempElerlyHealthCheckRecord.PsychologyStatus.%Id()
      ..s PsychologyStatusName = tempElerlyHealthCheckRecord.PsychologyStatus.Description

      .s HighPressure = tempElerlyHealthCheckRecord.HighPressure
      .s LowPressure = tempElerlyHealthCheckRecord.LowPressure
      .s HeartRate = tempElerlyHealthCheckRecord.HeartRate
      .s Weight = tempElerlyHealthCheckRecord.Weight
      .s Height = tempElerlyHealthCheckRecord.Height
      .s BMI = tempElerlyHealthCheckRecord.BMI

      .set FoodName = ""
      .set Food = ""
      .i tempElerlyHealthCheckRecord.Food '= "" d
      ..s Food = tempElerlyHealthCheckRecord.Food.%Id()
      ..s FoodName = tempElerlyHealthCheckRecord.Food.Description

      .s MentalityAdjust = tempElerlyHealthCheckRecord.MentalityAdjust
      .s EduKnowledge = tempElerlyHealthCheckRecord.EduKnowledge
      .s EduKnowledgeAim = tempElerlyHealthCheckRecord.EduKnowledgeAim
      .s bSmoke = tempElerlyHealthCheckRecord.bSmoke
      .s Smoke = tempElerlyHealthCheckRecord.Smoke
      .s SmokeNum = tempElerlyHealthCheckRecord.SmokeNum

      .set DateOfStopSmoke = tempElerlyHealthCheckRecord.DateOfStopSmoke
      .i DateOfStopSmoke '= "" d
      ..s DateOfStopSmoke = $zd(DateOfStopSmoke,3)

      .s bDrink = tempElerlyHealthCheckRecord.bDrink
      .s Drink = tempElerlyHealthCheckRecord.Drink
      .s DrinkQuentity = tempElerlyHealthCheckRecord.DrinkQuentity

      .set DateOfStopDrink = tempElerlyHealthCheckRecord.DateOfStopDrink
      .i DateOfStopDrink '= "" d
      ..s DateOfStopDrink = $zd(DateOfStopDrink,3)

      .s Exercise = tempElerlyHealthCheckRecord.Exercise

      .set DrugRegularityName = ""
      .set DrugRegularity = ""
      .i tempElerlyHealthCheckRecord.DrugRegularity '= "" d
      ..s DrugRegularity = tempElerlyHealthCheckRecord.DrugRegularity.%Id()
      ..s DrugRegularityName = tempElerlyHealthCheckRecord.DrugRegularity.Description

      .s EatDrug = tempElerlyHealthCheckRecord.EatDrug
      .s ExerciseNum = tempElerlyHealthCheckRecord.ExerciseNum
      .s ExerciseMin = tempElerlyHealthCheckRecord.ExerciseMin
      .s BloodAfterDining = tempElerlyHealthCheckRecord.BloodAfterDining
      .s BloodAfterDiningOfTwo = tempElerlyHealthCheckRecord.BloodAfterDiningOfTwo
      .s BloodSurgeLimosis = tempElerlyHealthCheckRecord.BloodSurgeLimosis
      .s NoComplaints = tempElerlyHealthCheckRecord.NoComplaints
      .s NeedTransfer = tempElerlyHealthCheckRecord.NeedTransfer
      .s PsychologyOfCoaching = tempElerlyHealthCheckRecord.PsychologyOfCoaching
      .s Drepress = tempElerlyHealthCheckRecord.Drepress

      .set ComplyDoctorName = ""
      .set ComplyDoctor = ""
      .i tempElerlyHealthCheckRecord.ComplyDoctor '= "" d
      ..s ComplyDoctor = tempElerlyHealthCheckRecord.ComplyDoctor.%Id()
      ..s ComplyDoctorName = tempElerlyHealthCheckRecord.ComplyDoctor.Description

      .s GiveVaccination = tempElerlyHealthCheckRecord.GiveVaccination
      .s DefendOfCoronary = tempElerlyHealthCheckRecord.DefendOfCoronary
      .s DefendOfOsteoporosis = tempElerlyHealthCheckRecord.DefendOfOsteoporosis

      .set CaseTypeName = ""
      .set CaseType = ""
      .i tempElerlyHealthCheckRecord.CaseType '= "" d
      ..s CaseType = tempElerlyHealthCheckRecord.CaseType.%Id()
      ..s CaseTypeName = tempElerlyHealthCheckRecord.CaseType.Description

      .set EyegroundCheckName = ""
      .set EyegroundCheck = ""
      .i tempElerlyHealthCheckRecord.EyegroundCheck '= "" d
      ..s EyegroundCheck = tempElerlyHealthCheckRecord.EyegroundCheck.%Id()
      ..s EyegroundCheckName = tempElerlyHealthCheckRecord.EyegroundCheck.Description

      .s TransferEachOther = tempElerlyHealthCheckRecord.TransferEachOther
      .s TransferReason = tempElerlyHealthCheckRecord.TransferReason

          
      
      .Set tmp = CheckRowId_"^"_DateCheck_"^"_CheckAdd_"^"_CheckDoctor_"^"_StaffInput_"^"_StaffInputName_"^"_DateOfInput_"^"_DateOfUpdate_"^"_TargetOfNextCheck_"^"_BookingDate_"^"_bBooking_"^"_Symptom_"^"_SymptomName_"^"_NewSymptom_"^"_OlsSymptom_"^"_MentalStatus_"^"_PsychologyStatus_"^"_PsychologyStatusName_"^"_HighPressure_"^"_LowPressure_"^"_HeartRate_"^"_Weight_"^"_Height_"^"_BMI_"^"_Food_"^"_FoodName_"^"_MentalityAdjust_"^"_EduKnowledge_"^"_EduKnowledgeAim_"^"_bSmoke_"^"_Smoke_"^"_SmokeNum_"^"_DateOfStopSmoke_"^"_bDrink_"^"_Drink_"^"_DrinkQuentity_"^"_DateOfStopDrink_"^"_Exercise_"^"_DrugRegularity_"^"_DrugRegularityName_"^"_EatDrug_"^"_ExerciseNum_"^"_ExerciseMin_"^"_BloodAfterDining_"^"_BloodAfterDiningOfTwo_"^"_BloodSurgeLimosis_"^"_NoComplaints_"^"_NeedTransfer_"^"_PsychologyOfCoaching_"^"_Drepress_"^"_ComplyDoctor_"^"_ComplyDoctorName_"^"_GiveVaccination_"^"_DefendOfCoronary_"^"_DefendOfOsteoporosis_"^"_CaseType_"^"_CaseTypeName_"^"_EyegroundCheck_"^"_EyegroundCheckName_"^"_TransferEachOther_"^"_TransferReason

      .Set count=count+1
      .If (count>start)&(count<=end) d
      ..d json.InsertRowData(tmp)
      .
      .
      
      Set resultString = json.getJsonData("CheckRowId^DateCheck^CheckAdd^CheckDoctor^StaffInput^StaffInputName^DateOfInput^DateOfUpdate1^TargetOfNextCheck^BookingDate^bBooking^Symptom^SymptomName^NewSymptom^OlsSymptom^MentalStatus^PsychologyStatus^PsychologyStatusName^HighPressure^LowPressure^HeartRate^Weight^Height^BMI^Food^FoodName^MentalityAdjust^EduKnowledge^EduKnowledgeAim^bSmoke^Smoke^SmokeNum^DateOfStopSmoke^bDrink^Drink^DrinkQuentity^DateOfStopDrink^Exercise^DrugRegularity^DrugRegularityName^EatDrug^ExerciseNum^ExerciseMin^BloodAfterDining^BloodAfterDiningOfTwo^BloodSurgeLimosis^NoComplaints^NeedTransfer^PsychologyOfCoaching^Drepress^ComplyDoctor^ComplyDoctorName^GiveVaccination^DefendOfCoronary^DefendOfOsteoporosis^CaseType^CaseTypeName^EyegroundCheck^EyegroundCheckName^TransferEachOther^TransferReason",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2009-11-
/// Description:添加老年人健康随访信息
/// Table：ElerlyHealthCheckRecord
/// Input: ElerlyHealthCheckRecord
/// Output：
/// Return：
/// Others：
ClassMethod Insert(PersonRowId As %Integer, DateCheck As %Date, CheckAdd As %String, CheckDoctor As %String, StaffInput As User.SSUser, DateOfInput As %Date, DateOfUpdate As %Date, TargetOfNextCheck As %String, BookingDate As %Date, bBooking As %String, Symptom As %Integer, NewSymptom As %String, OlsSymptom As %String, MentalStatus As %String, PsychologyStatus As %Integer, HighPressure As %Numeric, LowPressure As %Numeric, HeartRate As %Numeric, Weight As %Float, Height As %Float, BMI As %Float, Food As %Integer, MentalityAdjust As %String, EduKnowledge As %String, EduKnowledgeAim As %String, bSmoke As %String, Smoke As %String, SmokeNum As %Integer, DateOfStopSmoke As %Date, bDrink As %String, Drink As %String, DrinkQuentity As %Float, DateOfStopDrink As %Date, Exercise As %String, DrugRegularity As %Integer, EatDrug As %String, ExerciseNum As %Numeric, ExerciseMin As %Numeric, BloodAfterDining As %String, BloodAfterDiningOfTwo As %String, BloodSurgeLimosis As %String, NoComplaints As %String, NeedTransfer As %String, PsychologyOfCoaching As %String, Drepress As %String, ComplyDoctor As %Integer, GiveVaccination As %String, DefendOfCoronary As %String, DefendOfOsteoporosis As %String, CaseType As %Integer, EyegroundCheck As %Integer, TransferEachOther As %String, TransferReason As %String) As %String
{
      s tempElerlyHealthCheckRecord=""
      s tempElerlyHealthCheckRecord=##class(CHSS.ElerlyHealthCheckRecord).%New()
      q:(tempElerlyHealthCheckRecord="") 0
                 
	  
      i PersonRowId '= "" d
      .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
      .s tempElerlyHealthCheckRecord.PersonRowId=PersonRowIdobj
      

      /// 随访信息
      
      i DateCheck '= "" d
      .s DateCheck=$zdh(DateCheck ,3)
      s tempElerlyHealthCheckRecord.DateCheck=DateCheck

      s tempElerlyHealthCheckRecord.CheckAdd = CheckAdd
      s tempElerlyHealthCheckRecord.CheckDoctor = CheckDoctor
      
      i StaffInput '= "" d
      .s StaffInputobj=##class(User.SSUser).%OpenId(StaffInput)
      .s tempElerlyHealthCheckRecord.StaffInput=StaffInputobj
      

      i DateOfInput '= "" d
      .s DateOfInput=$zdh(DateOfInput ,3)
      s tempElerlyHealthCheckRecord.DateOfInput=DateOfInput

      i DateOfUpdate '= "" d
      .s DateOfUpdate=$zdh(DateOfUpdate ,3)
      s tempElerlyHealthCheckRecord.DateOfUpdate=DateOfUpdate

      s tempElerlyHealthCheckRecord.TargetOfNextCheck = TargetOfNextCheck

      s BookingDateStr = BookingDate
      i BookingDate '= "" d
      .s BookingDate=$zdh(BookingDate ,3)
      s tempElerlyHealthCheckRecord.BookingDate=BookingDate

      s tempElerlyHealthCheckRecord.bBooking = bBooking
      
      /// 老年人健康信息
      
      i Symptom '= "" d
      .s Symptomobj=##class(CHSS.DictSymptomType).%OpenId(Symptom)
      .s tempElerlyHealthCheckRecord.Symptom=Symptomobj
      
      s tempElerlyHealthCheckRecord.NewSymptom = NewSymptom
      s tempElerlyHealthCheckRecord.OlsSymptom = OlsSymptom
      s tempElerlyHealthCheckRecord.MentalStatus = MentalStatus
      
      i PsychologyStatus '= "" d
      .s PsychologyStatusobj=##class(CHSS.DictPsychologyStatus).%OpenId(PsychologyStatus)
      .s tempElerlyHealthCheckRecord.PsychologyStatus=PsychologyStatusobj
      
      s tempElerlyHealthCheckRecord.HighPressure = HighPressure
      s tempElerlyHealthCheckRecord.LowPressure = LowPressure
      s tempElerlyHealthCheckRecord.HeartRate = HeartRate
      s tempElerlyHealthCheckRecord.Weight = Weight
      s tempElerlyHealthCheckRecord.Height = Height
      s tempElerlyHealthCheckRecord.BMI = BMI
      
      i Food '= "" d
      .s Foodobj=##class(CHSS.DictElderFood).%OpenId(Food)
      .s tempElerlyHealthCheckRecord.Food=Foodobj
      
      s tempElerlyHealthCheckRecord.MentalityAdjust = MentalityAdjust
      s tempElerlyHealthCheckRecord.EduKnowledge = EduKnowledge
      s tempElerlyHealthCheckRecord.EduKnowledgeAim = EduKnowledgeAim
      s tempElerlyHealthCheckRecord.bSmoke = bSmoke
      s tempElerlyHealthCheckRecord.Smoke = Smoke
      s tempElerlyHealthCheckRecord.SmokeNum = SmokeNum

      i DateOfStopSmoke '= "" d
      .s DateOfStopSmoke=$zdh(DateOfStopSmoke ,3)
      s tempElerlyHealthCheckRecord.DateOfStopSmoke=DateOfStopSmoke

      s tempElerlyHealthCheckRecord.bDrink = bDrink
      s tempElerlyHealthCheckRecord.Drink = Drink
      s tempElerlyHealthCheckRecord.DrinkQuentity = DrinkQuentity

      i DateOfStopDrink '= "" d
      .s DateOfStopDrink=$zdh(DateOfStopDrink ,3)
      s tempElerlyHealthCheckRecord.DateOfStopDrink=DateOfStopDrink

      s tempElerlyHealthCheckRecord.Exercise = Exercise
      
      i DrugRegularity '= "" d
      .s DrugRegularityobj=##class(CHSS.DictDrugRegularityRate).%OpenId(DrugRegularity)
      .s tempElerlyHealthCheckRecord.DrugRegularity=DrugRegularityobj
      
      s tempElerlyHealthCheckRecord.EatDrug = EatDrug
      s tempElerlyHealthCheckRecord.ExerciseNum = ExerciseNum
      s tempElerlyHealthCheckRecord.ExerciseMin = ExerciseMin
      s tempElerlyHealthCheckRecord.BloodAfterDining = BloodAfterDining
      s tempElerlyHealthCheckRecord.BloodAfterDiningOfTwo = BloodAfterDiningOfTwo
      s tempElerlyHealthCheckRecord.BloodSurgeLimosis = BloodSurgeLimosis
      s tempElerlyHealthCheckRecord.NoComplaints = NoComplaints
      s tempElerlyHealthCheckRecord.NeedTransfer = NeedTransfer
      s tempElerlyHealthCheckRecord.PsychologyOfCoaching = PsychologyOfCoaching
      s tempElerlyHealthCheckRecord.Drepress = Drepress
      
      i ComplyDoctor '= "" d
      .s ComplyDoctorobj=##class(CHSS.DictComplyDoctor).%OpenId(ComplyDoctor)
      .s tempElerlyHealthCheckRecord.ComplyDoctor=ComplyDoctorobj
      
      s tempElerlyHealthCheckRecord.GiveVaccination = GiveVaccination
      s tempElerlyHealthCheckRecord.DefendOfCoronary = DefendOfCoronary
      s tempElerlyHealthCheckRecord.DefendOfOsteoporosis = DefendOfOsteoporosis
      
      i CaseType '= "" d
      .s CaseTypeobj=##class(CHSS.DictElderCaseType).%OpenId(CaseType)
      .s tempElerlyHealthCheckRecord.CaseType=CaseTypeobj
      
      i EyegroundCheck '= "" d
      .s EyegroundCheckobj=##class(CHSS.DictEyegroundCheck).%OpenId(EyegroundCheck)
      .s tempElerlyHealthCheckRecord.EyegroundCheck=EyegroundCheckobj
      
      s tempElerlyHealthCheckRecord.TransferEachOther = TransferEachOther
      s tempElerlyHealthCheckRecord.TransferReason = TransferReason

        
      s result=""
      s result=tempElerlyHealthCheckRecord.%Save()
      
     Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempElerlyHealthCheckRecord.%Id()_"}"
      .d ##class(CHSSWeb.PersonBookingCheckService).Insert(PersonRowId, 3, tempElerlyHealthCheckRecord.%Id(), BookingDateStr, 0)
      .///w "{""success"":""true"",""info"":"_tempElerlyHealthCheckRecord.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2009-11-
/// Description:更新老年人健康随访信息
/// Table：ElerlyHealthCheckRecord
/// Input: ElerlyHealthCheckRecord
/// Output：
/// Return：
/// Others：
ClassMethod Update(CheckRowId As %Integer, DateCheck As %Date, CheckAdd As %String, CheckDoctor As %String, StaffInput As User.SSUser, DateOfInput As %Date, DateOfUpdate As %Date, TargetOfNextCheck As %String, BookingDate As %Date, bBooking As %String, Symptom As %Integer, NewSymptom As %String, OlsSymptom As %String, MentalStatus As %String, PsychologyStatus As %Integer, HighPressure As %Numeric, LowPressure As %Numeric, HeartRate As %Numeric, Weight As %Float, Height As %Float, BMI As %Float, Food As %Integer, MentalityAdjust As %String, EduKnowledge As %String, EduKnowledgeAim As %String, bSmoke As %String, Smoke As %String, SmokeNum As %Integer, DateOfStopSmoke As %Date, bDrink As %String, Drink As %String, DrinkQuentity As %Float, DateOfStopDrink As %Date, Exercise As %String, DrugRegularity As %Integer, EatDrug As %String, ExerciseNum As %Numeric, ExerciseMin As %Numeric, BloodAfterDining As %String, BloodAfterDiningOfTwo As %String, BloodSurgeLimosis As %String, NoComplaints As %String, NeedTransfer As %String, PsychologyOfCoaching As %String, Drepress As %String, ComplyDoctor As %Integer, GiveVaccination As %String, DefendOfCoronary As %String, DefendOfOsteoporosis As %String, CaseType As %Integer, EyegroundCheck As %Integer, TransferEachOther As %String, TransferReason As %String) As %String
{
  
      q:($d(CheckRowId)=0)||(CheckRowId="")
      
      s tempElerlyHealthCheckRecord="",result=""
      s tempElerlyHealthCheckRecord=##class(CHSS.ElerlyHealthCheckRecord).%OpenId(CheckRowId)
      q:(tempElerlyHealthCheckRecord="") 0
       
      
      /// 随访信息 

      i DateCheck '= "" d
      .s DateCheck=$zdh(DateCheck ,3)
      s tempElerlyHealthCheckRecord.DateCheck=DateCheck

      s tempElerlyHealthCheckRecord.CheckAdd = CheckAdd
      s tempElerlyHealthCheckRecord.CheckDoctor = CheckDoctor
      
      i StaffInput '= "" d
      .s StaffInputobj=##class(User.SSUser).%OpenId(StaffInput)
      .s tempElerlyHealthCheckRecord.StaffInput=StaffInputobj
      

      i DateOfInput '= "" d
      .s DateOfInput=$zdh(DateOfInput ,3)
      s tempElerlyHealthCheckRecord.DateOfInput=DateOfInput

      i DateOfUpdate '= "" d
      .s DateOfUpdate=$zdh(DateOfUpdate ,3)
      s tempElerlyHealthCheckRecord.DateOfUpdate=DateOfUpdate

      s tempElerlyHealthCheckRecord.TargetOfNextCheck = TargetOfNextCheck
      
      s BookingDateStr = BookingDate
      i BookingDate '= "" d
      .s BookingDate=$zdh(BookingDate ,3)
      s tempElerlyHealthCheckRecord.BookingDate=BookingDate

      s tempElerlyHealthCheckRecord.bBooking = bBooking
      
      /// 老年人健康信息
      
      i Symptom '= "" d
      .s Symptomobj=##class(CHSS.DictSymptomType).%OpenId(Symptom)
      .s tempElerlyHealthCheckRecord.Symptom=Symptomobj
      
      s tempElerlyHealthCheckRecord.NewSymptom = NewSymptom
      s tempElerlyHealthCheckRecord.OlsSymptom = OlsSymptom
      s tempElerlyHealthCheckRecord.MentalStatus = MentalStatus
      
      i PsychologyStatus '= "" d
      .s PsychologyStatusobj=##class(CHSS.DictPsychologyStatus).%OpenId(PsychologyStatus)
      .s tempElerlyHealthCheckRecord.PsychologyStatus=PsychologyStatusobj
      
      s tempElerlyHealthCheckRecord.HighPressure = HighPressure
      s tempElerlyHealthCheckRecord.LowPressure = LowPressure
      s tempElerlyHealthCheckRecord.HeartRate = HeartRate
      s tempElerlyHealthCheckRecord.Weight = Weight
      s tempElerlyHealthCheckRecord.Height = Height
      s tempElerlyHealthCheckRecord.BMI = BMI
      
      i Food '= "" d
      .s Foodobj=##class(CHSS.DictElderFood).%OpenId(Food)
      .s tempElerlyHealthCheckRecord.Food=Foodobj
      
      s tempElerlyHealthCheckRecord.MentalityAdjust = MentalityAdjust
      s tempElerlyHealthCheckRecord.EduKnowledge = EduKnowledge
      s tempElerlyHealthCheckRecord.EduKnowledgeAim = EduKnowledgeAim
      s tempElerlyHealthCheckRecord.bSmoke = bSmoke
      s tempElerlyHealthCheckRecord.Smoke = Smoke
      s tempElerlyHealthCheckRecord.SmokeNum = SmokeNum

      i DateOfStopSmoke '= "" d
      .s DateOfStopSmoke=$zdh(DateOfStopSmoke ,3)
      s tempElerlyHealthCheckRecord.DateOfStopSmoke=DateOfStopSmoke

      s tempElerlyHealthCheckRecord.bDrink = bDrink
      s tempElerlyHealthCheckRecord.Drink = Drink
      s tempElerlyHealthCheckRecord.DrinkQuentity = DrinkQuentity

      i DateOfStopDrink '= "" d
      .s DateOfStopDrink=$zdh(DateOfStopDrink ,3)
      s tempElerlyHealthCheckRecord.DateOfStopDrink=DateOfStopDrink

      s tempElerlyHealthCheckRecord.Exercise = Exercise
      
      i DrugRegularity '= "" d
      .s DrugRegularityobj=##class(CHSS.DictDrugRegularityRate).%OpenId(DrugRegularity)
      .s tempElerlyHealthCheckRecord.DrugRegularity=DrugRegularityobj
      
      s tempElerlyHealthCheckRecord.EatDrug = EatDrug
      s tempElerlyHealthCheckRecord.ExerciseNum = ExerciseNum
      s tempElerlyHealthCheckRecord.ExerciseMin = ExerciseMin
      s tempElerlyHealthCheckRecord.BloodAfterDining = BloodAfterDining
      s tempElerlyHealthCheckRecord.BloodAfterDiningOfTwo = BloodAfterDiningOfTwo
      s tempElerlyHealthCheckRecord.BloodSurgeLimosis = BloodSurgeLimosis
      s tempElerlyHealthCheckRecord.NoComplaints = NoComplaints
      s tempElerlyHealthCheckRecord.NeedTransfer = NeedTransfer
      s tempElerlyHealthCheckRecord.PsychologyOfCoaching = PsychologyOfCoaching
      s tempElerlyHealthCheckRecord.Drepress = Drepress
      
      i ComplyDoctor '= "" d
      .s ComplyDoctorobj=##class(CHSS.DictComplyDoctor).%OpenId(ComplyDoctor)
      .s tempElerlyHealthCheckRecord.ComplyDoctor=ComplyDoctorobj
      
      s tempElerlyHealthCheckRecord.GiveVaccination = GiveVaccination
      s tempElerlyHealthCheckRecord.DefendOfCoronary = DefendOfCoronary
      s tempElerlyHealthCheckRecord.DefendOfOsteoporosis = DefendOfOsteoporosis
      
      i CaseType '= "" d
      .s CaseTypeobj=##class(CHSS.DictElderCaseType).%OpenId(CaseType)
      .s tempElerlyHealthCheckRecord.CaseType=CaseTypeobj
      
      i EyegroundCheck '= "" d
      .s EyegroundCheckobj=##class(CHSS.DictEyegroundCheck).%OpenId(EyegroundCheck)
      .s tempElerlyHealthCheckRecord.EyegroundCheck=EyegroundCheckobj
      
      s tempElerlyHealthCheckRecord.TransferEachOther = TransferEachOther
      s tempElerlyHealthCheckRecord.TransferReason = TransferReason

        
      s result=""
      s result=tempElerlyHealthCheckRecord.%Save()
      
 
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_CheckRowId_"}"
      .d ##class(CHSSWeb.PersonBookingCheckService).Insert(tempElerlyHealthCheckRecord.PersonRowId.%Id(), 3, CheckRowId, BookingDateStr, 0)
      .///w "{""success"":""true"",""info"":"_CheckRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

/// Creator: lyy
/// CreatDate：2009-11-
/// Description:删除老年人健康随访信息
/// Table：ElerlyHealthCheckRecord
/// Input: CheckRowId
/// Output：
/// Return：
/// Others：
ClassMethod Delete(CheckRowId As %String) As %String
{
      s tempElerlyHealthCheckRecord=##class(CHSS.ElerlyHealthCheckRecord).%OpenId(CheckRowId)
                
      d ##class(CHSSWeb.PersonBookingCheckService).DeleteBooking(tempElerlyHealthCheckRecord.PersonRowId.%Id(), 3, CheckRowId)
      
      &sql(delete from CHSS.ElerlyHealthCheckRecord where %ID=:CheckRowId)
      s result=SQLCODE
      Set resultString = ""
      
      i result = "0" d
      .s resultString = "{""success"":""true"",""info"":"_CheckRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
      
      q resultString
}

Storage Default
{
<Data name="ElerlyHealthCheckRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ElerlyHealthBD1D</DataLocation>
<DefaultData>ElerlyHealthCheckRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ElerlyHealthBD1D</IdLocation>
<IndexLocation>^CHSSWeb.ElerlyHealthBD1I</IndexLocation>
<StreamLocation>^CHSSWeb.ElerlyHealthBD1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
