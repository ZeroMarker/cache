Class CHSSWeb.ChildUnderNourishedService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(Start, Limit, CommunityCode)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = " select a.*,c.PersonRowId,c.PersonName,c.SexDR,c.IDCard,c.Address,c.LinkManPhone,c.CommunityCode,b.ChildDiseaseName from CHSS.ChildUnderNourished a join CHSS.ChildBaseInfo b on a.PersonRowId=b.PersonRowId join CHSS.PersonHealthRecordMain c on c.PersonRowId = a.PersonRowId where c.CommunityCode='"_CommunityCode_"' and  b.ChildDiseaseName like '%营养不良%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	
	While(result.Next())
	{
		s RegisterRowId = result.Data("RegisterRowId")
		s DiagnoseType = result.Data("DiagnoseType")
		s Hematin = result.Data("Hematin")
		s Evaluate = result.Data("Evaluate")
		s MainSymptom = result.Data("MainSymptom")
		s MainSigns = result.Data("MainSigns")
		
		s VisistDate = result.Data("VisistDate")
		i VisistDate'= "" d
		.s VisistDate = $zd(VisistDate,3)
		
		s BookingDate = result.Data("BookingDate")
		i BookingDate '= "" d
		.s BookingDate = $zd(BookingDate,3)
		
		s VestingDate= result.Data("VestingDate")
		i VestingDate '= "" d
		.s VestingDate = $zd(VestingDate,3)
		
		s Register = result.Data("Register")
		s RegisteDate = result.Data("RegisteDate")
		i RegisteDate '= "" d
		.s RegisteDate = $zd(RegisteDate,3)
		
		s Treatment = result.Data("Treatment")
		s Diagnose = result.Data("Diagnose")
		s GuideDate = result.Data("GuideDate")
		i GuideDate '= "" d
		.s GuideDate = $zd(GuideDate,3)
		
		s Remark = result.Data("Remark")
		s PersonRowId = result.Data("PersonRowId")
		s PersonName = result.Data("PersonName")
		
		s SexDR = result.Data("SexDR")
		s sexResult = ##class(%Library.ResultSet).%New()
		s sql = "SELECT CTSEX_Desc FROM SQLUser.CT_Sex where CTSEX_RowId ="_SexDR
		d sexResult.Prepare(sql)
		d sexResult.Execute()
		
		s jsonSex = ##class(Code.JsonObj).%New()
		while(sexResult.Next())
		{
			s SexName = sexResult.Data("CTSEX_Desc")
		}
		
		s IDCard = result.Data("IDCard")
		s Address = result.Data("Address")
		s LinkManPhone = result.Data("LinkManPhone")
		s ChildDiseaseName = result.Data("ChildDiseaseName")
		s CommunityCode = result.Data("CommunityCode")
		
		s tmp=RegisterRowId_"^"_DiagnoseType_"^"_Hematin_"^"_Evaluate_"^"_MainSymptom_"^"_MainSigns_"^"_VisistDate_"^"_BookingDate_"^"_VestingDate_"^"_Register_"^"_RegisteDate_"^"_Treatment_"^"_Diagnose_"^"_GuideDate_"^"_Remark_"^"_PersonRowId_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_IDCard_"^"_Address_"^"_LinkManPhone_"^"_ChildDiseaseName_"^"_CommunityCode
		s count = count+1
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RegisterRowId^DiagnoseType^Hematin^Evaluate^MainSymptom^MainSigns^VisistDate^BookingDate^VestingDate^Register^RegisteDate^Treatment^Diagnose^GuideDate^Remark^PersonRowId^PersonName^SexDR^SexName^IDCard^Address^LinkManPhone^ChildDiseaseName^CommunityCode",count)
	k json
	q resultString
}

ClassMethod insert(PersonRowId)
{
	s tempChild = ""
	s PersonRowId=PersonRowId
	s returnId=..exitPersonId(PersonRowId)
	s RowId=0
	i returnId '="0" d
	.s RowId=$O(^CHSS.ChildUnderNourishedI("PersonRowIdIndex",PersonRowId,RowId)) q:RowId=""  d
	.s tempChild=##class(CHSS.ChildUnderNourished).%OpenId(RowId)
	e  d
	.s tempChild =##class(CHSS.ChildUnderNourished).%New()
	
	i PersonRowId '= "" d
	.s tempChild.PersonRowId = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	
    s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":""数据保存成功！""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod exitPersonId(PersonRowId)
{
	q:PersonRowId="" "-1"
	s PersonRowId=""_PersonRowId
	q:$d(^CHSS.ChildUnderNourishedI("PersonRowIdIndex",PersonRowId)) "1"
    q "0"
}

ClassMethod Edit(RegisterRowId, PersonRowId, DiagnoseType, Hematin, Evaluate, VisistDate, BookingDate, VestingDate, MainSymptom, MainSigns, Register, RegisteDate, Treatment, Diagnose, GuideDate, Remark)
{
 q:($d(RegisterRowId)=0)||(RegisterRowId="")
      
     s tempChild="",result=""
     s tempChild=##class(CHSS.ChildUnderNourished).%OpenId(RegisterRowId)
     q:(tempChild="") 0	
     
      i PersonRowId '= "" d
	.s tempChild.PersonRowId = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	
	s tempChild.DiagnoseType=DiagnoseType
	s tempChild.Hematin=Hematin
	s tempChild.Evaluate=Evaluate
	
	i VisistDate'="" d
	.s VisistDate=$zdh(VisistDate,3)
	.s tempChild.VisistDate=VisistDate
	
	i BookingDate'="" d
	.s BookingDate=$zdh(BookingDate,3)
	.s tempChild.BookingDate=BookingDate
	
	i VestingDate'="" d
	.s VestingDate=$zdh(VestingDate,3)
	.s tempChild.VestingDate=VestingDate
	
	s tempChild.MainSymptom=MainSymptom
	s tempChild.MainSigns=MainSigns
	s tempChild.Register=Register
	
	i RegisteDate'="" d
	.s RegisteDate=$zdh(RegisteDate,3)
	.s tempChild.RegisteDate=RegisteDate
	
	s tempChild.Treatment=Treatment
	s tempChild.Diagnose=Diagnose
	
	i GuideDate'="" d
	.s GuideDate=$zdh(GuideDate,3)
	.s tempChild.GuideDate=GuideDate
	
	s tempChild.Remark=Remark
	
	 s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":""数据保存成功！""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

Storage Default
{
<Data name="ChildUnderNourishedServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChildUnderNoA64D</DataLocation>
<DefaultData>ChildUnderNourishedServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChildUnderNoA64D</IdLocation>
<IndexLocation>^CHSSWeb.ChildUnderNoA64I</IndexLocation>
<StreamLocation>^CHSSWeb.ChildUnderNoA64S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
