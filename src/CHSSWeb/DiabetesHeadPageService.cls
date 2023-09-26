Class CHSSWeb.DiabetesHeadPageService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod DiabetesHeadPageList(PersonRowId As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
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
		For  Set MainPageRowId=$O(^CHSS.DiabetesHeadPageI("PersonRowIdIndex",PersonRowId,MainPageRowId)) q:MainPageRowId=""  d
		.s tempDiabetesHeadPage=##class(CHSS.DiabetesHeadPage).%OpenId(MainPageRowId)
		.set DiseaseType = tempDiabetesHeadPage.DiseaseType
		.s DiagnoseDate = tempDiabetesHeadPage.DiagnoseDate
	    .i DiagnoseDate '= "" d
		..s DiagnoseDate=$zd(DiagnoseDate,3)
		.set BloodSurgeLimosis = tempDiabetesHeadPage.BloodSurgeLimosis
		.set BloodAfterDiningOfTwo = tempDiabetesHeadPage.BloodAfterDiningOfTwo
		.set BloodAfterDining = tempDiabetesHeadPage.BloodAfterDining
		.set CaseSource = tempDiabetesHeadPage.CaseSource
		.set UniteIll = tempDiabetesHeadPage.UniteIll
		.set DiseaseHistory = ""
		.set DiseaseHistoryName = ""
		.i tempDiabetesHeadPage.DiseaseHistory '= "" d
		..set DiseaseHistoryName = tempDiabetesHeadPage.DiseaseHistory.Description
		..set DiseaseHistory = tempDiabetesHeadPage.DiseaseHistory.%Id()
		.set CheckDoctor = tempDiabetesHeadPage.CheckDoctor
		.s DateCheck = tempDiabetesHeadPage.DateCheck
	    .i DateCheck '= "" d
		..s DateCheck=$zd(DateCheck,3)  
		.set CheckType = ""
		.set CheckTypeName = ""
		.i tempDiabetesHeadPage.CheckType '= "" d
		..set CheckTypeName = tempDiabetesHeadPage.CheckType.Description
		..set CheckType = tempDiabetesHeadPage.CheckType.%Id()
		.set CheckAdd = tempDiabetesHeadPage.CheckAdd
		.s DateOfInput = tempDiabetesHeadPage.DateOfInput
	    .i DateOfInput '= "" d
		..s DateOfInput=$zd(DateOfInput,3)   
		.s DateOfUpdate = tempDiabetesHeadPage.DateOfUpdate
	    .i DateOfUpdate '= "" d
		..s DateOfUpdate=$zd(DateOfUpdate,3)
		.Set tmp= MainPageRowId_"^"_DiseaseType_"^"_DiagnoseDate_"^"_BloodSurgeLimosis_"^"_BloodAfterDiningOfTwo_"^"_BloodAfterDining_"^"_CaseSource_"^"_DiseaseHistory_"^"_DiseaseHistoryName_"^"_CheckDoctor_"^"_DateCheck_"^"_CheckType_"^"_CheckTypeName_"^"_CheckAdd_"^"_DateOfInput_"^"_DateOfUpdate_"^"_UniteIll
	    .Set count=count+1
	    .If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("MainPageRowId^DiseaseType^DiagnoseDate^BloodSurgeLimosis^BloodAfterDiningOfTwo^BloodAfterDining^CaseSource^DiseaseHistory^DiseaseHistoryName^CheckDoctor^DateCheck^CheckType^CheckTypeName^CheckAdd^DateOfInput^DateOfUpdate^UniteIll",count)
	 	k json
		Quit resultString
}

ClassMethod Insert(MainPageRowId As %Integer, PersonRowId As %Integer, DiseaseType As %String, DiagnoseDate As %Date, BloodSurgeLimosis As %String, BloodAfterDiningOfTwo As %String, BloodAfterDining As %String, CaseSource As %String, DiseaseHistory As %Integer, CheckDoctor As %String, DateCheck As %Date, CheckType As %Integer, CheckAdd As %String, StaffInput As %Integer, DateOfInput As %Date, DateOfUpdate As %Date, UniteIll As %String) As %String
{
    s result =""
	s tempDiabetesHeadPage=""
	s ReturnCode=..existPersonRowId(PersonRowId)
	i (ReturnCode'="0") d
	.q:($d(PersonRowId)=0)||(PersonRowId="")
	.s tempDiabetesHeadPage=##class(CHSS.DiabetesHeadPage).%OpenId(MainPageRowId)
	e  d
	.s tempDiabetesHeadPage=##class(CHSS.DiabetesHeadPage).%New()
	 i PersonRowId '="" d
    .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    .s tempDiabetesHeadPage.PersonRowId=PersonRowIdobj
     s tempDiabetesHeadPage.DiseaseType= DiseaseType
	 i DiagnoseDate '="" d
	.s DiagnoseDate=$zdh(DiagnoseDate,3)
	.s tempDiabetesHeadPage.DiagnoseDate=DiagnoseDate 
	 s tempDiabetesHeadPage.BloodSurgeLimosis= BloodSurgeLimosis
	 s tempDiabetesHeadPage.BloodAfterDiningOfTwo= BloodAfterDiningOfTwo
	 s tempDiabetesHeadPage.BloodAfterDining= BloodAfterDining
	 s tempDiabetesHeadPage.CaseSource= CaseSource
	 i DiseaseHistory '= "" d
	.s DiseaseHistoryobj=##class(CHSS.DictDiseaseHistory).%OpenId(DiseaseHistory)
	.s tempDiabetesHeadPage.DiseaseHistory=DiseaseHistoryobj
	 s tempDiabetesHeadPage.CheckDoctor= CheckDoctor
	 i DateCheck '="" d
	.s DateCheck=$zdh(DateCheck,3)
	.s tempDiabetesHeadPage.DateCheck=DateCheck 
	 i CheckType '= "" d
	.s CheckTypeobj=##class(CHSS.DictCheckType).%OpenId(CheckType)
	.s tempDiabetesHeadPage.CheckType=CheckTypeobj
	 s tempDiabetesHeadPage.CheckAdd= CheckAdd
	 i StaffInput '="" d
	.s StaffInputobj=##class(User.SSUser).%OpenId(StaffInput)
	.s tempDiabetesHeadPage.StaffInput=StaffInputobj
	 i DateOfInput '="" d
	.s DateOfInput=$zdh(DateOfInput,3)
	.s tempDiabetesHeadPage.DateOfInput=DateOfInput
	 i DateOfUpdate '="" d
	.s DateOfUpdate=$zdh(DateOfUpdate,3)
	.s tempDiabetesHeadPage.DateOfUpdate=DateOfUpdate
	 s tempDiabetesHeadPage.UniteIll= UniteIll
	 s result=tempDiabetesHeadPage.%Save()
    i result = "1" d
    .w "{""success"":""true"",""info"":"_tempDiabetesHeadPage.%Id()_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    
    q ""
}

/// 添加
ClassMethod existPersonRowId(PersonRowId) As %String
{
	q:PersonRowId="" "-1"
	q:$d(^CHSS.DiabetesHeadPageI("PersonRowIdIndex",PersonRowId)) "1"
	q "0"
}

ClassMethod delete(RowId) As %String
{
	&sql(delete from CHSS.DiabetesHeadPage where %ID=:RowId)
	q SQLCODE
}

Storage Default
{
<Data name="DiabetesHeadPageServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DiabetesHead8E1D</DataLocation>
<DefaultData>DiabetesHeadPageServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.DiabetesHead8E1D</IdLocation>
<IndexLocation>^CHSSWeb.DiabetesHead8E1I</IndexLocation>
<StreamLocation>^CHSSWeb.DiabetesHead8E1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
