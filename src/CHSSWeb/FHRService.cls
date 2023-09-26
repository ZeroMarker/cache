/// 家庭档案操作
Class CHSSWeb.FHRService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:检索家庭档案列表
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod FamilyList(communityCode As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
		//n (communityCode, start, limit, sort)
		Set CommunityCode=$G(communityCode)
		s CommunityCode=" "_CommunityCode
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set FamilyRowId = 0
	    
		For  Set FamilyRowId=$O(^CHSS.FamilyHealthRecordI("CommunityCodeIndex",CommunityCode,FamilyRowId)) q:FamilyRowId=""  d
		.s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
		.set FamilyCode = tempFamily.FamilyCode
		
		.set DateOfRegister = tempFamily.DateOfRegister
		.i DateOfRegister '= "" d
		..s DateOfRegister = $zd(DateOfRegister,3)
		.
		.set DateOfInput = tempFamily.DateOfInput
		.i DateOfInput '= "" d
		..s DateOfInput = $zd(DateOfInput,3)
		..
		.set DoctorName = ""
		.set Doctor = ""
		.i tempFamily.Doctor '= "" d
		..s Doctor = tempFamily.Doctor.%Id()
		..s DoctorName = tempFamily.Doctor.SSUSRName
		..
		.set NurseName = ""
		.set Nurse = ""
		.i tempFamily.Nurse '= "" d
		..s Nurse = tempFamily.Nurse.%Id()
		..s NurseName = tempFamily.Nurse.SSUSRName
		.
		.set OperatorName = ""
		.set Operator = ""
		.i tempFamily.Operator '= "" d
		..s Operator = tempFamily.Operator.%Id()
		..s OperatorName = tempFamily.Operator.SSUSRName
		.
		.set HouseHoldName = tempFamily.HouseHoldName
		.set FamilyPeopleNum = tempFamily.FamilyPeopleNum
		.set CurrentNum = tempFamily.CurrentNum
		.set AverageEarnings = tempFamily.AverageEarnings
		.
		.set HouseTypeName = ""
		.set HouseType = ""
		.i tempFamily.HouseType '= "" d
		..s HouseType = tempFamily.HouseType.%Id()
		..s HouseTypeName = tempFamily.HouseType.Description
		.
		.set HouseArea = tempFamily.HouseArea
		.
		.set FuelTypeName = ""
		.set FuelType = ""
		.i tempFamily.FuelType '= "" d
		..s FuelType = tempFamily.FuelType.%Id()
		..s FuelTypeName = tempFamily.FuelType.Description
		.
		.set ToiletTypeName = ""
		.set ToiletType = ""
		.i tempFamily.ToiletType '= "" d
		..s ToiletType = tempFamily.ToiletType.%Id()
		..s ToiletTypeName = tempFamily.ToiletType.Description
		.
		.set FamilyAddress = tempFamily.FamilyAddress
		.set FamilyPhone = tempFamily.FamilyPhone
		.set CellPhone = tempFamily.CellPhone
		.set EMail = tempFamily.EMail
		.set Post = tempFamily.Post
		.set CommunityCode = tempFamily.CommunityCode
		.set Remark = tempFamily.Remark
		.set FamilyStatus = tempFamily.FamilyStatus
		
		.Set tmp= FamilyRowId_"^"_FamilyCode_"^"_DateOfRegister_"^"_DateOfInput_"^"_Doctor_"^"_DoctorName_"^"_Nurse_"^"_NurseName_"^"_Operator_"^"_OperatorName_"^"_HouseHoldName_"^"_FamilyPeopleNum_"^"_CurrentNum_"^"_AverageEarnings_"^"_HouseType_"^"_HouseTypeName_"^"_HouseArea_"^"_FuelType_"^"_FuelTypeName_"^"_ToiletType_"^"_ToiletTypeName_"^"_FamilyAddress_"^"_FamilyPhone_"^"_CellPhone_"^"_EMail_"^"_Post_"^"_CommunityCode_"^"_Remark_"^"_FamilyStatus

	    .Set count=count+1
	    .If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("FamilyRowId^FamilyCode^DateOfRegister^DateOfInput^Doctor^DoctorName^Nurse^NurseName^Operator^OperatorName^HouseHoldName^FamilyPeopleNum^CurrentNum^AverageEarnings^HouseType^HouseTypeName^HouseArea^FuelType^FuelTypeName^ToiletType^ToiletTypeName^FamilyAddress^FamilyPhone^CellPhone^EMail^Post^CommunityCode^Remark^FamilyStatus",count)
	 	k json
	 	
		Quit resultString
}

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:添加个人档案基本信息
/// Table：PersonHealthRecordMain
/// Input:PersonHealthRecordMain
/// Output：
/// Return：
/// Others：
ClassMethod Insert(FamilyCode As %String, DateOfRegister As %Date, DateOfInput As %Date, Doctor As %Integer, Nurse As %Integer, Operator As %Integer, HouseHoldName As %String, FamilyPeopleNum As %String, CurrentNum As %String, AverageEarnings As %String, HouseType As %Integer, HouseArea As %String, FuelType As %String, ToiletType As %String, FamilyAddress As %String, FamilyPhone As %String, CellPhone As %String, EMail As %String, Post As %String, CommunityCode As %String, Remark As %String, FamilyStatus As %Integer) As %String
{
	//, SexDR As %Integer, CommunityCode As %String,DateRegister As %Date,RelationHourseHoldDR As %Integer
	//n (PersonCode, PersonName, SexDR, CommunityCode,DateRegister,RelationHourseHoldDR)
  
	s tempFamily=""
	s tempFamily=##class(CHSS.PersonHealthRecordMain).%New()
	q:(tempFamily="") 0
	
	s ReturnCode=..existPersonCode(FamilyCode)
	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""个人编码: "_PersonCode_" 已存在! 请重新输入!""}"
	e  d
	.s tempFamily.CommunityCode = CommunityCode
	.s tempFamily.FamilyCode=FamilyCode
	.

	.i DateOfRegister '= "" d
	..s DateOfRegister=$zdh(DateOfRegister,3)
	.s tempFamily.DateOfRegister=DateOfRegister
	.
	.i DateOfInput '= "" d
	..s DateOfInput=$zdh(DateOfInput,3)
	.s tempFamily.DateOfInput=DateOfInput
	.
	.i Doctor '= "" d
	..s Doctorobj=##class(User.SSUser).%OpenId(Doctor)
	..s tempFamily.Doctor=Doctorobj
	.i Nurse '= "" d
	..s Nurseobj=##class(User.SSUser).%OpenId(Nurse)
	..s tempFamily.Nurse=Nurseobj
	.i Operator '= "" d
	..s Operatorobj=##class(User.SSUser).%OpenId(Operator)
	..s tempFamily.Operator=Operatorobj
	.
	.s tempFamily.HouseHoldName = HouseHoldName
	.s tempFamily.FamilyPeopleNum = FamilyPeopleNum
	.s tempFamily.CurrentNum = CurrentNum
	.s tempFamily.AverageEarnings = AverageEarnings
	
	i HouseType '= "" d
	.s HouseTypeobj=##class(CHSS.DictHouseHoldType).%OpenId(HouseType)
	.s tempFamily.HouseType=HouseTypeobj
	.
	.s tempFamily.HouseArea = HouseArea
	
	i FuelType '= "" d
	.s FuelTypeobj=##class(CHSS.DictFamilyFuelType).%OpenId(FuelType)
	.s tempFamily.FuelType=FuelTypeobj
	.
	//厕所类型
	//.i ToiletType '= "" d
	//.s ToiletTypeeobj=##class(CHSS.DictToiletType).%OpenId(ToiletType)
	//.s tempFamily.ToiletType=ToiletTypeobj
	//.
	
	.s tempFamily.FamilyAddress = FamilyAddress
	.s tempFamily.FamilyPhone = FamilyPhone
	.s tempFamily.CellPhone = CellPhone
	.s tempFamily.EMail = EMail
	.s tempFamily.Post = Post
	.s tempFamily.FamilyStatus = 1
	.s tempFamily.CommunityCode = CommunityCode
	.s tempFamily.Remark = Remark
	
	
	.s result=""
    .s result=tempFamily.%Save()
    .i result = "1" d
    ..w "{""success"":""true"",""info"":"_tempFamily.%Id()_"}"
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
}

ClassMethod Update1(PersonRowId As %Integer, PersonName As %String, SexDR As %Integer, PoliceRowIdDR As %Integer) As %String
{
	q:($d(PersonRowId)=0)||(PersonRowId="")
	s tempFamily="",result=""
	s tempFamily=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	q:(tempFamily="") 0
	
	s tempFamily.PersonName=PersonName
	
	i SexDR '= "" d
	.s sexobj=##class(User.CTSex).%OpenId(SexDR)
	.s tempFamily.SexDR=sexobj
	
	i PoliceRowIdDR '= "" d
	.s policeobj=##class(CHSS.DictPolice).%OpenId(PoliceRowIdDR)
	.s tempFamily.PoliceRowIdDR=policeobj
	
	s result=""
	s result=tempFamily.%Save()
	;;w result
	w "{""success"":""true"",""info"":""数据保存成功!""}"
}

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:更新个人档案基本信息
/// (注意：对于表字段多的情况采用这种对类赋值的方式，如果字段较少，可以直接采用SQL语句)
/// Table：PersonHealthRecordMain
/// Input:personRowId,PersonHealthRecordMain
/// Output：
/// Return：
/// Others：
ClassMethod Update(FamilyRowId As %Integer, FamilyCode As %String, DateOfRegister As %Date, DateOfInput As %Date, Doctor As %String, Nurse As %String, Operator As %String, HouseHoldName As %String, FamilyPeopleNum As %String, CurrentNum As %String, AverageEarnings As %String, HouseType As %Integer, HouseArea As %String, FuelType As %Integer, ToiletType As %Integer, FamilyAddress As %String, FamilyPhone As %String, CellPhone As %String, EMail As %String, Post As %String, CommunityCode As %String, Remark As %String, FamilyStatus As %Integer) As %String
{
	q:($d(FamilyRowId)=0)||(FamilyRowId="")
	s tempFamily="",result=""
	s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	q:(tempFamily="") 0
	
	s tempFamily.FamilyCode=FamilyCode
	
	i DateOfRegister '= "" d
	.s DateOfRegister=$zdh(DateOfRegister,3)
	.s tempFamily.DateOfRegister=DateOfRegister
	i DateOfInput '= "" d
	.s DateOfInput=$zdh(DateOfInput,3)
	.s tempFamily.DateOfInput=DateOfInput
	.
	i Doctor '= "" d
	.s Doctorobj=##class(User.SSUser).%OpenId(Doctor)
	.s tempFamily.Doctor=Doctorobj
	i Nurse '= "" d
	.s Nurseobj=##class(User.SSUser).%OpenId(Nurse)
	.s tempFamily.Nurse=Nurseobj
	i Operator '= "" d
	.s Operatorobj=##class(User.SSUser).%OpenId(Operator)
	.s tempFamily.Operator=Operatorobj
	.
	s tempFamily.HouseHoldName = HouseHoldName
	s tempFamily.FamilyPeopleNum = FamilyPeopleNum
	s tempFamily.CurrentNum = CurrentNum
	s tempFamily.AverageEarnings = AverageEarnings
	
	i HouseType '= "" d
	.s HouseTypeobj=##class(CHSS.DictHouseType).%OpenId(HouseType)
	.s tempFamily.HouseType=HouseTypeobj
	.
	s tempFamily.HouseArea = HouseArea
	
	i FuelType '= "" d
	.s FuelTypeobj=##class(CHSS.DictFamilyFuelType).%OpenId(FuelType)
	.s tempFamily.FuelType=FuelTypeobj
	.
    //厕所类型
    
    s tempFamily.FamilyAddress = FamilyAddress
    s tempFamily.FamilyPhone = FamilyPhone
    s tempFamily.CellPhone = CellPhone
    s tempFamily.EMail = EMail
    s tempFamily.Post = Post
    s tempFamily.Remark = Remark 
	//**********
	s result=""
	s result=tempFamily.%Save()
	i result = "1" d
    .w "{""success"":""true"",""info"":"_PersonRowId_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
}

//判断code是否存在,-1入参为空，1重复，0不重复

ClassMethod existPersonCode(PersonCode) As %String
{
	q:PersonCode="" "-1"
	s PersonCode=" "_PersonCode
	q:$d(^CHSS.PersonHealthRecordMainI("PersonCodeIndex",PersonCode)) "1"
	q "0"
}

//判断名字是否存在,-1入参为空，1重复，0不重复

ClassMethod existPersonName(PersonName As %String) As %String
{
	q:PersonName="" "-1"
	s PersonName=" "_PersonName
	q:$d(^CHSS.PersonHealthRecordMainI("NameIndex",PersonName)) "1"
	q "0"
}

Storage Default
{
<Data name="FHRServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.FHRServiceD</DataLocation>
<DefaultData>FHRServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.FHRServiceD</IdLocation>
<IndexLocation>^CHSSWeb.FHRServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.FHRServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
