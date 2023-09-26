/// create:2009-09-29 by wangbo 
Class CHSSWeb.PHROtherService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:检索社区编号个人档案列表
/// Table：PersonHealthRecordMain
/// Input:CommunityCode, start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod GetPersonOtherInfo(PersonRowIdParref As %String) As %String
{
		q:(PersonRowIdParref="") ""
		
		Set count=0
		Set resultString = ""
		s tempPerson=""
   		s ReturnCode=..existPersonRowIdParref(PersonRowIdParref)	
	    i (ReturnCode'="0") d
     	.q:($d(PersonRowIdParref)=0)||(PersonRowIdParref="")
     	.s PersonOtherRowId = 0
     	.s PersonOtherRowId = $O(^CHSS.PersonHealthRecordOtherI("PersonRowIdParrefIndex",PersonRowIdParref,PersonOtherRowId))
    	.s tempOtherInfo = ##class(CHSS.PersonHealthRecordOther).%OpenId(PersonOtherRowId)
		.s FatherName = ""
		.s FatherName = tempOtherInfo.FatherName
		.s MotherName = tempOtherInfo.MotherName
		.s SpouseName = tempOtherInfo.SpouseName
		.s Height = tempOtherInfo.Height
		.s Weight = tempOtherInfo.Weight
		.s IncomeSource = tempOtherInfo.IncomeSource
		.s WorkPlaceAdd = tempOtherInfo.WorkPlaceAdd
		.s WorkPlacePhone = tempOtherInfo.WorkPlacePhone
		.
		.s Domicile = tempOtherInfo.Domicile
		.s MUPSMeasure = tempOtherInfo.MUPSMeasure
		.s HeaSerWant = tempOtherInfo.HeaSerWant
		.s PHeartRate = tempOtherInfo.PHeartRate
		.s PHighHBP = tempOtherInfo.PHighHBP
		.s PLowHBP = tempOtherInfo.PLowHBP
		.s PersonPost = tempOtherInfo.PersonPost
		.s RHBloodType = tempOtherInfo.RHBloodType
		e  d
		.s FatherName = ""
		.s MotherName = ""
		.s SpouseName = ""
		.s Height = ""
		.s Weight = ""
		.s IncomeSource = ""
		.s WorkPlaceAdd = ""
		.s WorkPlacePhone = ""
		.
		.s Domicile = ""
		.s MUPSMeasure = ""
		.s HeaSerWant = ""
		.s PHeartRate = ""
		.s PHighHBP = ""
		.s PLowHBP = ""
		.s PersonPost = ""
		.s RHBloodType = ""
		Set tmp= "^"_FatherName_"^"_MotherName_"^"_SpouseName_"^"_Height_"^"_Weight_"^"_IncomeSource_"^"_WorkPlaceAdd_"^"_WorkPlacePhone_"^"_Domicile_"^"_MUPSMeasure_"^"_HeaSerWant_"^"_PHeartRate_"^"_PHighHBP_"^"_PLowHBP_"^"_PersonPost_"^"_RHBloodType
	    Quit tmp
}

//判断存在

ClassMethod existPersonRowIdParref(PersonRowIdParref) As %String
{
	
	q:PersonRowIdParref="" "-1"
	q:$d(^CHSS.PersonHealthRecordOtherI("PersonRowIdParrefIndex",PersonRowIdParref)) "1"
	q "0"
}

ClassMethod SavePersonOtherInfo(PersonRowIdParref As %Integer, FatherName As %String, MotherName As %String, SpouseName As %String, Height As %Float, Weight As %Float, IncomeSource As %String, WorkPlaceAdd As %String, WorkPlacePhone As %String, Domicile As %String, MUPSMeasure As %String, HeaSerWant As %String, PHeartRate As %Numeric, PHighHBP As %Numeric, PLowHBP As %Numeric, PersonPost As %String, RHBloodType As %String) As %String
{
	q:(PersonRowIdParref = "") ""
	s tempPersonOther=""
    s ReturnCode=..existPersonRowIdParref(PersonRowIdParref)
	i (ReturnCode'="0") d
	.q:($d(PersonRowIdParref)=0)||(PersonRowIdParref="")
	.s PersonOtherRowId = 0
    .s PersonOtherRowId = $O(^CHSS.PersonHealthRecordOtherI("PersonRowIdParrefIndex",PersonRowIdParref,PersonOtherRowId))
    .s tempPersonOther = ##class(CHSS.PersonHealthRecordOther).%OpenId(PersonOtherRowId)
	e  d
	.s tempPersonOther=##class(CHSS.PersonHealthRecordOther).%New()
	.i PersonRowIdParref '="" d
    ..s PersonRowIdDRobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
    ..s tempPersonOther.PersonRowIdParref=PersonRowIdDRobj
	s tempPersonOther.FatherName = FatherName
	s tempPersonOther.MotherName = MotherName
	s tempPersonOther.SpouseName = SpouseName
	i Height '= "" d
	.s tempPersonOther.Height= $Number(Height)
	i Weight '= "" d
    .s tempPersonOther.Weight= $Number(Weight)
	s tempPersonOther.IncomeSource = IncomeSource
	s tempPersonOther.WorkPlaceAdd = WorkPlaceAdd
	s tempPersonOther.WorkPlacePhone = WorkPlacePhone
	;add by wangbo 2009-11-30
	s tempPersonOther.Domicile = Domicile
	s tempPersonOther.MUPSMeasure = MUPSMeasure
	s tempPersonOther.HeaSerWant = HeaSerWant
	i PHeartRate '= "" d
	.s tempPersonOther.PHeartRate = $Number(PHeartRate)
	i PHighHBP '= "" d
	.s tempPersonOther.PHighHBP = $Number(PHighHBP)
	i PLowHBP '= "" d
	.s tempPersonOther.PLowHBP = $Number(PLowHBP)
	s tempPersonOther.PersonPost = PersonPost
	s tempPersonOther.RHBloodType = RHBloodType
	s result=""
	s result=tempPersonOther.%Save()
    q ""
}

ClassMethod GetPersonOtherColumns() As %String
{
	s ColumnsString = "^FatherName^MotherName^SpouseName^Height1^Weight1^IncomeSource^WorkPlaceAdd^WorkPlacePhone^Domicile^MUPSMeasure^HeaSerWant^PHeartRate^PHighHBP^PLowHBP^PersonPost^RHBloodType"
	Quit ColumnsString
}

/// Creator: wangbo
/// CreatDate：2009—12-15
/// Description:设置个人档案的家庭信息
/// Table：PersonHealthRecordMain
/// Input:CommunityCode, start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod SetFamilyRowId(PersonRowId As %String, FamilyRowId) As %String
{
	q:(PersonRowId = "") ""
	q:(FamilyRowId = "") ""
		
	&sql(update CHSS.PersonHealthRecordMain set FamilyRowId=:FamilyRowId where %ID=:PersonRowId)
	i SQLCODE = 0 d
	.w "{""success"":""true"",""info"":"_PersonRowId_"}"
    .
    e  d
    .w "{""success"":""false"",""info"":""数据导入出错!""}"
    
    q ""
}

/// Creator: wangbo
/// CreatDate：2010—04-14
/// Description:添加(临时)个人档案
/// Table：PersonHealthRecordMain
/// Input:CommunityCode,PersonName,SexDR,Birth,CardNumber,IDCard,OperatorInput,Address,LinkManName,LinkManPhone
/// Output：
/// Return：
/// Others：
ClassMethod SaveTempPersonInfo(CommunityCode As %String, PersonName As %String, SexDR As %Integer, Birth As %Date, CardNumber As %String, IDCard As %String, OperatorInput As %Integer, DateRegister As %Date, Address As %String, LinkManName As %String, LinkManPhone As %String) As %String
{
	
	s tempPerson=""
	s tempPerson=##class(CHSS.PersonHealthRecordMain).%New()
	q:(tempPerson="") ""
	q:(CommunityCode="") ""
	s PersonCode = ""
	;根据CommunityCode返回PersonCode
	s PersonCode = ##class(CHSSWeb.SystemIdService).GetSystemId2(CommunityCode,"PersonHealthRecordMain")
	
	s ReturnCode= ##class(CHSSWeb.PHRService).existColumn("IDCard",IDCard,"add","")
	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""证件号码: "_IDCard_" 已存在! 请重新输入!""}"
	q:(ReturnCode = "1") ""
	;s ReturnCode= ##class(CHSSWeb.PHRService).existCardNumber(CardNumber,"add","")
	;i (ReturnCode'="0") d
	;.w "{""success"":""false"",""info"":""卡号: "_CardNumber_" 已存在! 请重新输入!""}"
	q:(ReturnCode = "1") ""
	s ReturnCode= ##class(CHSSWeb.PHRService).existPersonCode(PersonCode)
	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""个人编码: "_PersonCode_" 已存在! 请重新添加!""}"
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
	.s tempPerson.DateRegister=DateRegister
	.
	.i OperatorInput '= "" d
	..s OperatorInputobj=##class(User.SSUser).%OpenId(OperatorInput)
	..s tempPerson.OperatorInput=OperatorInputobj
	.
	
	.s tempPerson.Address = Address
	.
	.s tempPerson.LinkManName = LinkManName
	.s tempPerson.LinkManPhone = LinkManPhone
	.
	.
	.i PersonStatus '= "" d
	..s PersonStatusobj=##class(CHSS.DictArchivesStatus).%OpenId(PersonStatus)
	..s tempPerson.PersonStatus = PersonStatusobj
	.
	.
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
    .
    .i result = "1" d
    ..;d ##class(CHSSWeb.PHROtherService).SavePersonOtherInfo(PersonRowId,FatherName,MotherName,SpouseName,Height,Weight,IncomeSource,WorkPlaceAdd,WorkPlacePhone, Domicile, MUPSMeasure, HeaSerWant, PHeartRate, PHighHBP, PLowHBP, PersonPost)
    ..w "{""success"":""true"",""info"":"_tempPerson.%Id()_"}"
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
 
    q ""
}

Storage Default
{
<Data name="PHROtherServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PHROtherServiceD</DataLocation>
<DefaultData>PHROtherServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PHROtherServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PHROtherServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PHROtherServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
