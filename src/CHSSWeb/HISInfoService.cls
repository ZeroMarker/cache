Class CHSSWeb.HISInfoService Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

ClassMethod PersonListFromHIS(CardNumber As %String) As %String
{
	
	//本地使用注释部分的代码
	//w "{results:1,rows:[{CardNumber:'000000000000153',PersonName:'王珂',SexDR:'1',DiagnoseId:'0000030000',Birth:'1974-10-25',SpellCode:'wang ke',IDCard:'510102197410254397',LinkManPhone:'13308066121'}]}"
	//q ""
	n (CardNumber)
	q:(CardNumber = "") ""
	s PatientId = ""
	//首先读取卡的状态CF_ActiveFlag：N||Normal  正常S||Suspend  挂失R||Reclaim  回收D||Depose  作废(此时，不能再次使用)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CF_ActiveFlag,CF_PAPMI_DR FROM SQLUser.DHC_CardRef where CF_CardNo = '"_CardNumber_"'"

	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = 1
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
		s ActiveFlag = result.Data("CF_ActiveFlag")
		s PatientId = result.Data("CF_PAPMI_DR")
		i ActiveFlag = "S" d
		.w "{""success"":""false"",""info"":""卡号: "_CardNumber_" 已挂失! 请重新输入!""}"
		.
		e  i ActiveFlag = "R" d
		.w "{""success"":""false"",""info"":""卡号: "_CardNumber_" 已回收! 请重新输入!""}"
		.
		e  i ActiveFlag = "D" d
		.w "{""success"":""false"",""info"":""卡号: "_CardNumber_" 已作废! 请重新输入!""}"
		.
		q:(ActiveFlag '= "N")
		s count = count+1
	}
	d result.Close()
	i count = 0 d
	.w "{""success"":""true"",""info"":""卡号: "_CardNumber_" 不存在，保存时会自动将卡号填入HIS中!""}"
	q:(count = 0) ""
	.
	//****读取个人基本信息*****************
		Set start=0
		Set limit=1
		Set sort=""
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()

		i PatientId '= "" d
		.s tempPerson=##class(User.PAPatMas).%OpenId(PatientId)
		.set PersonName = tempPerson.PAPMIName
		.
		.set SexDR = ""
		.i tempPerson.PAPMISexDR '= "" d
		..set SexDR = tempPerson.PAPMISexDR.%Id()
		.s DiagnoseId = tempPerson.PAPMINo
		.s Birth = tempPerson.PAPMIDOB
		.i Birth '= "" d
		..s Birth = $zd(Birth,3)
		.s SpellCode = tempPerson.PAPMIName2
		.s IDCard = tempPerson.PAPMIID
		.s LinkManPhone = tempPerson.PAPMIMobPhone
		.Set tmp= CardNumber_"^"_PersonName_"^"_SexDR_"^"_DiagnoseId_"^"_Birth_"^"_SpellCode_"^"_IDCard_"^"_LinkManPhone
		.//_"^"_Birth_"^"_SpellCode_"^"_CardNumber_"^"_IDCard_"^"_BirthPlace_"^"_WorkPlace_"^"_NationalityDR_"^"_NationDR_"^"_BloodTypeDR_"^"_MarriageDR_"^"_EducationDR_"^"_ProfessionDR
	    .Set count=count+1
	    .
		.If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    //Set resultString = json.getJsonData("CardNumber^PersonName^SexDR^Birth^SpellCode^CardNumber^IDCard^BirthPlace^WorkPlace^NationalityDR^NationDR^BloodTypeDR^MarriageDR^EducationDR^ProfessionDR",count)
	 	Set resultString = json.getJsonData("CardNumber^PersonName^SexDR^DiagnoseId^Birth^SpellCode^IDCard^LinkManPhone",count)
	 	
	 	k json
	 	
		Quit resultString
}

ClassMethod PersonInfoForHIS(CardNumber As %String) As %String
{

		n (CardNumber)
		q:(CardNumber = "") ""
		Set start=0
		Set limit=1
		Set sort=""
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		
		For  Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("CardNumberIndex",CardNumber,PersonRowId)) q:PersonRowId=""  d
		.s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
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
		..s DoctorRegister = tempPerson.DoctorRegister.%Id()
		..s DoctorName = tempPerson.DoctorRegister.SSUSRName
		..
		.set NurseName = ""
		.set NurseRegister = ""
		.i tempPerson.NurseRegister '= "" d
		..s NurseRegister = tempPerson.NurseRegister.%Id()
		..s NurseName = tempPerson.NurseRegister.SSUSRName
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
		..s HouseHoldName = tempPerson.FamilyRowId.HouseHoldName
		.
		.s HouseHoldDR = ""
		.S HouseHoldDRName = ""
		.i tempPerson.HouseHoldTypeDR '= "" d
		..s HouseHoldDR =tempPerson.HouseHoldTypeDR.%Id()
		..s HouseHoldDRName = tempPerson.HouseHoldTypeDR.Description
		..
		
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
		.Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_RelationHourseHoldDR_"^"_PoliceRowIdDR_"^"_PoliceName_"^"_PersonStatus_"^"_SpellCode_"^"_CardNumber_"^"_IDCard_"^"_WorkPlace_"^"_BirthPlace_"^"_DateOfWork_"^"_DateOFRetire_"^"_RelationHourseHoldDR_"^"_RelationHourseHoldName_"^"_DoctorRegister_"^"_DoctorName_"^"_NurseRegister_"^"_NurseName_"^"_OperatorInput_"^"_OperatorInputName_"^"_NationalityDR_"^"_NationalityDRName_"^"_FamilyRowId_"^"_HouseHoldDR_"^"_DocimialTypeDR_"^"_DocimialTypeDRName_"^"_PointHospitalRowIdDR_"^"_PointHospitalRowIdDRName_"^"_CommitteeDR_"^"_CommitteeDRName_"^"_StreetRowIdDR_"^"_StreetRowIdDRName_"^"_DeformityType_"^"_DeformityTypeName_"^"_StaffOfUpdate_"^"_StaffOfUpdateName_"^"_NationDR_"^"_NationDRName_"^"_BloodTypeDR_"^"_BloodTypeDRName_"^"_MarriageDR_"^"_MarriageDRName_"^"_EducationDR_"^"_EducationDRName_"^"_ProfessionDR_"^"_ProfessionDRName_"^"_DateRegister_"^"_DateInput_"^"_IDCardTypeDR_"^"_IDCardTypeName_"^"_DateOfIDStart_"^"_DateOfIDEnd_"^"_IDCardProvider_"^"_HouseHoldName_"^"_FamilyAddress_"^"_MedicalInsuranceID_"^"_PersonStatusName_"^"_Address_"^"_AddressTypeDR_"^"_AddressTypeDRName_"^"_LinkManName_"^"_LinkManPhone_"^"_MedicalInsuranceTypeDR_"^"_MedicalInsuranceTypeDRName_"^"_HosDiagnoseId
	    .Set count=count+1
	    .
	 	
		Quit tmp
}

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:从HIS添加个人档案基本信息
/// Table：PersonHealthRecordMain
/// Input:PersonHealthRecordMain
/// Output：
/// Return：
/// Others：
ClassMethod InsertFromHIS(PersonCode As %String, CommunityCode As %String, PersonName As %String, SexDR As %Integer, Birth As %Date, SpellCode As %String, CardNumber As %String, IDCard As %String, BirthPlace As %String, DateOfWork As %Date, WorkPlace As %String, DateOFRetire As %Date, DeformityCode As %String, RelationHourseHoldDR As %Integer, DoctorRegister As %Integer, NurseRegister As %Integer, OperatorInput As %Integer, NationalityDR As %Integer, FamilyRowId As %Integer, HouseHoldTypeDR As %Integer, DocimialTypeDR As %Integer, MedicalInsuranceTypeDR As %Integer, PointHospitalRowIdDR As %Integer, CommitteeDR As %Integer, PoliceRowIdDR As %Integer, StreetRowIdDR As %Integer, DeformityType As %Integer, StaffOfUpdate As %Integer, DateOfUpdate As %Date, NationDR As %Integer, BloodTypeDR As %Integer, MarriageDR As %Integer, EducationDR As %Integer, ProfessionDR As %Integer, DateRegister As %Date, DateInput As %Date, IDCardTypeDR As %Integer, DateOfIDStart As %Date, DateOfIDEnd As %Date, IDCardProvider As %String, MedicalInsuranceID As %String, Address As %String, AddressTypeDR As %Integer, LinkManName As %String, LinkManPhone As %String, HosDiagnoseId As %String) As %String
{
	//, SexDR As %Integer, CommunityCode As %String,DateRegister As %Date,RelationHourseHoldDR As %Integer
	//n (PersonCode, PersonName, SexDR, CommunityCode,DateRegister,RelationHourseHoldDR)
   	q:(CommunityCode = "") ""
   	s PersonCode = ##class(CHSSWeb.SystemIdService).GetSystemId(CommunityCode,"PERSONHEALRECORDMAIN")

	s tempPerson=""
	s tempPerson=##class(CHSS.PersonHealthRecordMain).%New()
	q:(tempPerson="") 0
	s ReturnCode= ..existPersonCode(CardNumber)
	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""卡号: "_CardNumber_" 已存在! 请重新输入!""}"
	
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
	..s DoctorRegisterobj=##class(User.SSUser).%OpenId(DoctorRegister)
	..s tempPerson.DoctorRegister=DoctorRegisterobj
	
	.i NurseRegister '= "" d
	..s NurseRegisterobj=##class(User.SSUser).%OpenId(NurseRegister)
	..s tempPerson.NurseRegister=NurseRegisterobj
	
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
	.s result=""
    .s result=tempPerson.%Save()
    
    .i result = "1" d
    ..w "{""success"":""true"",""info"":"_tempPerson.%Id()_"}"
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

//社区建档成功后往HIS插入卡信息和病人信息

ClassMethod existPersonCode(PersonCode) As %String
{
	q:PersonCode="" "-1"
	s PersonCode=" "_PersonCode
	q:$d(^CHSS.PersonHealthRecordMainI("PersonCodeIndex",PersonCode)) "1"
	q "0"
}

ClassMethod existCardNumber(CardNumber) As %String
{
	q:CardNumber="" "-1"
	s CardNumber=" "_CardNumber
	q:$d(^CHSS.PersonHealthRecordMainI("CardNumberIndex",CardNumber)) "1"
	q "0"
}

ClassMethod existCardNumberServer(CardNumber) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CF_ActiveFlag,CF_PAPMI_DR FROM SQLUser.DHC_CardRef where CF_CardNo = '"_CardNumber_"'"

	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = 1
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
		s count = count+1
	}
	d result.Close()
	q:(count = 0) "0"
	q:(count > 0) "1"
}

ClassMethod existPersonName(PersonName As %String) As %String
{
	q:PersonName="" "-1"
	s PersonName=" "_PersonName
	q:$d(^CHSS.PersonHealthRecordMainI("NameIndex",PersonName)) "1"
	q "0"
}

ClassMethod SavePCAInfoToServerCHSS(PersonCode As %String, CommunityCode As %String, PersonName As %String, SexDR As %Integer, Birth As %Date, SpellCode As %String, CardNumber As %String, IDCard As %String, BirthPlace As %String, DateOfWork As %Date, WorkPlace As %String, DateOFRetire As %Date, DeformityCode As %String, RelationHourseHoldDR As %Integer, DoctorRegister As %Integer, NurseRegister As %Integer, OperatorInput As %Integer, NationalityDR As %Integer, FamilyRowId As %Integer, HouseHoldTypeDR As %Integer, DocimialTypeDR As %Integer, MedicalInsuranceTypeDR As %Integer, PointHospitalRowIdDR As %Integer, CommitteeDR As %Integer, PoliceRowIdDR As %Integer, StreetRowIdDR As %Integer, DeformityType As %Integer, StaffOfUpdate As %Integer, DateOfUpdate As %Date, NationDR As %Integer, BloodTypeDR As %Integer, MarriageDR As %Integer, EducationDR As %Integer, ProfessionDR As %Integer, DateRegister As %Date, DateInput As %Date, IDCardTypeDR As %Integer, DateOfIDStart As %Date, DateOfIDEnd As %Date, IDCardProvider As %String, MedicalInsuranceID As %String, Address As %String, AddressTypeDR As %Integer, LinkManName As %String, LinkManPhone As %String, HosDiagnoseId As %String, bSaveCardInfo As %String) As %String
{
	q:(CardNumber = "") "0"
	q:(IDCard = "") "0"
	q:(SexDR = "") "0"
	q:(OperatorInput = "") "0"
	//s OperatorInput = "47"
	q:(bSaveCardInfo '= "1") "0"
	s resultCode = ..existCardNumberServer(CardNumber)
	q:(resultCode = "1") "0"
	
	s Sex = ""
	i SexDR = 1 d
	.s Sex = "男"
	e  i SexDR = 2 d
	.s Sex = "女"
	i Birth '= "" d
	.s Birth=$zd(Birth,3)
	s PaPatInfo = ..GetPatientXML(PersonName,PersonCode, Address, Birth, Sex, SpellCode, IDCard, LinkManPhone, OperatorInput, IDCardTypeDR,"1","23",CardNumber)
	//s PaPatInfo="<Request><Name>刘剑秋</Name><Sex>男</Sex><CredType>3</CredType><CredNo>510107883</CredNo><Birth>1985-07-21</Birth><Address>成都市</Address><TelHome>13880420460</TelHome><PatType>1</PatType><CardType>23</CardType><CardNo>000302342343235</CardNo><UserDR>47</UserDR></Request>"
	
	s resultStr = ##class(web.HX.IF.OP.HealthFileTranCard).HealthFileTranCard(PaPatInfo) 

	//s ^test("CradInfo")=resultStr
	//k ^test("CradInfo")
	q resultStr
}

ClassMethod GetCardTypeXML() As %String
{
	s xml = "<CardTypeConfig><AccManageFLag>N</AccManageFLag><CardAccountRelation>N</CardAccountRelation><CardFareCost>2</CardFareCost><CardRefFlag>Y</CardRefFlag><FareType>C</FareType><GroupRegFlag>PR</GroupRegFlag><PANoCardRefFlag>Y</PANoCardRefFlag><PatMasFlag>Y</PatMasFlag><SecurityNoFlag>Y</SecurityNoFlag><StChangeValidateFlag>Y</StChangeValidateFlag><UseINVType>R</UseINVType></CardTypeConfig>"

	q xml
}

ClassMethod GetPatientXML(Name, PersonCode, Address, Birth, Sex, SpellCode, IDCard, LinkManPhone, UserId, CredType, PatType, CardType, CardNo) As %String
{
	s patientxml = "<Request><Name>"_Name_"</Name><Sex>"_Sex_"</Sex><Birth>"_Birth_"</Birth><CredType>"_CredType_"</CredType><CredNo>"_IDCard_"</CredNo><Address>"_Address_"</Address><TelHome>"_LinkManPhone_"</TelHome><PatType>"_PatType_"</PatType><CardType>"_CardType_"</CardType><CardNo>"_CardNo_"</CardNo><UserDR>"_UserId_"</UserDR></Request>"
	
	q patientxml
}

ClassMethod GetCardRefXML(CardNumber As %String, CardType As %String, IDCard As %String, UserId As %String) As %String
{
	s xml = "<CardRef><ActiveFlag></ActiveFlag><CFAccNoDR></CFAccNoDR><CFDate></CFDate><CFTime></CFTime><CardINVPRTDR></CardINVPRTDR><CardNo>"_CardNumber_"</CardNo><CardRowID></CardRowID><CardTypeDefine>16</CardTypeDefine><ComputerIP>PC-200811181422</ComputerIP><CredNo>"_IDCard_"</CredNo><FareType></FareType><Organ></Organ><PAPMINo></PAPMINo><PAPMIRowID></PAPMIRowID><SecurityNo></SecurityNo><UserDR>"_UserId_"</UserDR></CardRef>"
	
	q xml
}

ClassMethod GetCardINVPRTXML(CardFareCost As %String, PayModel As %String, UserId As %String) As %String
{
	s xml = "<CardINVPRT><Bank></Bank><BankCardType></BankCardType><CardChequeNo></CardChequeNo><CardFareCost>"_CardFareCost_"</CardFareCost><ChequeDate></ChequeDate><Date></Date><Flag></Flag><PAPMIRowID></PAPMIRowID><PayAccNo></PayAccNo><PayCompany></PayCompany><PayMode>"_PayModel_"</PayMode><ReceiptNO></ReceiptNO><Remark></Remark><Time></Time><UserDR>"_UserId_"</UserDR></CardINVPRT>"
	q xml
}

ClassMethod SaveCardTest() As %String
{
	s ConfigInfo = "<CardTypeConfig><AccManageFLag>N</AccManageFLag><CardAccountRelation>N</CardAccountRelation><CardRefFlag>Y</CardRefFlag><FareType>NP</FareType><GroupRegFlag>PR</GroupRegFlag><PANoCardRefFlag>N</PANoCardRefFlag><PatMasFlag>Y</PatMasFlag><PreCardFlag>N</PreCardFlag><SearchMasFlag>N</SearchMasFlag><SecurityNoFlag>Y</SecurityNoFlag><StChangeValidateFlag>Y</StChangeValidateFlag></CardTypeConfig>"
	s PaPatInfo = "<PATMAS><MedicalCardNo></MedicalCardNo><MedicalYBNo></MedicalYBNo><Address>成都市</Address><Allergy></Allergy><Birth>52797</Birth><CTRelationDR></CTRelationDR><CityDescLookUpRowID></CityDescLookUpRowID><CityAreaLookUpRowID></CityAreaLookUpRowID><EmployeeCompanyLookUpRowID></EmployeeCompanyLookUpRowID><CountryDescLookUpRowID></CountryDescLookUpRowID><CredType>3</CredType><CredNo>51010742112</CredNo><EMail></EMail><ForeignName></ForeignName><EmployeeCompany></EmployeeCompany><PAPMINo></PAPMINo><IDCardNo1></IDCardNo1><InMedicare></InMedicare><MobPhone></MobPhone><Name>刘剑秋</Name><NationDescLookUpRowID></NationDescLookUpRowID><OpMedicare></OpMedicare><PAPMIRowID></PAPMIRowID><PatType>1</PatType><ProvinceInfoLookUpRowID></ProvinceInfoLookUpRowID><Sex>1</Sex><TelHome>13880420460</TelHome><TelOffice></TelOffice><UpdateDate></UpdateDate><UserDR>667</UserDR><UpdateTime></UpdateTime><Vocation></Vocation><ZipLookUpRowID></ZipLookUpRowID><ChinesePYCode>liujianqiu</ChinesePYCode></PATMAS>"
	s CardInfo = "<CardRef><ActiveFlag></ActiveFlag><CFDate>1940-12-31</CFDate><CFAccNoDR></CFAccNoDR><CardNo>000404584541551</CardNo><CFTime>00:00:00</CFTime><CardINVPRTDR></CardINVPRTDR><CardTypeDefine>22</CardTypeDefine><CardRowID></CardRowID><ComputerIP>健康档案</ComputerIP><PAPMIRowID></PAPMIRowID><CredNo>51010742112</CredNo><SecurityNo></SecurityNo><FareType></FareType><UserDR>667</UserDR><PAPMINo></PAPMINo><Organ></Organ></CardRef>"
	s CardINVInfo = "<CardINVPRT><UserDR>667</UserDR><PayMode>1</PayMode></CardINVPRT>"
	
	s resultStr = ##class(web.DHCBL.CARDIF.ICardRefInfo).SavePCAInfoToServer(ConfigInfo,PaPatInfo,CardInfo,"","",CardINVInfo,"^","") 
	w resultStr
	//s ^test("CradInfo")=resultStr
	//k ^test("CradInfo")
	q resultStr
}

Storage Default
{
<Data name="HISInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HISInfoServiceD</DataLocation>
<DefaultData>HISInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HISInfoServiceD</IdLocation>
<IndexLocation>^CHSSWeb.HISInfoServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.HISInfoServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
