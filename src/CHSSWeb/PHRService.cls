/// Modify:2009-08-03 by wangbo 增加删除个人档案功能
Class CHSSWeb.PHRService Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

ClassMethod GetAge(birthdate As %String) As %Integer
{
	S birth = $zd(birthdate,3)
	S today = $zd($h,3)
	s age = $E(today,1,4)- $E(birth,1,4)
	S birth = $E(today,1,4)_$E(birth,5,10)
	i ($zdh(birth,3)-$h>0) d
	.s age=age-1
	i age=-1 d
	.s age=0
	q age
}

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:检索社区编号个人档案列表
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
/// Modify:2009-07-21 by wangbo 增加就诊号
ClassMethod PersonList(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, searchField As %String, searchValue As %String) As %String
{
		n (communityCode, start, limit, sort)
		Set communityCode=$G(communityCode)

		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		s rowcount = 0
		
		&SQL(select count(*) into rowcount from  CHSS.PersonHealthRecordMain where CommunityCode = :communityCode and isnull(PersonStatus,0) != 3  )
		Set CommunityCode = " "_communityCode
		
		s middle = rowcount/2
		;w start_"-"_middle,!
		if (start <= middle)
		{
		For  Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("CommunityCodeIndex",CommunityCode,PersonRowId)) q:(PersonRowId="")!(count>end)  d
		.
		.s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		.;设置显示颜色
		.s Color = "blue"
		.set Birth = tempPerson.Birth
		.i Birth '= "" d
		..s Age = ..GetAge(Birth)
		..i Age > 60 d
		...s Color = "red"
		..
		.set PersonCode = "<font color="_Color_">"_tempPerson.PersonCode_"</font>"
		.set PersonName = tempPerson.PersonName
		.set SexDR = ""
		.set SexName = ""
		.i tempPerson.SexDR '= "" d
		..set SexDR = tempPerson.SexDR.%Id()
		..set SexName = tempPerson.SexDR.CTSEXDesc
		..s SexName = "<font color="_Color_">"_SexName_"</font>"
		..
		.
		.i Birth '= "" d
		..s Birth = $zd(Birth,3)
		..s Age = "<font color="_Color_">"_Age_"</font>"
		.
		.;个人档案状态
		.set PersonStatus = ""
		.set PersonStatusName = ""
		.i tempPerson.PersonStatus '= "" d
		..set PersonStatus = tempPerson.PersonStatus.%Id()
		..set PersonStatusName = tempPerson.PersonStatus.Description
		..
		.set SpellCode = tempPerson.SpellCode
		.set CardNumber = tempPerson.CardNumber
		.set IDCard = tempPerson.IDCard
		.;登记日期
		.s DateRegister = tempPerson.DateRegister
	    .i DateRegister '= "" d
		..s DateRegister=$zd(DateRegister,3)
		.;录入日期
		.s DateInput = tempPerson.DateInput
	    .i DateInput '= "" d
		..s DateInput=$zd(DateInput,3)
		.;与户主关系
		.s RelationHourseHoldDR = tempPerson.RelationHourseHoldDR
		.
		.set RelationHourseHoldDR = ""
		.set RelationHourseHoldName = ""
		.i tempPerson.RelationHourseHoldDR '= "" d
		..set RelationHourseHoldDR = tempPerson.RelationHourseHoldDR.%Id()
		..set RelationHourseHoldName = tempPerson.RelationHourseHoldDR.Description
		.;责任医生
		.set DoctorName = ""
		.set DoctorRegister = ""
		.i tempPerson.DoctorRegister '= "" d
		..s DoctorRegister = tempPerson.DoctorRegister
		..s DoctorName = tempPerson.DoctorRegister
		.;操作人员
		.set OperatorInputName = ""
		.set OperatorInput = ""
		.i tempPerson.OperatorInput '= "" d
		..s OperatorInput = tempPerson.OperatorInput.%Id()
		..s OperatorInputName = tempPerson.OperatorInput.SSUSRName
		.
		.
		.s FamilyRowId = ""
		.s HouseHoldName = ""
		.i tempPerson.FamilyRowId '= "" d
		..s FamilyRowId = tempPerson.FamilyRowId.%Id()
		..s HouseHoldName = tempPerson.FamilyRowId.HouseHoldName
		.
		.s HouseHoldDR = ""
		.S HouseHoldDRName = ""
		.i tempPerson.HouseHoldTypeDR '= "" d
		..s HouseHoldDR =tempPerson.HouseHoldTypeDR.%Id()
		..s HouseHoldDRName = tempPerson.HouseHoldTypeDR.Description
		.;家庭地址
	    .s FamilyAddress = ""
	    .
	    .i FamilyRowId '= "" d
	    ..s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    ..i tempFamily.ProvinceDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    ..i tempFamily.CityDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    ..i tempFamily.SectionDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    ..i tempFamily.StreetDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		..i tempFamily.VillageDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    ..e  d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    ..i tempFamily.DoorPlate '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
		.
	    .s Address = tempPerson.Address
	    .
	    .s LinkManName = tempPerson.LinkManName
		.s LinkManPhone = tempPerson.LinkManPhone
		.s PersonEmail = tempPerson.PersonEmail
		.;Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_RelationHourseHoldDR_"^"_PoliceRowIdDR_"^"_PoliceName_"^"_PersonStatus_"^"_SpellCode_"^"_CardNumber_"^"_IDCard_"^"_WorkPlace_"^"_BirthPlace_"^"_DateOfWork_"^"_DateOFRetire_"^"_RelationHourseHoldDR_"^"_RelationHourseHoldName_"^"_DoctorRegister_"^"_DoctorName_"^"_NurseRegister_"^"_NurseName_"^"_OperatorInput_"^"_OperatorInputName_"^"_NationalityDR_"^"_NationalityDRName_"^"_FamilyRowId_"^"_HouseHoldDR_"^"_DocimialTypeDR_"^"_DocimialTypeDRName_"^"_PointHospitalRowIdDR_"^"_PointHospitalRowIdDRName_"^"_CommitteeDR_"^"_CommitteeDRName_"^"_StreetRowIdDR_"^"_StreetRowIdDRName_"^"_DeformityType_"^"_DeformityTypeName_"^"_StaffOfUpdate_"^"_StaffOfUpdateName_"^"_NationDR_"^"_NationDRName_"^"_BloodTypeDR_"^"_BloodTypeDRName_"^"_MarriageDR_"^"_MarriageDRName_"^"_EducationDR_"^"_EducationDRName_"^"_ProfessionDR_"^"_ProfessionDRName_"^"_DateRegister_"^"_DateInput_"^"_IDCardTypeDR_"^"_IDCardTypeName_"^"_DateOfIDStart_"^"_DateOfIDEnd_"^"_IDCardProvider_"^"_HouseHoldName_"^"_Address_"^"_MedicalInsuranceID_"^"_PersonStatusName_"^"_LinkManName_"^"_LinkManPhone_"^"_MedicalInsuranceTypeDR_"^"_MedicalInsuranceTypeDRName_"^"_HosDiagnoseId_"^"_PersonEmail_"^"_DeformityCode_"^"_HaveDeformityCertificate
	   	.
	    .;modify by wangbo 2009-12-08
	    .Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth
		.set tmp=tmp_"^"_FamilyAddress_"^"_Address_"^"_LinkManPhone_"^"_LinkManName
		.set tmp=tmp_"^"_PersonStatusName_"^"_FamilyRowId_"^"_RelationHourseHoldName_"^"_IDCard
		.;modify by wangbo 2010-10-13
		.set tmp=tmp_"^"_Age
		.
		.s count=count+1
		.i (count>start)&(count<=end) d
		..;w tmp
		..d json.InsertRowData(tmp)	
		}
		else
		{
		
		s resultNum = rowcount - start
		s end = resultNum
		s start = end - limit
		s PersonRowId = ""
		For  Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("CommunityCodeIndex",CommunityCode,PersonRowId),-1) q:(count>end)  d
		.
		.;w PersonRowId,!
		.i PersonRowId = "" d
		..q
		.
		.s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		.;设置显示颜色
		.s Color = "blue"
		.set Birth = tempPerson.Birth
		.i Birth '= "" d
		..s Age = ..GetAge(Birth)
		..i Age > 60 d
		...s Color = "red"
		..
		.set PersonCode = "<font color="_Color_">"_tempPerson.PersonCode_"</font>"
		.set PersonName = "<font color="_Color_">"_tempPerson.PersonName_"</font>"
		.set SexDR = ""
		.set SexName = ""
		.i tempPerson.SexDR '= "" d
		..set SexDR = tempPerson.SexDR.%Id()
		..set SexName = tempPerson.SexDR.CTSEXDesc
		..s SexName = "<font color="_Color_">"_SexName_"</font>"
		..
		.
		.i Birth '= "" d
		..s Birth = $zd(Birth,3)
		..s Age = "<font color="_Color_">"_Age_"</font>"
		.
		.;个人档案状态
		.set PersonStatus = ""
		.set PersonStatusName = ""
		.i tempPerson.PersonStatus '= "" d
		..set PersonStatus = tempPerson.PersonStatus.%Id()
		..set PersonStatusName = tempPerson.PersonStatus.Description
		..
		.set SpellCode = tempPerson.SpellCode
		.set CardNumber = tempPerson.CardNumber
		.set IDCard = tempPerson.IDCard
		.;登记日期
		.s DateRegister = tempPerson.DateRegister
	    .i DateRegister '= "" d
		..s DateRegister=$zd(DateRegister,3)
		.;录入日期
		.s DateInput = tempPerson.DateInput
	    .i DateInput '= "" d
		..s DateInput=$zd(DateInput,3)
		.;与户主关系
		.s RelationHourseHoldDR = tempPerson.RelationHourseHoldDR
		.
		.set RelationHourseHoldDR = ""
		.set RelationHourseHoldName = ""
		.i tempPerson.RelationHourseHoldDR '= "" d
		..set RelationHourseHoldDR = tempPerson.RelationHourseHoldDR.%Id()
		..set RelationHourseHoldName = tempPerson.RelationHourseHoldDR.Description
		.;责任医生
		.set DoctorName = ""
		.set DoctorRegister = ""
		.i tempPerson.DoctorRegister '= "" d
		..s DoctorRegister = tempPerson.DoctorRegister
		..s DoctorName = tempPerson.DoctorRegister
		.;操作人员
		.set OperatorInputName = ""
		.set OperatorInput = ""
		.i tempPerson.OperatorInput '= "" d
		..s OperatorInput = tempPerson.OperatorInput.%Id()
		..s OperatorInputName = tempPerson.OperatorInput.SSUSRName
		.
		.
		.s FamilyRowId = ""
		.s HouseHoldName = ""
		.i tempPerson.FamilyRowId '= "" d
		..s FamilyRowId = tempPerson.FamilyRowId.%Id()
		..s HouseHoldName = tempPerson.FamilyRowId.HouseHoldName
		.
		.s HouseHoldDR = ""
		.S HouseHoldDRName = ""
		.i tempPerson.HouseHoldTypeDR '= "" d
		..s HouseHoldDR =tempPerson.HouseHoldTypeDR.%Id()
		..s HouseHoldDRName = tempPerson.HouseHoldTypeDR.Description
		.;家庭地址
	    .s FamilyAddress = ""
	    .
	    .i FamilyRowId '= "" d
	    ..s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    ..i tempFamily.ProvinceDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    ..i tempFamily.CityDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    ..i tempFamily.SectionDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    ..i tempFamily.StreetDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		..i tempFamily.VillageDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    ..e  d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    ..i tempFamily.DoorPlate '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
		.
	    .s Address = tempPerson.Address
	    .
	    .s LinkManName = tempPerson.LinkManName
		.s LinkManPhone = tempPerson.LinkManPhone
		.s PersonEmail = tempPerson.PersonEmail
		.;Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_RelationHourseHoldDR_"^"_PoliceRowIdDR_"^"_PoliceName_"^"_PersonStatus_"^"_SpellCode_"^"_CardNumber_"^"_IDCard_"^"_WorkPlace_"^"_BirthPlace_"^"_DateOfWork_"^"_DateOFRetire_"^"_RelationHourseHoldDR_"^"_RelationHourseHoldName_"^"_DoctorRegister_"^"_DoctorName_"^"_NurseRegister_"^"_NurseName_"^"_OperatorInput_"^"_OperatorInputName_"^"_NationalityDR_"^"_NationalityDRName_"^"_FamilyRowId_"^"_HouseHoldDR_"^"_DocimialTypeDR_"^"_DocimialTypeDRName_"^"_PointHospitalRowIdDR_"^"_PointHospitalRowIdDRName_"^"_CommitteeDR_"^"_CommitteeDRName_"^"_StreetRowIdDR_"^"_StreetRowIdDRName_"^"_DeformityType_"^"_DeformityTypeName_"^"_StaffOfUpdate_"^"_StaffOfUpdateName_"^"_NationDR_"^"_NationDRName_"^"_BloodTypeDR_"^"_BloodTypeDRName_"^"_MarriageDR_"^"_MarriageDRName_"^"_EducationDR_"^"_EducationDRName_"^"_ProfessionDR_"^"_ProfessionDRName_"^"_DateRegister_"^"_DateInput_"^"_IDCardTypeDR_"^"_IDCardTypeName_"^"_DateOfIDStart_"^"_DateOfIDEnd_"^"_IDCardProvider_"^"_HouseHoldName_"^"_Address_"^"_MedicalInsuranceID_"^"_PersonStatusName_"^"_LinkManName_"^"_LinkManPhone_"^"_MedicalInsuranceTypeDR_"^"_MedicalInsuranceTypeDRName_"^"_HosDiagnoseId_"^"_PersonEmail_"^"_DeformityCode_"^"_HaveDeformityCertificate
	   	.
	    .;modify by wangbo 2009-12-08
	    .Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth
		.set tmp=tmp_"^"_FamilyAddress_"^"_Address_"^"_LinkManPhone_"^"_LinkManName
		.set tmp=tmp_"^"_PersonStatusName_"^"_FamilyRowId_"^"_RelationHourseHoldName_"^"_IDCard
		.;modify by wangbo 2010-10-13
		.set tmp=tmp_"^"_Age
		.
		.
		.s count=count+1
		.i (count>start)&(count <= end) d
		..;w "asdfasdfa",!
		..d json.InsertRowData(tmp)	
		.
		}
		

	    Set resultString = json.getJsonData("PersonRowId^PersonCode^PersonName^SexDR^SexName^Birth^FamilyAddress^Address^LinkManPhone^LinkManName^PersonStatusName^FamilyRowId^RelationHourseHoldName^IDCard^Age",rowcount)
	 	k json
		Quit resultString
}

ClassMethod PersonList2(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, searchField As %String, searchValue As %String) As %String
{
		n (communityCode, start, limit, sort)
		Set communityCode=$G(communityCode)

		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		s rowcount = 0
		&SQL(select count(*) into rowcount from  CHSS.PersonHealthRecordMain where CommunityCode = :communityCode and isnull(PersonStatus,0) != 3  )
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT PersonRowId FROM CHSS.PersonHealthRecordMain where CommunityCode = '"_communityCode_"' and isnull(PersonStatus,0) != 3  "
		;w sqlStr
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
		;个人档案状态
		set PersonStatus = ""
		set PersonStatusName = ""
		i tempPerson.PersonStatus '= "" d
		.set PersonStatus = tempPerson.PersonStatus.%Id()
		.set PersonStatusName = tempPerson.PersonStatus.Description
		.
		set SpellCode = tempPerson.SpellCode
		set CardNumber = tempPerson.CardNumber
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
		;责任医生
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
		q:(count>end)
		}
	    Set resultString = json.getJsonData("PersonRowId^PersonCode^PersonName^SexDR^SexName^Birth^FamilyAddress^Address^LinkManPhone^PersonStatusName^FamilyRowId^RelationHourseHoldName^IDCard",rowcount)
	 	k json

		Quit resultString
}

/// Creator: wangbo
/// CreatDate：2009—12-08
/// Description:检索社区编号个人档案列表
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod GetPersonInfoWithId(PersonRowId As %Integer) As %String
{
		n (PersonRowId)
		q:(PersonRowId="") ""
		Set start=0
		Set limit=1
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()

		
		s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		q:(tempPerson="") ""
		i tempPerson '= "" d
		.set PersonCode = tempPerson.PersonCode
		.//&sql(select SexDR into :xx from  CHSS.PersonHealthRecordMain where %ID=:PersonRowId)
		.//b
		.//w "xx:"_$g(xx),!
		.
		.//w ^CHSS.PersonHealthRecordMainD(PersonRowId),!
		.set PersonName = tempPerson.PersonName
		.
		.//i searchValue '= "" d
		.//.i searchField = "PersonName" d
		.//.i searchValue '= PersonName d
		.
		.//查询检索
		.//q:(searchValue'="")&(searchField="PersonName")&(searchValue'=PersonName)
		.
		.set SexDR = ""
		.set SexName = ""
		.i tempPerson.SexDR '= "" d
		..set SexDR = tempPerson.SexDR.%Id()
		..set SexName = tempPerson.SexDR.CTSEXDesc
		.set Birth = tempPerson.Birth
		.i Birth '= "" d
		..s Birth = $zd(Birth,3)
		..
		.
		.
		.set CommitteeDR = $lg(^CHSS.PersonHealthRecordMainD(PersonRowId),32)
		.set PoliceRowIdDR = ""
		.set PoliceName = ""
		.i tempPerson.PoliceRowIdDR '= "" d
		..set PoliceName = tempPerson.PoliceRowIdDR.Description
		..set PoliceRowIdDR = tempPerson.PoliceRowIdDR.%Id()
		.
		.set PersonStatus = ""
		.set PersonStatusName = ""
		.i tempPerson.PersonStatus '= "" d
		..set PersonStatus = tempPerson.PersonStatus.%Id()
		..set PersonStatusName = tempPerson.PersonStatus.Description
		.
		.set SpellCode = tempPerson.SpellCode
		.set CardNumber = tempPerson.CardNumber
		.set IDCard = tempPerson.IDCard
		.set WorkPlace = tempPerson.WorkPlace
		.set BirthPlace = tempPerson.BirthPlace
		.
		.s DateOfWork = tempPerson.DateOfWork
		.i DateOfWork '= "" d
	    ..s DateOfWork=$zd(DateOfWork,3)
	    .
	    .s DateOFRetire = tempPerson.DateOFRetire
	    .i DateOFRetire '= "" d
		..s DateOFRetire=$zd(DateOFRetire,3)
		..
		.s DateRegister = tempPerson.DateRegister
	    .i DateRegister '= "" d
		..s DateRegister=$zd(DateRegister,3)
		..
		.s DateInput = tempPerson.DateInput
	    .i DateInput '= "" d
		..s DateInput=$zd(DateInput,3)
		..
		.s DeformityCode = tempPerson.DeformityCode
		.s HaveDeformityCertificate = tempPerson.HaveDeformityCertificate
		.s RelationHourseHoldDR = tempPerson.RelationHourseHoldDR
		.
		.set RelationHourseHoldDR = ""
		.set RelationHourseHoldName = ""
		.i tempPerson.RelationHourseHoldDR '= "" d
		..set RelationHourseHoldDR = tempPerson.RelationHourseHoldDR.%Id()
		..set RelationHourseHoldName = tempPerson.RelationHourseHoldDR.Description
		..
		.set DoctorName = ""
		.set DoctorRegister = ""
		.i tempPerson.DoctorRegister '= "" d
		..s DoctorRegister = tempPerson.DoctorRegister
		..s DoctorName = tempPerson.DoctorRegister
		..
		.set NurseName = ""
		.set NurseRegister = ""
		.i tempPerson.NurseRegister '= "" d
		..s NurseRegister = tempPerson.NurseRegister
		..s NurseName = tempPerson.NurseRegister
		..
		.set OperatorInputName = ""
		.set OperatorInput = ""
		.i tempPerson.OperatorInput '= "" d
		..s OperatorInput = tempPerson.OperatorInput.%Id()
		..s OperatorInputName = tempPerson.OperatorInput.SSUSRName
		..
		.s NationalityDR = ""
		.s NationalityDRName = ""
		.i tempPerson.NationalityDR '= "" d
		..s NationalityDR=tempPerson.NationalityDR.%Id()
		..s NationalityDRName = tempPerson.NationalityDR.CTCOUDesc
		.
		.s FamilyRowId = ""
		.s HouseHoldName = ""
		.i tempPerson.FamilyRowId '= "" d
		..s FamilyRowId = tempPerson.FamilyRowId.%Id()
		..s HouseHoldNameObj = ##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
		..i HouseHoldNameObj '= "" d
		...s HouseHoldName = HouseHoldNameObj.HouseHoldName
		.
		.s HouseHoldTypeDR = ""
		.S HouseHoldTypeDRName = ""
		.i tempPerson.HouseHoldTypeDR '= "" d
		..s HouseHoldTypeDR =tempPerson.HouseHoldTypeDR.%Id()
		..s HouseHoldTypeDRName = tempPerson.HouseHoldTypeDR.Description
		..
		.
		.s DocimialTypeDR = ""
		.S DocimialTypeDRName = ""
		.i tempPerson.DocimialTypeDR '= "" d
		..s DocimialTypeDR =tempPerson.DocimialTypeDR.%Id()
		..s DocimialTypeDRName = tempPerson.DocimialTypeDR.Description
		..
		.
		.s PointHospitalRowIdDR = ""
		.S PointHospitalRowIdDRName = ""
		.i tempPerson.PointHospitalRowIdDR '= "" d
		..s PointHospitalRowIdDR =tempPerson.PointHospitalRowIdDR.%Id()
		..s PointHospitalRowIdDRName = tempPerson.PointHospitalRowIdDR.Description
		..
		.
		.s CommitteeDR = ""
		.S CommitteeDRName = ""
		.i tempPerson.CommitteeDR '= "" d
		..s CommitteeDR =tempPerson.CommitteeDR.%Id()
		..s CommitteeDRName = tempPerson.CommitteeDR.Description
		..
		.s StreetRowIdDR = ""
		.S StreetRowIdDRName = ""
		.i tempPerson.StreetRowIdDR '= "" d
		..s StreetRowIdDR =tempPerson.StreetRowIdDR.%Id()
		..s StreetRowIdDRName = tempPerson.StreetRowIdDR.Description
		..
		..
		.s DeformityType = ""
		.S DeformityTypeName = ""
		.i tempPerson.DeformityType '= "" d
		..s DeformityType =tempPerson.DeformityType.%Id()
		..s DeformityTypeName = tempPerson.DeformityType.Description
		..
		..
		..
		.set StaffOfUpdateName = ""
		.set StaffOfUpdate = ""
		.i tempPerson.StaffOfUpdate '= "" d
		..s StaffOfUpdate = tempPerson.StaffOfUpdate.%Id()
		..s StaffOfUpdatetName = tempPerson.StaffOfUpdate.SSUSRName
		..
		..
		..
		.s NationDR = ""
		.S NationDRName = ""
		.i tempPerson.NationDR '= "" d
		..s NationDR =tempPerson.NationDR.%Id()
		..s NationDRName = tempPerson.NationDR.CTNATDesc
		..
		..
		..
		.s BloodTypeDR = ""
		.S BloodTypeDRName = ""
		.i tempPerson.BloodTypeDR '= "" d
		..s BloodTypeDR =tempPerson.BloodTypeDR.%Id()
		..s BloodTypeDRName = tempPerson.BloodTypeDR.BLDTDesc
		..
		..
		.s MarriageDR = ""
		.S MarriageDRName = ""
		.i tempPerson.MarriageDR '= "" d
		..s MarriageDR =tempPerson.MarriageDR.%Id()
		..s MarriageDRName = tempPerson.MarriageDR.CTMARDesc
		..
		..
		..
		.s EducationDR = ""
		.S EducationDRName = ""
		.i tempPerson.EducationDR '= "" d
		..s EducationDR =tempPerson.EducationDR.%Id()
		..s EducationDRName = tempPerson.EducationDR.EDUDesc
		..
		..
		..
		.s ProfessionDR = ""
		.S ProfessionDRName = ""
		.i tempPerson.ProfessionDR '= "" d
		..s ProfessionDR =tempPerson.ProfessionDR.%Id()
		..s ProfessionDRName = tempPerson.ProfessionDR.CTOCCDesc
		..
		.s IDCardTypeDR = ""
		.S IDCardTypeName = ""
		.i tempPerson.IDCardTypeDR '= "" d
		..s IDCardTypeDR =tempPerson.IDCardTypeDR.%Id()
		..s IDCardTypeName = tempPerson.IDCardTypeDR.CARDDesc
		..
		.s DateOfIDStart = tempPerson.DateOfIDStart
		.i DateOfIDStart '= "" d
	    ..s DateOfIDStart=$zd(DateOfIDStart,3)
	    ..
	    .s DateOfIDEnd = tempPerson.DateOfIDEnd
		.i DateOfIDEnd '= "" d
	    ..s DateOfIDEnd=$zd(DateOfIDEnd,3)
	    ..
	    .s IDCardProvider = tempPerson.IDCardProvider
	    .
	    .s FamilyAddress = ""
	    .
	    .i FamilyRowId '= "" d
	    ..s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    ..i tempFamily.ProvinceDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    ..i tempFamily.CityDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    ..i tempFamily.SectionDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    ..i tempFamily.StreetDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		..i tempFamily.VillageDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    ..e  d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    ..i tempFamily.DoorPlate '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	    
	    .s MedicalInsuranceID = tempPerson.MedicalInsuranceID
	    .
	    .s Address = tempPerson.Address
	    .
	    .s AddressTypeDR = ""
		.S AddressTypeDRName = ""
		.i tempPerson.AddressTypeDR '= "" d
		..s AddressTypeDR =tempPerson.AddressTypeDR.%Id()
		..s AddressTypeDRName = tempPerson.AddressTypeDR.Description
		.s LinkManName = tempPerson.LinkManName
		.s LinkManPhone = tempPerson.LinkManPhone
		.s MedicalInsuranceTypeDR = ""
		.s MedicalInsuranceTypeDRName = ""
		.i tempPerson.MedicalInsuranceTypeDR '= "" d
		..s MedicalInsuranceTypeDR =tempPerson.MedicalInsuranceTypeDR.%Id()
		..s MedicalInsuranceTypeDRName = tempPerson.MedicalInsuranceTypeDR.Description
		.s HosDiagnoseId = tempPerson.HosDiagnoseId
		.s PersonEmail = tempPerson.PersonEmail
		.s CommunityCode = tempPerson.CommunityCode
		.
		.
		.Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth
		.s tmp=tmp_"^"_RelationHourseHoldDR_"^"_PoliceRowIdDR_"^"_PoliceName_"^"_PersonStatus
		.s tmp=tmp_"^"_SpellCode_"^"_CardNumber_"^"_IDCard_"^"_WorkPlace_"^"_BirthPlace
		.s tmp=tmp_"^"_DateOfWork_"^"_DateOFRetire_"^"_RelationHourseHoldDR_"^"_RelationHourseHoldName
		.s tmp=tmp_"^"_DoctorRegister_"^"_DoctorName_"^"_NurseRegister_"^"_NurseName_"^"_OperatorInput
		.s tmp=tmp_"^"_OperatorInputName_"^"_NationalityDR_"^"_NationalityDRName_"^"_FamilyRowId
		.s tmp=tmp_"^"_$g(HouseHoldDR)_"^"_DocimialTypeDR_"^"_DocimialTypeDRName_"^"_PointHospitalRowIdDR
		.s tmp=tmp_"^"_PointHospitalRowIdDRName_"^"_CommitteeDR_"^"_CommitteeDRName_"^"_StreetRowIdDR
		.s tmp=tmp_"^"_StreetRowIdDRName_"^"_DeformityType_"^"_DeformityTypeName_"^"_StaffOfUpdate
		.s tmp=tmp_"^"_StaffOfUpdateName_"^"_NationDR_"^"_NationDRName_"^"_BloodTypeDR_"^"_BloodTypeDRName
		.s tmp=tmp_"^"_MarriageDR_"^"_MarriageDRName_"^"_EducationDR_"^"_EducationDRName_"^"_ProfessionDR
		.s tmp=tmp_"^"_ProfessionDRName_"^"_DateRegister_"^"_DateInput_"^"_IDCardTypeDR_"^"_IDCardTypeName
		.s tmp=tmp_"^"_DateOfIDStart_"^"_DateOfIDEnd_"^"_IDCardProvider_"^"_HouseHoldName_"^"_FamilyAddress
		.s tmp=tmp_"^"_MedicalInsuranceID_"^"_PersonStatusName_"^"_Address_"^"_AddressTypeDR
		.s tmp=tmp_"^"_AddressTypeDRName_"^"_LinkManName_"^"_LinkManPhone_"^"_MedicalInsuranceTypeDR
		.s tmp=tmp_"^"_MedicalInsuranceTypeDRName_"^"_$g(HosDiagnoseId)_"^"_PersonEmail_"^"_DeformityCode
		.s tmp=tmp_"^"_HaveDeformityCertificate_"^"_HouseHoldTypeDR_"^"_HouseHoldTypeDRName
		.
	    .s tmp2 = ##class(CHSSWeb.PHROtherService).GetPersonOtherInfo(PersonRowId)
	    .s tmp = tmp_tmp2
	    .s resultString2 = ##class(CHSSWeb.PHROtherService).GetPersonOtherColumns()
	    .
	    .;edit by wangbo 2010-03-22
	    .s tmp3 = ##class(CHSSWeb.PersonPhotoService).GetPeronPhotoUrl(PersonRowId)
	    .s tmp = tmp_"^"_tmp3
	    .s resultString2 = resultString2_"^PhotoUrl"
	    .
	    .Set count=count+1
	    .
		.If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
		s resultColumn = "PersonRowId^PersonCode^PersonName^SexDR^SexName^Birth^RelationHourseHoldDR^PoliceRowIdDR^PoliceName^PersonStatus^SpellCode^CardNumber^IDCard^WorkPlace^BirthPlace^DateOfWork^DateOFRetire^RelationHourseHoldDR^RelationHourseHoldName^DoctorRegister^DoctorName^NurseRegister^NurseName^OperatorInput^OperatorInputName^NationalityDR^NationalityDRName^FamilyRowId^HouseHoldDR^DocimialTypeDR^DocimialTypeDRName^PointHospitalRowIdDR^PointHospitalRowIdDRName^CommitteeDR^CommitteeDRName^StreetRowIdDR^StreetRowIdDRName^DeformityType^DeformityTypeName^StaffOfUpdate^StaffOfUpdateName^NationDR^NationDRName^BloodTypeDR^BloodTypeDRName^MarriageDR^MarriageDRName^EducationDR^EducationDRName^ProfessionDR^ProfessionDRName^DateRegister^DateInput^IDCardTypeDR^IDCardTypeName^DateOfIDStart^DateOfIDEnd^IDCardProvider^HouseHoldName1^FamilyAddress^MedicalInsuranceID^PersonStatusName^Address^AddressTypeDR^AddressTypeDRName^LinkManName^LinkManPhone^MedicalInsuranceTypeDR^MedicalInsuranceTypeDRName^HosDiagnoseId^PersonEmail^DeformityCode^HaveDeformityCertificate^HouseHoldTypeDR^HouseHoldTypeDRName"_resultString2
	    Set resultString = json.getJsonData(resultColumn,count)
	 	k json
	 	
		Quit resultString
}

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:根据家庭编码检索家庭成员
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
/// Modify:2009-07-21 by wangbo 增加就诊号
ClassMethod GetFamilyMembers(CommunityCode As %String, FamilyRowId As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
		n (CommunityCode, FamilyRowId, start, limit, sort)
		//q:searchField=""
		//q:searchValue=""
		Set communityCode=$G(CommunityCode)

		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0

		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT PersonRowId,RelationHourseHoldDR FROM CHSS.PersonHealthRecordMain where CommunityCode = '"_communityCode_"' "
		s sqlStr = sqlStr_" and FamilyRowId = "_FamilyRowId
		s sqlStr = sqlStr_" order by RelationHourseHoldDR "
		
		;w sqlStr
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
		set tmp=tmp_"^"_PersonStatusName_"^"_FamilyRowId_"^"_RelationHourseHoldName

	    Set count=count+1
	    
		If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}
	    Set resultString = json.getJsonData("PersonRowId^PersonCode^PersonName^SexDR^SexName^Birth^FamilyAddress^Address^LinkManPhone^PersonStatusName^FamilyRowId^RelationHourseHoldName",count)
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
ClassMethod Insert(PersonCode As %String, CommunityCode As %String, PersonName As %String, SexDR As %Integer, Birth As %Date, SpellCode As %String, CardNumber As %String, IDCard As %String, BirthPlace As %String, DateOfWork As %Date, WorkPlace As %String, DateOFRetire As %Date, DeformityCode As %String, RelationHourseHoldDR As %Integer, DoctorRegister As %Integer, NurseRegister As %Integer, OperatorInput As %Integer, NationalityDR As %Integer, FamilyRowId As %Integer, HouseHoldTypeDR As %Integer, DocimialTypeDR As %Integer, MedicalInsuranceTypeDR As %Integer, PointHospitalRowIdDR As %Integer, CommitteeDR As %Integer, PoliceRowIdDR As %Integer, StreetRowIdDR As %Integer, DeformityType As %Integer, StaffOfUpdate As %Integer, DateOfUpdate As %Date, NationDR As %Integer, BloodTypeDR As %Integer, MarriageDR As %Integer, EducationDR As %Integer, ProfessionDR As %Integer, DateRegister As %Date, DateInput As %Date, IDCardTypeDR As %Integer, DateOfIDStart As %Date, DateOfIDEnd As %Date, IDCardProvider As %String, MedicalInsuranceID As %String, Address As %String, AddressTypeDR As %Integer, LinkManName As %String, LinkManPhone As %String, HosDiagnoseId As %String, bSaveCardInfo As %String, PersonStatus As %String, PersonEmail As %String, FatherName As %String, MotherName As %String, SpouseName As %String, Height As %Float, Weight As %Float, IncomeSource As %String, WorkPlaceAdd As %String, WorkPlacePhone As %String, Domicile As %String, MUPSMeasure As %String, HeaSerWant As %String, PHeartRate As %Numeric, PHighHBP As %Numeric, PLowHBP As %Numeric, PersonPost As %String, RHBloodType As %String, Waist As %Float, Saddle As %Float) As %String
{
	//, SexDR As %Integer, CommunityCode As %String,DateRegister As %Date,RelationHourseHoldDR As %Integer
	//n (PersonCode, PersonName, SexDR, CommunityCode,DateRegister,RelationHourseHoldDR)
  
	s tempPerson=""
	s tempPerson=##class(CHSS.PersonHealthRecordMain).%New()
	q:(tempPerson="") 0
	s ReturnCode= ..existHouseHold(CommunityCode,FamilyRowId,"add","",RelationHourseHoldDR)
	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""每个家庭只允许有一个户主! 请重新选择与户主关系!""}"
	q:(ReturnCode = "1") ""
	//判断身份证是否重复
	s ReturnCode= ..existColumn("IDCard",IDCard,"add","")
	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""证件号码: "_IDCard_" 已存在! 请重新输入!""}"
	q:(ReturnCode = "1") ""
	s ReturnCode= ..existCardNumber(CardNumber,"add","")
	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""卡号: "_CardNumber_" 已存在! 请重新输入!""}"
	q:(ReturnCode = "1") ""
	
	//重新生成个人编码
	s PersonCode = ##class(CHSSWeb.SystemIdService).GetPersonCodeWithFamilyId(FamilyRowId)
	//判断家庭编码是否为空
	s ReturnCode= ..existPersonCode(PersonCode)
	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""个人编码: "_PersonCode_" 已存在! 请重新添加!""}"
	e  d
	.s tempPerson.CommunityCode = CommunityCode
	.s tempPerson.PersonCode=PersonCode
	.s tempPerson.PersonName=PersonName
	
	
	.i SexDR '= "" d
	..s sexobj=##class(User.CTSex).%OpenId(SexDR)
	..s tempPerson.SexDR=sexobj
	
	.i PoliceRowIdDR '= "" d
	..s policeobj=##class(CHSS.DictPolice).%OpenId(PoliceRowIdDR)
	..s tempPerson.PoliceRowIdDR=policeobj
	
	.i Birth '= "" d
	..s Birth=$zdh(Birth,3)
	.s tempPerson.Birth=Birth
	.
	.i DateRegister '= "" d
	..s DateRegister=$zdh(DateRegister,3)
	.s tempPerson.DateRegister=DateRegister
	.
	.i DateInput '= "" d
	..s DateInput=$zdh(DateInput,3)
	.s tempPerson.DateInput=DateInput
	
	.s tempPerson.SpellCode = SpellCode
	.s tempPerson.CardNumber = CardNumber
	.s tempPerson.IDCard = IDCard
	.s tempPerson.WorkPlace = WorkPlace
	
	.s tempPerson.BirthPlace = BirthPlace
	.i DateOfWork '= "" d
	..s DateOfWork=$zdh(DateOfWork,3)
	.s tempPerson.DateOfWork = DateOfWork
	
	.i DateOFRetire '= "" d
	..s DateOFRetire=$zdh(DateOFRetire,3)
	.s tempPerson.DateOFRetire = DateOFRetire
	.
	.s tempPerson.DeformityCode = DeformityCode
	
	.i RelationHourseHoldDR '= "" d
	..s RelationHourseHoldobj=##class(CHSS.DictKin).%OpenId(RelationHourseHoldDR)
	..s tempPerson.RelationHourseHoldDR=RelationHourseHoldobj
	
	.i DoctorRegister '= "" d
	..;s DoctorRegisterobj=##class(User.SSUser).%OpenId(DoctorRegister)
	..s tempPerson.DoctorRegister=DoctorRegister
	
    .i NurseRegister '= "" d
	..;s NurseRegisterobj=##class(User.SSUser).%OpenId(NurseRegister)
	..s tempPerson.NurseRegister=NurseRegister
	
	.i OperatorInput '= "" d
	..s OperatorInputobj=##class(User.SSUser).%OpenId(OperatorInput)
	..s tempPerson.OperatorInput=OperatorInputobj
	
	.i NationalityDR '= "" d
	..s Nationalityobj=##class(User.CTCountry).%OpenId(NationalityDR)
	..s tempPerson.NationalityDR = Nationalityobj
	
	.i FamilyRowId '= "" d
	..s FamilyRowIdeobj = ##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	..s tempPerson.FamilyRowId = FamilyRowIdeobj
	
	.i HouseHoldTypeDR '= "" d
	..s HouseHoldTypeobj = ##class(CHSS.DictHouseHoldType).%OpenId(HouseHoldTypeDR)
	..s tempPerson.HouseHoldTypeDR = HouseHoldTypeobj
	.
	.i DocimialTypeDR '= "" d
	..s DocimialTypeobj = ##class(CHSS.DictDocimialType).%OpenId(DocimialTypeDR)
	..s tempPerson.DocimialTypeDR = DocimialTypeobj
	.
	.i PointHospitalRowIdDR '= "" d
	..s PointHospitalobj = ##class(CHSS.DictPointHospital).%OpenId(PointHospitalRowIdDR)
	..s tempPerson.PointHospitalRowIdDR = PointHospitalobj
	.
	.i PointHospitalRowIdDR '= "" d
	..s PointHospitalobj = ##class(CHSS.DictPointHospital).%OpenId(PointHospitalRowIdDR)
	..s tempPerson.PointHospitalRowIdDR = PointHospitalobj
	
	
	.
	.i CommitteeDR '= "" d
	..s CommitteeDRobj = ##class(CHSS.DictCommittee).%OpenId(CommitteeDR)
	..s tempPerson.CommitteeDR = CommitteeDRobj
	.
	.i StreetRowIdDR '= "" d
	..s StreetRowIdDRobj = ##class(CHSS.DictStreet).%OpenId(StreetRowIdDR)
	..s tempPerson.StreetRowIdDR = StreetRowIdDRobj
	.
	.i DeformityType '= "" d
	..s DeformityTypeobj = ##class(CHSS.DictDeformityType).%OpenId(DeformityType)
	..s tempPerson.DeformityType = DeformityTypeobj
	.
	.i StaffOfUpdate '= "" d
	..s StaffOfUpdateobj=##class(User.SSUser).%OpenId(StaffOfUpdate)
	..s tempPerson.StaffOfUpdate=StaffOfUpdateobj
	
	.i DateOfUpdate '= "" d
	..s DateOfUpdate=$zdh(DateOfUpdate,3)
	.s tempPerson.DateOfUpdate = DateOfUpdate
	
	.i NationDR '= "" d
	..s NationDRobj=##class(User.CTNation).%OpenId(NationDR)
	..s tempPerson.NationDR = NationDRobj
	.
    
	.i BloodTypeDR '= "" d
	..s BloodTypeDRobj=##class(User.PACBloodType).%OpenId(BloodTypeDR)
	..s tempPerson.BloodTypeDR = BloodTypeDRobj
	
	.i MarriageDR '= "" d
	..s MarriageDRobj=##class(User.CTMarital).%OpenId(MarriageDR)
	..s tempPerson.MarriageDR = MarriageDRobj
	
	.i EducationDR '= "" d
	..s EducationDRobj=##class(User.CTEducation).%OpenId(EducationDR)
	..s tempPerson.EducationDR = EducationDRobj
	
	.i ProfessionDR '= "" d
	..s ProfessionDRobj=##class(User.CTOccupation).%OpenId(ProfessionDR)
	..s tempPerson.ProfessionDR = ProfessionDRobj
	..
	.i IDCardTypeDR '= "" d
	..s IDCardTypeobj=##class(User.PACCardType).%OpenId(IDCardTypeDR)
	..s tempPerson.IDCardTypeDR = IDCardTypeobj
	
	.i DateOfIDStart '= "" d
	..s DateOfIDStart=$zdh(DateOfIDStart,3)
	..s tempPerson.DateOfIDStart = DateOfIDStart
	
	.i DateOfIDEnd '= "" d
	..s DateOfIDEnd=$zdh(DateOfIDEnd,3)
	..s tempPerson.DateOfIDEnd = DateOfIDEnd
	
	.s tempPerson.IDCardProvider = IDCardProvider
	.s tempPerson.MedicalInsuranceID = MedicalInsuranceID 
	.s tempPerson.Address = Address
	.
	.i AddressTypeDR '= "" d
	..s AddressTypeDRobj=##class(CHSS.DictAddressType).%OpenId(AddressTypeDR)
	..s tempPerson.AddressTypeDR = AddressTypeDRobj
	.s tempPerson.LinkManName = LinkManName
	.s tempPerson.LinkManPhone = LinkManPhone
	.s tempPerson.HosDiagnoseId = HosDiagnoseId
	.
	.i PersonStatus '= "" d
	..s PersonStatusobj=##class(CHSS.DictArchivesStatus).%OpenId(PersonStatus)
	..s tempPerson.PersonStatus = PersonStatusobj
	.s tempPerson.PersonEmail = PersonEmail
	.
	.i MedicalInsuranceTypeDR '= "" d
	..s MedicalInsuranceTypeDRobj=##class(CHSS.DictMedicalInsuranceType).%OpenId(MedicalInsuranceTypeDR)
	..s tempPerson.MedicalInsuranceTypeDR=MedicalInsuranceTypeDRobj
	.;处理卡号（金堂模式）
    .s compareStr1 = "00502"
    .s compareStr1 = "00500"
    .i (CardNumber '= "") && (bSaveCardInfo = "1") d
    ..i $FIND(CardNumber,compareStr1) = 6 d
    ..d ##class(CHSSWeb.HISInfoWebService).SavePCAInfoToServerCHSS(PersonCode, CommunityCode, PersonName, SexDR, Birth, SpellCode, CardNumber, IDCard, BirthPlace, DateOfWork, WorkPlace, DateOFRetire, DeformityCode, RelationHourseHoldDR, DoctorRegister, NurseRegister, OperatorInput, NationalityDR, FamilyRowId, HouseHoldTypeDR,DocimialTypeDR, MedicalInsuranceTypeDR, PointHospitalRowIdDR, CommitteeDR, PoliceRowIdDR, StreetRowIdDR, DeformityType, StaffOfUpdate, DateOfUpdate, NationDR, BloodTypeDR, MarriageDR, EducationDR, ProfessionDR,DateRegister,DateInput,IDCardTypeDR,DateOfIDStart,DateOfIDEnd,IDCardProvider,MedicalInsuranceID,Address, AddressTypeDR, LinkManName ,LinkManPhone,HosDiagnoseId, bSaveCardInfo)
    ..s CardNumber = ##class(CHSSWeb.CardNumberService).GetRealCardNumber(IDCard)
    ..i CardNumber '= "" d
    ...s tempPerson.CardNumber = CardNumber
    ...
	.s result=""
    .s result=tempPerson.%Save()
    .s PersonRowId = tempPerson.%Id()
    .i result = "1" d
    ..d ##class(CHSSWeb.PHROtherService).SavePersonOtherInfo(PersonRowId,FatherName,MotherName,SpouseName,Height,Weight,IncomeSource,WorkPlaceAdd,WorkPlacePhone, Domicile, MUPSMeasure, HeaSerWant, PHeartRate, PHighHBP, PLowHBP, PersonPost, RHBloodType)
    ..w "{""success"":""true"",""info"":'"_tempPerson.%Id()_"^"_PersonCode_"'}"
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
 
    q ""
}

ClassMethod Update1(PersonRowId As %Integer, PersonName As %String, SexDR As %Integer, PoliceRowIdDR As %Integer) As %String
{
	q:($d(PersonRowId)=0)||(PersonRowId="")
	s tempPerson="",result=""
	s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	q:(tempPerson="") 0
	
	s tempPerson.PersonName=PersonName
	
	i SexDR '= "" d
	.s sexobj=##class(User.CTSex).%OpenId(SexDR)
	.s tempPerson.SexDR=sexobj
	
	i PoliceRowIdDR '= "" d
	.s policeobj=##class(CHSS.DictPolice).%OpenId(PoliceRowIdDR)
	.s tempPerson.PoliceRowIdDR=policeobj
	
	s result=""
	s result=tempPerson.%Save()
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
/// 
ClassMethod Update(PersonRowId As %Integer, PersonName As %String, SexDR As %Integer, Birth As %Date, SpellCode As %String, CardNumber As %String, IDCard As %String, BirthPlace As %String, DateOfWork As %Date, WorkPlace As %String, DateOFRetire As %Date, DeformityCode As %String, RelationHourseHoldDR As %Integer, DoctorRegister As %Integer, NurseRegister As %Integer, OperatorInput As %Integer, NationalityDR As %Integer, FamilyRowId As %Integer, HouseHoldTypeDR As %Integer, DocimialTypeDR As %Integer, MedicalInsuranceTypeDR As %Integer, PointHospitalRowIdDR As %Integer, CommitteeDR As %Integer, PoliceRowIdDR As %Integer, StreetRowIdDR As %Integer, DeformityType As %Integer, StaffOfUpdate As %Integer, DateOfUpdate As %Date, NationDR As %Integer, BloodTypeDR As %Integer, MarriageDR As %Integer, EducationDR As %Integer, ProfessionDR As %Integer, DateRegister As %Date, DateInput As %Date, IDCardTypeDR As %Integer, DateOfIDStart As %Date, DateOfIDEnd As %Date, IDCardProvider As %String, MedicalInsuranceID As %String, Address As %String, AddressTypeDR As %Integer, LinkManName As %String, LinkManPhone As %String, HosDiagnoseId As %String, bSaveCardInfo As %String, PersonStatus As %String, PersonEmail As %String, FatherName As %String, MotherName As %String, SpouseName As %String, Height As %Float, Weight As %Float, IncomeSource As %String, WorkPlaceAdd As %String, WorkPlacePhone As %String, Domicile As %String, MUPSMeasure As %String, HeaSerWant As %String, PHeartRate As %Numeric, PHighHBP As %Numeric, PLowHBP As %Numeric, PersonPost As %String, RHBloodType As %String, Waist As %Float, Saddle As %Float) As %String
{
	q:($d(PersonRowId)=0)||(PersonRowId="")

	s ReturnCode= ..existHouseHold(CommunityCode,FamilyRowId,"edit",PersonRowId,RelationHourseHoldDR)
	;w ReturnCode
	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""每个家庭只允许有一个户主! 请重新选择与户主关系!""}"
	
	q:(ReturnCode = "1") ""
	s ReturnCode= ..existColumn("IDCard",IDCard,"edit",PersonRowId)
	;w ReturnCode
	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""证件号码: "_IDCard_" 已存在! 请重新输入!""}"
	q:(ReturnCode = "1") ""
	s ReturnCode= ..existCardNumber(CardNumber,"edit",PersonRowId)

	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""卡号: "_CardNumber_" 已存在! 请重新输入!""}"
	q:(ReturnCode = "1") ""
	s tempPerson="",result=""
	s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	q:(tempPerson="") 0
	s tempPerson.PersonName=PersonName
	i SexDR '= "" d
	.s sexobj=##class(User.CTSex).%OpenId(SexDR)
	.s tempPerson.SexDR=sexobj
	
	i Birth '= "" d
	.s Birth=$zdh(Birth,3)
	.s tempPerson.Birth=Birth
	
	s tempPerson.SpellCode = SpellCode
	s tempPerson.CardNumber = CardNumber
	s tempPerson.IDCard = IDCard
	s tempPerson.WorkPlace = WorkPlace
	
	i PoliceRowIdDR '= "" d
	.s policeobj=##class(CHSS.DictPolice).%OpenId(PoliceRowIdDR)
	.s tempPerson.PoliceRowIdDR=policeobj
	e  d
	.s tempPerson.PoliceRowIdDR = ""
	
	s tempPerson.BirthPlace = BirthPlace
	i DateOfWork '= "" d
	.s DateOfWork=$zdh(DateOfWork,3)
	s tempPerson.DateOfWork = DateOfWork
	
	i DateOFRetire '= "" d
	.s DateOFRetire=$zdh(DateOFRetire,3)
	s tempPerson.DateOFRetire = DateOFRetire
	s tempPerson.DeformityCode = DeformityCode
	
	i RelationHourseHoldDR '= "" d
	.s HouseHoldTypeobj=##class(CHSS.DictKin).%OpenId(RelationHourseHoldDR)
	.s tempPerson.RelationHourseHoldDR=HouseHoldTypeobj
	e  d
	.s tempPerson.RelationHourseHoldDR=""
	
	i DoctorRegister '= "" d
	.;s DoctorRegisterobj=##class(User.SSUser).%OpenId(DoctorRegister)
	.s tempPerson.DoctorRegister=DoctorRegister

	i NurseRegister '= "" d
	.;s NurseRegisterobj=##class(User.SSUser).%OpenId(NurseRegister)
	.s tempPerson.NurseRegister=NurseRegister
	
	i OperatorInput '= "" d
	.s OperatorInputobj=##class(User.SSUser).%OpenId(OperatorInput)
	.s tempPerson.OperatorInput=OperatorInputobj
	
	i NationalityDR '= "" d
	.s Nationalityobj=##class(User.CTCountry).%OpenId(NationalityDR)
	.s tempPerson.NationalityDR = Nationalityobj
	
	i FamilyRowId '= "" d
	.s FamilyRowIdeobj = ##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	.s tempPerson.FamilyRowId = FamilyRowIdeobj
	
	i HouseHoldTypeDR '= "" d
	.s HouseHoldTypeobj = ##class(CHSS.DictHouseHoldType).%OpenId(HouseHoldTypeDR)
	.s tempPerson.HouseHoldTypeDR = HouseHoldTypeobj
	.
	i DocimialTypeDR '= "" d
	.s DocimialTypeobj = ##class(CHSS.DictDocimialType).%OpenId(DocimialTypeDR)
	.s tempPerson.DocimialTypeDR = DocimialTypeobj
	.
	i PointHospitalRowIdDR '= "" d
	.s PointHospitalobj = ##class(CHSS.DictPointHospital).%OpenId(PointHospitalRowIdDR)
	.s tempPerson.PointHospitalRowIdDR = PointHospitalobj
	.
	i PointHospitalRowIdDR '= "" d
	.s PointHospitalobj = ##class(CHSS.DictPointHospital).%OpenId(PointHospitalRowIdDR)
	.s tempPerson.PointHospitalRowIdDR = PointHospitalobj
	.
	i CommitteeDR '= "" d
	.s CommitteeDRobj = ##class(CHSS.DictCommittee).%OpenId(CommitteeDR)
	.s tempPerson.CommitteeDR = CommitteeDRobj
	e  d
	.s tempPerson.CommitteeDR = ""
	.
	i StreetRowIdDR '= "" d
	.s StreetRowIdDRobj = ##class(CHSS.DictStreet).%OpenId(StreetRowIdDR)
	.s tempPerson.StreetRowIdDR = StreetRowIdDRobj
	.
	i DeformityType '= "" d
	.s DeformityTypeobj = ##class(CHSS.DictDeformityType).%OpenId(DeformityType)
	.s tempPerson.DeformityType = DeformityTypeobj
	.
	i StaffOfUpdate '= "" d
	.s StaffOfUpdateobj=##class(User.SSUser).%OpenId(StaffOfUpdate)
	.s tempPerson.StaffOfUpdate=StaffOfUpdateobj
	
	i MedicalInsuranceTypeDR '= "" d
	.s MedicalInsuranceTypeDRobj=##class(CHSS.DictMedicalInsuranceType).%OpenId(MedicalInsuranceTypeDR)
	.s tempPerson.MedicalInsuranceTypeDR=MedicalInsuranceTypeDRobj
	//s tempPerson.MedicalInsuranceTypeDR = MedicalInsuranceTypeDR

	i DateOfUpdate '= "" d
	.s DateOfUpdate=$zdh(DateOfUpdate,3)
	s tempPerson.DateOfUpdate = DateOfUpdate
	
	i NationDR '= "" d
	.s NationDRobj=##class(User.CTNation).%OpenId(NationDR)
	.s tempPerson.NationDR = NationDRobj
	.

	i BloodTypeDR '= "" d
	.s BloodTypeDRobj=##class(User.PACBloodType).%OpenId(BloodTypeDR)
	.s tempPerson.BloodTypeDR = BloodTypeDRobj
	
	i MarriageDR '= "" d
	.s MarriageDRobj=##class(User.CTMarital).%OpenId(MarriageDR)
	.s tempPerson.MarriageDR = MarriageDRobj
	
	i EducationDR '= "" d
	.s EducationDRobj=##class(User.CTEducation).%OpenId(EducationDR)
	.s tempPerson.EducationDR = EducationDRobj
	
	i ProfessionDR '= "" d
	.s ProfessionDRobj=##class(User.CTOccupation).%OpenId(ProfessionDR)
	.s tempPerson.ProfessionDR = ProfessionDRobj
	.
	i DateRegister '= "" d
	.s DateRegister=$zdh(DateRegister,3)
	.s tempPerson.DateRegister=DateRegister
	.
	i DateInput '= "" d
	.s DateInput=$zdh(DateInput,3)
	.s tempPerson.DateInput=DateInput
	.
	i IDCardTypeDR '= "" d
	.s IDCardTypeobj=##class(User.PACCardType).%OpenId(IDCardTypeDR)
	.s tempPerson.IDCardTypeDR = IDCardTypeobj
	.
	i DateOfIDStart '= "" d
	.s DateOfIDStart=$zdh(DateOfIDStart,3)
	.s tempPerson.DateOfIDStart = DateOfIDStart
	.
	i DateOfIDEnd '= "" d
	.s DateOfIDEnd=$zdh(DateOfIDEnd,3)
	.s tempPerson.DateOfIDEnd = DateOfIDEnd
	.
	s tempPerson.IDCardProvider = IDCardProvider
	s tempPerson.MedicalInsuranceID = MedicalInsuranceID
	s tempPerson.Address = Address
	i AddressTypeDR '= "" d
	.s AddressTypeDRobj=##class(CHSS.DictAddressType).%OpenId(AddressTypeDR)
	.s tempPerson.AddressTypeDR = AddressTypeDRobj
	s tempPerson.LinkManName = LinkManName
	s tempPerson.LinkManPhone = LinkManPhone
	s tempPerson.HosDiagnoseId = HosDiagnoseId
	i PersonStatus '= "" d
	.s PersonStatusobj=##class(CHSS.DictArchivesStatus).%OpenId(PersonStatus)
	.s tempPerson.PersonStatus = PersonStatusobj
	s tempPerson.PersonEmail = PersonEmail
	
	;处理卡号（金堂模式）
    s compareStr1 = "00502"
    s compareStr1 = "00500"
    i (CardNumber '= "") && (bSaveCardInfo = "1") d
    .i $FIND(CardNumber,compareStr1) = 6 d
    .d ##class(CHSSWeb.HISInfoWebService).SavePCAInfoToServerCHSS(PersonCode, CommunityCode, PersonName, SexDR, Birth, SpellCode, CardNumber, IDCard, BirthPlace, DateOfWork, WorkPlace, DateOFRetire, DeformityCode, RelationHourseHoldDR, DoctorRegister, NurseRegister, OperatorInput, NationalityDR, FamilyRowId, HouseHoldTypeDR,DocimialTypeDR, MedicalInsuranceTypeDR, PointHospitalRowIdDR, CommitteeDR, PoliceRowIdDR, StreetRowIdDR, DeformityType, StaffOfUpdate, DateOfUpdate, NationDR, BloodTypeDR, MarriageDR, EducationDR, ProfessionDR,DateRegister,DateInput,IDCardTypeDR,DateOfIDStart,DateOfIDEnd,IDCardProvider,MedicalInsuranceID,Address, AddressTypeDR, LinkManName ,LinkManPhone,HosDiagnoseId, bSaveCardInfo)
    .s CardNumber = ##class(CHSSWeb.CardNumberService).GetRealCardNumber(IDCard)
    .i CardNumber '= "" d
    ..s tempPerson.CardNumber = CardNumber
    ..
	s result=""
	s result=tempPerson.%Save()
	i result = "1" d
	.
    .d ##class(CHSSWeb.PHROtherService).SavePersonOtherInfo(PersonRowId,FatherName,MotherName,SpouseName,Height,Weight,IncomeSource,WorkPlaceAdd,WorkPlacePhone, Domicile, MUPSMeasure, HeaSerWant, PHeartRate, PHighHBP, PLowHBP, PersonPost, RHBloodType)
    .w "{""success"":""true"",""info"":'"_PersonRowId_"^"_PersonCode_"'}"
    .
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    .
    
    q ""
}

//删除个人档案

ClassMethod existPersonCode(PersonCode) As %String
{
	q:PersonCode="" "-1"
	s PersonCode=" "_PersonCode
	q:$d(^CHSS.PersonHealthRecordMainI("PersonCodeIndex",PersonCode)) "1"
	q "0"
}

ClassMethod CardNumberCheck(CardNumber As %String, RecordType As %String, RowId As %Integer) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PersonRowId,CardNumber from CHSS.PersonHealthRecordMain where CardNumber = '"_CardNumber_"'"
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = 1
	s tempRowId = ""
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
		s tempRowId = result.Data("PersonRowId")
		s count = count+1
	}
	d result.Close()

	q:(count = 0) "{""success"":""true"",""info"":""0""}"
	if (RecordType = "add")
	{
		q:(count > 0) "{""success"":""true"",""info"":""1""}"
	}
	elseif (RecordType = "edit")
	{
		if (tempRowId '= RowId)
		{
			q "{""success"":""true"",""info"":""1""}"
		}
		else{
				q "{""success"":""true"",""info"":""0""}"
			}
		
	}
}

ClassMethod existCardNumber(CardNumber As %String, RecordType As %String, RowId As %Integer) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PersonRowId,CardNumber from CHSS.PersonHealthRecordMain where CardNumber = '"_CardNumber_"'"
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = 1
	s tempRowId = ""
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
		s tempRowId = result.Data("PersonRowId")
		s count = count+1
	}
	d result.Close()

	q:(count = 0) "0"
	if (RecordType = "add")
	{
		q:(count > 0) "1"
	}
	elseif (RecordType = "edit")
	{
		if (tempRowId '= RowId)
		{
			q "1"
		}
		else{
				q "0"
			}
		
	}
}

ClassMethod existColumn(ColumnName As %String, ColumnStr As %String, RecordType As %String, RowId As %Integer) As %String
{
	q:(ColumnStr = "") "0"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PersonRowId from CHSS.PersonHealthRecordMain where "_ColumnName_" = '"_ColumnStr_"'"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = 1
	s tempRowId = ""
	
	s json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
		s tempRowId = result.Data("PersonRowId")
		s count = count+1
	}
	;w RowId,!
	d result.Close()
	q:(count = 0) "0"
	if (RecordType = "add")
	{
		q:(count > 0) "1"
	}
	elseif (RecordType = "edit")
	{
		if (tempRowId '= RowId)
		{
			q "1"
		}
		else{
				q "0"
			}
		
	}
}

ClassMethod existHouseHold(CommunityCode As %String, FamilyRowId As %String, RecordType As %String, RowId As %Integer, RelationHourseHoldDR As %String) As %String
{
	q:(FamilyRowId = "") "0"
	q:($g(PersonRowId) = "") "0"
	q:(RelationHourseHoldDR = "") "0"
	;w PersonRowId
	;判断是否为户主
	s Description = ""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT Description from CHSS.DictKin where RowId = "_RelationHourseHoldDR
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = 1
	s tempRowId = ""
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
		s Description = result.Data("Description")
		s count = count+1
	}
	d result.Close()
	q:(Description '= "户主") "0"
	;判断该家庭有几个户主
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PersonRowId from CHSS.PersonHealthRecordMain where CommunityCode = '"_CommunityCode_"' and FamilyRowId = "_FamilyRowId_" and RelationHourseHoldDR -> Description = '户主'"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = 1
	s tempRowId = ""
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
		s tempRowId = result.Data("PersonRowId")
		s count = count+1
	}
	d result.Close()

	q:(count = 0) "0"
	if (RecordType = "add")
	{
		q:(count > 0) "1"
	}
	elseif (RecordType = "edit")
	{
	
		if (tempRowId '= RowId)
		{
			q "1"
		}
		else{
				q "0"
			}
		
	}
}

ClassMethod existPersonName(PersonName As %String) As %String
{
	q:PersonName="" "-1"
	s PersonName=" "_PersonName
	q:$d(^CHSS.PersonHealthRecordMainI("NameIndex",PersonName)) "1"
	q "0"
}

ClassMethod deletePerson(PersonRowId) As %String
{
	q:(PersonRowId = "") ""
	s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	q:(tempPerson="") ""
	
	s result=tempPerson.%DeleteId(PersonRowId)
	;s result = ##class(%Library.ResultSet).%New()
	;s sqlStr = "delete from CHSS.PersonHealthRecordMain where PersonRowId = "_PersonRowId
	;d result.Prepare(sqlStr)
	;s SQLCODE = result.Execute()
	i result = "1" d
    .w "{""success"":""true"",""info"":""数据删除成功！""}"
    .
    e  d
    .w "{""success"":""false"",""info"":""数据删除出错！""}"
    .
    q ""
}

Storage Default
{
<Data name="PHRServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PHRServiceD</DataLocation>
<DefaultData>PHRServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PHRServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PHRServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PHRServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
