Class CHSSWeb.PersonEarthquakeInfoService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod PersonEarthquakeInfoList(PersonRowIdDR As %Integer, start As %Integer, limit As %Integer, sort As %String, searchField As %String, searchValue As %String) As %String
{
		//n (communityCode, start, limit, sort)
        Set PersonRowIdDR=$G(PersonRowIdDR)
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set RowId = 0
		For  Set RowId=$O(^CHSS.PersonEarthquakeInfoI("PersonRowIdDRIndex",PersonRowIdDR,RowId)) q:RowId=""  d
		.s tempPersonEarthquake=##class(CHSS.PersonEarthquakeInfo).%OpenId(RowId)
		.set CityThen = ""
		.set CityThenName=""
		.i tempPersonEarthquake.CityThen '= "" d
		..set CityThen = tempPersonEarthquake.CityThen.%Id()
		..set CityThenName = tempPersonEarthquake.CityThen.Description
		.set CountryThen = ""
	    .set CountryThenName=""
		.i tempPersonEarthquake.CountryThen '= "" d
		..set CountryThen = tempPersonEarthquake.CountryThen.%Id()
		..set CountryThenName = tempPersonEarthquake.CountryThen.Description
		.set TownThen = ""
		.set TownThenName=""
		.i tempPersonEarthquake.TownThen '= "" d
		..set TownThen = tempPersonEarthquake.TownThen.%Id()
		..set TownThenName = tempPersonEarthquake.TownThen.Description
		.set HurtReason = ""
		.set HurtReasonName=""
		.i tempPersonEarthquake.HurtReason '= "" d
		..set HurtReason = tempPersonEarthquake.HurtReason.%Id()
		..set HurtReasonName = tempPersonEarthquake.HurtReason.Description
		.set bHurt = tempPersonEarthquake.bHurt
		.set bInHospital = tempPersonEarthquake.bInHospital
		.set bAmputation = tempPersonEarthquake.bAmputation
		.set ChildNum = tempPersonEarthquake.ChildNum
		.set TransferHospitalName = tempPersonEarthquake.TransferHospitalName
		.set HospitalName = tempPersonEarthquake.HospitalName
		.set SanitaryConditionAfter = ""
		.set SanitaryConditionAfterName=""
		.i tempPersonEarthquake.SanitaryConditionAfter '= "" d
		..set SanitaryConditionAfter = tempPersonEarthquake.SanitaryConditionAfter.%Id()
		..set SanitaryConditionAfterName = tempPersonEarthquake.SanitaryConditionAfter.Description	 
		.set Dept = ""
		.set DeptName = ""
		.i tempPersonEarthquake.Dept '= "" d
		..set Dept = tempPersonEarthquake.Dept.%Id()
		..set DeptName =  tempPersonEarthquake.Dept.CTLOCDesc
		.
		.set InHospitalNumber = tempPersonEarthquake.InHospitalNumber
		.set DateOfInHos  = tempPersonEarthquake.DateOfInHos
		.i DateOfInHos '= "" d
		..s DateOfInHos = $zd(DateOfInHos,3)
		.
		.set TimeOfInHos  = tempPersonEarthquake.TimeOfInHos 
		.i TimeOfInHos  '="" d
		..s TimeOfInHos =$zt(TimeOfInHos,4)
		.
		.set bOPS = tempPersonEarthquake.bOPS 
		.
		.s bTransfer = tempPersonEarthquake.bTransfer
		.s TransferInHospitalNumber = tempPersonEarthquake.TransferInHospitalNumber
		.s bBury = tempPersonEarthquake.bBury
		.
		.s TimeOfBury  = tempPersonEarthquake.TimeOfBury
		.s bEatorDrink  = tempPersonEarthquake.bEatorDrink
		.s bClearHead  = tempPersonEarthquake.bClearHead
		.
		.set BuryPart = ""
		.set BuryPartName=""
		.i tempPersonEarthquake.BuryPart '= "" d
		..set BuryPart = tempPersonEarthquake.BuryPart.%Id()
		..set BuryPartName = tempPersonEarthquake.BuryPart.Description
		.
		.set SpouseInfo = ""
		.set SpouseInfoName=""
		.i tempPersonEarthquake.SpouseInfo '="" d
		..set SpouseInfo = tempPersonEarthquake.SpouseInfo.%Id()
		..set SpouseInfoName= tempPersonEarthquake.SpouseInfo.Description
		. 
		.set FatherInfo  = ""
		.set FatherInfoName = ""
		.i tempPersonEarthquake.FatherInfo'="" d
		..set FatherInfo= tempPersonEarthquake.FatherInfo.%Id()
		..set FatherInfoName = tempPersonEarthquake.FatherInfo.Description
		.
		.set MotherInfo  = ""
		.set MotherInfoName = ""
		.i tempPersonEarthquake.MotherInfo '="" d
		..set MotherInfo = tempPersonEarthquake.MotherInfo.%Id()
		..set MotherInfoName = tempPersonEarthquake.MotherInfo.Description
		.
		.set ChildDiedBefore = tempPersonEarthquake.ChildDiedBefore 
		.set ChildDiedAfter = tempPersonEarthquake.ChildDiedAfter 
		.set ChildUnknownAfter  = tempPersonEarthquake.ChildUnknownAfter 
		.set ChildInHospitalAfter = tempPersonEarthquake.ChildInHospitalAfter 
		.set SibNum  = tempPersonEarthquake.SibNum 
		.set SibDiedBefore = tempPersonEarthquake.SibDiedBefore 
		.set SibDiedAfter = tempPersonEarthquake.SibDiedAfter
		.set SibUnknownAfter  = tempPersonEarthquake.SibUnknownAfter 
		.set SibInHospitalAfter  = tempPersonEarthquake.SibInHospitalAfter 
		.set OtherInHospitalAfter  = tempPersonEarthquake.OtherInHospitalAfter 
		.set OtherUnknown = tempPersonEarthquake.OtherUnknown 
		.set OtherDiedAfter  = tempPersonEarthquake.OtherDiedAfter 
		.set OtherDiedBefore = tempPersonEarthquake.OtherDiedBefore 
		.set bFriendDied  = tempPersonEarthquake.bFriendDied 
		.set bHouseAverage  = tempPersonEarthquake.bHouseAverage 
		.set bSeePersonBury  =tempPersonEarthquake.bSeePersonBury 
		.set bSeePersonDied  = tempPersonEarthquake.bSeePersonDied 
		.set bSeePersonHurt = tempPersonEarthquake.bSeePersonHurt 
		.set bResidenceStatusChanged  = tempPersonEarthquake.bResidenceStatusChanged
		.set HouseTypeBefore  = ""
		.set HouseTypeBeforeName=""
		.i tempPersonEarthquake.HouseTypeBefore '="" d
		..set HouseTypeBefore  = tempPersonEarthquake.HouseTypeBefore.%Id()
		..set HouseTypeBeforeName= tempPersonEarthquake.HouseTypeBefore.Description
		.set ResidentialDensityBefore  = tempPersonEarthquake.ResidentialDensityBefore
		.set TimeOfClear = tempPersonEarthquake.TimeOfClear
		.
		.set SanitaryConditionBefore = ""
		.set SanitaryConditionBeforeName =""
		.i tempPersonEarthquake.SanitaryConditionBefore '="" d
		..set SanitaryConditionBefore = tempPersonEarthquake.SanitaryConditionBefore.%Id()
		..set SanitaryConditionBeforeName = tempPersonEarthquake.SanitaryConditionBefore.Description
		.
		.set HouseTypeAfter  = ""
		.set HouseTypeAfterName=""
		.i tempPersonEarthquake.HouseTypeAfter '="" d
		..set HouseTypeAfter  = tempPersonEarthquake.HouseTypeAfter.%Id()
		..set HouseTypeAfterName= tempPersonEarthquake.HouseTypeAfter.Description
		.set TransferDept  = ""
		.set TransferDeptName=""
		.i tempPersonEarthquake.TransferDept '="" d
		..set TransferDept  = tempPersonEarthquake.TransferDept.%Id()
		..set TransferDeptName= tempPersonEarthquake.TransferDept.CTLOCDesc
		.set HurtPart = ""
		.set HurtPartName = ""
		.i tempPersonEarthquake.HurtPart '="" d
		..set HurtPart=tempPersonEarthquake.HurtPart.%Id()
		..set HurtPartName=tempPersonEarthquake.HurtPart.Description
		.set Amputation=""
		.set AmputationName=""
		.i tempPersonEarthquake.Amputation '="" d
		..set Amputation=tempPersonEarthquake.Amputation.%Id()
		..set AmputationName=tempPersonEarthquake.Amputation.Description
		.set ResidentialDensityAfter  = tempPersonEarthquake.ResidentialDensityAfter
		.set bSampleRoom  =tempPersonEarthquake.bSampleRoom 
		.set DateOfStartLive = tempPersonEarthquake.DateOfStartLive
	    .i DateOfStartLive '="" d
		..s DateOfStartLive = $zd(DateOfStartLive,3)
		.set DateOfEndLive  = tempPersonEarthquake.DateOfEndLive
		.i DateOfEndLive '="" d
		..s DateOfEndLive  = $zd(DateOfEndLive ,3) 
		.
		.set OperatorInput =""
		.set OperatorInputName=""
		.i tempPersonEarthquake.OperatorInput '="" d
		..set OperatorInput = tempPersonEarthquake.OperatorInput.%Id() 
		..set OperatorInputName=tempPersonEarthquake.OperatorInput.SSUSRName   
		.
		.set DateInput =tempPersonEarthquake.DateInput
		.i DateInput '="" d
		..s DateInput = $zd(DateInput,3)
		.Set tmp= RowId_"^"_CityThen_"^"_CityThenName_"^"_bHurt_"^"_bInHospital _"^"_HospitalName_"^"_Dept_"^"_DeptName_"^"_InHospitalNumber_"^"_DateOfInHos_"^"_TimeOfInHos_"^"_bOPS_"^"_bTransfer_"^"_bBury_"^"_TimeOfBury_"^"_bEatorDrink_"^"_bClearHead_"^"_BuryPart_"^"_BuryPartName_"^"_bAmputation_"^"_SpouseInfo_"^"_SpouseInfoName_"^"_FatherInfo_"^"_FatherInfoName_"^"_MotherInfo_"^"_MotherInfoName_"^"_ChildDiedBefore_"^"_ChildDiedAfter_"^"_ChildUnknownAfter_"^"_ChildInHospitalAfter_"^"_SibNum_"^"_SibDiedBefore_"^"_SibDiedAfter_"^"_SibUnknownAfter_"^"_SibInHospitalAfter_"^"_OtherInHospitalAfter_"^"_OtherUnknown_"^"_OtherDiedAfter_"^"_OtherDiedBefore_"^"_bHouseAverage_"^"_bSeePersonBury_"^"_bSeePersonDied_"^"_bSeePersonHurt_"^"_bResidenceStatusChanged_"^"_HouseTypeBefore_"^"_HouseTypeBeforeName_"^"_ResidentialDensityBefore_"^"_SanitaryConditionBefore_"^"_SanitaryConditionBeforeName_"^"_HouseTypeAfter_"^"_HouseTypeAfterName_"^"_ResidentialDensityAfter_"^"_bSampleRoom_"^"_DateOfStartLive_"^"_DateOfEndLive_"^"_OperatorInput_"^"_OperatorInputName_"^"_CountryThen_"^"_CountryThenName_"^"_ TownThen_"^"_TownThenName_"^"_HurtReason_"^"_HurtReasonName_"^"_SanitaryConditionAfter_"^"_DateInput_"^"_bFriendDied_"^"_ChildNum_"^"_HurtPart_"^"_HurtPartName_"^"_Amputation_"^"_AmputationName_"^"_TimeOfClear_"^"_TransferHospitalName_"^"_TransferInHospitalNumber_"^"_TransferDept_"^"_TransferDeptName
	    .Set count=count+1
	    .If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("RowId^CityThen^CityThenName^bHurt^bInHospital ^HospitalName^Dept^DeptName^InHospitalNumber^DateOfInHos^TimeOfInHos^bOPS^bTransfer^bBury^TimeOfBury^bEatorDrink^bClearHead^BuryPart^BuryPartName^bAmputation^SpouseInfo^SpouseInfoName^FatherInfo^FatherInfoName^MotherInfo^MotherInfoName^ChildDiedBefore^ChildDiedAfter^ChildUnknownAfter^ChildInHospitalAfter^SibNum^SibDiedBefore^SibDiedAfter^SibUnknownAfter^SibInHospitalAfter^OtherInHospitalAfter^OtherUnknown^OtherDiedAfter^OtherDiedBefore^bHouseAverage^bSeePersonBury^bSeePersonDied^bSeePersonHurt^bResidenceStatusChanged^HouseTypeBefore^HouseTypeBeforeName^ResidentialDensityBefore^SanitaryConditionBefore^SanitaryConditionBeforeName^HouseTypeAfter^HouseTypeAfterName^ResidentialDensityAfter^bSampleRoom^DateOfStartLive^DateOfEndLive^OperatorInput1^OperatorInput1Name^CountryThen^CountryThenName^TownThen^TownThenName^HurtReason^HurtReasonName^SanitaryConditionAfter^DateInput1^bFriendDied^ChildNum^HurtPart^HurtPartName^Amputation^AmputationName^TimeOfClear^TransferHospitalName^TransferInHospitalNumber^TransferDept^TransferDeptName",count)
	 	k json
		Quit resultString
}

/// 添加
ClassMethod Insert(RowId As %Integer, CityThen As %Integer, CountryThen As %Integer, TownThen As %Integer, bInHospital As %String, HospitalName As %String, Dept As %Integer, InHospitalNumber As %String, PersonRowIdDR As %Integer, DateOfInHos As %Date, TimeOfInHos As %Time, bOPS As %String, bTransfer As %String, HurtReason As %Integer, TimeOfBury As %Numeric, bEatorDrink As %String, BuryPart As %Integer, bAmputation As %String, SpouseInfo As %Integer, FatherInfo As %Integer, MotherInfo As %Integer, ChildNum As %Numeric, ChildDiedBefore As %Numeric, ChildDiedAfter As %Numeric, ChildUnknownAfter As %Numeric, ChildInHospitalAfter As %Numeric, SibNum As %Numeric, SibDiedBefore As %Numeric, SibDiedAfter As %Numeric, SibUnknownAfter As %Numeric, SibInHospitalAfter As %Numeric, OtherInHospitalAfter As %Numeric, OtherUnknown As %Numeric, OtherDiedAfter As %Numeric, OtherDiedBefore As %Numeric, bFriendDied As %String, bHouseAverage As %String, bSeePersonBury As %String, bSeePersonDied As %String, bSeePersonHurt As %String, bResidenceStatusChanged As %String, TransferHospitalName As %String, TransferDept As %Integer, TransferInHospitalNumber As %String, bClearHead As %String, TimeOfClear As %Numeric, HouseTypeBefore As %Integer, ResidentialDensityBefore As %Numeric, SanitaryConditionBefore As %Integer, HouseTypeAfter As %Integer, SanitaryConditionAfter As %Integer, bSampleRoom As %String, DateOfStartLive As %Date, DateOfEndLive As %Date, OperatorInput As %Integer, DateInput As %Date, bBury As %String, ResidentialDensityAfter As %Integer, HurtPart As %Integer, Amputation As %Integer, bHurt As %String) As %String
{

	s tempPersonEarthquake=""
    s ReturnCode=..existPersonRowIdDR(PersonRowIdDR)
	i (ReturnCode'="0") d
	.q:($d(PersonRowIdDR)=0)||(PersonRowIdDR="")
	.s result=""
	.s tempPersonEarthquake=##class(CHSS.PersonEarthquakeInfo).%OpenId(RowId)
	e  d
	.s tempPersonEarthquake=##class(CHSS.PersonEarthquakeInfo).%New()
	i CityThen '= "" d
	.s CityThenobj=##class(CHSS.DictCity).%OpenId(CityThen)
	.s tempPersonEarthquake.CityThen=CityThenobj
	i CountryThen '="" d
	.s CountryThenobj=##class(CHSS.DictSection).%OpenId(CountryThen)
	.s tempPersonEarthquake.CountryThen=CountryThenobj
	.
	i TownThen '="" d
	.s TownThenobj=##class(CHSS.DictStreet).%OpenId(TownThen)
	.s tempPersonEarthquake.TownThen=TownThenobj

	s tempPersonEarthquake.bInHospital=bInHospital
	s tempPersonEarthquake.SibUnknownAfter=SibUnknownAfter
	s tempPersonEarthquake.HospitalName=HospitalName
	i Dept'="" d
	.s Deptobj=##class(User.CTLoc).%OpenId(Dept)
	.s tempPersonEarthquake.Dept= Deptobj
	s tempPersonEarthquake.InHospitalNumber=InHospitalNumber
	s tempPersonEarthquake.ChildDiedAfter=ChildDiedAfter
	i DateOfInHos '="" d
	.s DateOfInHos=$zdh(DateOfInHos,3)
	.s tempPersonEarthquake.DateOfInHos=DateOfInHos 
    s tempPersonEarthquake.bOPS=bOPS
	s tempPersonEarthquake.bTransfer=bTransfer
    s tempPersonEarthquake.TransferHospitalName=TransferHospitalName
    i TransferDept'="" d
    .s TransferDeptobj=##class(User.CTLoc).%OpenId(TransferDept)
    .s tempPersonEarthquake.TransferDept= TransferDeptobj
    s tempPersonEarthquake.TransferInHospitalNumber= TransferInHospitalNumber
    i HurtReason '="" d
    .s HurtReasonobj=##class(CHSS.DictHurtReason).%OpenId(HurtReason)
    .s tempPersonEarthquake.HurtReason=HurtReasonobj
    i SanitaryConditionBefore '="" d
	.s SanitaryConditionBeforeobj=##class(CHSS.DictSanitaryCondition).%OpenId(SanitaryConditionBefore)
	.s tempPersonEarthquake.SanitaryConditionBefore=SanitaryConditionBeforeobj	
    s tempPersonEarthquake.bBury=bBury
    i PersonRowIdDR '="" d
    .s PersonRowIdDRobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdDR)
    .s tempPersonEarthquake.PersonRowIdDR=PersonRowIdDRobj
    s tempPersonEarthquake.TimeOfBury=$NUMBER(TimeOfBury)
    s tempPersonEarthquake.bEatorDrink=bEatorDrink
    s tempPersonEarthquake.bClearHead=bClearHead
    s tempPersonEarthquake.TimeOfClear=$NUMBER(TimeOfClear)
    s tempPersonEarthquake.bHurt=bHurt

	i HouseTypeAfter '="" d
    .s HouseTypeAfterobj=##class(CHSS.DictHouseTypeBefore).%OpenId(HouseTypeAfter)
    .s tempPersonEarthquake.HouseTypeAfter=HouseTypeAfterobj
    s tempPersonEarthquake.ResidentialDensityAfter=ResidentialDensityAfter
    i BuryPart'="" d
    .s BuryPartobj=##class(CHSS.DictBuryPart).%OpenId(BuryPart)
    .s tempPersonEarthquake.BuryPart=BuryPartobj
    s tempPersonEarthquake.bAmputation=bAmputation
    i SpouseInfo'="" d
    .s SpouseInfoobj=##class(CHSS.DictRelativeInfo).%OpenId(SpouseInfo)
    .s tempPersonEarthquake.SpouseInfo=SpouseInfoobj
    i FatherInfo '="" d
    .s FatherInfoobj=##class(CHSS.DictRelativeInfo).%OpenId(FatherInfo)
    .s tempPersonEarthquake.FatherInfo=FatherInfoobj
    i MotherInfo '="" d
    .s MotherInfoobj=##class(CHSS.DictRelativeInfo).%OpenId(MotherInfo)
    .s tempPersonEarthquake.MotherInfo=MotherInfoobj
    s tempPersonEarthquake.ChildNum=ChildNum
	s tempPersonEarthquake.ChildDiedBefore=$Number(ChildDiedBefore)
    s tempPersonEarthquake.ChildUnknownAfter=ChildUnknownAfter
    s tempPersonEarthquake.ChildInHospitalAfter=ChildInHospitalAfter
    s tempPersonEarthquake.SibNum=$Number(SibNum)
    s tempPersonEarthquake.SibDiedBefore=SibDiedBefore
    s tempPersonEarthquake.SibDiedAfter=SibDiedAfter
    s tempPersonEarthquake.SibInHospitalAfter=SibInHospitalAfter
    s tempPersonEarthquake.OtherInHospitalAfter=OtherInHospitalAfter
    s tempPersonEarthquake.OtherUnknown=OtherUnknown
    s tempPersonEarthquake.OtherDiedAfter=OtherDiedAfter
    s tempPersonEarthquake.OtherDiedBefore=OtherDiedBefore
    s tempPersonEarthquake.bFriendDied=bFriendDied
    s tempPersonEarthquake.bHouseAverage=bHouseAverage
    s tempPersonEarthquake.bSeePersonBury=bSeePersonBury
    s tempPersonEarthquake.bSeePersonDied=bSeePersonDied
    s tempPersonEarthquake.bSeePersonHurt=bSeePersonHurt
    s tempPersonEarthquake.bResidenceStatusChanged=bResidenceStatusChanged
    i HouseTypeBefore'="" d
    .s HouseTypeBeforeobj=##class(CHSS.DictHouseTypeBefore).%OpenId(HouseTypeBefore)
    .s tempPersonEarthquake.HouseTypeBefore=HouseTypeBeforeobj
    i Amputation '="" d
    .s Amputationobj=##class(CHSS.DictAmputation).%OpenId(Amputation)
    .s tempPersonEarthquake.Amputation=Amputationobj
    s tempPersonEarthquake.ResidentialDensityBefore=ResidentialDensityBefore
    i SanitaryConditionAfter'="" d
    .s SanitaryConditionAfterobj=##class(CHSS.DictSanitaryCondition).%OpenId(SanitaryConditionAfter)
    .s tempPersonEarthquake.SanitaryConditionAfter=SanitaryConditionAfterobj
    s tempPersonEarthquake.bSampleRoom=bSampleRoom
    i DateOfStartLive '="" d
	.s DateOfStartLive=$zdh(DateOfStartLive,3)
	.s tempPersonEarthquake.DateOfStartLive=DateOfStartLive 
     i DateOfEndLive '="" d
	.s DateOfEndLive=$zdh(DateOfEndLive,3)
	.s tempPersonEarthquake.DateOfEndLive=DateOfEndLive 
	 i TimeOfInHos '="" d
	.s TimeOfInHos=$zth(TimeOfInHos,4)
	.s tempPersonEarthquake.TimeOfInHos=TimeOfInHos
	 i OperatorInput '="" d
	.s OperatorInputobj=##class(User.SSUser).%OpenId(OperatorInput)
	.s tempPersonEarthquake.OperatorInput=OperatorInputobj
	 i HurtPart '="" d
	.s HurtPartobj=##class(CHSS.DictHurtPart).%OpenId(HurtPart)
	.s tempPersonEarthquake.HurtPart=HurtPartobj
     i DateInput '="" d
	.s DateInput=$zdh(DateInput,3)
	.s tempPersonEarthquake.DateInput=DateInput 
	
	s result=tempPersonEarthquake.%Save()

	i result = "1" d
    .w "{""success"":""true"",""info"":"_tempPersonEarthquake.%Id()_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
}

ClassMethod existPersonRowIdDR(PersonRowIdDR) As %String
{
	q:PersonRowIdDR="" "-1"
	q:$d(^CHSS.PersonEarthquakeInfoI("PersonRowIdDRIndex",PersonRowIdDR)) "1"
	q "0"
}

Storage Default
{
<Data name="PersonEarthquakeInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonEarthqADFD</DataLocation>
<DefaultData>PersonEarthquakeInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonEarthqADFD</IdLocation>
<IndexLocation>^CHSSWeb.PersonEarthqADFI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonEarthqADFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
