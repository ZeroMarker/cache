Class CHSSWeb.SchizoHeadPageService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod SchizoHeadPageList(PersonRowId As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
		
		Set PersonRowId=$G(PersonRowId)
		s PersonRowId=PersonRowId
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		Set MainPageRowId = 0
		For  Set MainPageRowId=$O(^CHSS.SchizoHeadPageI("PersonRowIdIndex",26,MainPageRowId)) q:MainPageRowId=""  d
		.s tempSchizoHeadPage=##class(CHSS.SchizoHeadPage).%OpenId(MainPageRowId)
		.set LockInfoRowIDDR = ""
		.set LockInfoRowIDDRName = ""
		.i tempSchizoHeadPage.LockInfoRowIDDR '= "" d
		..set LockInfoRowIDDRName = tempSchizoHeadPage.LockInfoRowIDDR.Description
		..set LockInfoRowIDDR = tempSchizoHeadPage.LockInfoRowIDDR.%Id()
		.set HeadPageCode = tempSchizoHeadPage.HeadPageCode
		.s Intime = tempSchizoHeadPage.Intime
	    .i Intime '= "" d
		..s Intime=$zd(Intime,3)
		.s DateOfInput = tempSchizoHeadPage.DateOfInput
	    .i DateOfInput '= "" d
		..s DateOfInput=$zd(DateOfInput,3)
		.s DateOfUpdate = tempSchizoHeadPage.DateOfUpdate
	    .i DateOfUpdate '= "" d
		..s DateOfUpdate=$zd(DateOfUpdate,3)
		.set GuardianName = tempSchizoHeadPage.GuardianName
		.set Relation = tempSchizoHeadPage.Relation
		.set GuardianAdd = tempSchizoHeadPage.GuardianAdd
		.set GuardianPhone = tempSchizoHeadPage.GuardianPhone
		.set CommitteePhone = tempSchizoHeadPage.CommitteePhone
		.s DateOfFirstOnset = tempSchizoHeadPage.DateOfFirstOnset
	    .i DateOfFirstOnset '= "" d
		..s DateOfFirstOnset=$zd(DateOfFirstOnset,3)
		.set PrimarySymptom = tempSchizoHeadPage.PrimarySymptom
		.set OutPatientDR = ""
		.set OutPatientDRName = ""
		.i tempSchizoHeadPage.OutPatientDR '= "" d
		..set OutPatientDRName = tempSchizoHeadPage.OutPatientDR.Description
		..set OutPatientDR = tempSchizoHeadPage.OutPatientDR.%Id()
		.set InHospitalNum = tempSchizoHeadPage.InHospitalNum
		.set Diagnose = tempSchizoHeadPage.Diagnose
		.set DiagnoseHospital = tempSchizoHeadPage.DiagnoseHospital
		.s DateOfDiagnose = tempSchizoHeadPage.DateOfDiagnose
	    .i DateOfDiagnose '= "" d
		..s DateOfDiagnose=$zd(DateOfDiagnose,3)
		.set LastTreatEffect = ""
		.set LastTreatEffectName = ""
		.i tempSchizoHeadPage.LastTreatEffect '= "" d
		..set LastTreatEffectName = tempSchizoHeadPage.LastTreatEffect.Description
		..set LastTreatEffect = tempSchizoHeadPage.LastTreatEffect.%Id()
		.Set tmp= MainPageRowId_"^"_LockInfoRowIDDR_"^"_LockInfoRowIDDRName_"^"_HeadPageCode_"^"_Intime_"^"_DateOfInput_"^"_DateOfUpdate_"^"_GuardianName_"^"_Relation_"^"_GuardianAdd_"^"_GuardianPhone_"^"_CommitteePhone_"^"_DateOfFirstOnset _"^"_PrimarySymptom_"^"_OutPatientDR_"^"_OutPatientDRName_"^"_InHospitalNum_"^"_Diagnose_"^"_DiagnoseHospital_"^"_DateOfDiagnose_"^"_LastTreatEffect_"^"_LastTreatEffectName
	    .Set count=count+1
	    .If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("MainPageRowId^LockInfoRowIDDR^LockInfoRowIDDRName^HeadPageCode^Intime^DateOfInput^DateOfUpdate^GuardianName^Relation^GuardianAdd^GuardianPhone^CommitteePhone^DateOfFirstOnset^PrimarySymptom^OutPatientDR^OutPatientDRName^InHospitalNum^Diagnose^DiagnoseHospital^DateOfDiagnose^LastTreatEffect^LastTreatEffectName",count)
	 	k json
		Quit resultString
}

ClassMethod Insert(MainPageRowId As %Integer, PersonRowId As %Integer, LockInfoRowIDDR As %Integer, HeadPageCode As %String, Intime As %Date, Doctor As %Integer, StaffInput As %Integer, DateOfInput As %Date, DateOfUpdate As %Date, GuardianName As %String, Relation As %String, GuardianAdd As %String, GuardianPhone As %String, CommitteePhone As %String, DateOfFirstOnset As %Date, PrimarySymptom As %String, OutPatientDR As %Integer, InHospitalNum As %Numeric, Diagnose As %String, DiagnoseHospital As %String, DateOfDiagnose As %Date, LastTreatEffect As %Integer) As %String
{
    s result =""
	s tempSchizoHeadPage=""
	s ReturnCode=..existPersonRowId(PersonRowId)
	i (ReturnCode'="0") d
	.q:($d(PersonRowId)=0)||(PersonRowId="")
	.s tempSchizoHeadPage=##class(CHSS.SchizoHeadPage).%OpenId(MainPageRowId)
	e  d
	.s tempSchizoHeadPage=##class(CHSS.SchizoHeadPage).%New()
	 i PersonRowId '="" d
    .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    .s tempSchizoHeadPage.PersonRowId=PersonRowIdobj
     i LockInfoRowIDDR '= "" d
	.s LockInfoRowIDDRobj=##class(CHSS.DictLockInfo).%OpenId(LockInfoRowIDDR)
	.s tempSchizoHeadPage.LockInfoRowIDDR=LockInfoRowIDDRobj
     s tempSchizoHeadPage.HeadPageCode= HeadPageCode
     s tempSchizoHeadPage.Intime= Intime
	 i Intime '="" d
	.s Intime=$zdh(Intime,3)
	.s tempSchizoHeadPage.Intime=Intime
	 i Doctor '="" d
	.s Doctorobj=##class(User.SSUser).%OpenId(Doctor)
	.s tempSchizoHeadPage.Doctor=Doctorobj
	 i StaffInput '="" d
	.s StaffInputobj=##class(User.SSUser).%OpenId(StaffInput)
	.s tempSchizoHeadPage.StaffInput=StaffInputobj
	 s tempSchizoHeadPage.DateOfInput= DateOfInput
	 i DateOfInput '="" d
	.s DateOfInput=$zdh(DateOfInput,3)
	.s tempSchizoHeadPage.DateOfInput=DateOfInput
	 s tempSchizoHeadPage.DateOfUpdate= DateOfUpdate
	 i DateOfUpdate '="" d
	.s DateOfUpdate=$zdh(DateOfUpdate,3)
	.s tempSchizoHeadPage.DateOfUpdate=DateOfUpdate
	 s tempSchizoHeadPage.GuardianName= GuardianName
	 s tempSchizoHeadPage.Relation= Relation
	 s tempSchizoHeadPage.GuardianAdd= GuardianAdd
	 s tempSchizoHeadPage.GuardianPhone= GuardianPhone
	 s tempSchizoHeadPage.CommitteePhone= CommitteePhone
	 s tempSchizoHeadPage.DateOfFirstOnset= DateOfFirstOnset
	 i DateOfFirstOnset '="" d
	.s DateOfFirstOnset=$zdh(DateOfFirstOnset,3)
	.s tempSchizoHeadPage.DateOfFirstOnset=DateOfFirstOnset
	 s tempSchizoHeadPage.PrimarySymptom= PrimarySymptom
	 i OutPatientDR '= "" d
	.s OutPatientDRobj=##class(CHSS.DictOutPatientDR).%OpenId(OutPatientDR)
	.s tempSchizoHeadPage.OutPatientDR=OutPatientDRobj
	 s tempSchizoHeadPage.InHospitalNum= InHospitalNum
	 s tempSchizoHeadPage.Diagnose= Diagnose
	 s tempSchizoHeadPage.DiagnoseHospital= DiagnoseHospital
	 i DateOfDiagnose '="" d
	.s DateOfDiagnose=$zdh(DateOfDiagnose,3)
	.s tempSchizoHeadPage.DateOfDiagnose=DateOfDiagnose
	 i LastTreatEffect '= "" d
	.s LastTreatEffectobj=##class(CHSS.DictLastTreatEffect).%OpenId(LastTreatEffect)
	.s tempSchizoHeadPage.LastTreatEffect=LastTreatEffectobj
	 s result=tempSchizoHeadPage.%Save()
    i result = "1" d
    .w "{""success"":""true"",""info"":"_tempSchizoHeadPage.%Id()_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    
    q ""
}

/// 添加
ClassMethod existPersonRowId(PersonRowId) As %String
{
	q:PersonRowId="" "-1"
	q:$d(^CHSS.SchizoHeadPageI("PersonRowIdIndex",PersonRowId)) "1"
	q "0"
}

ClassMethod delete(RowId) As %String
{
	&sql(delete from CHSS.SchizoHeadPage where %ID=:RowId)
	q SQLCODE
}

Storage Default
{
<Data name="SchizoHeadPageServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.SchizoHeadPageServiceD</DataLocation>
<DefaultData>SchizoHeadPageServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.SchizoHeadPageServiceD</IdLocation>
<IndexLocation>^CHSSWeb.SchizoHeadPageServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.SchizoHeadPageServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
