Class CHSSWeb.HISInterface.ElerlyHealthCheckInterface Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-02-
/// Description:老年人健康随访记录接口--检索身份证号返回老年人健康随访记录信息(HIS调用)
/// Table：ElerlyHealthCheck
/// Input:IDCard
/// Output：
/// Return：
/// Others：
ClassMethod GetElerlyHealthCheckData(IDCard As %String)
{
		n (IDCard)
		
		Set IDCard=$G(IDCard)
		;Set reportReportData = ##class(CHSSWeb.HISInterface.ElerlyHealthCheckInfoData).%New()
		s IDCard=" "_IDCard
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		s reportData = ""
		set returnData = ""
		set CheckRowId = 0
		
		Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("IDCardIndex",IDCard,PersonRowId))
		q:PersonRowId="" ""
		
      
        For  Set CheckRowId=$O(^CHSS.ElerlyHealthCheckRecordI("PersonRowIdIndex",PersonRowId,CheckRowId)) q:CheckRowId=""  d
        .
      
        .s tempElerlyHealthCheck=##class(CHSS.ElerlyHealthCheckRecord).%OpenId(CheckRowId)
        .
		.s reportData = ##class(CHSSWeb.HISInterface.ElerlyHealthCheckInfo).%New()
             
		.
		.s reportData.PersonRowId=tempElerlyHealthCheck.PersonRowId.%Id()
		.
		.s DateCheck=tempElerlyHealthCheck.DateCheck
		.i DateCheck '= "" d
		..s reportData.DateCheck = $zd(DateCheck,3)
		.
		.s reportData.CheckAdd=tempElerlyHealthCheck.CheckAdd
		.s reportData.CheckDoctor=tempElerlyHealthCheck.CheckDoctor
		.
		.;set StaffInputName = ""
        .set StaffInput = ""
        .i tempElerlyHealthCheck.StaffInput '= "" d
        ..s StaffInput = tempElerlyHealthCheck.StaffInput.%Id()
        ..s reportData.StaffInput = tempElerlyHealthCheck.StaffInput.SSUSRName
		.
		.s DateOfInput=tempElerlyHealthCheck.DateOfInput
		.i DateOfInput '= "" d
		..s reportData.DateOfInput = $zd(DateOfInput,3)
		.
		.s DateOfUpdate=tempElerlyHealthCheck.DateOfUpdate
		.i DateOfUpdate '= "" d
		..s reportData.DateOfUpdate = $zd(DateOfUpdate,3)
		.
		.s reportData.TargetOfNextCheck=tempElerlyHealthCheck.TargetOfNextCheck
		.
		.s BookingDate=tempElerlyHealthCheck.BookingDate
		.i BookingDate '= "" d
		..s reportData.BookingDate = $zd(BookingDate,3)
		.
		.s reportData.bBooking=tempElerlyHealthCheck.bBooking
		.
		.;set SymptomName = ""
        .set Symptom = ""
        .i tempElerlyHealthCheck.Symptom '= "" d
        ..s Symptom = tempElerlyHealthCheck.Symptom.%Id()
        ..s reportData.Symptom = tempElerlyHealthCheck.Symptom.Description
		.
		.i tempElerlyHealthCheck.NewSymptom '= "" d
        ..s NewSymptom = tempElerlyHealthCheck.NewSymptom
        ..s reportData.NewSymptom = ##class(CHSSWeb.HISInterface.ElerlyBaseInterface).GetDisplayValue(NewSymptom, "DictChronicSymptom")
		.
		.;s reportData.NewSymptom=tempElerlyHealthCheck.NewSymptom
		.
		.i tempElerlyHealthCheck.OlsSymptom '= "" d
        ..s OlsSymptom = tempElerlyHealthCheck.OlsSymptom
        ..s reportData.OlsSymptom = ##class(CHSSWeb.HISInterface.ElerlyBaseInterface).GetDisplayValue(OlsSymptom, "DictChronicSymptom")
		.
		.;s reportData.OlsSymptom=tempElerlyHealthCheck.OlsSymptom
		.
		.s reportData.MentalStatus=tempElerlyHealthCheck.MentalStatus
		.
		.;set PsychologyStatusName = ""
        .set PsychologyStatus = ""
        .i tempElerlyHealthCheck.PsychologyStatus '= "" d
        ..s PsychologyStatus = tempElerlyHealthCheck.PsychologyStatus.%Id()
        ..s reportData.PsychologyStatus = tempElerlyHealthCheck.PsychologyStatus.Description
        .
		.s reportData.HighPressure=tempElerlyHealthCheck.HighPressure
		.s reportData.LowPressure=tempElerlyHealthCheck.LowPressure
		.s reportData.HeartRate=tempElerlyHealthCheck.HeartRate
		.s reportData.Weight=tempElerlyHealthCheck.Weight
		.s reportData.Height=tempElerlyHealthCheck.Height
		.s reportData.BMI=tempElerlyHealthCheck.BMI
		.
		.;set FoodName = ""
        .set Food = ""
        .i tempElerlyHealthCheck.Food '= "" d
        ..s Food = tempElerlyHealthCheck.Food.%Id()
        ..s reportData.Food = tempElerlyHealthCheck.Food.Description
		.
		.s reportData.MentalityAdjust=tempElerlyHealthCheck.MentalityAdjust
		.
		.i tempElerlyHealthCheck.EduKnowledge '= "" d
        ..s EduKnowledge = tempElerlyHealthCheck.EduKnowledge
        ..s reportData.EduKnowledge = ##class(CHSSWeb.HISInterface.ElerlyBaseInterface).GetDisplayValue(EduKnowledge, "DictEduKnowledge")
		.
		.;s reportData.EduKnowledge=tempElerlyHealthCheck.EduKnowledge
		.s reportData.EduKnowledgeAim=tempElerlyHealthCheck.EduKnowledgeAim
		.s reportData.bSmoke=tempElerlyHealthCheck.bSmoke
		.s reportData.SmokeNum=tempElerlyHealthCheck.SmokeNum
		.
		.s DateOfStopSmoke=tempElerlyHealthCheck.DateOfStopSmoke
		.i DateOfStopSmoke '= "" d
		..s reportData.DateOfStopSmoke = $zd(DateOfStopSmoke,3)
		.
		.s reportData.bDrink=tempElerlyHealthCheck.bDrink
		.s reportData.DrinkQuentity=tempElerlyHealthCheck.DrinkQuentity
		.
		.s DateOfStopDrink=tempElerlyHealthCheck.DateOfStopDrink
		.i DateOfStopDrink '= "" d
		..s reportData.DateOfStopDrink = $zd(DateOfStopDrink,3)
		.
		.s reportData.Exercise=tempElerlyHealthCheck.Exercise
		.
		.;set DrugRegularityName = ""
        .set DrugRegularity = ""
        .i tempElerlyHealthCheck.DrugRegularity '= "" d
        ..s DrugRegularity = tempElerlyHealthCheck.DrugRegularity.%Id()
        ..s reportData.DrugRegularity = tempElerlyHealthCheck.DrugRegularity.Description
		.
		.s reportData.EatDrug=tempElerlyHealthCheck.EatDrug
		.s reportData.ExerciseNum=tempElerlyHealthCheck.ExerciseNum
		.s reportData.ExerciseMin=tempElerlyHealthCheck.ExerciseMin
		.s reportData.BloodAfterDining=tempElerlyHealthCheck.BloodAfterDining
		.s reportData.BloodAfterDiningOfTwo=tempElerlyHealthCheck.BloodAfterDiningOfTwo
		.s reportData.BloodSurgeLimosis=tempElerlyHealthCheck.BloodSurgeLimosis
		.s reportData.NeedTransfer=tempElerlyHealthCheck.NeedTransfer
		.s reportData.PsychologyOfCoaching=tempElerlyHealthCheck.PsychologyOfCoaching
		.s reportData.Drepress=tempElerlyHealthCheck.Drepress
		.
		.;set ComplyDoctorName = ""
        .set ComplyDoctor = ""
        .i tempElerlyHealthCheck.ComplyDoctor '= "" d
        ..s ComplyDoctor = tempElerlyHealthCheck.ComplyDoctor.%Id()
        ..s reportData.ComplyDoctor = tempElerlyHealthCheck.ComplyDoctor.Description
		.
		.s reportData.GiveVaccination=tempElerlyHealthCheck.GiveVaccination
		.s reportData.DefendOfCoronary=tempElerlyHealthCheck.DefendOfCoronary
		.s reportData.DefendOfOsteoporosis=tempElerlyHealthCheck.DefendOfOsteoporosis
		.
		.;set CaseTypeName = ""
        .set CaseType = ""
        .i tempElerlyHealthCheck.CaseType '= "" d
        ..s CaseType = tempElerlyHealthCheck.CaseType.%Id()
        ..s reportData.CaseType = tempElerlyHealthCheck.CaseType.Description
		.
		.;set EyegroundCheckName = ""
        .set EyegroundCheck = ""
        .i tempElerlyHealthCheck.EyegroundCheck '= "" d
        ..s EyegroundCheck = tempElerlyHealthCheck.EyegroundCheck.%Id()
        ..s reportData.EyegroundCheck = tempElerlyHealthCheck.EyegroundCheck.Description
        .
		.s reportData.TransferEachOther=tempElerlyHealthCheck.TransferEachOther
		.s reportData.TransferReason=tempElerlyHealthCheck.TransferReason
		.
		
		.;如果返回的是LIST，则使用[Collection = list]方式返回列表
		.;d reportReportData.ElerlyHealthCheckInfo.Insert(reportData)
		.
		.;第二种方法：手工拼写
	    .Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.ElerlyHealthCheckInfo")
 		.s returnData = returnData_"<ElerlyHealthCheckInfo>"
		. // get list of properties
		.;Write "---Properties---",!
		.Set count = cdef.Properties.Count()
		.For i = 1:1:count d
    	..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 		..s returnData = returnData_"</ElerlyHealthCheckInfo>"
 		.
 		.
			
	  	Quit returnData
}

/// Creator:jinming
/// CreateDate:2011-6-20
/// Description:EHR浏览器老年人随访记录
ClassMethod ElerlyHealthCheckList(PersonRowId As %String, start As %String, limit As %String) As %String
{
    Set PersonRowId=$G(PersonRowId)
    Set start=$G(start)
    Set limit=$G(limit)
    Set count=0
    Set resultString = ""
    Set end = start+limit
	s reportData = ""
	s returnData = ""
    set CheckRowId = 0      
      
    For  Set CheckRowId=$O(^CHSS.ElerlyHealthCheckRecordI("PersonRowIdIndex",PersonRowId,CheckRowId)) q:CheckRowId=""  d
    .s reportData = ##class(CHSSWeb.HISInterface.ElerlyHealthCheckInfo).%New()
    .s tempElerlyHealthCheckRecord=##class(CHSS.ElerlyHealthCheckRecord).%OpenId(CheckRowId)
    
    .s reportData.CheckRowId = CheckRowId

    .; 随访信息
      
    .set reportData.DateCheck = tempElerlyHealthCheckRecord.DateCheck
    .i reportData.DateCheck '= "" d
    ..s reportData.DateCheck = $zd(reportData.DateCheck,3)

    .s reportData.CheckAdd = tempElerlyHealthCheckRecord.CheckAdd
    .s reportData.CheckDoctor = tempElerlyHealthCheckRecord.CheckDoctor

    .set reportData.StaffInputName = ""
    .set reportData.StaffInput = ""
    .i tempElerlyHealthCheckRecord.StaffInput '= "" d
    ..s reportData.StaffInput = tempElerlyHealthCheckRecord.StaffInput.%Id()
    ..s reportData.StaffInputName = tempElerlyHealthCheckRecord.StaffInput.SSUSRName

    .set reportData.DateOfInput = tempElerlyHealthCheckRecord.DateOfInput
    .i reportData.DateOfInput '= "" d
    ..s reportData.DateOfInput = $zd(reportData.DateOfInput,3)

    .set reportData.DateOfUpdate = tempElerlyHealthCheckRecord.DateOfUpdate
    .i reportData.DateOfUpdate '= "" d
    ..s reportData.DateOfUpdate = $zd(reportData.DateOfUpdate,3)

    .s reportData.TargetOfNextCheck = tempElerlyHealthCheckRecord.TargetOfNextCheck

    .set reportData.BookingDate = tempElerlyHealthCheckRecord.BookingDate
    .i reportData.BookingDate '= "" d
    ..s reportData.BookingDate = $zd(reportData.BookingDate,3)

    .s reportData.bBooking = tempElerlyHealthCheckRecord.bBooking      
      
    .; 老年人健康信息

    .set reportData.SymptomName = ""
    .set reportData.Symptom = ""
    .i tempElerlyHealthCheckRecord.Symptom '= "" d
    ..s reportData.Symptom = tempElerlyHealthCheckRecord.Symptom.%Id()
    ..s reportData.SymptomName = tempElerlyHealthCheckRecord.Symptom.Description

    .s tempNewSymptom = tempElerlyHealthCheckRecord.NewSymptom
    .s reportData.NewSymptom = tempNewSymptom
    .s tempNewSymptomCount = $l(tempNewSymptom,",")
    .s tempNewSymptomNames = ""
    .f i=1:1:tempNewSymptomCount d    
    ..s tempNewSymptomId = $p(tempNewSymptom,",",i,i)
    ..s tempNewSymptomObj = ##class(CHSS.DictChronicSymptom).%OpenId(tempNewSymptomId)
    ..s tempNewSymptomName = tempNewSymptomObj.Description
    ..i tempNewSymptomNames '= "" d
    ...s tempNewSymptomNames = tempNewSymptomNames_", "_tempNewSymptomName
    ..e  d
    ...s tempNewSymptomNames = tempNewSymptomName
    .s reportData.NewSymptomName = tempNewSymptomNames
    
    .s tempOlsSymptom = tempElerlyHealthCheckRecord.OlsSymptom
    .s reportData.OlsSymptom = tempOlsSymptom
    .s tempOlsSymptomCount = $l(tempOlsSymptom,",")
    .s tempOlsSymptomNames = ""
    .f i=1:1:tempOlsSymptomCount d    
    ..s tempOlsSymptomId = $p(tempOlsSymptom,",",i,i)
    ..s tempOlsSymptomObj = ##class(CHSS.DictChronicSymptom).%OpenId(tempOlsSymptomId)
    ..s tempOlsSymptomName = tempOlsSymptomObj.Description
    ..i tempOlsSymptomNames '= "" d
    ...s tempOlsSymptomNames = tempOlsSymptomNames_", "_tempOlsSymptomName
    ..e  d
    ...s tempOlsSymptomNames = tempOlsSymptomName
    .s reportData.OlsSymptomName = tempOlsSymptomNames
    
    .s reportData.MentalStatus = tempElerlyHealthCheckRecord.MentalStatus

    .set reportData.PsychologyStatusName = ""
    .set reportData.PsychologyStatus = ""
    .i tempElerlyHealthCheckRecord.PsychologyStatus '= "" d
    ..s reportData.PsychologyStatus = tempElerlyHealthCheckRecord.PsychologyStatus.%Id()
    ..s reportData.PsychologyStatusName = tempElerlyHealthCheckRecord.PsychologyStatus.Description

    .s reportData.HighPressure = tempElerlyHealthCheckRecord.HighPressure
    .s reportData.LowPressure = tempElerlyHealthCheckRecord.LowPressure
    .s reportData.HeartRate = tempElerlyHealthCheckRecord.HeartRate
    .s reportData.Weight = tempElerlyHealthCheckRecord.Weight
    .s reportData.Height = tempElerlyHealthCheckRecord.Height
    .s reportData.BMI = tempElerlyHealthCheckRecord.BMI

    .set reportData.FoodName = ""
    .set reportData.Food = ""
    .i tempElerlyHealthCheckRecord.Food '= "" d
    ..s reportData.Food = tempElerlyHealthCheckRecord.Food.%Id()
    ..s reportData.FoodName = tempElerlyHealthCheckRecord.Food.Description

    .s reportData.MentalityAdjust = tempElerlyHealthCheckRecord.MentalityAdjust
    
    .s tempEduKnowledge = tempElerlyHealthCheckRecord.EduKnowledge
    .s reportData.EduKnowledge = tempEduKnowledge
    .s reportData.EduKnowledgeValue = ##class(CHSSWeb.HISInterface.DictQuery).GetDictQuery(tempEduKnowledge,"DictEduKnowledge")
    
    .s reportData.EduKnowledgeAim = tempElerlyHealthCheckRecord.EduKnowledgeAim
    .s reportData.bSmoke = tempElerlyHealthCheckRecord.bSmoke
    .s reportData.Smoke = tempElerlyHealthCheckRecord.Smoke
    .s reportData.SmokeNum = tempElerlyHealthCheckRecord.SmokeNum

    .set reportData.DateOfStopSmoke = tempElerlyHealthCheckRecord.DateOfStopSmoke
    .i reportData.DateOfStopSmoke '= "" d
    ..s reportData.DateOfStopSmoke = $zd(reportData.DateOfStopSmoke,3)

    .s reportData.bDrink = tempElerlyHealthCheckRecord.bDrink
    .s reportData.Drink = tempElerlyHealthCheckRecord.Drink
    .s reportData.DrinkQuentity = tempElerlyHealthCheckRecord.DrinkQuentity

    .set reportData.DateOfStopDrink = tempElerlyHealthCheckRecord.DateOfStopDrink
    .i reportData.DateOfStopDrink '= "" d
    ..s reportData.DateOfStopDrink = $zd(reportData.DateOfStopDrink,3)

    .s reportData.Exercise = tempElerlyHealthCheckRecord.Exercise
    .set reportData.DrugRegularityName = ""
    .set reportData.DrugRegularity = ""
    .i tempElerlyHealthCheckRecord.DrugRegularity '= "" d
    ..s reportData.DrugRegularity = tempElerlyHealthCheckRecord.DrugRegularity.%Id()
    ..s reportData.DrugRegularityName = tempElerlyHealthCheckRecord.DrugRegularity.Description

    .s reportData.EatDrug = tempElerlyHealthCheckRecord.EatDrug
    .s reportData.ExerciseNum = tempElerlyHealthCheckRecord.ExerciseNum
    .s reportData.ExerciseMin = tempElerlyHealthCheckRecord.ExerciseMin
    .s reportData.BloodAfterDining = tempElerlyHealthCheckRecord.BloodAfterDining
    .s reportData.BloodAfterDiningOfTwo = tempElerlyHealthCheckRecord.BloodAfterDiningOfTwo
    .s reportData.BloodSurgeLimosis = tempElerlyHealthCheckRecord.BloodSurgeLimosis
    .s reportData.NoComplaints = tempElerlyHealthCheckRecord.NoComplaints
    .s reportData.NeedTransfer = tempElerlyHealthCheckRecord.NeedTransfer
    .s reportData.PsychologyOfCoaching = tempElerlyHealthCheckRecord.PsychologyOfCoaching
    .s reportData.Drepress = tempElerlyHealthCheckRecord.Drepress

    .set reportData.ComplyDoctorName = ""
    .set reportData.ComplyDoctor = ""
    .i tempElerlyHealthCheckRecord.ComplyDoctor '= "" d
    ..s reportData.ComplyDoctor = tempElerlyHealthCheckRecord.ComplyDoctor.%Id()
    ..s reportData.ComplyDoctorName = tempElerlyHealthCheckRecord.ComplyDoctor.Description

    .s reportData.GiveVaccination = tempElerlyHealthCheckRecord.GiveVaccination
    .s reportData.DefendOfCoronary = tempElerlyHealthCheckRecord.DefendOfCoronary
    .s reportData.DefendOfOsteoporosis = tempElerlyHealthCheckRecord.DefendOfOsteoporosis

    .set reportData.CaseTypeName = ""
    .set reportData.CaseType = ""
    .i tempElerlyHealthCheckRecord.CaseType '= "" d
    ..s reportData.CaseType = tempElerlyHealthCheckRecord.CaseType.%Id()
    ..s reportData.CaseTypeName = tempElerlyHealthCheckRecord.CaseType.Description

    .set reportData.EyegroundCheckName = ""
    .set reportData.EyegroundCheck = ""
    .i tempElerlyHealthCheckRecord.EyegroundCheck '= "" d
    ..s reportData.EyegroundCheck = tempElerlyHealthCheckRecord.EyegroundCheck.%Id()
    ..s reportData.EyegroundCheckName = tempElerlyHealthCheckRecord.EyegroundCheck.Description

    .s reportData.TransferEachOther = tempElerlyHealthCheckRecord.TransferEachOther
    .s reportData.TransferReason = tempElerlyHealthCheckRecord.TransferReason
     
    .Set count=count+1
    .If (count>start)&(count<=end) d
    ..s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.ElerlyHealthCheckInfo")
    ..s returnData = "<ElerlyHealthCheck>"
    ..s countPro = cdef.Properties.Count()
    ..f i=1:1:countPro d
    ...s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
    ..s returnData = returnData_"</ElerlyHealthCheck>"
    .s resultString = resultString_returnData
      
    i count'=0 d
    .s resultString = "<ElerlyHealthChecks count='"_count_"'>"_resultString_"</ElerlyHealthChecks>"
    q resultString
}

Storage Default
{
<Data name="ElerlyHealthCheckInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.ElerlyHealthA32D</DataLocation>
<DefaultData>ElerlyHealthCheckInterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.ElerlyHealthA32D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.ElerlyHealthA32I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.ElerlyHealthA32S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
