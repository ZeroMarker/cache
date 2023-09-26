Class CHSSWeb.EHRDataImport Extends %Persistent
{

ClassMethod AddFamilyData(HouseHoldName As %String, CommunityCode As %String, FamilyStatus As %String, ProvinceDR As %String, CityDR As %String, SectionDR As %String, StreetDR As %String, VillageDR As %String, DoorPlate As %String, VillageName As %String) As %String
{
	;q "result1"
	;
	;w ##class(CHSSWeb.EHRDataImport).AddFamilyData("testweb","",1,1,1,1,1,1,"30号","成绵")
	;"龙映菊^女^汉^19760403^510703197604032425^涪城区成绵路^^２３号^龙映菊^户主"
	;设置行政区域
	;四川省
	s ProvinceDR = 2
	;绵阳市
	s CityDR = 16
	;
	s SectionDR = 15
	;
	;s StreetDR = 19
	
	;s VillageDR = ..GetVillageRowId(StreetDR,VillageName)
	;q:(VillageDR="") "0"
	s CommunityType = "社区卫生服务中心"
	;"乡镇卫生院"
	s CommunityCode = ..GetCommunityCode(StreetDR,CommunityType)
	q:(CommunityCode="") "0"
	;w CommunityCode
	;q ""
  	
  	;set CurDate = $zd($Horolog,8)
  	s CurDate = $zd($Horolog,3)
  	s DateOfRegister = CurDate
  	s DateOfInput = CurDate
  	;s DateOfRegister = ""
  	;s DateOfInput = ""
  	
  	
	s tempFamily=""
	s tempFamily=##class(CHSS.FamilyHealthRecord).%New()
	q:(tempFamily="") ""
	
	;判断地址是否重复
	s ReturnCode=..existFamilyAddress(0,"add",StreetDR,VillageName,DoorPlate,HouseHoldName)
	;w "Address"_ReturnCode,!
	;q ""
	;i ReturnCode= "" d
	;.s ^tempFamily = ^tempFamily_"^"_HouseHoldName_":existFamilyAddress"
	q:(ReturnCode=1) "result1"

	s result = ""
	
	//绵阳模式
	;s FamilyCode = ##class(CHSSWeb.SystemIdService).GetSystemId(CommunityCode,"FamilyHealthRecord")
	//生成家庭编码 （湖北鄂州模式）
	s FamilyCode = ##class(CHSSWeb.SystemIdService).GetSystemIdWithVillageDR(CommunityCode,VillageName,"FAMILYHEALTHRECORD")
	
	;w "dd"_FamilyCode_"dd"
	;q ""
	;s ReturnCode=..existFamilyCode(FamilyCode)
	i (FamilyCode="") d
	.w "{""success"":""false"",""info"":""家庭编码: "_FamilyCode_" 已存在! 请重新输入!""}"
	e  d
	.
	.s tempFamily.CommunityCode = CommunityCode
	.s tempFamily.FamilyCode=FamilyCode
	

	.i DateOfRegister '= "" d
	..s DateOfRegister=$zdh(DateOfRegister,3)
	.s tempFamily.DateOfRegister=DateOfRegister
	
	.i DateOfInput '= "" d
	..s DateOfInput=$zdh(DateOfInput,3)
	
	.s tempFamily.DateOfInput=DateOfInput
	
	.i ProvinceDR '= "" d
	..s ProvinceDRobj=##class(CHSS.DictProvince).%OpenId(ProvinceDR)
	..s tempFamily.ProvinceDR=ProvinceDRobj
	
	.i CityDR '= "" d
	..s CityDRobj=##class(CHSS.DictCity).%OpenId(CityDR)
	..s tempFamily.CityDR=CityDRobj
	
	.i SectionDR '= "" d
	..s SectionDRobj=##class(CHSS.DictSection).%OpenId(SectionDR)
	..s tempFamily.SectionDR=SectionDRobj
	
	.i StreetDR '= "" d
	..s StreetDRobj=##class(CHSS.DictStreet).%OpenId(StreetDR)
	..s tempFamily.StreetDR=StreetDRobj 
	..
	..
	.;读取村/社区 信息
  	.i VillageDR '="" d
	..;s VillageDRobj=##class(CHSS.DictVillage).%OpenId(VillageDR)
	..;s tempFamily.VillageDR=VillageDRobj
	..;
	.s tempFamily.VillageName = VillageName
	.s tempFamily.HouseHoldName = HouseHoldName	
	.s tempFamily.DoorPlate = DoorPlate
	.s tempFamily.FamilyStatus = 1
	.s tempFamily.CommunityCode = CommunityCode
	.s tempFamily.RegisterType = 1
	.s result=""
    .s result=tempFamily.%Save()
    .i result '= "1" d
    ..;s ^tempFamily = ^tempFamily_"^"_HouseHoldName_":"_result

	q:(result="1") tempFamily.%Id()
	q ""
}

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:添加个人档案基本信息
/// Table：PersonHealthRecordMain
/// Input:PersonHealthRecordMain
/// Output：
/// Return：
/// Others：
ClassMethod AddPersonData(HouseHoldName As %String, CommunityCode As %String, FamilyStatus As %String, ProvinceDR As %String, CityDR As %String, SectionDR As %String, StreetDR As %String, VillageDR As %String, DoorPlate As %String, VillageName As %String, PersonName As %String, SexDR As %String, Birth As %Date, IDCard As %String, Address As %String, AddressTypeDR As %String, RelationHourseHoldDR As %String, PersonStatus As %String, FamilyRowId As %String) As %String
{
	;w ##class(CHSSWeb.EHRDataImport).AddPersonData("testweb","",1,1,1,1,1,1,"30号","成绵","testweb",1,1982-10-01,"51070219480107021X","","","户主",1)
	;PersonName, SexDR, Birth, IDCard , Address , AddressTypeDR,RelationHourseHoldDR, PersonStatus


	;q "result2"
	
	i SexDR '= "" d
	.i SexDR = "男" d
	..s SexDR = 1
	.e  i SexDR = "女" d
	..s SexDR = 2
	
	;设置行政区域
	;四川省
	s ProvinceDR = 2
	;绵阳市
	s CityDR = 16
	;
	s SectionDR = 15
	;
	;s StreetDR = 19
	;读取VillageDR
	;s VillageDR = ..GetVillageRowId(StreetDR,VillageName)
	;q:(VillageDR="") "0"
	s CommunityType = "社区卫生服务中心"
	;"村卫生所","社区卫生服务站"
	s CommunityCode = ..GetCommunityCode(StreetDR,CommunityType)
	q:(CommunityCode="") "0"
	i CommunityCode= "" d
	.s ^tempPerson = ^tempPerson_"^"_PersonName_"GetCommunityCode"
	;w CommunityCode
	;q ""
  	q:(CommunityCode="") "0"
    
    ;s RelationHourseHoldDR = ..GetDictKin(RelationHourseHoldDR)
    ;s ^tempdd = RelationHourseHoldDR

    s IDCardTypeDR = 1
    s PersonStatus = ""
	s FamilyRowId=FamilyRowId
	;..GetFamilyRowId(StreetDR,VillageName,DoorPlate,HouseHoldName)
    ;w FamilyRowId,!
    ;q "result2"
    
  	s CurDate = $zd($Horolog,3)
  	s DateRegister = CurDate
  	s DateInput = CurDate
  	
	s tempPerson=""
	s tempPerson=##class(CHSS.PersonHealthRecordMain).%New()
	q:(tempPerson="") 0
	;s ReturnCode= ##class(CHSSWeb.PHRService).existHouseHold(CommunityCode,FamilyRowId,"add","",RelationHourseHoldDR)
	;i (ReturnCode'="0") d
	;.w "{""success"":""false"",""info"":""每个家庭只允许有一个户主! 请重新选择与户主关系!""}"
	;q:(ReturnCode = "1") ""
	;判断身份证是否重复
	;s ReturnCode=##class(CHSSWeb.PHRService).existColumn("IDCard",IDCard,"add","")
	;i (ReturnCode'="0") d
	;.w "{""success"":""false"",""info"":""证件号码: "_IDCard_" 已存在! 请重新输入!""}"
	;q:(ReturnCode = "1") "result2"

	;s ReturnCode= ##class(CHSSWeb.PHRService).existCardNumber(CardNumber,"add","")
	;i (ReturnCode'="0") d
	;.w "{""success"":""false"",""info"":""卡号: "_CardNumber_" 已存在! 请重新输入!""}"
	;q:(ReturnCode = "1") ""
	;
	;生成个人编码--绵阳模式
	;s PersonCode = ##class(CHSSWeb.SystemIdService).GetSystemId(CommunityCode,"PersonHealthRecordMain")
	//生成个人编码 -- 湖北鄂州模式
	s PersonCode = ##class(CHSSWeb.SystemIdService).GetPersonCodeWithFamilyId(FamilyRowId)
	
	;判断编码是否重复
	;s ReturnCode= ##class(CHSSWeb.PHRService).existPersonCode(PersonCode)
	;q:(ReturnCode = "1") ""
	
	i (PersonCode="") d
	.w "个人档案编码为空",!
	e  d
	.s tempPerson.CommunityCode = CommunityCode
	.s tempPerson.PersonCode=PersonCode
	.s tempPerson.PersonName=PersonName
	
	
	.i SexDR '= "" d
	..s sexobj=##class(User.CTSex).%OpenId(SexDR)
	..s tempPerson.SexDR=sexobj
	
	.i Birth '= "" d
	..s Birth=$zdh(Birth,3)
	.s tempPerson.Birth=Birth
	.
	.i DateRegister '= "" d
	..s DateRegister=$zdh(DateRegister,3)
	.s tempPerson.DateInput=DateRegister
	..;$zdh(CurDate,3)
	.

	.
	.i DateInput '= "" d
	..s DateInput=$zdh(DateInput,3)
	..;$zdh(DateInput,3)
	.;s DateRegister=CurDate
	.s tempPerson.DateInput=DateInput
	
	
	.s tempPerson.IDCard = IDCard
	.s tempPerson.RegisterType = 1
	
	.i RelationHourseHoldDR '= "" d
	..s RelationHourseHoldobj=##class(CHSS.DictKin).%OpenId(RelationHourseHoldDR)
	..s tempPerson.RelationHourseHoldDR=RelationHourseHoldobj
	
	.i FamilyRowId '= "" d
	..s FamilyRowIdeobj = ##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	..s tempPerson.FamilyRowId = FamilyRowIdeobj
	..;w FamilyRowId_"^"_FamilyRowIdeobj,!
	
	.
	.i IDCardTypeDR '= "" d
	..s IDCardTypeobj=##class(User.PACCardType).%OpenId(IDCardTypeDR)
	..s tempPerson.IDCardTypeDR = IDCardTypeobj
	
	
	.s tempPerson.Address = Address
	.
	.i AddressTypeDR '= "" d
	..s AddressTypeDRobj=##class(CHSS.DictAddressType).%OpenId(AddressTypeDR)
	..s tempPerson.AddressTypeDR = AddressTypeDRobj
	
	.i PersonStatus '= "" d
	..s PersonStatusobj=##class(CHSS.DictArchivesStatus).%OpenId(PersonStatus)
	..s tempPerson.PersonStatus = PersonStatusobj
	.s result=""
    .s result=tempPerson.%Save()
    .;i result '= "1" d
    ..;s ^tempPerson = ^tempPerson_"^"_PersonName_":"_result
    .;w "ok",!
	
	;W result,!
	
	q:(result="1") "result2"
	q ""
}

ClassMethod GetVillageRowId(StreetDR As %Integer, VillageName As %String) As %String
{
		set count = 0
		set tempRowId = ""
		Set json = ##class(Code.JsonObj).%New()
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT * FROM CHSS.DictVillage where RowIdParref = "_StreetDR_" and Description like '%"_VillageName_"%'"
		;w sqlStr,!
		;q ""
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
			set tempRowId = result.Get("RowId")
			s count = count + 1
		}
		q tempRowId
}

ClassMethod GetCommunityCode(VillageRowId As %Integer, CommunityType As %String) As %String
{
		set count = 0
		set tempCommunityCode = ""
		Set json = ##class(Code.JsonObj).%New()
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT * FROM CHSS.DictHospital where (CommunityType = '社区卫生服务中心' or CommunityType = '乡镇卫生院')  and RecordDR = "_VillageRowId
		;w sqlStr,!
		;q ""
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
			set tempCommunityCode = result.Get("CommunityCode")
			s count = count + 1
		}
		;w tempCommunityCode,!
		q tempCommunityCode
}

ClassMethod GetFamilyRowId(StreetDR As %Integer, VillageName As %String, DoorPlate As %String, HouseHoldName) As %String
{
		set count = 0
		set tempFamilyRowId = 0
		Set json = ##class(Code.JsonObj).%New()
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT FamilyRowId FROM CHSS.FamilyHealthRecord where StreetDR = "_StreetDR_" and DoorPlate = '"_DoorPlate_"' and VillageName = '"_VillageName_"' and HouseHoldName = '"_HouseHoldName_"'"
		;s ^tempSQL = sqlStr
		;q ""
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
			set tempFamilyRowId = result.Get("FamilyRowId")
			s count = count + 1
		}
		q tempFamilyRowId
}

ClassMethod GetDictKin(KinDR As %String) As %String
{
		set count = 0
		set tempRowId = ""
		Set json = ##class(Code.JsonObj).%New()
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT RowId,Description FROM CHSS.DictKin where Description = '"_KinDR_"'"
		;w sqlStr,!
		;q ""
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
			set tempRowId = result.Get("RowId")
			s count = count + 1
		}
		q tempRowId
}

ClassMethod existFamilyAddress(FamilyRowId As %Integer, RecordType As %String, StreetDR As %Integer, VillageName As %String, DoorPlate As %String, HouseHoldName As %String) As %String
{
		set count = 0
		set tempFamilyRowId = 0

		q "0"
		&SQL(select count(*) into :count  FROM CHSS.FamilyHealthRecord where StreetDR = :StreetDR and VillageName = :VillageName and HouseHoldName=:HouseHoldName)
		q:(count>0) "1"
		q:(count=0) "0"
		/*
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT FamilyRowId FROM CHSS.FamilyHealthRecord where StreetDR = "_StreetDR_" and VillageName = '"_VillageName_"' and HouseHoldName='"_HouseHoldName_"'"
		;s ^tempSQL = sqlStr
		;q ""
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
			set tempFamilyRowId = result.Get("FamilyRowId")
			s count = count + 1
		}
		if (RecordType = "add")
		{
			if (count>0)
			{
				q "1"
			}
			elseif (count=0)
			{
				q "0"
			}
		}
		elseif (RecordType = "edit")
		{
			if (count=1 && (FamilyRowId '= tempFamilyRowId))
			{
				q "1"
			}
			elseif (count>1)
			{
				q "1"
			}
			else
			{
				q "0"
			}
		}*/
}

ClassMethod DeleteFamilyRecord(StreetDR As %Integer) As %String
{
		&SQL(delete from CHSS.FamilyHealthRecord where RegisterType = 1 and StreetDR = :StreetDR)
		q ""
}

ClassMethod DeletePersonRecord(StreetDR As %Integer) As %String
{
		&SQL(delete from CHSS.PersonHealthRecordMain where RegisterType = 1 and FamilyRowId in (select FamilyRowId from CHSS.FamilyHealthRecord where RegisterType = 1 and StreetDR = :StreetDR))
		q ""
}

Storage Default
{
<Data name="EHRDataImportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.EHRDataImportD</DataLocation>
<DefaultData>EHRDataImportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.EHRDataImportD</IdLocation>
<IndexLocation>^CHSSWeb.EHRDataImportI</IndexLocation>
<StreamLocation>^CHSSWeb.EHRDataImportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
