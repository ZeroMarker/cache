Class CHSSWeb.HBPHeadPageService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod HBPHeadPageList(PersonRowId As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
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
		Set HeadPageRowId = 0
		For  Set HeadPageRowId=$O(^CHSS.HBPHeadPageI("PersonRowIdIndex",PersonRowId,HeadPageRowId)) q:HeadPageRowId=""  d
		.s tempHBPHeadPage=##class(CHSS.HBPHeadPage).%OpenId(HeadPageRowId)
		.s Intime = tempHBPHeadPage.Intime
	    .i Intime '= "" d
		..s Intime=$zd(Intime,3)
		.set Doctor = ""
		.set DoctorName = ""
		.i tempHBPHeadPage.Doctor '= "" d
		..set DoctorName = tempHBPHeadPage.Doctor
		..set Doctor = tempHBPHeadPage.Doctor
		.set Nurse = ""
		.set NurseName = ""
		.i tempHBPHeadPage.Nurse '= "" d
		..set Nurse = tempHBPHeadPage.Nurse.%Id()
		..set NurseName = tempHBPHeadPage.Nurse.SSUSRName
		.s DateOfInput = tempHBPHeadPage.DateOfInput
	    .i DateOfInput '= "" d
		..s DateOfInput=$zd(DateOfInput,3)
		.s DateOfCheck = tempHBPHeadPage.DateOfCheck
	    .i DateOfCheck '= "" d
		..s DateOfCheck=$zd(DateOfCheck,3)
		.set Checker = tempHBPHeadPage.Checker
		.s DateOfUpdate = tempHBPHeadPage.DateOfUpdate  
	    .i DateOfUpdate '= "" d
		..s DateOfUpdate=$zd(DateOfUpdate,3)
		.set DiagnoseUnit = tempHBPHeadPage.DiagnoseUnit
		.set SmokeInfo = tempHBPHeadPage.SmokeInfo
		.set DrinkInfo = tempHBPHeadPage.DrinkInfo
		.set CheckOutWay = tempHBPHeadPage.CheckOutWay
		.set Mof =tempHBPHeadPage.Mof
		.set GymInfo = tempHBPHeadPage.GymInfo
		.set DiseaseHistory = tempHBPHeadPage.DiseaseHistory
		.set Weight = tempHBPHeadPage.Weight
		.set High = tempHBPHeadPage.High
		.set BMI = tempHBPHeadPage.BMI
		.set DangerousFactor = tempHBPHeadPage.DangerousFactor
		.set HighPressure = tempHBPHeadPage.HighPressure
		.set LowPressure = tempHBPHeadPage.LowPressure
		.set UniteIll = tempHBPHeadPage.UniteIll
		.set SelfCare = ""
		.set SelfCareName = ""
		.i tempHBPHeadPage.SelfCare '= "" d
		..set SelfCareName = tempHBPHeadPage.SelfCare.Description
		..set SelfCare = tempHBPHeadPage.SelfCare.%Id()
		.set CaseDiscuss = tempHBPHeadPage.CaseDiscuss
		.set ReasonOfDisc = tempHBPHeadPage.ReasonOfDisc
	    .set ResultOfDisc = tempHBPHeadPage.ResultOfDisc
		.Set tmp= HeadPageRowId_"^"_Intime_"^"_Doctor_"^"_DoctorName_"^"_Nurse_"^"_NurseName_"^"_DateOfInput_"^"_DateOfUpdate_"^"_DiagnoseUnit_"^"_SmokeInfo_"^"_DrinkInfo_"^"_GymInfo_"^"_DiseaseHistory_"^"_Weight_"^"_High_"^"_BMI_"^"_DangerousFactor_"^"_HighPressure_"^"_LowPressure_"^"_UniteIll_"^"_SelfCare_"^"_SelfCareName_"^"_CaseDiscuss_"^"_ReasonOfDisc_"^"_ResultOfDisc_"^"_CheckOutWay_"^"_Mof_"^"_DateOfCheck_"^"_Checker_"^"_DateOfCheck
	    .Set count=count+1
	    .If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("HeadPageRowId^Intime^Doctor1^DoctorName^Nurse^NurseName^DateOfInput^DateOfUpdate^DiagnoseUnit^SmokeInfo^DrinkInfo^GymInfo^DiseaseHistory^Weight^High^BMI^DangerousFactor^HighPressure^LowPressure^UniteIll^SelfCare^SelfCareName^CaseDiscuss^ReasonOfDisc^ResultOfDisc^CheckOutWay^Mof^DateOfCheck^Checker^DateOfCheck",count)
	 	k json
		Quit resultString
}

ClassMethod Insert(HeadPageRowId As %Integer, PersonRowId As %Integer, Intime As %Date, Doctor As %Integer, Nurse As %Integer, StaffInput As %Integer, DateOfInput As %Date, DateOfUpdate As %Date, DiagnoseUnit As %String, SmokeInfo As %String, DrinkInfo As %String, GymInfo As %String, DiseaseHistory As %String, Weight As %Float, High As %Float, BMI As %Float, DangerousFactor As %String, HighPressure As %Numeric, LowPressure As %Numeric, UniteIll As %String, SelfCare As %Integer, CaseDiscuss As %String, ReasonOfDisc As %String, ResultOfDisc As %String, CheckOutWay As %String, Mof As %String, Checker As %String, DateOfCheck As %Date) As %String
{
    s result =""
	s tempHBPHeadPage=""
	s ReturnCode=..existPersonRowId(PersonRowId)
	i (ReturnCode'="0") d
	.q:($d(PersonRowId)=0)||(PersonRowId="")
	.s tempHBPHeadPage=##class(CHSS.HBPHeadPage).%OpenId(HeadPageRowId)
	e  d
	.s tempHBPHeadPage=##class(CHSS.HBPHeadPage).%New()
	 i PersonRowId '="" d
    .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    .s tempHBPHeadPage.PersonRowId=PersonRowIdobj
      i Intime '="" d
	.s Intime=$zdh(Intime,3)
	.s tempHBPHeadPage.Intime=Intime
     i Doctor '= "" d
	.;s Doctorobj=##class(User.SSUser).%OpenId(Doctor)
	.s tempHBPHeadPage.Doctor=Doctor
	 i Nurse '= "" d
	.;s Nurseobj=##class(User.SSUser).%OpenId(Nurse)
	.;s tempHBPHeadPage.Nurse=Nurseobj
	 i StaffInput '= "" d
	.s StaffInputobj=##class(User.SSUser).%OpenId(StaffInput)
	.s tempHBPHeadPage.StaffInput=StaffInputobj
	 i DateOfInput '="" d
	.s DateOfInput=$zdh(DateOfInput,3)
	.s tempHBPHeadPage.DateOfInput=DateOfInput
	 i DateOfCheck '="" d
	.s DateOfCheck=$zdh(DateOfCheck,3)
	.s tempHBPHeadPage.DateOfCheck=DateOfCheck
	 i DateOfUpdate '="" d
	.s DateOfUpdate=$zdh(DateOfUpdate,3)
	.s tempHBPHeadPage.DateOfUpdate=DateOfUpdate
	 s tempHBPHeadPage.DiagnoseUnit= DiagnoseUnit
	 s tempHBPHeadPage.Checker=Checker
	 s tempHBPHeadPage.SmokeInfo= SmokeInfo
	 s tempHBPHeadPage.DrinkInfo= DrinkInfo
	 s tempHBPHeadPage.GymInfo= GymInfo
	 s tempHBPHeadPage.CheckOutWay = CheckOutWay
	 s tempHBPHeadPage.Mof = Mof
	 s tempHBPHeadPage.DiseaseHistory= DiseaseHistory
	 s tempHBPHeadPage.Weight= Weight
	 s tempHBPHeadPage.High= High

	 i (BMI '= "") && (BMI '= "undefined") d
	 .s tempHBPHeadPage.BMI= BMI
	 s tempHBPHeadPage.DangerousFactor= DangerousFactor
	 s tempHBPHeadPage.HighPressure= HighPressure
	 s tempHBPHeadPage.LowPressure= LowPressure
	 s tempHBPHeadPage.UniteIll= UniteIll
     i SelfCare '= "" d
	.s SelfCareobj=##class(CHSS.DictSelfCare).%OpenId(SelfCare)
	.s tempHBPHeadPage.SelfCare=SelfCareobj
	s tempHBPHeadPage.CaseDiscuss= CaseDiscuss
	s tempHBPHeadPage.ReasonOfDisc= ReasonOfDisc
    s tempHBPHeadPage.ResultOfDisc= ResultOfDisc
	s result=tempHBPHeadPage.%Save()

    i result = "1" d
    .w "{""success"":""true"",""info"":"_tempHBPHeadPage.%Id()_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

/// 添加
ClassMethod existPersonRowId(PersonRowId) As %String
{
	q:PersonRowId="" "-1"
	q:$d(^CHSS.HBPHeadPageI("PersonRowIdIndex",PersonRowId)) "1"
	q "0"
}

ClassMethod delete(RowId) As %String
{
	&sql(delete from CHSS.HBPHeadPage where %ID=:RowId)
	q SQLCODE
}

Storage Default
{
<Data name="HBPHeadPageServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HBPHeadPageServiceD</DataLocation>
<DefaultData>HBPHeadPageServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HBPHeadPageServiceD</IdLocation>
<IndexLocation>^CHSSWeb.HBPHeadPageServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.HBPHeadPageServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
