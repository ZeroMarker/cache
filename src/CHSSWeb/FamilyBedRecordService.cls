Class CHSSWeb.FamilyBedRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(Start, Limit, CommunityCode) As %String
{
	s result=##class(%Library.ResultSet).%New()
	s sqlStr="select *from CHSS.FamilyBedRecord where BedStatus=0"
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=Start+Limit
	s json=##class(Code.JsonObj).%New()
	
	while(result.Next())
	{
		s FaBedRowId=result.Data("FaBedRowId")
		s temp=##class(CHSS.FamilyBedRecord).%OpenId(FaBedRowId)
		s PersonRowId=""
		s PCommunityCode=""
		i temp.PersonRowId '="" d
		.s PersonRowId=temp.PersonRowId.%Id()
		.s PCommunityCode=temp.PersonRowId.CommunityCode
		continue:(CommunityCode'=PCommunityCode)
		
		s DateOfRecord=result.Data("DateOfRecord")
		i DateOfRecord '="" d
		.s DateOfRecord=$zd(DateOfRecord,3)
		
		s SexDR=""
		s SexDRName=""
		i temp.SexDR '="" d
		.s SexDR=temp.SexDR.%Id()
		.s SexDRName=temp.SexDR.CTSEXDesc
		
		s PersonName=result.Data("PersonName")
		
		s Birth=result.Data("Birth")
		i Birth '="" d
		.s Birth=$zd(Birth,3)
		
		s Address=result.Data("Address")
		s PatientPhone=result.Data("PatientPhone")
		s LinkManName=result.Data("LinkManName")
		s LinkManPhone=result.Data("LinkManPhone")
		
		s BedCreateDate=result.Data("BedCreateDate")
		i BedCreateDate '="" d
		.s BedCreateDate=$zd(BedCreateDate,3)
		
		s BedCreateReason=result.Data("BedCreateReason")
		s Symptom=result.Data("Symptom")
		s BedStatus=result.Data("BedStatus")
		
		s FaBedType=""
		s FaBedTypeName=""
		i temp.FaBedType '="" d
		.s FaBedType=temp.FaBedType.%Id()
		.s FaBedTypeName=temp.FaBedType.Description
		
		s Doctor=result.Data("Doctor")
		s Nurse=result.Data("Nurse")
		s Register=result.Data("Register")
		
		s tmp=FaBedRowId_"^"_PersonRowId_"^"_DateOfRecord_"^"_SexDR_"^"_SexDRName_"^"_PersonName_"^"_Birth_"^"_Address_"^"_PatientPhone_"^"_LinkManName_"^"_LinkManPhone_"^"_BedCreateDate_"^"_BedCreateReason_"^"_Symptom_"^"_BedStatus_"^"_FaBedType_"^"_FaBedTypeName_"^"_Doctor_"^"_Nurse_"^"_Register
		s count=count+1
        i (count>Start)&(count<=end) d
	    .d json.InsertRowData(tmp)
	  }
	d result.Close()
	s resultString = json.getJsonData("FaBedRowId^PersonRowId^DateOfRecord^SexDR^SexDRName^PersonName^Birth^Address^PatientPhone^LinkManName^LinkManPhone^BedCreateDate^BedCreateReason^Symptom^BedStatus^FaBedType^FaBedTypeName^Doctor^Nurse^Register",count)
	k json
	q resultString
}

ClassMethod Search(Start, Limit, DateOfStart, DateOfEnd, CommunityCode) As %String
{

	
	s result=##class(%Library.ResultSet).%New()
	s sqlStr=""
    i DateOfStart'="" d
	 .s DateOfStart=$zdh(DateOfStart,3)
	i DateOfEnd'="" d
	 .s DateOfEnd=$zdh(DateOfEnd,3)
	 
	 
	i (DateOfStart ="") && (DateOfEnd ="") d
	.s sqlStr="select *from CHSS.FamilyBedRecord where BedStatus=0 "
	
	i (DateOfStart '="") && (DateOfEnd '="") d
	.s sqlStr="select *from CHSS.FamilyBedRecord where BedStatus=0 and BedCreateDate between "_DateOfStart_" and "_DateOfEnd
	
	i (DateOfStart '="") && (DateOfEnd="") d
	.s sqlStr="select *from CHSS.FamilyBedRecord where BedStatus=0 and BedCreateDatef >="_DateOfStart
	
	i (DateOfStart ="") && (DateOfEnd '="") d
	.s sqlStr="select *from CHSS.FamilyBedRecord where BedStatus=0 and BedCreateDatef <="_DateOfEnd
	
    d result.Prepare(sqlStr)
	d result.Execute()

	s count=0
	s resultString=""
	s end=Start+Limit
	s json=##class(Code.JsonObj).%New()
	
	while(result.Next())
	{
		s FaBedRowId=result.Data("FaBedRowId")
		s temp=##class(CHSS.FamilyBedRecord).%OpenId(FaBedRowId)
		s PersonRowId=""
		s PCommunityCode=""
		i temp.PersonRowId '="" d
		.s PersonRowId=temp.PersonRowId.%Id()
		.s PCommunityCode=temp.PersonRowId.CommunityCode
		continue:(CommunityCode'=PCommunityCode)
		
		s DateOfRecord=result.Data("DateOfRecord")
		i DateOfRecord '="" d
		.s DateOfRecord=$zd(DateOfRecord,3)
		
		s SexDR=""
		s SexDRName=""
		i temp.SexDR '="" d
		.s SexDR=temp.SexDR.%Id()
		.s SexDRName=temp.SexDR.CTSEXDesc
		
		s PersonName=result.Data("PersonName")
		
		s Birth=result.Data("Birth")
		i Birth '="" d
		.s Birth=$zd(Birth,3)
		
		s Address=result.Data("Address")
		s PatientPhone=result.Data("PatientPhone")
		s LinkManName=result.Data("LinkManName")
		s LinkManPhone=result.Data("LinkManPhone")
		
		s BedCreateDate=result.Data("BedCreateDate")
		i BedCreateDate '="" d
		.s BedCreateDate=$zd(BedCreateDate,3)
		
		s BedCreateReason=result.Data("BedCreateReason")
		s Symptom=result.Data("Symptom")
		s BedStatus=result.Data("BedStatus")
		
		s FaBedType=""
		s FaBedTypeName=""
		i temp.FaBedType '="" d
		.s FaBedType=temp.FaBedType.%Id()
		.s FaBedTypeName=temp.FaBedType.Description
		
		s Doctor=result.Data("Doctor")
		s Nurse=result.Data("Nurse")
		s Register=result.Data("Register")
		
		s tmp=FaBedRowId_"^"_PersonRowId_"^"_DateOfRecord_"^"_SexDR_"^"_SexDRName_"^"_PersonName_"^"_Birth_"^"_Address_"^"_PatientPhone_"^"_LinkManName_"^"_LinkManPhone_"^"_BedCreateDate_"^"_BedCreateReason_"^"_Symptom_"^"_BedStatus_"^"_FaBedType_"^"_FaBedTypeName_"^"_Doctor_"^"_Nurse_"^"_Register
		s count=count+1
        i (count>Start)&(count<=end) d
	    .d json.InsertRowData(tmp)
	  }
	d result.Close()
	s resultString = json.getJsonData("FaBedRowId^PersonRowId^DateOfRecord^SexDR^SexDRName^PersonName^Birth^Address^PatientPhone^LinkManName^LinkManPhone^BedCreateDate^BedCreateReason^Symptom^BedStatus^FaBedType^FaBedTypeName^Doctor^Nurse^Register",count)
	k json
	q resultString
}

ClassMethod Insert(PersonRowId, DateOfRecord, SexDR, PersonName, Birth, Address, PatientPhone, LinkManName, LinkManPhone, BedCreateDate, BedCreateReason, Symptom, BedStatus, FaBedType, Doctor, Nurse, Register) As %String
{
    s temp=""
	s temp=##class(CHSS.FamilyBedRecord).%New()
	i DateOfRecord '="" d
	.s DateOfRecord=$zdh(DateOfRecord,3)
	i Birth '="" d
	.s Birth=$zdh(Birth,3)
	i BedCreateDate '="" d
	.s BedCreateDate=$zdh(BedCreateDate,3)
	
	i PersonRowId '="" d
	.s temp.PersonRowId=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	
	s temp.DateOfRecord=DateOfRecord
	
	i SexDR '="" d
	.s temp.SexDR=##class(User.CTSex).%OpenId(SexDR)
	
	s temp.PersonName=PersonName
	s temp.Birth=Birth
	s temp.Address=Address
	s temp.PatientPhone=PatientPhone
	s temp.LinkManName=LinkManName
	s temp.LinkManPhone=LinkManPhone
	s temp.BedCreateDate=BedCreateDate
	s temp.BedCreateReason=BedCreateReason
	s temp.Symptom=Symptom
	s temp.BedStatus=BedStatus
	
	i FaBedType '="" d
	.s temp.FaBedType=##class(CHSS.DictFaBedType).%OpenId(FaBedType)
	
	s temp.Doctor=Doctor
	s temp.Nurse=Nurse
	s temp.Register=Register
	
	s result=""
    s result=temp.%Save()
    Set resultString = ""
    i result = "1" d
   .s resultString = "{""success"":""true"",""info"":"_temp.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod Update(FaBedRowId, PersonRowId, DateOfRecord, SexDR, PersonName, Birth, Address, PatientPhone, LinkManName, LinkManPhone, BedCreateDate, BedCreateReason, Symptom, BedStatus, FaBedType, Doctor, Nurse, Register) As %String
{
	s temp=""
	s temp=##class(CHSS.FamilyBedRecord).%OpenId(FaBedRowId) 
	
    i DateOfRecord '="" d
	.s DateOfRecord=$zdh(DateOfRecord,3)
	i Birth '="" d
	.s Birth=$zdh(Birth,3)
	i BedCreateDate '="" d
	.s BedCreateDate=$zdh(BedCreateDate,3)
	
	i PersonRowId '="" d
	.s temp.PersonRowId=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	
	s temp.DateOfRecord=DateOfRecord
	
	i SexDR '="" d
	.s temp.SexDR=##class(User.CTSex).%OpenId(SexDR)
	
	i PersonName '="" d
	.s temp.PersonName=PersonName
    s temp.Birth=Birth
	i Address '="" d
	.s temp.Address=Address
	
	
	i PatientPhone '="" d
	.s temp.PatientPhone=PatientPhone
	.&sql(update CHSS.PersonHealthRecordOther set WorkPlacePhone=:PatientPhone where PersonRowIdParref=:PersonRowId)

	
	i LinkManName '="" d
	.s temp.LinkManName=LinkManName
	.s temp.PersonRowId.LinkManName=LinkManName
	
	i LinkManPhone '="" d
	.s temp.LinkManPhone=LinkManPhone
	.s temp.PersonRowId.LinkManPhone=LinkManPhone 
	
	s temp.BedCreateDate=BedCreateDate
	i BedCreateReason '="" d
	.s temp.BedCreateReason=BedCreateReason
	i Symptom '="" d
	.s temp.Symptom=Symptom
	i BedStatus '="" d
	.s temp.BedStatus=BedStatus
	
	i FaBedType '="" d
	.s temp.FaBedType=##class(CHSS.DictFaBedType).%OpenId(FaBedType)
	
	i Doctor '="" d
	.s temp.Doctor=Doctor
	i Nurse '="" d
	.s temp.Nurse=Nurse
	i Register '="" d
	.s temp.Register=Register
	
	s result=""
    s result=temp.%Save()
    Set resultString = ""
    i result = "1" d
   .s resultString = "{""success"":""true"",""info"":"_temp.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod Delete(FaBedRowId) As %String
{
	s temp =##class(CHSS.FamilyBedRecord).%OpenId(FaBedRowId)
	s result=temp.%DeleteId(FaBedRowId)
    i result="1" d
	. s resultString="{""success"":""true"",""info"":""数据删除成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
    q resultString
}

ClassMethod ListPPhone(Start, Limit, PersonRowId) As %String
{
	s temp=""
	s result=""
	s result=##class(%Library.ResultSet).%New()
	s sqlStr="select * from CHSS.PersonHealthRecordOther where PersonRowIdParref="_PersonRowId
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=Start+Limit
	s json=##class(Code.JsonObj).%New()
	while(result.Next())
	{
		s PersonOtherRowId=result.Data("PersonOtherRowId")
		s WorkPlacePhone=result.Data("WorkPlacePhone")
	    s tmp=PersonOtherRowId_"^"_WorkPlacePhone
		s count=count+1
        i (count>Start)&(count<=end) d
	    .d json.InsertRowData(tmp)
		
	}
	d result.Close()
	s resultString = json.getJsonData("PersonOtherRowId^WorkPlacePhone",count)
	k json
	q resultString
}

ClassMethod Quash(FaBedRowId) As %String
{
   	
	&sql(update CHSS.FamilyBedRecord set BedStatus=1 where FaBedRowId=:FaBedRowId)
	
    if SQLCODE=0 d
	. s resultString="{""success"":""true"",""info"":""撤床成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""撤床出错!""}"
    q resultString
}

Storage Default
{
<Data name="FamilyBedRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.FamilyBedRec89DD</DataLocation>
<DefaultData>FamilyBedRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.FamilyBedRec89DD</IdLocation>
<IndexLocation>^CHSSWeb.FamilyBedRec89DI</IndexLocation>
<StreamLocation>^CHSSWeb.FamilyBedRec89DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
