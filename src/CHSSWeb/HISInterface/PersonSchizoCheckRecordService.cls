Class CHSSWeb.HISInterface.PersonSchizoCheckRecordService Extends %Persistent
{

/// Creator:jinming
/// CreateDate:2011-6-21
/// Description:EHR浏览器精神病人随访记录
ClassMethod SchizoCheckRecordList(PersonRowId As %String, start As %String, limit As %String) As %String
{
		 
	s PersonRowId = $G(PersonRowId)
	Set start=$G(start)
	Set limit=$G(limit)		
	Set count=0
	Set resultString = ""
	Set end = start+limit
	s reportData = ""
	
	set RowId = 0
	For  Set RowId=$O(^CHSS.SchizoCheckRecordI("PersonRowIdIndex",PersonRowId,RowId)) q:RowId=""  d
	.s tempSchizoCheckRecord=##class(CHSS.SchizoCheckRecord).%OpenId(RowId)
	.s reportData = ##class(CHSSWeb.HISInterface.PersonSchizoCheckRecordInfo).%New()
	
	.s reportData.RowId = RowId
   
    .set reportData.CheckType = ""
	.set reportData.CheckTypeName = ""
	.i tempSchizoCheckRecord.CheckType '= "" d
	..set reportData.CheckTypeName = tempSchizoCheckRecord.CheckType.Description
	..set reportData.CheckType = tempSchizoCheckRecord.CheckType.%Id()	

	.s reportData.CheckAdd=tempSchizoCheckRecord.CheckAdd
	.s reportData.CheckDoctor=tempSchizoCheckRecord.CheckDoctor
	
	.s reportData.DateCheck=tempSchizoCheckRecord.DateCheck
	.i reportData.DateCheck '= "" d
	..s reportData.DateCheck=$zd(reportData.DateCheck,3)
	
	.s reportData.Symptom=tempSchizoCheckRecord.Symptom
	.s reportData.SymptomName=##class(CHSSWeb.HISInterface.DictQuery).GetDictQuery(reportData.Symptom,"DictSymptom")
	
	.s reportData.OtherSymptom=tempSchizoCheckRecord.OtherSymptom
	.s reportData.HeartRate=tempSchizoCheckRecord.HeartRate
	.s reportData.nLowPressure=tempSchizoCheckRecord.nLowPressure
	.s reportData.nHighPressure=tempSchizoCheckRecord.nHighPressure
	
	.set reportData.InsightInfo = ""
	.set reportData.InsightInfoName = ""
	.i tempSchizoCheckRecord.InsightInfo '= "" d
	..set reportData.InsightInfoName = tempSchizoCheckRecord.InsightInfo.Description
	..set reportData.InsightInfo = tempSchizoCheckRecord.InsightInfo.%Id()		
	 
	.set reportData.SleepInfo = ""
	.set reportData.SleepInfoName = ""
	.i tempSchizoCheckRecord.SleepInfo '= "" d
	..set reportData.SleepInfoName = tempSchizoCheckRecord.SleepInfo.Description
	..set reportData.SleepInfo = tempSchizoCheckRecord.SleepInfo.%Id()		
	
	.set reportData.DeitInfo = ""
	.set reportData.DeitInfoName = ""
	.i tempSchizoCheckRecord.DeitInfo '= "" d
	..set reportData.DeitInfoName = tempSchizoCheckRecord.DeitInfo.Description
	..set reportData.DeitInfo = tempSchizoCheckRecord.DeitInfo.%Id()		
	
	.set reportData.SelfCare = ""
	.set reportData.SelfCareName = ""
	.i tempSchizoCheckRecord.SelfCare '= "" d
	..set reportData.SelfCareName = tempSchizoCheckRecord.SelfCare.Description
	..set reportData.SelfCare = tempSchizoCheckRecord.SelfCare.%Id()
	
	.set reportData.Housework = ""
	.set reportData.HouseworkName = ""
	.i tempSchizoCheckRecord.Housework '= "" d
	..set reportData.HouseworkName = tempSchizoCheckRecord.Housework.Description
	..set reportData.Housework = tempSchizoCheckRecord.Housework.%Id()		
	
	.set reportData.ProductiveLabour = ""
	.set reportData.ProductiveLabourName = ""
	.i tempSchizoCheckRecord.ProductiveLabour '= "" d
	..set reportData.ProductiveLabourName = tempSchizoCheckRecord.ProductiveLabour.Description
	..set reportData.ProductiveLabour = tempSchizoCheckRecord.ProductiveLabour.%Id()		
	
	.set reportData.StudyAbility = ""
	.set reportData.StudyAbilityName = ""
	.i tempSchizoCheckRecord.StudyAbility '= "" d
	..set reportData.StudyAbilityName = tempSchizoCheckRecord.StudyAbility.Description
	..set reportData.StudyAbility = tempSchizoCheckRecord.StudyAbility.%Id()
	
	.set reportData.HumanCommunication = ""
	.set reportData.HumanCommunicationName = ""
	.i tempSchizoCheckRecord.HumanCommunication '= "" d
	..set reportData.HumanCommunicationName = tempSchizoCheckRecord.HumanCommunication.Description
	..set reportData.HumanCommunication = tempSchizoCheckRecord.HumanCommunication.%Id()		
	
	.s reportData.PhysicalDisease=tempSchizoCheckRecord.PhysicalDisease
	.s reportData.LaboratoryExamination=tempSchizoCheckRecord.LaboratoryExamination
	
	.set reportData.ComplyDoctor = ""
	.set reportData.ComplyDoctorName = ""
	.i tempSchizoCheckRecord.ComplyDoctor '= "" d
	..set reportData.ComplyDoctorName = tempSchizoCheckRecord.ComplyDoctor.Description
	..set reportData.ComplyDoctor = tempSchizoCheckRecord.ComplyDoctor.%Id()

    .set reportData.DoseComplier = ""
	.set reportData.DoseComplierName = ""
 	.i tempSchizoCheckRecord.DoseComplier '= "" d
	..set reportData.DoseComplierName = tempSchizoCheckRecord.DoseComplier.Description
	..set reportData.DoseComplier = tempSchizoCheckRecord.DoseComplier.%Id()
 
	.s reportData.bAdverseEffects=tempSchizoCheckRecord.bAdverseEffects
	.s reportData.DrugOfAdverseEffects=tempSchizoCheckRecord.DrugOfAdverseEffects
	
	.set reportData.EvaluationCategory = ""
	.set reportData.EvaluationCategoryName = ""
	.i tempSchizoCheckRecord.EvaluationCategory '= "" d
	..set reportData.EvaluationCategoryName = tempSchizoCheckRecord.EvaluationCategory.Description
	..set reportData.EvaluationCategory = tempSchizoCheckRecord.EvaluationCategory.%Id()
	
	.s reportData.RehabilitationMeasure=tempSchizoCheckRecord.RehabilitationMeasure
	.s reportData.bTransfer=tempSchizoCheckRecord.bTransfer
	.s reportData.TransferHospital=tempSchizoCheckRecord.TransferHospital
	.s reportData.AdvisoryOpinion=tempSchizoCheckRecord.AdvisoryOpinion
	
	.s reportData.StaffInput = ""
	.s reportData.StaffInputName=""
	.i tempSchizoCheckRecord.StaffInput'="" d
	..s reportData.StaffInput=tempSchizoCheckRecord.StaffInput.%Id()
	..s reportData.StaffInputName=tempSchizoCheckRecord.StaffInput.SSUSRName
	
	.s reportData.DateOfInput=tempSchizoCheckRecord.DateOfInput
	.i reportData.DateOfInput '= "" d
	..s reportData.DateOfInput=$zd(reportData.DateOfInput,3)
	
	.s reportData.DateOfUpdate=tempSchizoCheckRecord.DateOfUpdate
	.i reportData.DateOfUpdate '= "" d
	..s reportData.DateOfUpdate=$zd(reportData.DateOfUpdate,3)
	
	.s reportData.DateOfNextCheck=tempSchizoCheckRecord.DateOfNextCheck
	.i reportData.DateOfNextCheck '= "" d
	..s reportData.DateOfNextCheck=$zd(reportData.DateOfNextCheck,3)
	
	.s reportData.TransferReason=tempSchizoCheckRecord.TransferReason

    .set reportData.bBooking = tempSchizoCheckRecord.bBooking
  
    .set reportData.CureEffect = ""
	.set reportData.CureEffectName = ""
    .i tempSchizoCheckRecord.CureEffect '= "" d
	..set reportData.CureEffectName = tempSchizoCheckRecord.CureEffect.Description
	..set reportData.CureEffect = tempSchizoCheckRecord.CureEffect.%Id()
 
     
	
    .Set count=count+1
    .If (count>start)&(count<=end) d
	..s cdef=##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.PersonSchizoCheckRecordInfo")
	..s returnData = "<SchizoCheck>"
	..s countPro = cdef.Properties.Count()
	..f i=1:1:countPro d
	...s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
	..s returnData = returnData_"</SchizoCheck>"
	..s resultString = resultString_returnData
	
	i count'=0 d
	.s resultString = "<SchizoChecks count='"_count_"'>"_resultString_"</SchizoChecks>"
    
	Quit resultString
}

/// Creator:jinming
/// CreateDate:2011-6-21
/// Description:获取【患病对家庭社会的影响】字段
ClassMethod EffectToFamily(PersonRowId As %String) As %String
{
	s PersonRowId = $g(PersonRowId)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowId,EffectRowIDDR,Times FROM CHSS.SchizoEffectToFamily"
 		
	i (PersonRowId'="") d
	.s sqlStr = sqlStr_" where PersonRowId="_PersonRowId
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set count=0
	Set resultString = ""	
	s temp=""
	s startStr=""
	
	While(result.Next())
	{
	    s RowId = result.Data("RowId")
		s EffectRowIDDR = result.Data("EffectRowIDDR")
		
		s Times = result.Data("Times")	
		//s tmp = ##class(CHSS.DictEffectToFamily).%OpenId(EffectRowIDDR)	
		//s EffectRowIDDR=tmp.Description
		
		s temp = temp_startStr_EffectRowIDDR_Times_"次"
		s startStr="、"
	}
	d result.Close()
	s resultString="<EffectToFamily><Info>"_temp_"</Info></EffectToFamily>"
	q resultString
}

/// Creator:jinming
/// CreateDate:2011-6-22
/// Description:获取【患病对家庭社会的影响】列表
ClassMethod EffectToFamilyList(PersonRowId As %String, start As %String, limit As %String) As %String
{
	s PersonRowId = $g(PersonRowId)
	s start = $g(start)
	s limit = $g(limit)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowId,EffectRowIDDR,Times FROM CHSS.SchizoEffectToFamily"
	s end = start+limit
	s count=0
 		
	i (PersonRowId'="") d
	.s sqlStr = sqlStr_" where PersonRowId="_PersonRowId
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set count=0
	Set resultString = ""	
	s resultString=""	
	
	While(result.Next())
	{		
		s count=count+1
    	i (count>start)&(count<=end) d
	    .s RowId = result.Data("RowId")
		.s EffectRowIDDR = result.Data("EffectRowIDDR")
		
		.s Times = result.Data("Times")	
		.//s tmp = ##class(CHSS.DictEffectToFamily).%OpenId(EffectRowIDDR)	
		.//s EffectRowIDDR=tmp.Description
		
		.s temp="<EffectToFamily>"
		.s temp = temp_"<RowId>"_RowId_"</RowId>"
		.s temp=temp_"<EffectRowIDDR>"_EffectRowIDDR_"</EffectRowIDDR>"
		.s temp=temp_"<Times>"_Times_"</Times>"
		.s temp=temp_"</EffectToFamily>"
		
		.s resultString=resultString_temp
	}
	d result.Close()
	i count'=0 d
	.s resultString="<EffectToFamilys count='"_count_"'>"_resultString_"</EffectToFamilys>"
	q resultString
}

Storage Default
{
<Data name="PersonSchizoCheckRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonSchizoBF5D</DataLocation>
<DefaultData>PersonSchizoCheckRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonSchizoBF5D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonSchizoBF5I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonSchizoBF5S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
