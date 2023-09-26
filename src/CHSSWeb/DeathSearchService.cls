Class CHSSWeb.DeathSearchService Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: liuchao
/// CreatDate：2010—04-06
/// Description:根据条件查询个人档案（条件查询）  模仿乙肝页面
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod PersonSearchSql(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
		n (communityCode, start, limit, sort, whereStr)
         
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
		s sqlStr = "SELECT PersonRowId FROM CHSS.PersonHealthRecordMain where CommunityCode = '"_communityCode_"' and PersonStatus=7 "_whereStr
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
        ; w tmp
         
	    Set count=count+1
	    
		If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}
	    Set resultString = json.getJsonData("PersonRowId^PersonCode^PersonName^SexDR^SexName^Birth^FamilyAddress^Address^LinkManPhone^PersonStatusName^FamilyRowId^RelationHourseHoldName",count)
	 	k json
	 	
		Quit resultString
}

//将 PersonHealthRecordMain表中的 几个字段 插入到PersonDeathCard中

ClassMethod DeathCardInfo(PersonRowId As %String) As %String
{
	n (PersonRowId)
	 ;判断是否有死亡证明书
	 s count=$d(^CHSS.PersonDeathCardI("PersonRowIdIndex"," "_PersonRowId))
	 
	 s CardRowId=""
	 i count="0" d
	  .s CardRowId = ..InsertBaseInfo(PersonRowId)
	 e  d
	  .s CardRowId = $O(^CHSS.PersonDeathCardI("PersonRowIdIndex"," "_PersonRowId,""))
	 i CardRowId '= "" d
	 .s tempDeathCard=##class(CHSS.PersonDeathCard).%OpenId(CardRowId)
	 .;个人档案主键 
	.s PersonRowId = tempDeathCard.PersonRowId
	.;报告单位编码 
	.s CommunityCode = tempDeathCard.CommunityCode
	.;报告单位名称 
	.s CommunityName = tempDeathCard.CommunityName
	.;卡片编号 
	.s CardCode = tempDeathCard.CardCode
	.;患者姓名 
	.s PatientName = tempDeathCard.PatientName
	.;性别编码	
	.set SexDR = ""
	.set SexName = ""
	.i tempDeathCard.Sex '= "" d
	..set SexDR = tempDeathCard.Sex.%Id()
    ..set SexName = tempDeathCard.Sex.CTSEXDesc
	 
		
	.;若为女性，属于哪种情况 
	.;s WomenType = tempDeathCard.WomenType
	.;身份证号 
	.s ID = tempDeathCard.ID
	.;出生日期 
	.s Birthday = tempDeathCard.Birthday
	.i Birthday '= "" d
	..s Birthday = $zd(Birthday,3)
	.;民族 
	.set NationDR = ""
	.set NationName = ""
	.i tempDeathCard.Nation '= "" d
	..set NationDR = tempDeathCard.Nation.%Id()
    ..set NationName = tempDeathCard.Nation.CTNATDesc
	
	.;婚姻状况 
	.set MarriageDR = ""
	.set MarriageName = ""
	.i tempDeathCard.Marriage '= "" d
	..set MarriageDR = tempDeathCard.Marriage.%Id()
    ..set MarriageName = tempDeathCard.Marriage.CTMARDesc
	.;主要职业及工种 
	.set WorkTypeDR = ""
	.set WorkTypeName = ""
	.i tempDeathCard.WorkType '= "" d
	..set WorkTypeDR = tempDeathCard.WorkType.%Id()
    ..set WorkTypeName = tempDeathCard.WorkType.CTOCCDesc
	.;文化程度 
    .set DeuLevelDR = ""
	.set DeuLevelName = ""
	.i tempDeathCard.DeuLevel '= "" d
	..set DeuLevelDR = tempDeathCard.DeuLevel.%Id()
    ..set DeuLevelName = tempDeathCard.DeuLevel.EDUDesc
	.;详细现住地址 
	.s Addr = tempDeathCard.Addr
	.;现住地址名称 
	.s AddrName = tempDeathCard.AddrName
	.;现住地址类型 CHSS.AreaType
	.s PlaceTypeDR = ""
	.s PlaceTypeName = ""
	.i tempDeathCard.PlaceType'="" d
	..set PlaceTypeDR = tempDeathCard.PlaceType.%Id()
    ..set PlaceTypeName = tempDeathCard.PlaceType.Description
 	.;户籍地址 
	.s RegisterAddr = tempDeathCard.RegisterAddr
	.;户籍地址编码 
	.s RegisterAddrCode = tempDeathCard.RegisterAddrCode
	.;户籍地址名称 
	.s RegisterAddrName = tempDeathCard.RegisterAddrName
	.;户籍类型 	 
	.s AreaTypeDR = ""
	.s AreaTypeName = ""
	.i tempDeathCard.AreaType'="" d
	..set PAreaTypeDR = tempDeathCard.AreaType.%Id()
    ..set AreaTypeName = tempDeathCard.AreaType.Description
	.;死者生前工作单位 
	.s WorkPlace = tempDeathCard.WorkPlace
	.;死亡日期 
	.s DeadDate = tempDeathCard.DeadDate
	.;死亡地点
	.s DeadZoneDR = ""
	.s DeadZoneName = ""
	.i tempDeathCard.DeadZone'="" d
	..set DeadZoneDR = tempDeathCard.DeadZone.%Id()
    ..set DeadZoneName = tempDeathCard.DeadZone.Description
	.;死亡地点编码 
	.s DeadZoneCode = tempDeathCard.DeadZoneCode
	.;死者家属姓名 
	.s FolkName = tempDeathCard.FolkName
	.;家属联系电话 
	.s FolkTel = tempDeathCard.FolkTel
	.;家属联系地址 
	.s FolkAddr = tempDeathCard.FolkAddr
	.;直接导致死亡的疾病或情况 (a) 
	.s ACause = tempDeathCard.ACause
	.;直接导致死亡的疾病或情况 (a)ICD编码 
	.s AICD10 = tempDeathCard.AICD10
	.;直接导致死亡的疾病或情况 (a) 发病至死亡时间间隔数 
	.s AScopeTime = tempDeathCard.AScopeTime
	.;直接导致死亡的疾病或情况 (a) 发病至死亡时间间隔单位 
	.s AScopeTimeUnit = tempDeathCard.AScopeTimeUnit
	.;直接导致死亡的疾病或情况 (b) 
	.s BCause = tempDeathCard.BCause
	.;直接导致死亡的疾病或情况 (b)ICD编码 
	.s BICD10 = tempDeathCard.BICD10
	.;直接导致死亡的疾病或情况 (b) 发病至死亡时间间隔数 
	.s BScopeTime = tempDeathCard.BScopeTime
	.;直接导致死亡的疾病或情况 (b) 发病至死亡时间间隔单位 
	.s BScopeTimeUnit = tempDeathCard.BScopeTimeUnit
	.;直接导致死亡的疾病或情况 (c) 
	.s CCause = tempDeathCard.CCause
	.;直接导致死亡的疾病或情况 (c)ICD编码 
	.s CICD10 = tempDeathCard.CICD10
	.;直接导致死亡的疾病或情况 (c) 发病至死亡时间间隔数 
	.s CScopeTime = tempDeathCard.CScopeTime
	.;直接导致死亡的疾病或情况 (c) 发病至死亡时间间隔单位 
	.s CScopeTimeUnit = tempDeathCard.CScopeTimeUnit
	.;直接导致死亡的疾病或情况 (d) 
	.s DCause = tempDeathCard.DCause
	.;直接导致死亡的疾病或情况 (d)ICD编码 
	.s DICD10 = tempDeathCard.DICD10
	.;直接导致死亡的疾病或情况 (d) 发病至死亡时间间隔数 
	.s DScopeTime = tempDeathCard.DScopeTime
	.;直接导致死亡的疾病或情况 (d) 发病至死亡时间间隔单位 
	.s DScopeTimeUnit = tempDeathCard.DScopeTimeUnit
	.;其它疾病诊断 
	.s OtherCause = tempDeathCard.OtherCause
	.;其它疾病诊断ICD 
	.s OtherICD10 = tempDeathCard.OtherICD10
	.;根本死因原因 
	.s BaseCause = tempDeathCard.BaseCause
	.;根本死亡原因ICD10编码 
	.s BSICD10 = tempDeathCard.BSICD10
	.;最高诊断单位 
	.s DorgLevel = tempDeathCard.DorgLevel
	.;最高诊断依据  
	.s DiagnoseByDR = ""
	.s DiagnoseByName = ""
	.i tempDeathCard.DiagnoseBy'="" d
	..set DiagnoseByDR = tempDeathCard.DiagnoseBy.%Id()
    ..set DiagnoseByName = tempDeathCard.DiagnoseBy.Description
	.;住院号 
	.s HospitalNo = tempDeathCard.HospitalNo
	.;填卡医生 
	.s Doctor = tempDeathCard.Doctor
	.;医生填卡日期 
	.s FillDate = tempDeathCard.FillDate
	.;备注 
	.s Note = tempDeathCard.Note
	
   /*****============以下是调查表的信息====================*****/
    s InvestRowId = $O(^CHSS.PersonDeathInvestI("PersonRowIdIndex",PersonRowId,""))
	s PersonRowId=""
	s Symptom=""
	s Informan=""
	s Relationship=""
	s InformanTAddr=""
	s InformanTTEL=""
	s DeathReason=""
	s Investigator=""
	s InvestigateDate=""	
	s tmp = ""
	 
	i InvestRowId '= "" d
	.s tempInvest=##class(CHSS.PersonDeathInvest).%OpenId(InvestRowId)	 
	.//死者生前病史及症状体征
	.s Symptom=tempInvest.Symptom
	.//被调查者姓名
	.s Informan=tempInvest.Informan
	.//与死者关系
	.s Relationship=tempInvest.Relationship
	.//联系地址或工作单位
	.s InformanTAddr=tempInvest.InformanTAddr
	.//被调查者电话号码
	.s InformanTTEL=tempInvest.InformanTTEL
	.//死因推断
	.s DeathReason=tempInvest.DeathReason
	.//调查者签名
	.s Investigator=tempInvest.Investigator
	.//调查日期
	.s InvestigateDate=tempInvest.InvestigateDate
	.i tempInvest.InvestigateDate'=""
	..s InvestigateDate = $zdh(InvestigateDate,3)
     .//*****============以上是调查表的信息====================*****/
	.s tmp = CardRowId_"^"_PersonRowId_"^"_CommunityCode_"^"_CommunityName_"^"_CardCode_"^"_PatientName_"^"_SexDR_"^"_SexName_"^"_ID_"^"_Birthday_"^"_NationDR_"^"_NationName_"^"_MarriageDR_"^"_MarriageName_"^"_WorkTypeDR_"^"_WorkTypeName_"^"_DeuLevelDR_"^"_DeuLevelName_"^"_Addr_"^"_AddrName_"^"_PlaceTypeDR_"^"_PlaceTypeName_"^"_RegisterAddr_"^"_RegisterAddrCode_"^"_RegisterAddrName_"^"_AreaTypeDR_"^"_AreaTypeName_"^"_WorkPlace_"^"_DeadDate_"^"_DeadZoneDR_"^"_DeadZoneName_"^"_DeadZoneCode_"^"_FolkName_"^"_FolkTel_"^"_FolkAddr_"^"_ACause_"^"_AICD10_"^"_AScopeTime_"^"_AScopeTimeUnit_"^"_BCause_"^"_BICD10_"^"_BScopeTime_"^"_BScopeTimeUnit_"^"_CCause_"^"_CICD10_"^"_CScopeTime_"^"_CScopeTimeUnit_"^"_DCause_"^"_DICD10_"^"_DScopeTime_"^"_DScopeTimeUnit_"^"_OtherCause_"^"_OtherICD10_"^"_BaseCause_"^"_BSICD10_"^"_DorgLevel_"^"_DiagnoseByDR_"^"_DiagnoseByName_"^"_HospitalNo_"^"_Doctor_"^"_FillDate_"^"_Note_"^"_InvestRowId_"^"_Symptom_"^"_Informan_"^"_Relationship_"^"_InformanTAddr_"^"_InformanTTEL_"^"_DeathReason_"^"_Investigator_"^"_InvestigateDate
     

  
    Set json = ##class(Code.JsonObj).%New()
    d json.InsertRowData(tmp)
    Set resultString = json.getJsonData("CardRowId^PersonRowId^CommunityCode^CommunityName^CardCode^PatientName^SexDR^SexName^ID^Birthday^NationDR^NationName^MarriageDR^MarriageName^WorkTypeDR^WorkTypeName^DeuLevelDR^DeuLevelName^Addr^AddrName^PlaceTypeDR^PlaceTypeName^RegisterAddr^RegisterAddrCode^RegisterAddrName^AreaTypeDR^AreaTypeName^WorkPlace^DeadDate^DeadZoneDr^DeadZoneName^DeadZoneCode^FolkName^FolkTel^FolkAddr^ACause^AICD10^AScopeTime^AScopeTimeUnit^BCause^BICD10^BScopeTime^BScopeTimeUnit^CCause^CICD10^CScopeTime^CScopeTimeUnit^DCause^DICD10^DScopeTime^DScopeTimeUnit^OtherCause^OtherICD10^BaseCause^BSICD10^DorgLevel^DiagnoseByDR^DiagnoseByName^HospitalNo^Doctor^FillDate^Note^InvestRowId^Symptom^Informan^Relationship^InformanTAddr^InformanTTEL^DeathReason^Investigator^InvestigateDate",1)
    k json
	 	
    Quit resultString
}

ClassMethod InsertBaseInfo(PersonRowId As %String) As %String
{
	
 //性别	SexDR  姓名	PersonName 出生日期	Birth 民族	NationDR 婚姻状况	MarriageDR 文化程度	EducationDR 职业	ProfessionDR
 //详细现住地址	Addr 户籍地址	RegisterAddr 户籍地址编码	RegisterAddrCode

 s tempPerson = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)	
 s tempDeathCard = ##class(CHSS.PersonDeathCard).%New()
 s tempDeathCard.PersonRowId =PersonRowId
 s tempDeathCard.PatientName = tempPerson.PersonName
 s tempDeathCard.Sex = tempPerson.SexDR
 s tempDeathCard.Birthday = tempPerson.Birth
 s tempDeathCard.Nation = tempPerson.NationDR
 s tempDeathCard.Marriage = tempPerson.MarriageDR
 s tempDeathCard.WorkType = tempPerson.ProfessionDR
 s tempDeathCard.DeuLevel = tempPerson.EducationDR
 
 
 //将家庭档案表中的住址 设为 死亡证明书中的户籍住址， 将个人档案中的地址设为现住址
 s FamilyRowId = ""
 s FamilyAddress = ""
 i tempPerson.FamilyRowId '= "" d
  .s FamilyRowId = tempPerson.FamilyRowId.%Id() 
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
  i FamilyAddress '= "" d
  .s tempDeathCard.RegisterAddr = FamilyAddress
 
  s tempDeathCard.Addr = tempPerson.Address 
 
  s result=tempDeathCard.%Save()  
  
  //以下代码是往PersonDeathInvest表中插入一条数据
  &SQL(insert into chss.PersonDeathInvest (PersonRowId) values(:PersonRowId))
  i result = "1" q tempDeathCard.%Id()
  e  q ""
}

/// Creator: liuchao
/// CreatDate：2010-04-11
/// Description:更新死亡卡信息
/// Table：PersonDeathCard
/// Input: CardRowId
/// Output：
/// Return：
/// Others：
ClassMethod Update(CardRowId As %Integer, CardCode As %String, PatientName As %String, Sex As %Integer, ID As %String, Birthday As %Date, Nation As %Integer, Marriage As %Integer, WorkType As %Integer, DeuLevel As %Integer, Addr As %String, PlaceType As %Integer, RegisterAddr As %String, AreaType As %Integer, WorkPlace As %String, DeadDate As %Date, DeadZone As %String, DeadZoneCode As %String, FolkName As %String, FolkTel As %String, FolkAddr As %String, ACause As %String, AICD10 As %String, AScopeTime As %String, AScopeTimeUnit As %String, BCause As %String, BICD10 As %String, BScopeTime As %String, BScopeTimeUnit As %String, CCause As %String, CICD10 As %String, CScopeTime As %String, CScopeTimeUnit As %String, DCause As %String, DICD10 As %String, DScopeTime As %String, DScopeTimeUnit As %String, OtherCause As %String, OtherICD10 As %String, BaseCause As %String, BSICD10 As %String, DorgLevel As %String, DiagnoseBy As %String, HospitalNo As %String, FillDate As %Date, Doctor As %String, Note As %String, InvestRowId As %String, Symptom As %String, Informan As %String, Relationship As %String, InformanTAddr As %String, InformanTTEL As %String, Investigator As %String, DeathReason As %String, InvestigateDate As %Date) As %String
{
 
	q:(CardRowId="") "code-rep"
	 s tempDeath = ##class(CHSS.PersonDeathCard).%OpenId(CardRowId)
	
	 
	i Sex '= "" d
	.s Sexobj=##class(User.CTSex).%OpenId(Sex)
	.s tempDeath.Sex=Sexobj
	i Nation '= "" d
	.s Nationobj=##class(User.CTNation).%OpenId(Nation)
	.s tempDeath.Nation=Nationobj
	i Marriage '= "" d
	.s Marriageobj=##class(User.CTMarital).%OpenId(Marriage)
	.s tempDeath.Marriage=Marriageobj
	i WorkType '= ""  d
	.s WorkTypeobj=##class(User.CTOccupation).%OpenId(WorkType)
	.s tempDeath.WorkType=WorkTypeobj
 
	i DeuLevel '= "" d
	.s DeuLeveleobj=##class(User.CTEducation).%OpenId(DeuLevel)
	.s tempDeath.DeuLevel=DeuLeveleobj
	i PlaceType '= "" d
	.s PlaceTypeobj=##class(CHSS.DictAreaType).%OpenId(PlaceType)
	.s tempDeath.PlaceType=PlaceTypeobj
	i AreaType '= "" d
	.s AreaTypeobj=##class(CHSS.DictAreaType).%OpenId(AreaType)
	.s tempDeath.AreaType=AreaTypeobj
 
   
   	i DeadZone '= "" d
	.s DeadZoneobj=##class(CHSS.DictDeathPlace).%OpenId(DeadZone)
	.s tempDeath.DeadZone=DeadZoneobj
    i DiagnoseBy '= "" d
	.s DiagnoseByobj=##class(CHSS.DiagnosisWitness).%OpenId(DiagnoseBy)
	.s tempDeath.DiagnoseBy=DiagnoseByobj
 
   
   	s tempDeath.CardCode=CardCode  
	s tempDeath.PatientName=PatientName
 
	s tempDeath.ID=ID
		 
	i Birthday'="" d
	.s Birthday=$zdh(Birthday,3)
	.s tempDeath.Birthday=Birthday
	s tempDeath.Addr=Addr
  
	s tempDeath.RegisterAddr=RegisterAddr
	 
	s tempDeath.WorkPlace=WorkPlace
 
	i DeadDate'="" d
	.s DeadDate=$zdh(DeadDate,3)
	.s tempDeath.DeadDate=DeadDate
    i FillDate'="" d
	.s FillDate=$zdh(FillDate,3)
	.s tempDeath.FillDate=FillDate
	s tempDeath.FolkName=FolkName
	s tempDeath.FolkTel=FolkTel
	s tempDeath.FolkAddr=FolkAddr
	s tempDeath.ACause=ACause
	s tempDeath.AICD10=AICD10
	s tempDeath.AScopeTime=AScopeTime
	s tempDeath.AScopeTimeUnit=AScopeTimeUnit
	s tempDeath.BCause=BCause
	s tempDeath.BICD10=BICD10
	s tempDeath.BScopeTime=BScopeTime
	s tempDeath.BScopeTimeUnit=BScopeTimeUnit
	s tempDeath.CCause=CCause
	s tempDeath.CICD10=CICD10
	s tempDeath.CScopeTime=CScopeTime
	s tempDeath.CScopeTimeUnit=CScopeTimeUnit
	s tempDeath.DCause=DCause
	s tempDeath.DICD10=DICD10
	s tempDeath.DScopeTime=DScopeTime
	s tempDeath.DScopeTimeUnit=DScopeTimeUnit
	s tempDeath.OtherCause=OtherCause
	s tempDeath.OtherICD10=OtherICD10
	s tempDeath.BaseCause=BaseCause
	s tempDeath.BSICD10=BSICD10
	s tempDeath.DorgLevel=DorgLevel
 
	s tempDeath.HospitalNo=HospitalNo 
	s tempDeath.Doctor=Doctor
	s tempDeath.FillDate=FillDate
	s tempDeath.Note=Note   
    
  
	//&sql(update CHSS.PersonDeathCard set CardCode=:CardCode,PatientName=:PatientName,Sex=:Sexobj,ID=:ID,Birthday=:Birthday,Nation=:Nationobj,Marriage=:Marriageobj,WorkType=:WorkTypeobj,DeuLevel=:DeuLevelobj,Addr=:Addr,PlaceType=:PlaceType,RegisterAddr=:RegisterAddr,AreaType=:AreaType,WorkPlace=:WorkPlace,DeadDate=:DeadDate,DeadZone=:DeadZone,DeadZoneCode=:DeadZoneCode,FolkName=:FolkName,FolkTel=:FolkTel,FolkAddr=:FolkAddr,ACause=:ACause,AICD10=:AICD10,AScopeTime=:AScopeTime,AScopeTimeUnit=:AScopeTimeUnit,BCause=:BCause,BICD10=:BICD10,BScopeTime=:BScopeTime,BScopeTimeUnit=:BScopeTimeUnit,CCause=:CCause,CICD10=:CICD10,CScopeTime=:CScopeTime,CScopeTimeUnit=:CScopeTimeUnit,DCause=:DCause,DICD10=:DICD10,DScopeTime=:DScopeTime,DScopeTimeUnit=:DScopeTimeUnit,OtherCause=:OtherCause,OtherICD10=:OtherICD10,BaseCause=:BaseCause,BSICD10=:BSICD10,DorgLevel=:DorgLevel,DiagnoseBy=:DiagnoseBy,HospitalNo=:HospitalNo,Note=:Note where %Id=:CardRowId)
	s result=tempDeath.%Save()
 
    Set resultString = ""
    Set InvestResult = ""
    i result = "1" d  
   .s InvestResult = ..UpdateDeathInvestInfo(InvestRowId,Symptom ,Informan ,Relationship ,InformanTAddr,InformanTTEL ,Investigator ,DeathReason ,InvestigateDate)
   .i InvestResult = "1" d
    ..s resultString = "{""success"":""true"",""info"":"_CardRowId_"}"
    .e  s resultString = "{""success"":""false"",""info"":""数据保存出错!!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      
    q resultString
}

/// 调查记录
ClassMethod UpdateDeathInvestInfo(InvestRowId As %String, Symptom As %String, Informan As %String, Relationship As %String, InformanTAddr As %String, InformanTTEL As %String, Investigator As %String, DeathReason As %String, InvestigateDate As %Date) As %String
{
    
	q:(InvestRowId="") "code-rep"     
	
    i InvestigateDate'="" d
     
     
	.s InvestigateDate = $zdh(InvestigateDate,3) 
	 
	&sql(update CHSS.PersonDeathInvest set Symptom=:Symptom,Informan=:Informan,Relationship=:Relationship,InformanTAddr=:InformanTAddr,InformanTTEL=:InformanTTEL,DeathReason=:DeathReason,Investigator=:Investigator,InvestigateDate=:InvestigateDate where %ID=:InvestRowId)
  
    s resultString = ""
	i SQLCODE = "0" d
    .s resultString = "1"
    e  d
    .s resultString = "0"      
    q resultString
}

Storage Default
{
<Data name="DeathSearchServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DeathSearchServiceD</DataLocation>
<DefaultData>DeathSearchServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.DeathSearchServiceD</IdLocation>
<IndexLocation>^CHSSWeb.DeathSearchServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.DeathSearchServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
