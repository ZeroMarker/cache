Class CHSSWeb.PHRSearchService Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: wangbo
/// CreatDate：2009—06-16
/// Description:根据条件查询个人档案（条件查询）
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// 检索慢性病、传染病语句 " and PersonRowId in (select * from PersonHealthDiagnose where ItemdCode = '22' and ItemAssortCode = '')"
/// Output：
/// Return：
/// Others：
ClassMethod PersonSearchSql(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
		n (communityCode, start, limit, sort, whereStr)
		//q:searchField=""
		//q:searchValue=""
		Set communityCode=$G(communityCode)

		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		s sqlStr = ""
		s result = ##class(%Library.ResultSet).%New()
		;s sqlStr = "SELECT PersonRowId FROM CHSS.PersonHealthRecordMain where CommunityCode = '"_communityCode_"' and isnull(PersonStatus,0) != 3 "_whereStr
		
		
		i start=0 d
		.s sqlStr ="SELECT top "_limit_" PersonRowId FROM CHSS.PersonHealthRecordMain where CommunityCode = '"_communityCode_"' and isnull(PersonStatus,0) != 3 "_whereStr
		e  d
		.s sqlStr = "SELECT PersonRowId FROM CHSS.PersonHealthRecordMain where CommunityCode = '"_communityCode_"' and isnull(PersonStatus,0) != 3  and "_searchField_" like '%"_searchValue_"%'"
		
		;绵阳检索不限制社区
		;i start=0 d
		;.s sqlStr ="SELECT top "_limit_" PersonRowId FROM CHSS.PersonHealthRecordMain where  isnull(PersonStatus,0) != 3 "_whereStr
		;e  d
		;.s sqlStr = "SELECT PersonRowId FROM CHSS.PersonHealthRecordMain where  isnull(PersonStatus,0) != 3 "_whereStr
		
		;w sqlStr
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
		set PersonRowId = result.Get("PersonRowId")
		s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		;个人编码
		set PersonCode = tempPerson.PersonCode
		;姓名
		set PersonName = tempPerson.PersonName
		;性别
		set SexDR = ""
		set SexName = ""
		i tempPerson.SexDR '= "" d
		.set SexDR = tempPerson.SexDR.%Id()
		.set SexName = tempPerson.SexDR.CTSEXDesc
		;出生日期
		set Birth = tempPerson.Birth
		i Birth '= "" d
		.s Birth = $zd(Birth,3)
		.
		.
		.
		;个人状态
		set PersonStatus = ""
		set PersonStatusName = ""
		i tempPerson.PersonStatus '= "" d
		.set PersonStatus = tempPerson.PersonStatus.%Id()
		.set PersonStatusName = tempPerson.PersonStatus.Description
		;拼音码
		set SpellCode = tempPerson.SpellCode
		;卡号
		set CardNumber = tempPerson.CardNumber
		;身份证号
		set IDCard = tempPerson.IDCard
		;登记日期
		s DateRegister = tempPerson.DateRegister
	    i DateRegister '= "" d
		.s DateRegister=$zd(DateRegister,3)
		;录入日期
		s DateInput = tempPerson.DateInput
	    i DateInput '= "" d
		.s DateInput=$zd(DateInput,3)
		;与户主关系
		s RelationHourseHoldDR = tempPerson.RelationHourseHoldDR
		
		set RelationHourseHoldDR = ""
		set RelationHourseHoldName = ""
		i tempPerson.RelationHourseHoldDR '= "" d
		.set RelationHourseHoldDR = tempPerson.RelationHourseHoldDR.%Id()
		.set RelationHourseHoldName = tempPerson.RelationHourseHoldDR.Description
		;负责医生
		set DoctorName = ""
		set DoctorRegister = ""
		i tempPerson.DoctorRegister '= "" d
		.s DoctorRegister = tempPerson.DoctorRegister
		.s DoctorName = tempPerson.DoctorRegister
		;操作人员
		set OperatorInputName = ""
		set OperatorInput = ""
		i tempPerson.OperatorInput '= "" d
		.s OperatorInput = tempPerson.OperatorInput.%Id()
		.s OperatorInputName = tempPerson.OperatorInput.SSUSRName
		.
		;家庭编号
		s FamilyRowId = ""
		s HouseHoldName = ""
		i tempPerson.FamilyRowId '= "" d
		.s FamilyRowId = tempPerson.FamilyRowId.%Id()
		.s HouseHoldName = tempPerson.FamilyRowId.HouseHoldName
		;户主姓名
		s HouseHoldDR = ""
		S HouseHoldDRName = ""
		i tempPerson.HouseHoldTypeDR '= "" d
		.s HouseHoldDR =tempPerson.HouseHoldTypeDR.%Id()
		.s HouseHoldDRName = tempPerson.HouseHoldTypeDR.Description
		.
	    s FamilyAddress = ""
	    ;家庭地址
	    i FamilyRowId '= "" d
	    .s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    .i tempFamily.ProvinceDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    .i tempFamily.CityDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    .i tempFamily.SectionDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    .i tempFamily.StreetDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		.i tempFamily.VillageDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    .e  d
	    ..s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    .i tempFamily.DoorPlate '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.DoorPlate

	    s Address = tempPerson.Address
	    
	    s LinkManName = tempPerson.LinkManName
		s LinkManPhone = tempPerson.LinkManPhone
		s PersonEmail = tempPerson.PersonEmail
		;Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_RelationHourseHoldDR_"^"_PoliceRowIdDR_"^"_PoliceName_"^"_PersonStatus_"^"_SpellCode_"^"_CardNumber_"^"_IDCard_"^"_WorkPlace_"^"_BirthPlace_"^"_DateOfWork_"^"_DateOFRetire_"^"_RelationHourseHoldDR_"^"_RelationHourseHoldName_"^"_DoctorRegister_"^"_DoctorName_"^"_NurseRegister_"^"_NurseName_"^"_OperatorInput_"^"_OperatorInputName_"^"_NationalityDR_"^"_NationalityDRName_"^"_FamilyRowId_"^"_HouseHoldDR_"^"_DocimialTypeDR_"^"_DocimialTypeDRName_"^"_PointHospitalRowIdDR_"^"_PointHospitalRowIdDRName_"^"_CommitteeDR_"^"_CommitteeDRName_"^"_StreetRowIdDR_"^"_StreetRowIdDRName_"^"_DeformityType_"^"_DeformityTypeName_"^"_StaffOfUpdate_"^"_StaffOfUpdateName_"^"_NationDR_"^"_NationDRName_"^"_BloodTypeDR_"^"_BloodTypeDRName_"^"_MarriageDR_"^"_MarriageDRName_"^"_EducationDR_"^"_EducationDRName_"^"_ProfessionDR_"^"_ProfessionDRName_"^"_DateRegister_"^"_DateInput_"^"_IDCardTypeDR_"^"_IDCardTypeName_"^"_DateOfIDStart_"^"_DateOfIDEnd_"^"_IDCardProvider_"^"_HouseHoldName_"^"_Address_"^"_MedicalInsuranceID_"^"_PersonStatusName_"^"_LinkManName_"^"_LinkManPhone_"^"_MedicalInsuranceTypeDR_"^"_MedicalInsuranceTypeDRName_"^"_HosDiagnoseId_"^"_PersonEmail_"^"_DeformityCode_"^"_HaveDeformityCertificate
	   
	    ;modify by wangbo 2009-12-08
	    Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth
		set tmp=tmp_"^"_FamilyAddress_"^"_Address_"^"_LinkManPhone
		set tmp=tmp_"^"_PersonStatusName_"^"_FamilyRowId_"^"_RelationHourseHoldName_"^"_IDCard

	    Set count=count+1
	    
		If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}
	    Set resultString = json.getJsonData("PersonRowId^PersonCode^PersonName^SexDR^SexName^Birth^FamilyAddress^Address^LinkManPhone^PersonStatusName^FamilyRowId^RelationHourseHoldName^IDCard",count)
	 	k json
	 	
		Quit resultString
}

/// Creator: wangbo
/// CreatDate：2009—06-16
/// Description:根据条件查询个人档案（单个查询）
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod PersonSearch(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, searchField As %String, searchValue As %String) As %String
{
		n (communityCode, start, limit, sort,searchField,searchValue)
		q:(searchField="") ""
		q:(searchValue="") ""
		Set communityCode=$G(communityCode)

		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0

		s result = ##class(%Library.ResultSet).%New()
		
		i start=0 d
		.s sqlStr ="SELECT top "_limit_" PersonRowId FROM CHSS.PersonHealthRecordMain where CommunityCode = '"_communityCode_"' and isnull(PersonStatus,0) != 3  and "_searchField_" like '%"_searchValue_"%'"
		e  d
		.s sqlStr = "SELECT PersonRowId FROM CHSS.PersonHealthRecordMain where CommunityCode = '"_communityCode_"' and isnull(PersonStatus,0) != 3  and "_searchField_" like '%"_searchValue_"%'"
		
		;绵阳检索不限制社区
		;i start=0 d
		;.s sqlStr ="SELECT top "_limit_" PersonRowId FROM CHSS.PersonHealthRecordMain where  isnull(PersonStatus,0) != 3 "_whereStr
		;e  d
		;.s sqlStr = "SELECT PersonRowId FROM CHSS.PersonHealthRecordMain where  isnull(PersonStatus,0) != 3  and "_searchField_" like '%"_searchValue_"%'"

		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
		set PersonRowId = result.Get("PersonRowId")
		s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		set PersonCode = tempPerson.PersonCode
		set PersonName = tempPerson.PersonName
		set SexDR = ""
		set SexName = ""
		i tempPerson.SexDR '= "" d
		.set SexDR = tempPerson.SexDR.%Id()
		.set SexName = tempPerson.SexDR.CTSEXDesc
		set Birth = tempPerson.Birth
		i Birth '= "" d
		.s Birth = $zd(Birth,3)
		.
		.
		.
		set CommitteeDR = $lg(^CHSS.PersonHealthRecordMainD(PersonRowId),32)
		set PoliceRowIdDR = ""
		set PoliceName = ""
		i tempPerson.PoliceRowIdDR '= "" d
		.set PoliceName = tempPerson.PoliceRowIdDR.Description
		.set PoliceRowIdDR = tempPerson.PoliceRowIdDR.%Id()
		.
		set PersonStatus = ""
		set PersonStatusName = ""
		i tempPerson.PersonStatus '= "" d
		.set PersonStatus = tempPerson.PersonStatus.%Id()
		.set PersonStatusName = tempPerson.PersonStatus.Description
		.
		set SpellCode = tempPerson.SpellCode
		set CardNumber = tempPerson.CardNumber
		set IDCard = tempPerson.IDCard
		set WorkPlace = tempPerson.WorkPlace
		set BirthPlace = tempPerson.BirthPlace
		
		s DateOfWork = tempPerson.DateOfWork
		i DateOfWork '= "" d
	    .s DateOfWork=$zd(DateOfWork,3)
	    .
	    s DateOFRetire = tempPerson.DateOFRetire
	    i DateOFRetire '= "" d
		.s DateOFRetire=$zd(DateOFRetire,3)
		.
		s DateRegister = tempPerson.DateRegister
	    i DateRegister '= "" d
		.s DateRegister=$zd(DateRegister,3)
		.
		s DateInput = tempPerson.DateInput
	    i DateInput '= "" d
		.s DateInput=$zd(DateInput,3)
		s HaveDeformityCertificate = tempPerson.HaveDeformityCertificate
		s DeformityCode = tempPerson.DeformityCode
		s RelationHourseHoldDR = tempPerson.RelationHourseHoldDR
		
		set RelationHourseHoldDR = ""
		set RelationHourseHoldName = ""
		i tempPerson.RelationHourseHoldDR '= "" d
		.set RelationHourseHoldDR = tempPerson.RelationHourseHoldDR.%Id()
		.set RelationHourseHoldName = tempPerson.RelationHourseHoldDR.Description
		.
		set DoctorName = ""
		set DoctorRegister = ""
		i tempPerson.DoctorRegister '= "" d
		.s DoctorRegister = tempPerson.DoctorRegister
		.s DoctorName = tempPerson.DoctorRegister
		.
		set NurseName = ""
		set NurseRegister = ""
		i tempPerson.NurseRegister '= "" d
		.s NurseRegister = NurseRegister
		.s NurseName = NurseRegister
		.
		set OperatorInputName = ""
		set OperatorInput = ""
		i tempPerson.OperatorInput '= "" d
		.s OperatorInput = tempPerson.OperatorInput.%Id()
		.s OperatorInputName = tempPerson.OperatorInput.SSUSRName
		.
		s NationalityDR = ""
		s NationalityDRName = ""
		i tempPerson.NationalityDR '= "" d
		.s NationalityDR=tempPerson.NationalityDR.%Id()
		.s NationalityDRName = tempPerson.NationalityDR.CTCOUDesc
		
		s FamilyRowId = ""
		s HouseHoldName = ""
		i tempPerson.FamilyRowId '= "" d
		.s FamilyRowId = tempPerson.FamilyRowId.%Id()
		.s HouseHoldName = tempPerson.FamilyRowId.HouseHoldName
		
		s HouseHoldDR = ""
		
		S HouseHoldDRName = ""
		i tempPerson.HouseHoldTypeDR '= "" d
		.s HouseHoldDR =tempPerson.HouseHoldTypeDR.%Id()
		.s HouseHoldDRName = tempPerson.HouseHoldTypeDR.Description
		.
		
		s DocimialTypeDR = ""
		S DocimialTypeDRName = ""
		i tempPerson.DocimialTypeDR '= "" d
		.s DocimialTypeDR =tempPerson.DocimialTypeDR.%Id()
		.s DocimialTypeDRName = tempPerson.DocimialTypeDR.Description
		.
		.
		s PointHospitalRowIdDR = ""
		S PointHospitalRowIdDRName = ""
		i tempPerson.PointHospitalRowIdDR '= "" d
		.s PointHospitalRowIdDR =tempPerson.PointHospitalRowIdDR.%Id()
		.s PointHospitalRowIdDRName = tempPerson.PointHospitalRowIdDR.Description
		.
		.
		s CommitteeDR = ""
		S CommitteeDRName = ""
		i tempPerson.CommitteeDR '= "" d
		.s CommitteeDR =tempPerson.CommitteeDR.%Id()
		.s CommitteeDRName = tempPerson.CommitteeDR.Description
		.
		s StreetRowIdDR = ""
		S StreetRowIdDRName = ""
		i tempPerson.StreetRowIdDR '= "" d
		.s StreetRowIdDR =tempPerson.StreetRowIdDR.%Id()
		.s StreetRowIdDRName = tempPerson.StreetRowIdDR.Description
		.
		.
		s DeformityType = ""
		S DeformityTypeName = ""
		i tempPerson.DeformityType '= "" d
		.s DeformityType =tempPerson.DeformityType.%Id()
		.s DeformityTypeName = tempPerson.DeformityType.Description
		.
		.
		.
		set StaffOfUpdateName = ""
		set StaffOfUpdate = ""
		i tempPerson.StaffOfUpdate '= "" d
		.s StaffOfUpdate = tempPerson.StaffOfUpdate.%Id()
		.s StaffOfUpdatetName = tempPerson.StaffOfUpdate.SSUSRName
		.
		.
		.
		s NationDR = ""
		S NationDRName = ""
		i tempPerson.NationDR '= "" d
		.s NationDR =tempPerson.NationDR.%Id()
		.s NationDRName = tempPerson.NationDR.CTNATDesc
		.
		.
		.
		s BloodTypeDR = ""
		S BloodTypeDRName = ""
		i tempPerson.BloodTypeDR '= "" d
		.s BloodTypeDR =tempPerson.BloodTypeDR.%Id()
		.s BloodTypeDRName = tempPerson.BloodTypeDR.BLDTDesc
		.
		.
		s MarriageDR = ""
		S MarriageDRName = ""
		i tempPerson.MarriageDR '= "" d
		.s MarriageDR =tempPerson.MarriageDR.%Id()
		.s MarriageDRName = tempPerson.MarriageDR.CTMARDesc
		.
		.
		.
		s EducationDR = ""
		S EducationDRName = ""
		i tempPerson.EducationDR '= "" d
		.s EducationDR =tempPerson.EducationDR.%Id()
		.s EducationDRName = tempPerson.EducationDR.EDUDesc
		.
		.
		.
		s ProfessionDR = ""
		S ProfessionDRName = ""
		i tempPerson.ProfessionDR '= "" d
		.s ProfessionDR =tempPerson.ProfessionDR.%Id()
		.s ProfessionDRName = tempPerson.ProfessionDR.CTOCCDesc
		.
		s IDCardTypeDR = ""
		S IDCardTypeName = ""
		i tempPerson.IDCardTypeDR '= "" d
		.s IDCardTypeDR =tempPerson.IDCardTypeDR.%Id()
		.s IDCardTypeName = tempPerson.IDCardTypeDR.CARDDesc
		.
		s DateOfIDStart = tempPerson.DateOfIDStart
		i DateOfIDStart '= "" d
	    .s DateOfIDStart=$zd(DateOfIDStart,3)
	    .
	    s DateOfIDEnd = tempPerson.DateOfIDEnd
		i DateOfIDEnd '= "" d
	    .s DateOfIDEnd=$zd(DateOfIDEnd,3)
	    .
	    s IDCardProvider = tempPerson.IDCardProvider
	    
	    s FamilyAddress = ""
	    
	    i FamilyRowId '= "" d
	    .s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    .i tempFamily.ProvinceDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    .i tempFamily.CityDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    .i tempFamily.SectionDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    .i tempFamily.StreetDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		.i tempFamily.VillageDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    .e  d
	    ..s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    .i tempFamily.DoorPlate '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.DoorPlate

	    s Address = tempPerson.Address
	    
	    s MedicalInsuranceID = tempPerson.MedicalInsuranceID
	    s LinkManName = tempPerson.LinkManName
		s LinkManPhone = tempPerson.LinkManPhone
		s MedicalInsuranceTypeDR = ""
		s MedicalInsuranceTypeDRName = ""
		i tempPerson.MedicalInsuranceTypeDR '= "" d
		.s MedicalInsuranceTypeDR =tempPerson.MedicalInsuranceTypeDR.%Id()
		.s MedicalInsuranceTypeDRName = tempPerson.MedicalInsuranceTypeDR.Description
		s HosDiagnoseId = tempPerson.HosDiagnoseId
		s PersonEmail = tempPerson.PersonEmail
		;Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_RelationHourseHoldDR_"^"_PoliceRowIdDR_"^"_PoliceName_"^"_PersonStatus_"^"_SpellCode_"^"_CardNumber_"^"_IDCard_"^"_WorkPlace_"^"_BirthPlace_"^"_DateOfWork_"^"_DateOFRetire_"^"_RelationHourseHoldDR_"^"_RelationHourseHoldName_"^"_DoctorRegister_"^"_DoctorName_"^"_NurseRegister_"^"_NurseName_"^"_OperatorInput_"^"_OperatorInputName_"^"_NationalityDR_"^"_NationalityDRName_"^"_FamilyRowId_"^"_HouseHoldDR_"^"_DocimialTypeDR_"^"_DocimialTypeDRName_"^"_PointHospitalRowIdDR_"^"_PointHospitalRowIdDRName_"^"_CommitteeDR_"^"_CommitteeDRName_"^"_StreetRowIdDR_"^"_StreetRowIdDRName_"^"_DeformityType_"^"_DeformityTypeName_"^"_StaffOfUpdate_"^"_StaffOfUpdateName_"^"_NationDR_"^"_NationDRName_"^"_BloodTypeDR_"^"_BloodTypeDRName_"^"_MarriageDR_"^"_MarriageDRName_"^"_EducationDR_"^"_EducationDRName_"^"_ProfessionDR_"^"_ProfessionDRName_"^"_DateRegister_"^"_DateInput_"^"_IDCardTypeDR_"^"_IDCardTypeName_"^"_DateOfIDStart_"^"_DateOfIDEnd_"^"_IDCardProvider_"^"_HouseHoldName_"^"_Address_"^"_MedicalInsuranceID_"^"_PersonStatusName_"^"_LinkManName_"^"_LinkManPhone_"^"_MedicalInsuranceTypeDR_"^"_MedicalInsuranceTypeDRName_"^"_HosDiagnoseId_"^"_PersonEmail
	   
	    ;modify by wangbo 2009-12-08
	    Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth
		set tmp=tmp_"^"_FamilyAddress_"^"_Address_"^"_LinkManPhone_"^"_PersonStatusName_"^"_FamilyRowId_"^"_RelationHourseHoldName
		
	    Set count=count+1
	    
		If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}
	    Set resultString = json.getJsonData("PersonRowId^PersonCode^PersonName^SexDR^SexName^Birth^FamilyAddress^Address^LinkManPhone^PersonStatusName^FamilyRowId^RelationHourseHoldName",count)
	 	k json
	 	
		Quit resultString
}

/// Creator: wangbo
/// CreatDate：2009—06-16
/// Description:根据个人档案号查询个人档案
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod GetPersonInfoWithRowId(PersonRowId) As %String
{
		n (PersonRowId)
		
		i PersonRowId = "" d
   		.w "{""success"":""false"",""info"":个人档案号不能为空！}"
		q:(PersonRowId="") ""
		Set start=0
		Set limit=1
		
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()

		s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		q:(tempPerson = "") ""
		set PersonCode = tempPerson.PersonCode
		set PersonName = tempPerson.PersonName
		set SexDR = ""
		set SexName = ""
		i tempPerson.SexDR '= "" d
		.set SexDR = tempPerson.SexDR.%Id()
		.set SexName = tempPerson.SexDR.CTSEXDesc
		set Birth = tempPerson.Birth
		i Birth '= "" d
		.s Birth = $zd(Birth,3)
		.
		.
		.
		set CommitteeDR = $lg(^CHSS.PersonHealthRecordMainD(PersonRowId),32)
		set PoliceRowIdDR = ""
		set PoliceName = ""
		i tempPerson.PoliceRowIdDR '= "" d
		.set PoliceName = tempPerson.PoliceRowIdDR.Description
		.set PoliceRowIdDR = tempPerson.PoliceRowIdDR.%Id()
		.
		set PersonStatus = ""
		set PersonStatusName = ""
		i tempPerson.PersonStatus '= "" d
		.set PersonStatus = tempPerson.PersonStatus.%Id()
		.set PersonStatusName = tempPerson.PersonStatus.Description
		.
		set SpellCode = tempPerson.SpellCode
		set CardNumber = tempPerson.CardNumber
		set IDCard = tempPerson.IDCard
		set WorkPlace = tempPerson.WorkPlace
		set BirthPlace = tempPerson.BirthPlace
		
		s DateOfWork = tempPerson.DateOfWork
		i DateOfWork '= "" d
	    .s DateOfWork=$zd(DateOfWork,3)
	    .
	    s DateOFRetire = tempPerson.DateOFRetire
	    i DateOFRetire '= "" d
		.s DateOFRetire=$zd(DateOFRetire,3)
		.
		s DateRegister = tempPerson.DateRegister
	    i DateRegister '= "" d
		.s DateRegister=$zd(DateRegister,3)
		.
		s DateInput = tempPerson.DateInput
	    i DateInput '= "" d
		.s DateInput=$zd(DateInput,3)
		s HaveDeformityCertificate = tempPerson.HaveDeformityCertificate
		s DeformityCode = tempPerson.DeformityCode
		s RelationHourseHoldDR = tempPerson.RelationHourseHoldDR
		
		set RelationHourseHoldDR = ""
		set RelationHourseHoldName = ""
		i tempPerson.RelationHourseHoldDR '= "" d
		.set RelationHourseHoldDR = tempPerson.RelationHourseHoldDR.%Id()
		.set RelationHourseHoldName = tempPerson.RelationHourseHoldDR.Description
		.
		set DoctorName = ""
		set DoctorRegister = ""
		i tempPerson.DoctorRegister '= "" d
		.s DoctorRegister = tempPerson.DoctorRegister
		.s DoctorName = tempPerson.DoctorRegister
		.
		set NurseName = ""
		set NurseRegister = ""
		i tempPerson.NurseRegister '= "" d
		.s NurseRegister = tempPerson.NurseRegister.%Id()
		.s NurseName = tempPerson.NurseRegister.SSUSRName
		.
		set OperatorInputName = ""
		set OperatorInput = ""
		i tempPerson.OperatorInput '= "" d
		.s OperatorInput = tempPerson.OperatorInput.%Id()
		.s OperatorInputName = tempPerson.OperatorInput.SSUSRName
		.
		s NationalityDR = ""
		s NationalityDRName = ""
		i tempPerson.NationalityDR '= "" d
		.s NationalityDR=tempPerson.NationalityDR.%Id()
		.s NationalityDRName = tempPerson.NationalityDR.CTCOUDesc
		
		s FamilyRowId = ""
		s HouseHoldName = ""
		i tempPerson.FamilyRowId '= "" d
		.s FamilyRowId = tempPerson.FamilyRowId.%Id()
		.s HouseHoldName = tempPerson.FamilyRowId.HouseHoldName
		
		s HouseHoldDR = ""
		S HouseHoldDRName = ""
		i tempPerson.HouseHoldTypeDR '= "" d
		.s HouseHoldDR =tempPerson.HouseHoldTypeDR.%Id()
		.s HouseHoldDRName = tempPerson.HouseHoldTypeDR.Description
		.
		
		s DocimialTypeDR = ""
		S DocimialTypeDRName = ""
		i tempPerson.DocimialTypeDR '= "" d
		.s DocimialTypeDR =tempPerson.DocimialTypeDR.%Id()
		.s DocimialTypeDRName = tempPerson.DocimialTypeDR.Description
		.
		.
		s PointHospitalRowIdDR = ""
		S PointHospitalRowIdDRName = ""
		i tempPerson.PointHospitalRowIdDR '= "" d
		.s PointHospitalRowIdDR =tempPerson.PointHospitalRowIdDR.%Id()
		.s PointHospitalRowIdDRName = tempPerson.PointHospitalRowIdDR.Description
		.
		.
		s CommitteeDR = ""
		S CommitteeDRName = ""
		i tempPerson.CommitteeDR '= "" d
		.s CommitteeDR =tempPerson.CommitteeDR.%Id()
		.s CommitteeDRName = tempPerson.CommitteeDR.Description
		.
		s StreetRowIdDR = ""
		S StreetRowIdDRName = ""
		i tempPerson.StreetRowIdDR '= "" d
		.s StreetRowIdDR =tempPerson.StreetRowIdDR.%Id()
		.s StreetRowIdDRName = tempPerson.StreetRowIdDR.Description
		.
		.
		s DeformityType = ""
		S DeformityTypeName = ""
		i tempPerson.DeformityType '= "" d
		.s DeformityType =tempPerson.DeformityType.%Id()
		.s DeformityTypeName = tempPerson.DeformityType.Description
		.
		.
		.
		set StaffOfUpdateName = ""
		set StaffOfUpdate = ""
		i tempPerson.StaffOfUpdate '= "" d
		.s StaffOfUpdate = tempPerson.StaffOfUpdate.%Id()
		.s StaffOfUpdatetName = tempPerson.StaffOfUpdate.SSUSRName
		.
		.
		.
		s NationDR = ""
		S NationDRName = ""
		i tempPerson.NationDR '= "" d
		.s NationDR =tempPerson.NationDR.%Id()
		.s NationDRName = tempPerson.NationDR.CTNATDesc
		.
		.
		.
		s BloodTypeDR = ""
		S BloodTypeDRName = ""
		i tempPerson.BloodTypeDR '= "" d
		.s BloodTypeDR =tempPerson.BloodTypeDR.%Id()
		.s BloodTypeDRName = tempPerson.BloodTypeDR.BLDTDesc
		.
		.
		s MarriageDR = ""
		S MarriageDRName = ""
		i tempPerson.MarriageDR '= "" d
		.s MarriageDR =tempPerson.MarriageDR.%Id()
		.s MarriageDRName = tempPerson.MarriageDR.CTMARDesc
		.
		.
		.
		s EducationDR = ""
		S EducationDRName = ""
		i tempPerson.EducationDR '= "" d
		.s EducationDR =tempPerson.EducationDR.%Id()
		.s EducationDRName = tempPerson.EducationDR.EDUDesc
		.
		.
		.
		s ProfessionDR = ""
		S ProfessionDRName = ""
		i tempPerson.ProfessionDR '= "" d
		.s ProfessionDR =tempPerson.ProfessionDR.%Id()
		.s ProfessionDRName = tempPerson.ProfessionDR.CTOCCDesc
		.
		s IDCardTypeDR = ""
		S IDCardTypeName = ""
		i tempPerson.IDCardTypeDR '= "" d
		.s IDCardTypeDR =tempPerson.IDCardTypeDR.%Id()
		.s IDCardTypeName = tempPerson.IDCardTypeDR.CARDDesc
		.
		s DateOfIDStart = tempPerson.DateOfIDStart
		i DateOfIDStart '= "" d
	    .s DateOfIDStart=$zd(DateOfIDStart,3)
	    .
	    s DateOfIDEnd = tempPerson.DateOfIDEnd
		i DateOfIDEnd '= "" d
	    .s DateOfIDEnd=$zd(DateOfIDEnd,3)
	    .
	    s IDCardProvider = tempPerson.IDCardProvider
	    
	    s Address = ""
	    
	    i FamilyRowId '= "" d
	    .s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    .i tempFamily.ProvinceDR '= "" d
	    ..s Address = Address_tempFamily.ProvinceDR.Description
	    .i tempFamily.CityDR '= "" d
	    ..s Address = Address_tempFamily.CityDR.Description
	    .i tempFamily.SectionDR '= "" d
	   	..s Address = Address_tempFamily.SectionDR.Description
	    .i tempFamily.StreetDR '= "" d
	    ..s Address = Address_tempFamily.StreetDR.Description
		.i tempFamily.VillageDR '= "" d
	    ..;s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    .e  d
	    ..s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    .i tempFamily.DoorPlate '= "" d
	    ..s Address = Address_tempFamily.DoorPlate
	    
	    s MedicalInsuranceID = tempPerson.MedicalInsuranceID
	    s LinkManName = tempPerson.LinkManName
		s LinkManPhone = tempPerson.LinkManPhone
		s MedicalInsuranceTypeDR = ""
		s MedicalInsuranceTypeDRName = ""
		i tempPerson.MedicalInsuranceTypeDR '= "" d
		.s MedicalInsuranceTypeDR =tempPerson.MedicalInsuranceTypeDR.%Id()
		.s MedicalInsuranceTypeDRName = tempPerson.MedicalInsuranceTypeDR.Description
		s HosDiagnoseId = tempPerson.HosDiagnoseId
		s PersonEmail = tempPerson.PersonEmail
		Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_RelationHourseHoldDR_"^"_PoliceRowIdDR_"^"_PoliceName_"^"_PersonStatus_"^"_SpellCode_"^"_CardNumber_"^"_IDCard_"^"_WorkPlace_"^"_BirthPlace_"^"_DateOfWork_"^"_DateOFRetire_"^"_RelationHourseHoldDR_"^"_RelationHourseHoldName_"^"_DoctorRegister_"^"_DoctorName_"^"_NurseRegister_"^"_NurseName_"^"_OperatorInput_"^"_OperatorInputName_"^"_NationalityDR_"^"_NationalityDRName_"^"_FamilyRowId_"^"_HouseHoldDR_"^"_DocimialTypeDR_"^"_DocimialTypeDRName_"^"_PointHospitalRowIdDR_"^"_PointHospitalRowIdDRName_"^"_CommitteeDR_"^"_CommitteeDRName_"^"_StreetRowIdDR_"^"_StreetRowIdDRName_"^"_DeformityType_"^"_DeformityTypeName_"^"_StaffOfUpdate_"^"_StaffOfUpdateName_"^"_NationDR_"^"_NationDRName_"^"_BloodTypeDR_"^"_BloodTypeDRName_"^"_MarriageDR_"^"_MarriageDRName_"^"_EducationDR_"^"_EducationDRName_"^"_ProfessionDR_"^"_ProfessionDRName_"^"_DateRegister_"^"_DateInput_"^"_IDCardTypeDR_"^"_IDCardTypeName_"^"_DateOfIDStart_"^"_DateOfIDEnd_"^"_IDCardProvider_"^"_HouseHoldName_"^"_Address_"^"_MedicalInsuranceID_"^"_PersonStatusName_"^"_LinkManName_"^"_LinkManPhone_"^"_MedicalInsuranceTypeDR_"^"_MedicalInsuranceTypeDRName_"^"_HosDiagnoseId_"^"_PersonEmail
	    Set count=count+1
	    
		If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)

	    Set resultString = json.getJsonData("PersonRowId^PersonCode^PersonName^SexDR^SexName^Birth^RelationHourseHoldDR^PoliceRowIdDR^PoliceName^PersonStatus^SpellCode^CardNumber^IDCard^WorkPlace^BirthPlace^DateOfWork^DateOFRetire^RelationHourseHoldDR^RelationHourseHoldName^DoctorRegister^DoctorName^NurseRegister^NurseName^OperatorInput^OperatorInputName^NationalityDR^NationalityDRName^FamilyRowId^HouseHoldDR^DocimialTypeDR^DocimialTypeDRName^PointHospitalRowIdDR^PointHospitalRowIdDRName^CommitteeDR^CommitteeDRName^StreetRowIdDR^StreetRowIdDRName^DeformityType^DeformityTypeName^StaffOfUpdate^StaffOfUpdateName^NationDR^NationDRName^BloodTypeDR^BloodTypeDRName^MarriageDR^MarriageDRName^EducationDR^EducationDRName^ProfessionDR^ProfessionDRName^DateRegister^DateInput^IDCardTypeDR^IDCardTypeName^DateOfIDStart^DateOfIDEnd^IDCardProvider^HouseHoldName1^Address^MedicalInsuranceID^PersonStatusName^LinkManName^LinkManPhone^MedicalInsuranceTypeDR^MedicalInsuranceTypeDRName^HosDiagnoseId^PersonEmail",count)
	 	k json
	 	
		Quit resultString
}

/// Creator: wangbo
/// CreatDate：2010—01-08
/// Description:根据条件查询个人档案（条件查询）
/// 该查询供电子健康档案浏览器使用
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod PersonSearchSqlForBrowser(start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
		n (start, limit, sort, whereStr)

		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0

		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT PersonRowId FROM CHSS.PersonHealthRecordMain where 1=1 "
		;_whereStr
		i whereStr '= "" d
		.s sqlStr = sqlStr_whereStr
		;w sqlStr
		s ^tempWhere = sqlStr
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
		set PersonRowId = result.Get("PersonRowId")
		
		s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		set PersonCode = tempPerson.PersonCode
		set PersonName = tempPerson.PersonName
		set SexDR = ""
		set SexName = ""
		i tempPerson.SexDR '= "" d
		.set SexDR = tempPerson.SexDR.%Id()
		.set SexName = tempPerson.SexDR.CTSEXDesc
		set Birth = tempPerson.Birth
		i Birth '= "" d
		.s Birth = $zd(Birth,3)
		.
		.
		.
		set PersonStatus = ""
		set PersonStatusName = ""
		i tempPerson.PersonStatus '= "" d
		.set PersonStatus = tempPerson.PersonStatus.%Id()
		.set PersonStatusName = tempPerson.PersonStatus.Description
		.
		set SpellCode = tempPerson.SpellCode
		set CardNumber = tempPerson.CardNumber
		set IDCard = tempPerson.IDCard
		
		s DateRegister = tempPerson.DateRegister
	    i DateRegister '= "" d
		.s DateRegister=$zd(DateRegister,3)
		.
		s DateInput = tempPerson.DateInput
	    i DateInput '= "" d
		.s DateInput=$zd(DateInput,3)
		;与户主关系
		s RelationHourseHoldDR = tempPerson.RelationHourseHoldDR
		
		set RelationHourseHoldDR = ""
		set RelationHourseHoldName = ""
		i tempPerson.RelationHourseHoldDR '= "" d
		.set RelationHourseHoldDR = tempPerson.RelationHourseHoldDR.%Id()
		.set RelationHourseHoldName = tempPerson.RelationHourseHoldDR.Description
		.
		set DoctorName = ""
		set DoctorRegister = ""
		i tempPerson.DoctorRegister '= "" d
		.s DoctorRegister = tempPerson.DoctorRegister
		.s DoctorName = tempPerson.DoctorRegister
		.
		set OperatorInputName = ""
		set OperatorInput = ""
		i tempPerson.OperatorInput '= "" d
		.s OperatorInput = tempPerson.OperatorInput.%Id()
		.s OperatorInputName = tempPerson.OperatorInput.SSUSRName
		.
		
		s FamilyRowId = ""
		s HouseHoldName = ""
		i tempPerson.FamilyRowId '= "" d
		.s FamilyRowId = tempPerson.FamilyRowId.%Id()
		.s HouseHoldName = tempPerson.FamilyRowId.HouseHoldName
		
		s HouseHoldDR = ""
		S HouseHoldDRName = ""
		i tempPerson.HouseHoldTypeDR '= "" d
		.s HouseHoldDR =tempPerson.HouseHoldTypeDR.%Id()
		.s HouseHoldDRName = tempPerson.HouseHoldTypeDR.Description
		.
		;家庭地址
	    s FamilyAddress = ""
	    
	    i FamilyRowId '= "" d
	    .s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    .i tempFamily.ProvinceDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    .i tempFamily.CityDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    .i tempFamily.SectionDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    .i tempFamily.StreetDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		.i tempFamily.VillageDR '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    .e  d
	    ..s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    .i tempFamily.DoorPlate '= "" d
	    ..s FamilyAddress = FamilyAddress_tempFamily.DoorPlate

	    s Address = tempPerson.Address
	    
	    s LinkManName = tempPerson.LinkManName
		s LinkManPhone = tempPerson.LinkManPhone
		s PersonEmail = tempPerson.PersonEmail
		;Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_RelationHourseHoldDR_"^"_PoliceRowIdDR_"^"_PoliceName_"^"_PersonStatus_"^"_SpellCode_"^"_CardNumber_"^"_IDCard_"^"_WorkPlace_"^"_BirthPlace_"^"_DateOfWork_"^"_DateOFRetire_"^"_RelationHourseHoldDR_"^"_RelationHourseHoldName_"^"_DoctorRegister_"^"_DoctorName_"^"_NurseRegister_"^"_NurseName_"^"_OperatorInput_"^"_OperatorInputName_"^"_NationalityDR_"^"_NationalityDRName_"^"_FamilyRowId_"^"_HouseHoldDR_"^"_DocimialTypeDR_"^"_DocimialTypeDRName_"^"_PointHospitalRowIdDR_"^"_PointHospitalRowIdDRName_"^"_CommitteeDR_"^"_CommitteeDRName_"^"_StreetRowIdDR_"^"_StreetRowIdDRName_"^"_DeformityType_"^"_DeformityTypeName_"^"_StaffOfUpdate_"^"_StaffOfUpdateName_"^"_NationDR_"^"_NationDRName_"^"_BloodTypeDR_"^"_BloodTypeDRName_"^"_MarriageDR_"^"_MarriageDRName_"^"_EducationDR_"^"_EducationDRName_"^"_ProfessionDR_"^"_ProfessionDRName_"^"_DateRegister_"^"_DateInput_"^"_IDCardTypeDR_"^"_IDCardTypeName_"^"_DateOfIDStart_"^"_DateOfIDEnd_"^"_IDCardProvider_"^"_HouseHoldName_"^"_Address_"^"_MedicalInsuranceID_"^"_PersonStatusName_"^"_LinkManName_"^"_LinkManPhone_"^"_MedicalInsuranceTypeDR_"^"_MedicalInsuranceTypeDRName_"^"_HosDiagnoseId_"^"_PersonEmail_"^"_DeformityCode_"^"_HaveDeformityCertificate
	   
	    ;modify by wangbo 2009-12-08
	    Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth
		set tmp=tmp_"^"_FamilyAddress_"^"_Address_"^"_LinkManPhone
		set tmp=tmp_"^"_PersonStatusName_"^"_FamilyRowId_"^"_RelationHourseHoldName_"^"_IDCard

	    Set count=count+1
	    
		If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}
	    Set resultString = json.getJsonData("PersonRowId^PersonCode^PersonName^SexDR^SexName^Birth^FamilyAddress^Address^LinkManPhone^PersonStatusName^FamilyRowId^RelationHourseHoldName^IDCard",count)
	 	k json
	 	
		Quit resultString
}

Storage Default
{
<Data name="PHRSearchServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PHRSearchServiceD</DataLocation>
<DefaultData>PHRSearchServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PHRSearchServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PHRSearchServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PHRSearchServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
