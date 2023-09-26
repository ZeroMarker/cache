Class CHSSWeb.ChildWeakRegisteService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(Start, Limit, CommunityCode)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = " select a.*,c.PersonRowId,c.PersonName,c.SexDR,c.IDCard,c.Address,c.LinkManPhone,c.CommunityCode from CHSS.ChildWeakRegister a  join CHSS.PersonHealthRecordMain c on c.PersonRowId = a.PersonRowId where c.CommunityCode='"_CommunityCode_"'"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
		
		s RegisterRowId = result.Data("RegisterRowId")
		
		s CaseStartDate = result.Data("CaseStartDate")
		i CaseStartDate '= "" d
		.s CaseStartDate = $zd(CaseStartDate,3)
		
		s CaseEndDate = result.Data("CaseEndDate")
		i CaseEndDate '= "" d
		.s CaseEndDate = $zd(CaseEndDate,3)
		
		s VisistDate = result.Data("VisistDate")
		i VisistDate '= "" d
		.s VisistDate = $zd(VisistDate,3)
		
		s BookingDate = result.Data("BookingDate")
		i BookingDate '= "" d
		.s BookingDate = $zd(BookingDate,3)
		
		s VestingDate = result.Data("VestingDate")
		i VestingDate '= "" d
		.s VestingDate = $zd(VestingDate,3)
		
		s MainSymptom = result.Data("MainSymptom")
		s MainSigns = result.Data("MainSigns")
		s Register = result.Data("Register")
		
		s RegisteDate = result.Data("RegisteDate")
		i RegisteDate '= "" d
		.s RegisteDate=$zd(RegisteDate,3)
		
		s BirthInfo = result.Data("BirthInfo")
		s Diagnose = result.Data("Diagnose")
		
		s GuideDate = result.Data("GuideDate")
		i GuideDate '= "" d
		.s GuideDate=$zd(GuideDate,3)
		
		s Remark = result.Data("Remark")
		s PersonRowId = result.Data("PersonRowId")
		s PersonName = result.Data("PersonName")
		s bNormal=result.Data("bNormal")
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
		s ChildDiseaseName = "体弱"
		s CommunityCode = result.Data("CommunityCode")
		
		s tmp=RegisterRowId_"^"_CaseStartDate_"^"_CaseEndDate_"^"_VisistDate_"^"_BookingDate_"^"_VestingDate_"^"_MainSymptom_"^"_MainSigns_"^"_Register_"^"_RegisteDate_"^"_BirthInfo_"^"_Diagnose_"^"_GuideDate_"^"_Remark_"^"_PersonRowId_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_IDCard_"^"_Address_"^"_LinkManPhone_"^"_ChildDiseaseName_"^"_CommunityCode_"^"_bNormal
		s count = count+1
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RegisterRowId^CaseStartDate^CaseEndDate^VisistDate^BookingDate^VestingDate^MainSymptom^MainSigns^Register^RegisteDate^BirthInfo^Diagnose^GuideDate^Remark^PersonRowId^PersonName^SexDR^SexName^IDCard^Address^LinkManPhone^ChildDiseaseName^CommunityCode^bNormal",count)
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
	.s RowId=$O(^CHSS.ChildWeakRegisterI("PersonRowIdIndex",PersonRowId,RowId)) q:RowId=""  d
	.s tempChild=##class(CHSS.ChildWeakRegister).%OpenId(RowId)
	e  d
	.s tempChild =##class(CHSS.ChildWeakRegister).%New()
	
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
	q:$d(^CHSS.ChildWeakRegisterI("PersonRowIdIndex",PersonRowId)) "1"
    q "0"
}

ClassMethod listrecord(Start, Limit, RegisterRowId)
{
	q:($d(RegisterRowId)=0)||(RegisterRowId="")
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = " select RowId from  CHSS.ChildWeakCheck where RegisterRowId="_RegisterRowId
   
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
		
		s RowId = result.Data("RowId")
		
		s tempRecord=##class(CHSS.ChildWeakCheck).%OpenId(RowId)
		
		s RegisterRowId=""
	    i tempRecord.RegisterRowId'="" d
	    .s RegisterRowId=tempRecord.RegisterRowId.%Id()
		
 
		
		s Checker=tempRecord.Checker
		
		s CheckDate=tempRecord.CheckDate
		
		i CheckDate'="" d
		
		.s CheckDate=$zd(CheckDate,3)
		
		s BodyCheck=tempRecord.BodyCheck
		
		s CureInfo=tempRecord.CureInfo
		
		
		s Remark=tempRecord.Remark
		
		s bNormal=tempRecord.bNormal
		s tmp=RowId_"^"_RegisterRowId_"^"_Checker_"^"_CheckDate_"^"_BodyCheck_"^"_CureInfo_"^"_Remark_"^"_bNormal
		s count = count+1
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^RegisterRowId^Checker^CheckDate^BodyCheck^CureInfo^Remark^bNormal",count)
	k json
	q resultString
}

ClassMethod Edit(RegisterRowId, PersonRowId, CaseStartDate, CaseEndDate, VisistDate, BookingDate, VestingDate, MainSymptom, MainSigns, Register, RegisteDate, BirthInfo, Diagnose, GuideDate, Remark, bNormal)
{
	q:($d(RegisterRowId)=0)||(RegisterRowId="")
	 Set $ZT   ="ERROR"
	 TSTART
     s tempChild="",result=""
     s tempChild=##class(CHSS.ChildWeakRegister).%OpenId(RegisterRowId)
     q:(tempChild="") 0	
     
      i PersonRowId '= "" d
	.s tempChild.PersonRowId = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	
	i CaseStartDate'="" d
	.s CaseStartDate=$zdh(CaseStartDate,3)
	.s tempChild.CaseStartDate=CaseStartDate
	
	i CaseEndDate'="" d
	.s CaseEndDate=$zdh(CaseEndDate,3)
	.s tempChild.CaseEndDate=CaseEndDate
	
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
	
	s tempChild.BirthInfo=BirthInfo
	s tempChild.Diagnose=Diagnose
	
	i GuideDate'="" d
	.s GuideDate=$zdh(GuideDate,3)
	.s tempChild.GuideDate=GuideDate
	
	s tempChild.Remark=Remark
	s tempChild.bNormal=bNormal
	 s result=""
	
    s result=tempChild.%Save()
    
    Set resultString = ""
    i result = "1" d
 
    .i bNormal="true" d
    ..s updateResult=..updateChildDisease(PersonRowId)
    ..i updateResult=1 d
    ...TCommit
    ...s resultString = "{""success"":""true"",""info"":""数据保存成功!""}" 
    ..e  d
    ...TRollback
    ...s resultString = "{""success"":""false"",""info"":""数据保存出错!""}" 
    .e  d
    ..TCommit
    ..s resultString = "{""success"":""true"",""info"":""数据保存成功!""}" 
    e  d
    .TRollback
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
ERROR
     TRollback
     s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
     q resultString
}

//判断是否转正常，修改儿童基本信息的  儿童患病情况

ClassMethod updateChildDisease(persobrowid)
{
	    s updateResult=""
	    s Result = ##class(%Library.ResultSet).%New()
		s sql = "SELECT ChildRowid FROM CHSS.ChildBaseInfo where personrowid ="_persobrowid
		
		d Result.Prepare(sql)
		d Result.Execute()
		s tempChildBaseInfo=""
		while(Result.Next())
		{
			s ChildRowid = Result.Data("ChildRowId")
			s tempChildBaseInfo=##class(CHSS.ChildBaseInfo).%OpenId(ChildRowid)
			s childDisease = tempChildBaseInfo.ChildDisease
			 
			s tempChildBaseInfo.ChildDisease=$Translate(childDisease,"体弱","")
			 
			s updateResult=tempChildBaseInfo.%Save()

		}
		d Result.Close() 
		q updateResult
}

Storage Default
{
<Data name="ChildWeakRegisteServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChildWeakReg910D</DataLocation>
<DefaultData>ChildWeakRegisteServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChildWeakReg910D</IdLocation>
<IndexLocation>^CHSSWeb.ChildWeakReg910I</IndexLocation>
<StreamLocation>^CHSSWeb.ChildWeakReg910S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
