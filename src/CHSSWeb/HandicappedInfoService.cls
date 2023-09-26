Class CHSSWeb.HandicappedInfoService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-07-
/// Description:残疾人档案
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod List(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
	    
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
		s sqlStr = "SELECT distinct PersonRowId FROM CHSS.PersonHealthRecordMain where CommunityCode = '"_communityCode_"' "_whereStr

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
		.
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
		.;s DoctorRegister = tempPerson.DoctorRegister.%Id()
		.;s DoctorName = tempPerson.DoctorRegister.SSUSRName
		.
		set NurseName = ""
		set NurseRegister = ""
		i tempPerson.NurseRegister '= "" d
		.;s NurseRegister = tempPerson.NurseRegister.%Id()
		.;s NurseName = tempPerson.NurseRegister.SSUSRName
		.
		set OperatorInputName = ""
		set OperatorInput = ""
		i tempPerson.OperatorInput '= "" d
		.;s OperatorInput = tempPerson.OperatorInput.%Id()
		.;s OperatorInputName = tempPerson.OperatorInput.SSUSRName
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
		.;i tempFamily.VillageDR '= "" d
	    ..;s Address = Address_tempFamily.VillageDR.Description
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
		
		s HandicappedInfo =..ShowInfo(0,100,PersonRowId,14)
		
		Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_RelationHourseHoldDR_"^"_PoliceRowIdDR_"^"_PoliceName_"^"_PersonStatus_"^"_SpellCode_"^"_CardNumber_"^"_IDCard_"^"_WorkPlace_"^"_BirthPlace_"^"_DateOfWork_"^"_DateOFRetire_"^"_RelationHourseHoldDR_"^"_RelationHourseHoldName_"^"_DoctorRegister_"^"_DoctorName_"^"_NurseRegister_"^"_NurseName_"^"_OperatorInput_"^"_OperatorInputName_"^"_NationalityDR_"^"_NationalityDRName_"^"_FamilyRowId_"^"_HouseHoldDR_"^"_DocimialTypeDR_"^"_DocimialTypeDRName_"^"_PointHospitalRowIdDR_"^"_PointHospitalRowIdDRName_"^"_CommitteeDR_"^"_CommitteeDRName_"^"_StreetRowIdDR_"^"_StreetRowIdDRName_"^"_DeformityType_"^"_DeformityTypeName_"^"_StaffOfUpdate_"^"_StaffOfUpdateName_"^"_NationDR_"^"_NationDRName_"^"_BloodTypeDR_"^"_BloodTypeDRName_"^"_MarriageDR_"^"_MarriageDRName_"^"_EducationDR_"^"_EducationDRName_"^"_ProfessionDR_"^"_ProfessionDRName_"^"_DateRegister_"^"_DateInput_"^"_IDCardTypeDR_"^"_IDCardTypeName_"^"_DateOfIDStart_"^"_DateOfIDEnd_"^"_IDCardProvider_"^"_HouseHoldName_"^"_Address_"^"_MedicalInsuranceID_"^"_PersonStatusName_"^"_LinkManName_"^"_LinkManPhone_"^"_MedicalInsuranceTypeDR_"^"_MedicalInsuranceTypeDRName_"^"_HandicappedInfo
	    Set count=count+1
	    
		If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}
	    Set resultString = json.getJsonData("PersonRowId^PersonCode^PersonName^SexDR^SexName^Birth^RelationHourseHoldDR^PoliceRowIdDR^PoliceName^PersonStatus^SpellCode^CardNumber^IDCard^WorkPlace^BirthPlace^DateOfWork^DateOFRetire^RelationHourseHoldDR^RelationHourseHoldName^DoctorRegister^DoctorName^NurseRegister^NurseName^OperatorInput^OperatorInputName^NationalityDR^NationalityDRName^FamilyRowId^HouseHoldDR^DocimialTypeDR^DocimialTypeDRName^PointHospitalRowIdDR^PointHospitalRowIdDRName^CommitteeDR^CommitteeDRName^StreetRowIdDR^StreetRowIdDRName^DeformityType^DeformityTypeName^StaffOfUpdate^StaffOfUpdateName^NationDR^NationDRName^BloodTypeDR^BloodTypeDRName^MarriageDR^MarriageDRName^EducationDR^EducationDRName^ProfessionDR^ProfessionDRName^DateRegister^DateInput^IDCardTypeDR^IDCardTypeName^DateOfIDStart^DateOfIDEnd^IDCardProvider^HouseHoldName1^Address^MedicalInsuranceID^PersonStatusName^LinkManName^LinkManPhone^MedicalInsuranceTypeDR^MedicalInsuranceTypeDRName^HandicappedInfo",count)
	 	k json
	 	
		Quit resultString
}

ClassMethod ShowInfo(Start As %Integer, Limit As %Integer, PersonRowIdParref As %Integer, ItemdCode As %String) As %String
{
		set ItemdCode = " "_ItemdCode
		set ItemCode = ""
		Set start=$G(Start)
		Set limit=$G(Limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		set tmp = ""
		set startStr = ""
		Set json = ##class(Code.JsonObj).%New()
		set DiagnoseRowId = 0
		For  Set DiagnoseRowId=$O(^CHSS.PersonHealthDiagnoseI("PersonAndCodeIndex",PersonRowIdParref, ItemdCode,DiagnoseRowId)) q:DiagnoseRowId=""  d
		.s tempObj=##class(CHSS.PersonHealthDiagnose).%OpenId(DiagnoseRowId)
		.s DetailRowId = tempObj.DetailRowId
		.s ItemName = tempObj.ItemName
		.//s ItemCode = tempObj.ItemdCode
		.s ItemAssortCode = tempObj.ItemAssortCode
		.s ItemAssortName = tempObj.ItemAssortName
		.s DiagnoseResult = tempObj.DiagnoseResult
		.s ICDCode = tempObj.ICDCode
		.set DateOfStart = tempObj.DateOfStart
		.i DateOfStart '= "" d
		..s DateOfStart = $zd(DateOfStart,3)
		.set DateOfEnd = tempObj.DateOfEnd
		.i DateOfEnd '= "" d
		..s DateOfEnd = $zd(DateOfEnd,3)
		.s MainPart = tempObj.MainPart
		.s MainReason = tempObj.MainReason
		.s MainDiagnose = tempObj.MainDiagnose
		.s SequenceCode = tempObj.SequenceCode
		.S count=count+1
		.
		.
		.i ItemdCode = " 1" d  //ABO血型
		..s tmp = tmp_startStr_DiagnoseResult
		.e  i ItemdCode = " 2" d  //RH血型
		..s tmp = tmp_startStr_DiagnoseResult
		.e  i ItemdCode = " 3" d  //药物过敏史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 4" d  //暴露史
		..s tmp = tmp_startStr_ItemAssortName_":"_DiagnoseResult
		.e  i ItemdCode = " 5" d  //疾病史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 52" d  //外伤
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 6" d  //手术史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 7" d  //输血情况
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 8" d  //家族疾病史-父亲
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 9" d  //家族疾病史-母亲
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 10" d  //家族疾病史-兄弟姐妹
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 11" d  //家族疾病史-子女
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 12" d  //家族遗传病史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 13" d  //精神疾病情况
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 14" d  //残疾状况
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 15" d  //免疫接种类别
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 16" d  //并发症
		..i DateOfStart '= "" d
		...s DateOfStart =  $p(DateOfStart,"-",1,1)
		...s tmp = tmp_startStr_ItemAssortName_":"_DateOfStart_"年"
		..e  d
		...s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 18" d  //有创医疗操作
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 19" d  //体征
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 20" d  //传染病接触史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 21" d //X线检查结果
		..s tmp = tmp_startStr_ItemAssortName_DiagnoseResult_ItemAssortCode
		.e  i ItemdCode = " 22" d  //慢性病
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 23" d  //家族疾病史-祖辈
		..s tmp = tmp_startStr_ItemAssortName
		.s startStr = "、"
		i tmp '= "" d
		.s tmp = tmp_""
		.
		e  d
	    .s tmp = """"""
		
		Quit tmp
}

Storage Default
{
<Data name="HandicappedInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HandicappedI8AED</DataLocation>
<DefaultData>HandicappedInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HandicappedI8AED</IdLocation>
<IndexLocation>^CHSSWeb.HandicappedI8AEI</IndexLocation>
<StreamLocation>^CHSSWeb.HandicappedI8AES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
