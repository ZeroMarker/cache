/// Modify:2009-08-03 by wangbo 增加删除家庭档案功能
Class CHSSWeb.FamilyService Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
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
		n (communityCode, start, limit, sort)
		q:(communityCode="") 0
		s rowcount = 0
		&SQL(select count(*) into rowcount from  CHSS.FamilyHealthRecord where CommunityCode = :communityCode)
		
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
	    
	    //w CommunityCode,!
		For  Set FamilyRowId=$O(^CHSS.FamilyHealthRecordI("CommunityCodeIndex",CommunityCode,FamilyRowId)) q:(FamilyRowId="")!(count>end)  d
		.s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
		.
		.set FamilyCode = "<font color=blue>"_tempFamily.FamilyCode_"</font>"
		.set DateOfRegister = tempFamily.DateOfRegister
		.i DateOfRegister '= "" d
		..s DateOfRegister = $zd(DateOfRegister,3)
		.
		.set DateOfInput = tempFamily.DateOfInput
		.i DateOfInput '= "" d
		..s DateOfInput = $zd(DateOfInput,3)
		.
		.set ProvinceName = ""
		.set ProvinceDR = ""
		.i tempFamily.ProvinceDR '="" d
		.. s ProvinceDR = tempFamily.ProvinceDR.%Id()
		.. s ProvinceName = tempFamily.ProvinceDR.Description
		.
		.set CityName=""
		.set CityDR=""
		.i tempFamily.CityDR '="" d
		.. s CityDR = tempFamily.CityDR.%Id()
		.. s CityName = tempFamily.CityDR.Description
		
		.set SectionName=""
		.set SectionDR="" 
		.i tempFamily.SectionDR '="" d
		.. s SectionDR = tempFamily.SectionDR.%Id()
		.. s SectionName = tempFamily.SectionDR.Description
		.
		.set StreetName=""
		.set StreetDR=""
		.i tempFamily.StreetDR '="" d
		.. s StreetDR=tempFamily.StreetDR.%Id()
		.. s StreetName = tempFamily.StreetDR.Description 
		.
		.set VillageName =""
		.set VillageDR =""
		.i tempFamily.VillageDR '="" d
		.. s VillageDR = tempFamily.VillageDR.%Id()
		.. s VillageName = tempFamily.VillageDR.Description
		.
		.set DoctorName = ""
		.set Doctor = ""
		
		.i tempFamily.Doctor '= "" d
		..s Doctor = tempFamily.Doctor
		..s DoctorName = tempFamily.Doctor
		.
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
		.set DoorPlate = tempFamily.DoorPlate
		.//set VillageDR = tempFamily.VillageDR
		.set FamilyAddress = tempFamily.FamilyAddress
		.set FamilyPhone = tempFamily.FamilyPhone
		.set CellPhone = tempFamily.CellPhone
		.set EMail = tempFamily.EMail
		.set Post = tempFamily.Post
		.//set CommunityCode = tempFamily.CommunityCode
		.set Remark = tempFamily.Remark
		.set FamilyStatus = tempFamily.FamilyStatus
		.
		.s FamilyAddress = ""
	    .i tempFamily.ProvinceDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    .i tempFamily.CityDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    .i tempFamily.SectionDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    .i tempFamily.StreetDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		.;i tempFamily.VillageDR '= "" d
	    .;.s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    .s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    .i tempFamily.DoorPlate '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	    .
	    .s VillageName = tempFamily.VillageName
		.s bEarthquakeFamily = tempFamily.bEarthquakeFamily
		.s WaterSource = tempFamily.WaterSource
		.Set tmp= FamilyRowId_"^"_FamilyCode_"^"_DateOfRegister_"^"_DateOfInput_"^"_Doctor_"^"_DoctorName_"^"_Nurse_"^"_NurseName_"^"_Operator_"^"_OperatorName_"^"_HouseHoldName_"^"_FamilyPeopleNum_"^"_CurrentNum_"^"_FamilyAddress_"^"_CommunityCode_"^"_FamilyStatus_"^"_FamilyPhone
	    .Set count=count+1
	    .If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.
		.		
		
	    Set resultString = json.getJsonData("FamilyRowId^FamilyCode^DateOfRegister^DateOfInput^Doctor^DoctorName^Nurse^NurseName^Operator^OperatorName^HouseHoldName^FamilyPeopleNum^CurrentNum^FamilyAddress^CommunityCode^FamilyStatus^FamilyPhone",rowcount)
	 	k json
	 	
		Quit resultString
}

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:根据家庭档案号查询家庭档案
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod GetFamilyInfoWithFamilyRowId(FamilyRowId As %Integer) As %String
{
		//n (communityCode, start, limit, sort)
		Set count=0
		Set start=0
		Set limit=1
		Set end = start+limit
		i FamilyRowId = "" d
   		.w "{""success"":""false"",""info"":家庭档案号不能为空！}"
   		q:(FamilyRowId = "") ""
   		Set json = ##class(Code.JsonObj).%New()
	    s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    q:(tempFamily="") ""
	    i tempFamily '= "" d
	    .set FamilyCode = tempFamily.FamilyCode
		.set DateOfRegister = tempFamily.DateOfRegister
		.i DateOfRegister '= "" d
		..s DateOfRegister = $zd(DateOfRegister,3)
		.
		.set DateOfInput = tempFamily.DateOfInput
		.i DateOfInput '= "" d
		..s DateOfInput = $zd(DateOfInput,3)
		.
		.set ProvinceName = ""
		.set ProvinceDR = ""
		.i tempFamily.ProvinceDR '="" d
		.. s ProvinceDR = tempFamily.ProvinceDR.%Id()
		.. s ProvinceName = tempFamily.ProvinceDR.Description
		.
		.set CityName=""
		.set CityDR=""
		.i tempFamily.CityDR '="" d
		.. s CityDR = tempFamily.CityDR.%Id()
		.. s CityName = tempFamily.CityDR.Description
		
		.set SectionName=""
		.set SectionDR="" 
		.i tempFamily.SectionDR '="" d
		.. s SectionDR = tempFamily.SectionDR.%Id()
		.. s SectionName = tempFamily.SectionDR.Description
		.
		.set StreetName=""
		.set StreetDR=""
		.i tempFamily.StreetDR '="" d
		.. s StreetDR=tempFamily.StreetDR.%Id()
		.. s StreetName = tempFamily.StreetDR.Description 
		.
		.set VillageName =""
		.set VillageDR =""
		.i tempFamily.VillageDR '="" d
		.. s VillageDR = tempFamily.VillageDR.%Id()
		.. s VillageName = tempFamily.VillageDR.Description
		.
		.set DoctorName = ""
		.set Doctor = ""
		
		.i tempFamily.Doctor '= "" d
		..s Doctor = tempFamily.Doctor
		..s DoctorName = tempFamily.Doctor
		.
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
		.set DoorPlate = tempFamily.DoorPlate
		.//set VillageDR = tempFamily.VillageDR
		.set FamilyAddress = tempFamily.FamilyAddress
		.set FamilyPhone = tempFamily.FamilyPhone
		.set CellPhone = tempFamily.CellPhone
		.set EMail = tempFamily.EMail
		.set Post = tempFamily.Post
		.//set CommunityCode = tempFamily.CommunityCode
		.set Remark = tempFamily.Remark
		.set FamilyStatus = tempFamily.FamilyStatus
		.
		.s FamilyAddress = ""
	    .i tempFamily.ProvinceDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    .i tempFamily.CityDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    .i tempFamily.SectionDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    .i tempFamily.StreetDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		.;i tempFamily.VillageDR '= "" d
	    .;.s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    .s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    .i tempFamily.DoorPlate '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	    .
	    .s VillageName = tempFamily.VillageName
		.s bEarthquakeFamily = tempFamily.bEarthquakeFamily
		.s WaterSource = tempFamily.WaterSource
		.s CommunityCode = tempFamily.CommunityCode
		.
		.Set tmp= FamilyRowId_"^"_FamilyCode_"^"_DateOfRegister_"^"_DateOfInput_"^"_Doctor
		.set tmp=tmp_"^"_DoctorName_"^"_Nurse_"^"_NurseName_"^"_ProvinceDR_"^"_ProvinceName
		.set tmp=tmp_"^"_CityDR_"^"_CityName_"^"_SectionDR_"^"_SectionName_"^"_StreetDR_"^"_StreetName
		.set tmp=tmp_"^"_VillageDR_"^"_VillageName_"^"_Operator_"^"_OperatorName
		.set tmp=tmp_"^"_HouseHoldName_"^"_FamilyPeopleNum_"^"_CurrentNum_"^"_AverageEarnings
		.set tmp=tmp_"^"_HouseType_"^"_HouseTypeName_"^"_HouseArea_"^"_FuelType_"^"_FuelTypeName
		.set tmp=tmp_"^"_ToiletType_"^"_ToiletTypeName_"^"_FamilyAddress_"^"_FamilyPhone
		.set tmp=tmp_"^"_CellPhone_"^"_EMail_"^"_Post_"^"_CommunityCode_"^"_Remark
		.set tmp=tmp_"^"_FamilyStatus_"^"_VillageDR_"^"_DoorPlate_"^"_bEarthquakeFamily_"^"_WaterSource
	    .Set count=count+1
	    .If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.
		.		
	    Set resultString = json.getJsonData("FamilyRowId^FamilyCode^DateOfRegister^DateOfInput^Doctor^DoctorName^Nurse^NurseName^ProvinceDR^ProvinceName^CityDR^CityName^SectionDR^SectionName^StreetDR^StreetName^VillageDR^VillageName^Operator^OperatorName^HouseHoldName^FamilyPeopleNum^CurrentNum^AverageEarnings^HouseType^HouseTypeName^HouseArea^FuelType^FuelTypeName^ToiletType^ToiletTypeName^FamilyAddress^FamilyPhone^CellPhone^EMail^Post^CommunityCode^Remark^FamilyStatus^VillageDR^DoorPlate^bEarthquakeFamily^WaterSource",count)
	 	k json
	 	
		Quit resultString
}

ClassMethod Insert(FamilyCode As %String, DateOfRegister As %Date, DateOfInput As %Date, Doctor As %Integer, Nurse As %Integer, Operator As %Integer, HouseHoldName As %String, FamilyPeopleNum As %String, CurrentNum As %String, AverageEarnings As %String, HouseType As %Integer, HouseArea As %String, FuelType As %String, ToiletType As %String, FamilyAddress As %String, FamilyPhone As %String, CellPhone As %String, EMail As %String, Post As %String, CommunityCode As %String, Remark As %String, FamilyStatus As %Integer, ProvinceDR As %Integer, CityDR As %Integer, SectionDR As %Integer, StreetDR As %Integer, VillageDR As %Integer, DoorPlate As %String, VillageName As %String, bEarthquakeFamily As %String, WaterSource As %String) As %String
{
	//, SexDR As %Integer, CommunityCode As %String,DateRegister As %Date,RelationHourseHoldDR As %Integer
	//n (PersonCode, PersonName, SexDR, CommunityCode,DateRegister,RelationHourseHoldDR)

  	q:(CommunityCode="") "0"
	s tempFamily=""
	s tempFamily=##class(CHSS.FamilyHealthRecord).%New()
	q:(tempFamily="") "0"
	s ReturnCode=..existFamilyAddress(0,"add",StreetDR,VillageName,DoorPlate)
	i (ReturnCode="1") d
	.w "{""success"":""false"",""info"":""家庭地址重复! 请重新输入!""}"
	.
	//重新生成家庭编码
	s FamilyCode = ##class(CHSSWeb.SystemIdService).GetSystemIdWithVillageDR(CommunityCode,VillageName,"FAMILYHEALTHRECORD")
	//判断家庭编码是否为空
	q:(ReturnCode="1") ""
	s ReturnCode=..existFamilyCode(FamilyCode)
	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""家庭编码: "_FamilyCode_" 已存在! 请重新输入!""}"
	e  d
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
		
	.i VillageDR '="" d
	..s VillageDRobj=##class(CHSS.DictVillage).%OpenId(VillageDR)
	..s tempFamily.VillageDR=VillageDRobj
	
	.i Doctor '= "" d
	..;s Doctorobj=##class(User.SSUser).%OpenId(Doctor)
	..s tempFamily.Doctor=Doctor
	
	.i Nurse '= "" d
	..s Nurseobj=##class(User.SSUser).%OpenId(Nurse)
	..s tempFamily.Nurse=Nurseobj
	.
	.i Operator '= "" d
	..s Operatorobj=##class(User.SSUser).%OpenId(Operator)
	..s tempFamily.Operator=Operatorobj
    
	.s tempFamily.HouseHoldName = HouseHoldName
	.s tempFamily.FamilyPeopleNum = FamilyPeopleNum
	.s tempFamily.CurrentNum = CurrentNum
	.s tempFamily.AverageEarnings = AverageEarnings
	.//s tempFamily.VillageDR=VillageDR
	
	.i HouseType '= "" d
	..s HouseTypeobj=##class(CHSS.DictHouseType).%OpenId(HouseType)
	..s tempFamily.HouseType=HouseTypeobj
	.i ToiletType '="" d
	..s ToiletTypeobj=##class(CHSS.DictToiletType).%OpenId(ToiletType)
	..s tempFamily.ToiletType=ToiletTypeobj
	
	
 	.s tempFamily.HouseArea = HouseArea
	
	.i FuelType '= "" d
	..s FuelTypeobj=##class(CHSS.DictFamilyFuelType).%OpenId(FuelType)
	..s tempFamily.FuelType=FuelTypeobj
	.

	.s tempFamily.DoorPlate = DoorPlate
	.s tempFamily.FamilyAddress = FamilyAddress
	.s tempFamily.FamilyPhone = FamilyPhone
	.s tempFamily.CellPhone = CellPhone
	.s tempFamily.EMail = EMail
	.s tempFamily.Post = Post
	.s tempFamily.FamilyStatus = 1
	.s tempFamily.CommunityCode = CommunityCode
	.s tempFamily.Remark = Remark
	.s tempFamily.VillageName = VillageName
	.s tempFamily.bEarthquakeFamily = bEarthquakeFamily
	.s tempFamily.WaterSource = WaterSource
	.s result=""
    .s result=tempFamily.%Save()
    .i result = "1" d
    ..s resultstr=tempFamily.%Id()_"^"_FamilyCode
    ..w "{""success"":""true"",""info"":"_"'"_resultstr_"'}"
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
    ..
    ..	//厕所类型
	//.i ToiletType '= "" d
	//.s ToiletTypeeobj=##class(CHSS.DictToiletType).%OpenId(ToiletType)
	//.s tempFamily.ToiletType=ToiletTypeobj
	//.
	q ""
}

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:更新家庭档案基本信息
/// (注意：对于表字段多的情况采用这种对类赋值的方式，如果字段较少，可以直接采用SQL语句)
/// Table：PersonHealthRecordMain
/// Input:personRowId,PersonHealthRecordMain
/// Output：
/// Return：
/// Others：
ClassMethod Update(FamilyRowId As %Integer, FamilyCode As %String, DateOfRegister As %Date, DateOfInput As %Date, Doctor As %Integer, Nurse As %Integer, Operator As %Integer, HouseHoldName As %String, FamilyPeopleNum As %String, CurrentNum As %String, AverageEarnings As %String, HouseType As %Integer, HouseArea As %String, FuelType As %String, ToiletType As %String, FamilyAddress As %String, FamilyPhone As %String, CellPhone As %String, EMail As %String, Post As %String, CommunityCode As %String, Remark As %String, FamilyStatus As %Integer, ProvinceDR As %Integer, CityDR As %Integer, SectionDR As %Integer, StreetDR As %Integer, VillageDR As %String, DoorPlate As %String, VillageName As %String, bEarthquakeFamily As %String, WaterSource As %String) As %String
{
	q:($d(FamilyRowId)=0)||(FamilyRowId="")
	s tempFamily="",result=""
	s ReturnCode=..existFamilyAddress(FamilyRowId,"edit",StreetDR,VillageName,DoorPlate)
	i (ReturnCode="1") d
	.w "{""success"":""false"",""info"":""家庭地址重复! 请重新输入!""}"
	.
	q:(ReturnCode="1") ""
	s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	q:(tempFamily="") "0"
	i tempFamily.VillageName '= VillageName d
	.s FamilyCode = ##class(CHSSWeb.SystemIdService).GetSystemIdWithVillageDR(CommunityCode,VillageName,"FAMILYHEALTHRECORD")
	.s tempFamily.FamilyCode = FamilyCode
	i DateOfRegister '= "" d
	.s DateOfRegister=$zdh(DateOfRegister,3)
	s tempFamily.DateOfRegister=DateOfRegister
	i DateOfInput '= "" d
	.s DateOfInput=$zdh(DateOfInput,3)
	s tempFamily.DateOfInput=DateOfInput
	
	i ProvinceDR '= "" d
	.s ProvinceDRobj=##class(CHSS.DictProvince).%OpenId(ProvinceDR)
	.s tempFamily.ProvinceDR=ProvinceDRobj
	i CityDR '= "" d
	.s CityDRobj=##class(CHSS.DictCity).%OpenId(CityDR)
	.s tempFamily.CityDR=CityDRobj
	
	i SectionDR '= "" d
    .s SectionDRobj=##class(CHSS.DictSection).%OpenId(SectionDR)
	.s tempFamily.SectionDR=SectionDRobj
	
	i StreetDR '= "" d
	.s StreetDRobj=##class(CHSS.DictStreet).%OpenId(StreetDR)
	.s tempFamily.StreetDR=StreetDRobj 
	i VillageDR '="" d
	.s VillageDRobj=##class(CHSS.DictVillage).%OpenId(VillageDR)
	.s tempFamily.VillageDR = VillageDRobj
		
	i Doctor '= "" d
	.;s Doctorobj=##class(User.SSUser).%OpenId(Doctor)
	.s tempFamily.Doctor=Doctor
	
	i Nurse '= "" d
	.s Nurseobj=##class(User.SSUser).%OpenId(Nurse)
	.s tempFamily.Nurse=Nurseobj
		
	i Operator '= "" d
	.s Operatorobj=##class(User.SSUser).%OpenId(Operator)
	.s tempFamily.Operator=Operatorobj
    s tempFamily.DoorPlate = DoorPlate
	s tempFamily.HouseHoldName = HouseHoldName
	s tempFamily.FamilyPeopleNum = FamilyPeopleNum
	s tempFamily.CurrentNum = CurrentNum
	s tempFamily.AverageEarnings = AverageEarnings

	i HouseType '= "" d
	.s HouseTypeobj=##class(CHSS.DictHouseType).%OpenId(HouseType)
    .s tempFamily.HouseType=HouseTypeobj

	i ToiletType '="" d
	.s ToiletTypeobj=##class(CHSS.DictToiletType).%OpenId(ToiletType)
	.s tempFamily.ToiletType=ToiletTypeobj
	
	
 	s tempFamily.HouseArea = HouseArea
	
	i FuelType '= "" d
	.s FuelTypeobj=##class(CHSS.DictFamilyFuelType).%OpenId(FuelType)
	.s tempFamily.FuelType=FuelTypeobj
	

	
	s tempFamily.FamilyAddress = FamilyAddress
	s tempFamily.FamilyPhone = FamilyPhone
	s tempFamily.CellPhone = CellPhone
    s tempFamily.EMail = EMail
	s tempFamily.Post = Post
	s tempFamily.FamilyStatus = 1
	s tempFamily.CommunityCode = CommunityCode
	s tempFamily.Remark = Remark
	s tempFamily.VillageName = VillageName
	s tempFamily.bEarthquakeFamily = bEarthquakeFamily
	s tempFamily.WaterSource = WaterSource
	s result=""
    s result=tempFamily.%Save()
    i result = "1" d
    .s resultstr=tempFamily.%Id()_"^"_FamilyCode
    .w "{""success"":""true"",""info"":"_"'"_resultstr_"'}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

//删除个人档案

ClassMethod deleteFamily(FamilyRowId) As %String
{
	q:(FamilyRowId = "") ""
	s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	q:(tempFamily="") ""
	s result=tempFamily.%DeleteId(FamilyRowId)
	i result = "1" d
    .w "{""success"":""true"",""info"":""数据删除成功！""}"
    .
    e  d
    .w "{""success"":""false"",""info"":""数据删除出错！""}"
    .
    q ""
}

//判断code是否存在,-1入参为空，1重复，0不重复

ClassMethod existFamilyCode(FamilyCode) As %String
{
	q:FamilyCode="" "-1"
	s FamilyCode=" "_FamilyCode
	q:$d(^CHSS.FamilyHealthRecordI("FamilyCodeIndex",FamilyCode)) "1"
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

ClassMethod existFamilyAddress(FamilyRowId As %Integer, RecordType As %String, StreetDR As %Integer, VillageName As %String, DoorPlate As %String) As %String
{
		n (FamilyRowId, RecordType, StreetDR, VillageName, DoorPlate)
		set count = 0
		set tempFamilyRowId = 0
		Set json = ##class(Code.JsonObj).%New()
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT FamilyRowId FROM CHSS.FamilyHealthRecord where StreetDR = "_StreetDR_" and VillageName = '"_VillageName_"' and DoorPlate='"_DoorPlate_"'"
		;w sqlStr,!
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
		}
}

Storage Default
{
<Data name="FamilyServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.FamilyServiceD</DataLocation>
<DefaultData>FamilyServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.FamilyServiceD</IdLocation>
<IndexLocation>^CHSSWeb.FamilyServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.FamilyServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
