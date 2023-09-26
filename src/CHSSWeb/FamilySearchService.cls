Class CHSSWeb.FamilySearchService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:检索家庭档案列表
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
/// Modify:2010-06-11 by wangbo 增加检索不限定社区
ClassMethod FamilySearch(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, searchField As %String, searchValue As %String) As %String
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

		set PersonRowId = 0

		s result = ##class(%Library.ResultSet).%New()
		;s sqlStr = "SELECT FamilyRowId FROM CHSS.FamilyHealthRecord where CommunityCode = '"_communityCode_"' and "_searchField_" like '%"_searchValue_"%'"
		i start=0 d
		.s sqlStr = "SELECT top "_limit_"FamilyRowId FROM CHSS.FamilyHealthRecord where  CommunityCode = '"_communityCode_"' and "_searchField_" like '%"_searchValue_"%'"
		e  d
		.s sqlStr = "SELECT FamilyRowId FROM CHSS.FamilyHealthRecord where  CommunityCode = '"_communityCode_"' and "_searchField_" like '%"_searchValue_"%'"
		
		
		;绵阳检索不限定社区
		;i start=0 d
		;.s sqlStr = "SELECT top "_limit_"FamilyRowId FROM CHSS.FamilyHealthRecord where  "_searchField_" like '%"_searchValue_"%'"
		;e  d
		;.s sqlStr = "SELECT FamilyRowId FROM CHSS.FamilyHealthRecord where  "_searchField_" like '%"_searchValue_"%'"

		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
		set FamilyRowId = result.Get("FamilyRowId")
		s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
		
		set FamilyCode = tempFamily.FamilyCode
		set DateOfRegister = tempFamily.DateOfRegister
		i DateOfRegister '= "" d
		.s DateOfRegister = $zd(DateOfRegister,3)
		
		set DateOfInput = tempFamily.DateOfInput
		i DateOfInput '= "" d
		.s DateOfInput = $zd(DateOfInput,3)
		
		set ProvinceName = ""
		set ProvinceDR = ""
		i tempFamily.ProvinceDR '="" d
		. s ProvinceDR = tempFamily.ProvinceDR.%Id()
		. s ProvinceName = tempFamily.ProvinceDR.Description
		
		set CityName=""
		set CityDR=""
		i tempFamily.CityDR '="" d
		. s CityDR = tempFamily.CityDR.%Id()
		. s CityName = tempFamily.CityDR.Description
		
		set SectionName=""
		set SectionDR="" 
		i tempFamily.SectionDR '="" d
		. s SectionDR = tempFamily.SectionDR.%Id()
		. s SectionName = tempFamily.SectionDR.Description
		
		set StreetName=""
		set StreetDR=""
		i tempFamily.StreetDR '="" d
		. s StreetDR=tempFamily.StreetDR.%Id()
		. s StreetName = tempFamily.StreetDR.Description 
		. 
		set VillageName =""
		set VillageDR =""
		i tempFamily.VillageDR '="" d
		. s VillageDR = tempFamily.VillageDR.%Id()
		. s VillageName = tempFamily.VillageDR.Description
		
		set DoctorName = ""
		set Doctor = ""
		
		i tempFamily.Doctor '= "" d
		.s Doctor = tempFamily.Doctor
		.s DoctorName = tempFamily.Doctor
		
		set NurseName = ""
		set Nurse = ""
		i tempFamily.Nurse '= "" d
		.s Nurse = tempFamily.Nurse.%Id()
		.s NurseName = tempFamily.Nurse.SSUSRName
		
		set OperatorName = ""
		set Operator = ""
		i tempFamily.Operator '= "" d
		.s Operator = tempFamily.Operator.%Id()
		.s OperatorName = tempFamily.Operator.SSUSRName
		
		set HouseHoldName = tempFamily.HouseHoldName
		set FamilyPeopleNum = tempFamily.FamilyPeopleNum
		set CurrentNum = tempFamily.CurrentNum
		set AverageEarnings = tempFamily.AverageEarnings
		
		set HouseTypeName = ""
		set HouseType = ""
		i tempFamily.HouseType '= "" d
		.s HouseType = tempFamily.HouseType.%Id()
		.s HouseTypeName = tempFamily.HouseType.Description
		
		set HouseArea = tempFamily.HouseArea
		
		set FuelTypeName = ""
		set FuelType = ""
		i tempFamily.FuelType '= "" d
		.s FuelType = tempFamily.FuelType.%Id()
		.s FuelTypeName = tempFamily.FuelType.Description
		
		set ToiletTypeName = ""
		set ToiletType = ""
		i tempFamily.ToiletType '= "" d
		.s ToiletType = tempFamily.ToiletType.%Id()
		.s ToiletTypeName = tempFamily.ToiletType.Description
		set DoorPlate = tempFamily.DoorPlate
		//set VillageDR = tempFamily.VillageDR
		set FamilyAddress = tempFamily.FamilyAddress
		set FamilyPhone = tempFamily.FamilyPhone
		set CellPhone = tempFamily.CellPhone
		set EMail = tempFamily.EMail
		set Post = tempFamily.Post
		//set CommunityCode = tempFamily.CommunityCode
		set Remark = tempFamily.Remark
		set FamilyStatus = tempFamily.FamilyStatus
		
		s FamilyAddress = ""
	    i tempFamily.ProvinceDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    i tempFamily.CityDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    i tempFamily.SectionDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    i tempFamily.StreetDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		;i tempFamily.VillageDR '= "" d
	    ;.s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    i tempFamily.DoorPlate '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
		s bEarthquakeFamily = tempFamily.bEarthquakeFamily ;add by wangbo 2009-08-24
		s WaterSource = tempFamily.WaterSource ;add by wangbo 2009-09-29
		;Set tmp= FamilyRowId_"^"_FamilyCode_"^"_DateOfRegister_"^"_DateOfInput_"^"_Doctor_"^"_DoctorName_"^"_Nurse_"^"_NurseName_"^"_ProvinceDR_"^"_ProvinceName_"^"_CityDR_"^"_CityName_"^"_SectionDR_"^"_SectionName_"^"_StreetDR_"^"_StreetName_"^"_Operator_"^"_OperatorName_"^"_HouseHoldName_"^"_FamilyPeopleNum_"^"_CurrentNum_"^"_AverageEarnings_"^"_HouseType_"^"_HouseTypeName_"^"_HouseArea_"^"_FuelType_"^"_FuelTypeName_"^"_ToiletType_"^"_ToiletTypeName_"^"_FamilyAddress_"^"_FamilyPhone_"^"_CellPhone_"^"_EMail_"^"_Post_"^"_CommunityCode_"^"_Remark_"^"_FamilyStatus_"^"_VillageDR_"^"_DoorPlate_"^"_VillageName_"^"_bEarthquakeFamily_"^"_WaterSource
	    ;modify by wangbo 2009-12-08
	    Set tmp= FamilyRowId_"^"_FamilyCode_"^"_DateOfRegister_"^"_DateOfInput_"^"_Doctor_"^"_DoctorName_"^"_Nurse_"^"_NurseName_"^"_Operator_"^"_OperatorName_"^"_HouseHoldName_"^"_FamilyPeopleNum_"^"_CurrentNum_"^"_FamilyAddress_"^"_CommunityCode_"^"_FamilyStatus_"^"_FamilyPhone
	    
	    Set count=count+1
	    If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}		
	    Set resultString = json.getJsonData("FamilyRowId^FamilyCode^DateOfRegister^DateOfInput^Doctor^DoctorName^Nurse^NurseName^Operator^OperatorName^HouseHoldName^FamilyPeopleNum^CurrentNum^FamilyAddress^CommunityCode^FamilyStatus^FamilyPhone",count)
	 	k json
	 	
		Quit resultString
}

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:根据SQL语句检索家庭档案列表
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
/// Modify:2010-06-11 by wangbo 增加检索不限定社区
ClassMethod FamilySearchSql(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
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

		set PersonRowId = 0

		s result = ##class(%Library.ResultSet).%New()
		;s sqlStr = "SELECT FamilyRowId FROM CHSS.FamilyHealthRecord where CommunityCode = '"_communityCode_"'  "_whereStr
		i start=0 d
		.s sqlStr = "SELECT top "_limit_"FamilyRowId FROM CHSS.FamilyHealthRecord where  CommunityCode = '"_communityCode_"' "_whereStr
		e  d
		.s sqlStr = "SELECT FamilyRowId FROM CHSS.FamilyHealthRecord where  CommunityCode = '"_communityCode_"' "_whereStr
		
		
		;绵阳检索不限定社区
		;i start=0 d
		;.s sqlStr = "SELECT top "_limit_"FamilyRowId FROM CHSS.FamilyHealthRecord where  1=1 "_whereStr
		;e  d
		;.s sqlStr = "SELECT FamilyRowId FROM CHSS.FamilyHealthRecord where  1=1 "_whereStr
		
		;绵阳检索不限定社区
		;s sqlStr = "SELECT FamilyRowId FROM CHSS.FamilyHealthRecord where 1=1  "_whereStr
		
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
		set FamilyRowId = result.Get("FamilyRowId")
		s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
		
		set FamilyCode = tempFamily.FamilyCode
		set DateOfRegister = tempFamily.DateOfRegister
		i DateOfRegister '= "" d
		.s DateOfRegister = $zd(DateOfRegister,3)
		
		set DateOfInput = tempFamily.DateOfInput
		i DateOfInput '= "" d
		.s DateOfInput = $zd(DateOfInput,3)
		
		set ProvinceName = ""
		set ProvinceDR = ""
		i tempFamily.ProvinceDR '="" d
		. s ProvinceDR = tempFamily.ProvinceDR.%Id()
		. s ProvinceName = tempFamily.ProvinceDR.Description
		
		set CityName=""
		set CityDR=""
		i tempFamily.CityDR '="" d
		. s CityDR = tempFamily.CityDR.%Id()
		. s CityName = tempFamily.CityDR.Description
		
		set SectionName=""
		set SectionDR="" 
		i tempFamily.SectionDR '="" d
		. s SectionDR = tempFamily.SectionDR.%Id()
		. s SectionName = tempFamily.SectionDR.Description
		
		set StreetName=""
		set StreetDR=""
		i tempFamily.StreetDR '="" d
		. s StreetDR=tempFamily.StreetDR.%Id()
		. s StreetName = tempFamily.StreetDR.Description 
		. 
		set VillageName =""
		set VillageDR =""
		i tempFamily.VillageDR '="" d
		. s VillageDR = tempFamily.VillageDR.%Id()
		. s VillageName = tempFamily.VillageDR.Description
		
		set DoctorName = ""
		set Doctor = ""
		
		i tempFamily.Doctor '= "" d
		.s Doctor = tempFamily.Doctor
		.s DoctorName = tempFamily.Doctor
		
		set NurseName = ""
		set Nurse = ""
		i tempFamily.Nurse '= "" d
		.s Nurse = tempFamily.Nurse.%Id()
		.s NurseName = tempFamily.Nurse.SSUSRName
		
		set OperatorName = ""
		set Operator = ""
		i tempFamily.Operator '= "" d
		.s Operator = tempFamily.Operator.%Id()
		.s OperatorName = tempFamily.Operator.SSUSRName
		
		set HouseHoldName = tempFamily.HouseHoldName
		set FamilyPeopleNum = tempFamily.FamilyPeopleNum
		set CurrentNum = tempFamily.CurrentNum
		set AverageEarnings = tempFamily.AverageEarnings
		
		set HouseTypeName = ""
		set HouseType = ""
		i tempFamily.HouseType '= "" d
		.s HouseType = tempFamily.HouseType.%Id()
		.s HouseTypeName = tempFamily.HouseType.Description
		
		set HouseArea = tempFamily.HouseArea
		
		set FuelTypeName = ""
		set FuelType = ""
		i tempFamily.FuelType '= "" d
		.s FuelType = tempFamily.FuelType.%Id()
		.s FuelTypeName = tempFamily.FuelType.Description
		
		set ToiletTypeName = ""
		set ToiletType = ""
		i tempFamily.ToiletType '= "" d
		.s ToiletType = tempFamily.ToiletType.%Id()
		.s ToiletTypeName = tempFamily.ToiletType.Description
		set DoorPlate = tempFamily.DoorPlate
		//set VillageDR = tempFamily.VillageDR
		set FamilyAddress = tempFamily.FamilyAddress
		set FamilyPhone = tempFamily.FamilyPhone
		set CellPhone = tempFamily.CellPhone
		set EMail = tempFamily.EMail
		set Post = tempFamily.Post
		//set CommunityCode = tempFamily.CommunityCode
		set Remark = tempFamily.Remark
		set FamilyStatus = tempFamily.FamilyStatus
		
		s FamilyAddress = ""
	    i tempFamily.ProvinceDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    i tempFamily.CityDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    i tempFamily.SectionDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    i tempFamily.StreetDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		;i tempFamily.VillageDR '= "" d
	    ;.s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    i tempFamily.DoorPlate '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	    
	    s VillageName = tempFamily.VillageName
		s bEarthquakeFamily = tempFamily.bEarthquakeFamily ;add by wangbo 2009-08-24
		s WaterSource = tempFamily.WaterSource ;add by wangbo 2009-09-29
		;modify by wangbo 2009-12-08
	    Set tmp= FamilyRowId_"^"_FamilyCode_"^"_DateOfRegister_"^"_DateOfInput_"^"_Doctor_"^"_DoctorName_"^"_Nurse_"^"_NurseName_"^"_Operator_"^"_OperatorName_"^"_HouseHoldName_"^"_FamilyPeopleNum_"^"_CurrentNum_"^"_FamilyAddress_"^"_CommunityCode_"^"_FamilyStatus_"^"_FamilyPhone
	    
	    Set count=count+1
	    If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}		
	    Set resultString = json.getJsonData("FamilyRowId^FamilyCode^DateOfRegister^DateOfInput^Doctor^DoctorName^Nurse^NurseName^Operator^OperatorName^HouseHoldName^FamilyPeopleNum^CurrentNum^FamilyAddress^CommunityCode^FamilyStatus^FamilyPhone",count)
	 	k json
	 	
		Quit resultString
}

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:根据个人档案查询家庭档案
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod GetFamilyInfoWithPersonRowId(PersonRowId As %Integer) As %String
{
		//n (communityCode, start, limit, sort)
		q:(PersonRowId = 0) ""
		Set count=0
		i PersonRowId = "" d
   		.w "{""success"":""false"",""info"":查看家庭档案出错，请选中一行数据！}"
   		.q
   		s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		q:(tempPerson="") ""
		i tempPerson.FamilyRowId = "" d
		.w "{""success"":""false"",""info"":该个人档案未选择户主，请先选择户主！}"
		.q
		Set json = ##class(Code.JsonObj).%New()
		s FamilyRowId = tempPerson.FamilyRowId.%Id()
	    s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
		
		set FamilyCode = tempFamily.FamilyCode
		set DateOfRegister = tempFamily.DateOfRegister
		i DateOfRegister '= "" d
		.s DateOfRegister = $zd(DateOfRegister,3)
		
		set DateOfInput = tempFamily.DateOfInput
		i DateOfInput '= "" d
		.s DateOfInput = $zd(DateOfInput,3)
		.
		set ProvinceName = ""
		set ProvinceDR = ""
		i tempFamily.ProvinceDR '="" d
		. s ProvinceDR = tempFamily.ProvinceDR.%Id()
		. s ProvinceName = tempFamily.ProvinceDR.Description
		.
		set CityName=""
		set CityDR=""
		i tempFamily.CityDR '="" d
		. s CityDR = tempFamily.CityDR.%Id()
		. s CityName = tempFamily.CityDR.Description
		
		set SectionName=""
		set SectionDR="" 
		i tempFamily.SectionDR '="" d
		. s SectionDR = tempFamily.SectionDR.%Id()
		. s SectionName = tempFamily.SectionDR.Description
		.
		set StreetName=""
		set StreetDR=""
		i tempFamily.StreetDR '="" d
		. s StreetDR=tempFamily.StreetDR.%Id()
		. s StreetName = tempFamily.StreetDR.Description 
		.
		set VillageName =""
		set VillageDR =""
		i tempFamily.VillageDR '="" d
		. s VillageDR = tempFamily.VillageDR.%Id()
		. s VillageName = tempFamily.VillageDR.Description
		.
		set DoctorName = ""
		set Doctor = ""
		
		i tempFamily.Doctor '= "" d
		.s Doctor = tempFamily.Doctor
		.s DoctorName = tempFamily.Doctor
		.
		set NurseName = ""
		set Nurse = ""
		i tempFamily.Nurse '= "" d
		.s Nurse = tempFamily.Nurse.%Id()
		.s NurseName = tempFamily.Nurse.SSUSRName
		.
		set OperatorName = ""
		set Operator = ""
		i tempFamily.Operator '= "" d
		.s Operator = tempFamily.Operator.%Id()
		.s OperatorName = tempFamily.Operator.SSUSRName
		.
		set HouseHoldName = tempFamily.HouseHoldName
		set FamilyPeopleNum = tempFamily.FamilyPeopleNum
		set CurrentNum = tempFamily.CurrentNum
		set AverageEarnings = tempFamily.AverageEarnings
		.
		set HouseTypeName = ""
		set HouseType = ""
		i tempFamily.HouseType '= "" d
		.s HouseType = tempFamily.HouseType.%Id()
		.s HouseTypeName = tempFamily.HouseType.Description
		.
		set HouseArea = tempFamily.HouseArea
		.
		set FuelTypeName = ""
		set FuelType = ""
		i tempFamily.FuelType '= "" d
		.s FuelType = tempFamily.FuelType.%Id()
		.s FuelTypeName = tempFamily.FuelType.Description
		.
		set ToiletTypeName = ""
		set ToiletType = ""
		i tempFamily.ToiletType '= "" d
		.s ToiletType = tempFamily.ToiletType.%Id()
		.s ToiletTypeName = tempFamily.ToiletType.Description
		set DoorPlate = tempFamily.DoorPlate
		//set VillageDR = tempFamily.VillageDR
		set FamilyAddress = tempFamily.FamilyAddress
		set FamilyPhone = tempFamily.FamilyPhone
		set CellPhone = tempFamily.CellPhone
		set EMail = tempFamily.EMail
		set Post = tempFamily.Post
		set CommunityCode = tempFamily.CommunityCode
		set Remark = tempFamily.Remark
		set FamilyStatus = tempFamily.FamilyStatus
		
		s FamilyAddress = ""
	    i tempFamily.ProvinceDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    i tempFamily.CityDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    i tempFamily.SectionDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    i tempFamily.StreetDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		;i tempFamily.VillageDR '= "" d
	   	;.s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	   	s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    i tempFamily.DoorPlate '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	    
		s VillageName = tempFamily.VillageName
		s bEarthquakeFamily = tempFamily.bEarthquakeFamily
		s WaterSource = tempFamily.WaterSource
		Set tmp= FamilyRowId_"^"_FamilyCode_"^"_DateOfRegister_"^"_DateOfInput_"^"_Doctor_"^"_DoctorName_"^"_Nurse_"^"_NurseName_"^"_ProvinceDR_"^"_ProvinceName_"^"_CityDR_"^"_CityName_"^"_SectionDR_"^"_SectionName_"^"_StreetDR_"^"_StreetName_"^"_Operator_"^"_OperatorName_"^"_HouseHoldName_"^"_FamilyPeopleNum_"^"_CurrentNum_"^"_AverageEarnings_"^"_HouseType_"^"_HouseTypeName_"^"_HouseArea_"^"_FuelType_"^"_FuelTypeName_"^"_ToiletType_"^"_ToiletTypeName_"^"_FamilyAddress_"^"_FamilyPhone_"^"_CellPhone_"^"_EMail_"^"_Post_"^"_CommunityCode_"^"_Remark_"^"_FamilyStatus_"^"_VillageDR_"^"_DoorPlate_"^"_VillageName_"^"_bEarthquakeFamily_"^"_WaterSource
	    Set count=count+1
		d json.InsertRowData(tmp)		
	    Set resultString = json.getJsonData("FamilyRowId^FamilyCode^DateOfRegister^DateOfInput^Doctor^DoctorName^Nurse^NurseName^ProvinceDR^ProvinceName^CityDR^CityName^SectionDR^SectionName^StreetDR^StreetName^Operator^OperatorName^HouseHoldName^FamilyPeopleNum^CurrentNum^AverageEarnings^HouseType^HouseTypeName^HouseArea^FuelType^FuelTypeName^ToiletType^ToiletTypeName^FamilyAddress^FamilyPhone^CellPhone^EMail^Post^CommunityCode^Remark^FamilyStatus^VillageDR^DoorPlate^VillageName^bEarthquakeFamily^WaterSource",count)
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
		q:(FamilyRowId = 0) ""
		//n (communityCode, start, limit, sort)
		Set count=0
		i FamilyRowId = "" d
   		.w "{""success"":""false"",""info"":家庭档案号不能为空！}"
   		q:(FamilyRowId = "") ""
   		Set json = ##class(Code.JsonObj).%New()
	    s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
		
		set FamilyCode = tempFamily.FamilyCode
		set DateOfRegister = tempFamily.DateOfRegister
		i DateOfRegister '= "" d
		.s DateOfRegister = $zd(DateOfRegister,3)
		
		set DateOfInput = tempFamily.DateOfInput
		i DateOfInput '= "" d
		.s DateOfInput = $zd(DateOfInput,3)
		.
		set ProvinceName = ""
		set ProvinceDR = ""
		i tempFamily.ProvinceDR '="" d
		. s ProvinceDR = tempFamily.ProvinceDR.%Id()
		. s ProvinceName = tempFamily.ProvinceDR.Description
		.
		set CityName=""
		set CityDR=""
		i tempFamily.CityDR '="" d
		. s CityDR = tempFamily.CityDR.%Id()
		. s CityName = tempFamily.CityDR.Description
		
		set SectionName=""
		set SectionDR="" 
		i tempFamily.SectionDR '="" d
		. s SectionDR = tempFamily.SectionDR.%Id()
		. s SectionName = tempFamily.SectionDR.Description
		.
		set StreetName=""
		set StreetDR=""
		i tempFamily.StreetDR '="" d
		. s StreetDR=tempFamily.StreetDR.%Id()
		. s StreetName = tempFamily.StreetDR.Description 
		.
		set VillageName =""
		set VillageDR =""
		i tempFamily.VillageDR '="" d
		. s VillageDR = tempFamily.VillageDR.%Id()
		. s VillageName = tempFamily.VillageDR.Description
		.
		set DoctorName = ""
		set Doctor = ""
		
		i tempFamily.Doctor '= "" d
		.s Doctor = tempFamily.Doctor
		.s DoctorName = tempFamily.Doctor
		.
		set NurseName = ""
		set Nurse = ""
		i tempFamily.Nurse '= "" d
		.s Nurse = tempFamily.Nurse.%Id()
		.s NurseName = tempFamily.Nurse.SSUSRName
		.
		set OperatorName = ""
		set Operator = ""
		i tempFamily.Operator '= "" d
		.s Operator = tempFamily.Operator.%Id()
		.s OperatorName = tempFamily.Operator.SSUSRName
		.
		set HouseHoldName = tempFamily.HouseHoldName
		set FamilyPeopleNum = tempFamily.FamilyPeopleNum
		set CurrentNum = tempFamily.CurrentNum
		set AverageEarnings = tempFamily.AverageEarnings
		.
		set HouseTypeName = ""
		set HouseType = ""
		i tempFamily.HouseType '= "" d
		.s HouseType = tempFamily.HouseType.%Id()
		.s HouseTypeName = tempFamily.HouseType.Description
		.
		set HouseArea = tempFamily.HouseArea
		.
		set FuelTypeName = ""
		set FuelType = ""
		i tempFamily.FuelType '= "" d
		.s FuelType = tempFamily.FuelType.%Id()
		.s FuelTypeName = tempFamily.FuelType.Description
		.
		set ToiletTypeName = ""
		set ToiletType = ""
		i tempFamily.ToiletType '= "" d
		.s ToiletType = tempFamily.ToiletType.%Id()
		.s ToiletTypeName = tempFamily.ToiletType.Description
		set DoorPlate = tempFamily.DoorPlate
		//set VillageDR = tempFamily.VillageDR
		set FamilyAddress = tempFamily.FamilyAddress
		set FamilyPhone = tempFamily.FamilyPhone
		set CellPhone = tempFamily.CellPhone
		set EMail = tempFamily.EMail
		set Post = tempFamily.Post
		set CommunityCode = tempFamily.CommunityCode
		set Remark = tempFamily.Remark
		set FamilyStatus = tempFamily.FamilyStatus
		
		s FamilyAddress = ""
	    i tempFamily.ProvinceDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    i tempFamily.CityDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    i tempFamily.SectionDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    i tempFamily.StreetDR '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		;i tempFamily.VillageDR '= "" d
	   	;.s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	   	s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    i tempFamily.DoorPlate '= "" d
	    .s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
		s VillageName = tempFamily.VillageName
		s bEarthquakeFamily = tempFamily.bEarthquakeFamily
		s WaterSource = tempFamily.WaterSource
		Set tmp= FamilyRowId_"^"_FamilyCode_"^"_DateOfRegister_"^"_DateOfInput_"^"_Doctor_"^"_DoctorName_"^"_Nurse_"^"_NurseName_"^"_ProvinceDR_"^"_ProvinceName_"^"_CityDR_"^"_CityName_"^"_SectionDR_"^"_SectionName_"^"_StreetDR_"^"_StreetName_"^"_Operator_"^"_OperatorName_"^"_HouseHoldName_"^"_FamilyPeopleNum_"^"_CurrentNum_"^"_AverageEarnings_"^"_HouseType_"^"_HouseTypeName_"^"_HouseArea_"^"_FuelType_"^"_FuelTypeName_"^"_ToiletType_"^"_ToiletTypeName_"^"_FamilyAddress_"^"_FamilyPhone_"^"_CellPhone_"^"_EMail_"^"_Post_"^"_CommunityCode_"^"_Remark_"^"_FamilyStatus_"^"_VillageDR_"^"_DoorPlate_"^"_VillageName_"^"_bEarthquakeFamily_"^"_WaterSource
	    Set count=count+1
		d json.InsertRowData(tmp)		
	    Set resultString = json.getJsonData("FamilyRowId^FamilyCode^DateOfRegister^DateOfInput^Doctor^DoctorName^Nurse^NurseName^ProvinceDR^ProvinceName^CityDR^CityName^SectionDR^SectionName^StreetDR^StreetName^Operator^OperatorName^HouseHoldName^FamilyPeopleNum^CurrentNum^AverageEarnings^HouseType^HouseTypeName^HouseArea^FuelType^FuelTypeName^ToiletType^ToiletTypeName^FamilyAddress^FamilyPhone^CellPhone^EMail^Post^CommunityCode^Remark^FamilyStatus^VillageDR^DoorPlate^VillageName^bEarthquakeFamily^WaterSource",count)
	 	k json
	 	
		Quit resultString
}

Storage Default
{
<Data name="FamilySearchServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.FamilySearchServiceD</DataLocation>
<DefaultData>FamilySearchServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.FamilySearchServiceD</IdLocation>
<IndexLocation>^CHSSWeb.FamilySearchServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.FamilySearchServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
