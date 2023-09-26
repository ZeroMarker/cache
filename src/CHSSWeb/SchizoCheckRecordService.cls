Class CHSSWeb.SchizoCheckRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod SchizoCheckRecordList(PersonRowId As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
		 
		s PersonRowId = $G(PersonRowId)
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set RowId = 0
		For  Set RowId=$O(^CHSS.SchizoCheckRecordI("PersonRowIdIndex",PersonRowId,RowId)) q:RowId=""  d
		.s tempSchizoCheckRecord=##class(CHSS.SchizoCheckRecord).%OpenId(RowId)
	   
        .set CheckType = ""
		.set CheckTypeName = ""
		.i tempSchizoCheckRecord.CheckType '= "" d
		..set CheckTypeName = tempSchizoCheckRecord.CheckType.Description
		..set CheckType = tempSchizoCheckRecord.CheckType.%Id()
	
 
		.s CheckAdd=tempSchizoCheckRecord.CheckAdd
		.s CheckDoctor=tempSchizoCheckRecord.CheckDoctor
		.s DateCheck=tempSchizoCheckRecord.DateCheck
		.i DateCheck '= "" d
		..s DateCheck=$zd(DateCheck,3)
		.s Symptom=tempSchizoCheckRecord.Symptom
		.s OtherSymptom=tempSchizoCheckRecord.OtherSymptom
		.s HeartRate=tempSchizoCheckRecord.HeartRate
		.s nLowPressure=tempSchizoCheckRecord.nLowPressure
		.s nHighPressure=tempSchizoCheckRecord.nHighPressure
		
		.set InsightInfo = ""
		.set InsightInfoName = ""
		.i tempSchizoCheckRecord.InsightInfo '= "" d
		..set InsightInfoName = tempSchizoCheckRecord.InsightInfo.Description
		..set InsightInfo = tempSchizoCheckRecord.InsightInfo.%Id()
		
		 
		.set SleepInfo = ""
		.set SleepInfoName = ""
		.i tempSchizoCheckRecord.SleepInfo '= "" d
		..set SleepInfoName = tempSchizoCheckRecord.SleepInfo.Description
		..set SleepInfo = tempSchizoCheckRecord.SleepInfo.%Id()
		
		
		.set DeitInfo = ""
		.set DeitInfoName = ""
		.i tempSchizoCheckRecord.DeitInfo '= "" d
		..set DeitInfoName = tempSchizoCheckRecord.DeitInfo.Description
		..set DeitInfo = tempSchizoCheckRecord.DeitInfo.%Id()
		
		
		.set SelfCare = ""
		.set SelfCareName = ""
		.i tempSchizoCheckRecord.SelfCare '= "" d
		..set SelfCareName = tempSchizoCheckRecord.SelfCare.Description
		..set SelfCare = tempSchizoCheckRecord.SelfCare.%Id()
		
		.set Housework = ""
		.set HouseworkName = ""
		.i tempSchizoCheckRecord.Housework '= "" d
		..set HouseworkName = tempSchizoCheckRecord.Housework.Description
		..set Housework = tempSchizoCheckRecord.Housework.%Id()
		
		
		.set ProductiveLabour = ""
		.set ProductiveLabourName = ""
		.i tempSchizoCheckRecord.ProductiveLabour '= "" d
		..set ProductiveLabourName = tempSchizoCheckRecord.ProductiveLabour.Description
		..set ProductiveLabour = tempSchizoCheckRecord.ProductiveLabour.%Id()
		
		
		.set StudyAbility = ""
		.set StudyAbilityName = ""
		.i tempSchizoCheckRecord.StudyAbility '= "" d
		..set StudyAbilityName = tempSchizoCheckRecord.StudyAbility.Description
		..set StudyAbility = tempSchizoCheckRecord.StudyAbility.%Id()
		
		.set HumanCommunication = ""
		.set HumanCommunicationName = ""
		.i tempSchizoCheckRecord.HumanCommunication '= "" d
		..set HumanCommunicationName = tempSchizoCheckRecord.HumanCommunication.Description
		..set HumanCommunication = tempSchizoCheckRecord.HumanCommunication.%Id()
		
		
		.s PhysicalDisease=tempSchizoCheckRecord.PhysicalDisease
		.s LaboratoryExamination=tempSchizoCheckRecord.LaboratoryExamination
		
		.set ComplyDoctor = ""
		.set ComplyDoctorName = ""
		.i tempSchizoCheckRecord.ComplyDoctor '= "" d
		..set ComplyDoctorName = tempSchizoCheckRecord.ComplyDoctor.Description
		..set ComplyDoctor = tempSchizoCheckRecord.ComplyDoctor.%Id()

        .set DoseComplier = ""
		.set DoseComplierName = ""
	 	.i tempSchizoCheckRecord.DoseComplier '= "" d
		..set DoseComplierName = tempSchizoCheckRecord.DoseComplier.Description
		..set DoseComplier = tempSchizoCheckRecord.DoseComplier.%Id()
	 
		.s bAdverseEffects=tempSchizoCheckRecord.bAdverseEffects
		.s DrugOfAdverseEffects=tempSchizoCheckRecord.DrugOfAdverseEffects
		
		.set EvaluationCategory = ""
		.set EvaluationCategoryName = ""
		.i tempSchizoCheckRecord.EvaluationCategory '= "" d
		..set EvaluationCategoryName = tempSchizoCheckRecord.EvaluationCategory.Description
		..set EvaluationCategory = tempSchizoCheckRecord.EvaluationCategory.%Id()
		
		.s RehabilitationMeasure=tempSchizoCheckRecord.RehabilitationMeasure
		.s bTransfer=tempSchizoCheckRecord.bTransfer
		.s TransferHospital=tempSchizoCheckRecord.TransferHospital
		.s AdvisoryOpinion=tempSchizoCheckRecord.AdvisoryOpinion
		.s StaffInput=tempSchizoCheckRecord.StaffInput
		.s DateOfInput=tempSchizoCheckRecord.DateOfInput
		.i DateOfInput '= "" d
		..s DateOfInput=$zd(DateOfInput,3)
		.s DateOfUpdate=tempSchizoCheckRecord.DateOfUpdate
		.i DateOfUpdate '= "" d
		..s DateOfUpdate=$zd(DateOfUpdate,3)
		.s DateOfNextCheck=tempSchizoCheckRecord.DateOfNextCheck
		.i DateOfNextCheck '= "" d
		..s DateOfNextCheck=$zd(DateOfNextCheck,3)
		.s TransferReason=tempSchizoCheckRecord.TransferReason

        .set bBooking = tempSchizoCheckRecord.bBooking
      
        .set CureEffect = ""
		.set CureEffectName = ""
        .i tempSchizoCheckRecord.CureEffect '= "" d
		..set CureEffectName = tempSchizoCheckRecord.CureEffect.Description
		..set CureEffect = tempSchizoCheckRecord.CureEffect.%Id()
     
         
		.Set tmp=  RowId_"^"_CheckType_"^"_CheckTypeName_"^"_CheckAdd_"^"_CheckDoctor_"^"_DateCheck_"^"_Symptom_"^"_OtherSymptom_"^"_HeartRate_"^"_nLowPressure_"^"_nHighPressure_"^"_InsightInfo_"^"_InsightInfoName_"^"_SleepInfo_"^"_SleepInfoName_"^"_DeitInfo_"^"_DeitInfoName_"^"_SelfCare_"^"_SelfCareName_"^"_Housework_"^"_HouseworkName_"^"_ProductiveLabour_"^"_ProductiveLabourName_"^"_StudyAbility_"^"_StudyAbilityName_"^"_HumanCommunication_"^"_HumanCommunicationName_"^"_PhysicalDisease_"^"_LaboratoryExamination_"^"_ComplyDoctor_"^"_ComplyDoctorName_"^"_DoseComplier_"^"_DoseComplierName_"^"_bAdverseEffects_"^"_DrugOfAdverseEffects_"^"_EvaluationCategory_"^"_EvaluationCategoryName_"^"_RehabilitationMeasure_"^"_bTransfer_"^"_TransferHospital_"^"_AdvisoryOpinion_"^"_StaffInput_"^"_DateOfInput_"^"_DateOfUpdate_"^"_DateOfNextCheck_"^"_TransferReason_"^"_bBooking_"^"_CureEffect_"^"_CureEffectName
	    .Set count=count+1
	    .If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("RowId^CheckType^CheckTypeName^CheckAdd^CheckDoctor^DateCheck^Symptom^OtherSymptom^HeartRate^nLowPressure^nHighPressure^InsightInfo^InsightInfoName^SleepInfo^SleepInfoName^DeitInfo^DeitInfoName^SelfCare^SelfCareName^Housework^HouseworkName^ProductiveLabour^ProductiveLabourName^StudyAbility^StudyAbilityName^HumanCommunication^HumanCommunicationName^PhysicalDisease^LaboratoryExamination^ComplyDoctor^ComplyDoctorName^DoseComplier^DoseComplierName^bAdverseEffects^DrugOfAdverseEffects^EvaluationCategory^EvaluationCategoryName^RehabilitationMeasure^bTransfer^TransferHospital^AdvisoryOpinion^StaffInput^DateOfInput^DateOfUpdate^DateOfNextCheck^TransferReason^bBooking^CureEffect^CureEffectName",count)
	 	k json
	 	;w resultString
		Quit resultString
}

/// 添加
ClassMethod Insert(RowId As %Integer, PersonRowId As %Integer, CheckType As %Integer, CheckAdd As %String, CheckDoctor As %String, DateCheck As %Date, Symptom As %String, OtherSymptom As %String, HeartRate As %Numeric, nLowPressure As %Numeric, nHighPressure As %Numeric, InsightInfo As %Integer, SleepInfo As %Integer, DeitInfo As %Integer, SelfCare As %Integer, Housework As %Integer, ProductiveLabour As %Integer, StudyAbility As %Integer, HumanCommunication As %Integer, PhysicalDisease As %String, LaboratoryExamination As %String, ComplyDoctor As %Integer, DoseComplier As %String, bAdverseEffects As %String, DrugOfAdverseEffects As %String, EvaluationCategory As %Integer, RehabilitationMeasure As %String, bTransfer As %String, TransferHospital As %String, AdvisoryOpinion As %String, StaffInput As %Integer, DateOfInput As %Date, DateOfUpdate As %Date, DateOfNextCheck As %Date, TransferReason As %String, bBooking As %String, CureEffect As %Integer) As %String
{
    s result =""
	s tempSchizoCheckRecord=""
    s tempSchizoCheckRecord=##class(CHSS.SchizoCheckRecord).%New()
    q:(tempSchizoCheckRecord="") 0
	 i PersonRowId '="" d
    .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    .s tempSchizoCheckRecord.PersonRowId=PersonRowIdobj
	

	i CheckType '= "" d
	.s CheckTypeobj=##class(CHSS.DictCheckType).%OpenId(CheckType)
	.s tempSchizoCheckRecord.CheckType=CheckTypeobj
	s tempSchizoCheckRecord.CheckAdd=CheckAdd
	s tempSchizoCheckRecord.CheckDoctor=CheckDoctor
	i DateCheck'="" d
	.s DateCheck=$zdh(DateCheck,3)
	.s tempSchizoCheckRecord.DateCheck=DateCheck
	s tempSchizoCheckRecord.Symptom=Symptom
	s tempSchizoCheckRecord.OtherSymptom=OtherSymptom
	s tempSchizoCheckRecord.HeartRate=HeartRate
	s tempSchizoCheckRecord.nLowPressure=nLowPressure
	s tempSchizoCheckRecord.nHighPressure=nHighPressure
	i InsightInfo '= "" d
	.s InsightInfoobj=##class(CHSS.DictInSight).%OpenId(InsightInfo)
	.s tempSchizoCheckRecord.InsightInfo=InsightInfoobj
	i SleepInfo '= "" d
	.s SleepInfoobj=##class(CHSS.DictSleepStatus).%OpenId(SleepInfo)
	.s tempSchizoCheckRecord.SleepInfo=SleepInfoobj
	i DeitInfo '= "" d
	.s DeitInfoobj=##class(CHSS.DictSleepStatus).%OpenId(DeitInfo)
	.s tempSchizoCheckRecord.DeitInfo=DeitInfoobj
	i SelfCare '= "" d
	.s SelfCareobj=##class(CHSS.DictSleepStatus).%OpenId(SelfCare)
	.s tempSchizoCheckRecord.SelfCare=SelfCareobj
	i Housework '= "" d
	.s Houseworkobj=##class(CHSS.DictSleepStatus).%OpenId(Housework)
	.s tempSchizoCheckRecord.Housework=Houseworkobj
	i ProductiveLabour '= "" d
	.s ProductiveLabourobj=##class(CHSS.DictSleepStatus).%OpenId(ProductiveLabour)
	.s tempSchizoCheckRecord.ProductiveLabour=ProductiveLabourobj
	
	i StudyAbility '= "" d
	.s StudyAbilityobj=##class(CHSS.DictSleepStatus).%OpenId(StudyAbility)
	.s tempSchizoCheckRecord.StudyAbility=StudyAbilityobj
	
	i HumanCommunication '= "" d
	.s HumanCommunicationobj=##class(CHSS.DictSleepStatus).%OpenId(HumanCommunication)
	.s tempSchizoCheckRecord.HumanCommunication=HumanCommunicationobj
	
	s tempSchizoCheckRecord.PhysicalDisease=PhysicalDisease
	s tempSchizoCheckRecord.LaboratoryExamination=LaboratoryExamination
	i ComplyDoctor '= "" d
	.s ComplyDoctorobj=##class(CHSS.DictComplyDoctor).%OpenId(ComplyDoctor)
	.s tempSchizoCheckRecord.ComplyDoctor=ComplyDoctorobj
	i DoseComplier '= "" d
	.s DoseComplierobj=##class(CHSS.DictDrugRegularityRate).%OpenId(DoseComplier)
	.s tempSchizoCheckRecord.DoseComplier=DoseComplierobj

	s tempSchizoCheckRecord.DoseComplier=DoseComplier
	s tempSchizoCheckRecord.bAdverseEffects=bAdverseEffects
	s tempSchizoCheckRecord.DrugOfAdverseEffects=DrugOfAdverseEffects
	i EvaluationCategory '= "" d
	.s EvaluationCategoryobj=##class(CHSS.DictEvaluationCategory).%OpenId(EvaluationCategory)
	.s tempSchizoCheckRecord.EvaluationCategory=EvaluationCategoryobj
	s tempSchizoCheckRecord.RehabilitationMeasure=RehabilitationMeasure
	s tempSchizoCheckRecord.bTransfer=bTransfer
	s tempSchizoCheckRecord.TransferHospital=TransferHospital
	s tempSchizoCheckRecord.AdvisoryOpinion=AdvisoryOpinion
	s tempSchizoCheckRecord.StaffInput=StaffInput
	i DateOfInput'="" d
	.s DateOfInput=$zdh(DateOfInput,3)
	.s tempSchizoCheckRecord.DateOfInput=DateOfInput
	i DateOfUpdate'="" d
	.s DateOfUpdate=$zdh(DateOfUpdate,3)
	.s tempSchizoCheckRecord.DateOfUpdate=DateOfUpdate
	i DateOfNextCheck'="" d
	.s DateOfNextCheck=$zdh(DateOfNextCheck,3)
	.s tempSchizoCheckRecord.DateOfNextCheck=DateOfNextCheck
	s tempSchizoCheckRecord.TransferReason=TransferReason
    s tempSchizoCheckRecord.bBooking= bBooking
	 i StaffInput '="" d
	.;s StaffInputobj=##class(User.SSUser).%OpenId(StaffInput)
	.;s tempSchizoCheckRecord.StaffInput=StaffInputobj
	i CureEffect '= "" d
	.s CureEffectobj=##class(CHSS.DictCureEffect).%OpenId(CureEffect)
	.s tempSchizoCheckRecord.CureEffect=CureEffectobj

 
	
	s result=tempSchizoCheckRecord.%Save()

	i result = "1" d
    .w "{""success"":""true"",""info"":"_tempSchizoCheckRecord.%Id()_"}"
    .//d ##class(CHSSWeb.PersonBookingCheckService).Insert(PersonRowIdParref, 1, tempSchizoCheckRecord.%Id(), BookingStr, 0)
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

/// 更新
ClassMethod Update(RowId As %Integer, PersonRowId As %Integer, CheckType As %Integer, CheckAdd As %String, CheckDoctor As %String, DateCheck As %Date, Symptom As %String, OtherSymptom As %String, HeartRate As %Numeric, nLowPressure As %Numeric, nHighPressure As %Numeric, InsightInfo As %Integer, SleepInfo As %Integer, DeitInfo As %Integer, SelfCare As %Integer, Housework As %Integer, ProductiveLabour As %Integer, StudyAbility As %Integer, HumanCommunication As %Integer, PhysicalDisease As %String, LaboratoryExamination As %String, ComplyDoctor As %Integer, DoseComplier As %String, bAdverseEffects As %String, DrugOfAdverseEffects As %String, EvaluationCategory As %Integer, RehabilitationMeasure As %String, bTransfer As %String, TransferHospital As %String, AdvisoryOpinion As %String, StaffInput As %Integer, DateOfInput As %Date, DateOfUpdate As %Date, DateOfNextCheck As %Date, TransferReason As %String, bBooking As %String, CureEffect As %Integer) As %String
{
  
    q:($d(RowId)=0)||(RowId="")
    s tempSchizoCheckRecord="",result=""
    s tempSchizoCheckRecord=##class(CHSS.SchizoCheckRecord).%OpenId(RowId)
    q:(tempSchizoCheckRecord="") 0
	i CheckType '= "" d
	.s CheckTypeobj=##class(CHSS.DictCheckType).%OpenId(CheckType)
	.s tempSchizoCheckRecord.CheckType=CheckTypeobj
	s tempSchizoCheckRecord.CheckAdd=CheckAdd
	s tempSchizoCheckRecord.CheckDoctor=CheckDoctor
	i DateCheck'="" d
	.s DateCheck=$zdh(DateCheck,3)
	.s tempSchizoCheckRecord.DateCheck=DateCheck
	s tempSchizoCheckRecord.Symptom=Symptom
	s tempSchizoCheckRecord.OtherSymptom=OtherSymptom
	s tempSchizoCheckRecord.HeartRate=HeartRate
	s tempSchizoCheckRecord.nLowPressure=nLowPressure
	s tempSchizoCheckRecord.nHighPressure=nHighPressure
	i InsightInfo '= "" d
	.s InsightInfoobj=##class(CHSS.DictInSight).%OpenId(InsightInfo)
	.s tempSchizoCheckRecord.InsightInfo=InsightInfoobj
	i SleepInfo '= "" d
	.s SleepInfoobj=##class(CHSS.DictSleepStatus).%OpenId(SleepInfo)
	.s tempSchizoCheckRecord.SleepInfo=SleepInfoobj
	i DeitInfo '= "" d
	.s DeitInfoobj=##class(CHSS.DictSleepStatus).%OpenId(DeitInfo)
	.s tempSchizoCheckRecord.DeitInfo=DeitInfoobj
	i SelfCare '= "" d
	.s SelfCareobj=##class(CHSS.DictSleepStatus).%OpenId(SelfCare)
	.s tempSchizoCheckRecord.SelfCare=SelfCareobj
	i Housework '= "" d
	.s Houseworkobj=##class(CHSS.DictSleepStatus).%OpenId(Housework)
	.s tempSchizoCheckRecord.Housework=Houseworkobj
	i ProductiveLabour '= "" d
	.s ProductiveLabourobj=##class(CHSS.DictSleepStatus).%OpenId(ProductiveLabour)
	.s tempSchizoCheckRecord.ProductiveLabour=ProductiveLabourobj
	
	i StudyAbility '= "" d
	.s StudyAbilityobj=##class(CHSS.DictSleepStatus).%OpenId(StudyAbility)
	.s tempSchizoCheckRecord.StudyAbility=StudyAbilityobj
	
	i HumanCommunication '= "" d
	.s HumanCommunicationobj=##class(CHSS.DictSleepStatus).%OpenId(HumanCommunication)
	.s tempSchizoCheckRecord.HumanCommunication=HumanCommunicationobj
	
	s tempSchizoCheckRecord.PhysicalDisease=PhysicalDisease
	s tempSchizoCheckRecord.LaboratoryExamination=LaboratoryExamination
	i ComplyDoctor '= "" d
	.s ComplyDoctorobj=##class(CHSS.DictComplyDoctor).%OpenId(ComplyDoctor)
	.s tempSchizoCheckRecord.ComplyDoctor=ComplyDoctorobj

	i DoseComplier '= "" d
	.s DoseComplierobj=##class(CHSS.DictDrugRegularityRate).%OpenId(DoseComplier)
	.s tempSchizoCheckRecord.DoseComplier=DoseComplierobj


 
	s tempSchizoCheckRecord.bAdverseEffects=bAdverseEffects
	s tempSchizoCheckRecord.DrugOfAdverseEffects=DrugOfAdverseEffects
	i EvaluationCategory '= "" d
	.s EvaluationCategoryobj=##class(CHSS.DictEvaluationCategory).%OpenId(EvaluationCategory)
	.s tempSchizoCheckRecord.EvaluationCategory=EvaluationCategoryobj
	s tempSchizoCheckRecord.RehabilitationMeasure=RehabilitationMeasure
	s tempSchizoCheckRecord.bTransfer=bTransfer
	s tempSchizoCheckRecord.TransferHospital=TransferHospital
	s tempSchizoCheckRecord.AdvisoryOpinion=AdvisoryOpinion
	s tempSchizoCheckRecord.StaffInput=StaffInput
	i DateOfInput'="" d
	.s DateOfInput=$zdh(DateOfInput,3)
	.s tempSchizoCheckRecord.DateOfInput=DateOfInput
	i DateOfUpdate'="" d
	.s DateOfUpdate=$zdh(DateOfUpdate,3)
	.s tempSchizoCheckRecord.DateOfUpdate=DateOfUpdate
	i DateOfNextCheck'="" d
	.s DateOfNextCheck=$zdh(DateOfNextCheck,3)
	.s tempSchizoCheckRecord.DateOfNextCheck=DateOfNextCheck
	s tempSchizoCheckRecord.TransferReason=TransferReason
    s tempSchizoCheckRecord.bBooking= bBooking
	 i StaffInput '="" d
	.;s StaffInputobj=##class(User.SSUser).%OpenId(StaffInput)
	.;s tempSchizoCheckRecord.StaffInput=StaffInputobj
 
 	i CureEffect '= "" d
	.s CureEffectobj=##class(CHSS.DictCureEffect).%OpenId(CureEffect)
	.s tempSchizoCheckRecord.CureEffect=CureEffectobj
 
 
	
	s result=tempSchizoCheckRecord.%Save()
      i result = "1" d
      .w "{""success"":""true"",""info"":"_RowId_"}"
      .//d ##class(CHSSWeb.PersonBookingCheckService).Insert(PersonRowIdParref, 1,RowId, BookingStr, 0)
      e  d
      .w "{""success"":""false"",""info"":""数据保存出错!""}"
      q ""
}

ClassMethod existPersonRowId(PersonRowId) As %String
{
	q:PersonRowId="" "-1"
	q:$d(^CHSS.SchizoCheckRecordI("PersonRowIdIndex",PersonRowId)) "1"
	q "0"
}

ClassMethod delete(RowId, PersonRowId) As %String
{
	&sql(delete from CHSS.SchizoCheckRecord where %ID=:RowId)
	//d ##class(CHSSWeb.PersonBookingCheckService).DeleteBooking(PersonRowIdParref, 1,RowId)

	q SQLCODE
}

Storage Default
{
<Data name="SchizoCheckRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.SchizoCheckR97ED</DataLocation>
<DefaultData>SchizoCheckRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.SchizoCheckR97ED</IdLocation>
<IndexLocation>^CHSSWeb.SchizoCheckR97EI</IndexLocation>
<StreamLocation>^CHSSWeb.SchizoCheckR97ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
