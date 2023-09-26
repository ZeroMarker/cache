Class CHSSWeb.FamilyEarthquakeInfoService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2009—06-23
/// Description:家庭地震伤亡情况
/// Table：FamilyEarthquakeInfo
/// Input: FamilyEarthquakeInfo
/// Output：
/// Return：
/// Others：
ClassMethod List(FamilyRowIdParref As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
		Set FamilyRowIdParref=$G(FamilyRowIdParref)
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set RowId = 0
		
		
		For  Set RowId=$O(^CHSS.FamilyEarthquakeInfoI("FamilyRowIdParrefIndex",FamilyRowIdParref,RowId)) q:RowId=""  d
		.
		.s tempFamilyEarthquakeInfo=##class(CHSS.FamilyEarthquakeInfo).%OpenId(RowId)
		
		.set FamilyPropertyName = ""
		.set FamilyProperty = ""
		.i tempFamilyEarthquakeInfo.FamilyProperty '= "" d
		.. s FamilyProperty = tempFamilyEarthquakeInfo.FamilyProperty.%Id()
		.. s FamilyPropertyName =  tempFamilyEarthquakeInfo.FamilyProperty.Description
		
		.s NumOfLabourBefore = tempFamilyEarthquakeInfo.NumOfLabourBefore
		.s NumOfOtherBefore = tempFamilyEarthquakeInfo.NumOfOtherBefore
		.s NumOfManBefore = tempFamilyEarthquakeInfo.NumOfManBefore
		.s NumOfWomenBefore = tempFamilyEarthquakeInfo.NumOfWomenBefore
		
		.s NumOfLabourAfter = tempFamilyEarthquakeInfo.NumOfLabourAfter
		.s NumOfOtherAfter = tempFamilyEarthquakeInfo.NumOfOtherAfter
		.s NumOfManAfter = tempFamilyEarthquakeInfo.NumOfManAfter
		.s NumOfWomenAfter = tempFamilyEarthquakeInfo.NumOfWomenAfter
		
		.s PerIncomeBefore = tempFamilyEarthquakeInfo.PerIncomeBefore
		.s AllIncomeBefore = tempFamilyEarthquakeInfo.AllIncomeBefore
		.s PerIncomeAfter = tempFamilyEarthquakeInfo.PerIncomeAfter
		.s AllIncomeAfter = tempFamilyEarthquakeInfo.AllIncomeAfter
		
		.s ExpensesOfFoodBefore = tempFamilyEarthquakeInfo.ExpensesOfFoodBefore
		.s ExpensesOfDressBefore = tempFamilyEarthquakeInfo.ExpensesOfDressBefore
		.s ExpensesOfFacilitiesBefore = tempFamilyEarthquakeInfo.ExpensesOfFacilitiesBefore
		.s ExpensesOfHealthCareBefore = tempFamilyEarthquakeInfo.ExpensesOfHealthCareBefore
		
		.s ExpensesOfTransportBefore = tempFamilyEarthquakeInfo.ExpensesOfTransportBefore
		.s ExpensesOfRecreationBefore = tempFamilyEarthquakeInfo.ExpensesOfRecreationBefore
		.s ExpensesOfLiveBefore = tempFamilyEarthquakeInfo.ExpensesOfLiveBefore
		.s ExpensesOfOverheadsBefore = tempFamilyEarthquakeInfo.ExpensesOfOverheadsBefore
		
		.s ExpensesOfFoodAfter = tempFamilyEarthquakeInfo.ExpensesOfFoodAfter
		.s ExpensesOfDressAfter = tempFamilyEarthquakeInfo.ExpensesOfDressAfter
		.s ExpensesOfFacilitiesAfter = tempFamilyEarthquakeInfo.ExpensesOfFacilitiesAfter
		.s ExpensesOfHealthCareAfter = tempFamilyEarthquakeInfo.ExpensesOfHealthCareAfter
	
		.s ExpensesOfTransportAfter = tempFamilyEarthquakeInfo.ExpensesOfTransportAfter
		.s ExpensesOfLiveAfter = tempFamilyEarthquakeInfo.ExpensesOfLiveAfter
		.s ExpensesOfRecreationAfter = tempFamilyEarthquakeInfo.ExpensesOfRecreationAfter
		.s ExpensesOfOverheadsAfter = tempFamilyEarthquakeInfo.ExpensesOfOverheadsAfter
		
		.s bHighwaysBefore = tempFamilyEarthquakeInfo.bHighwaysBefore
		
		.set HighwayTypeName = ""
		.set HighwayType = ""
		.i tempFamilyEarthquakeInfo.HighwayType '= "" d
		.. s HighwayType = tempFamilyEarthquakeInfo.HighwayType.%Id()
		.. s HighwayTypeName =  tempFamilyEarthquakeInfo.HighwayType.Description
		
		.s bHighwayAverage = tempFamilyEarthquakeInfo.bHighwayAverage
		.s TimeOfInterdiction = tempFamilyEarthquakeInfo.TimeOfInterdiction
		
		.set CommunicationBeforeName = ""
		.set CommunicationBefore = ""
		.i tempFamilyEarthquakeInfo.CommunicationBefore '= "" d
		.. s CommunicationBefore = tempFamilyEarthquakeInfo.CommunicationBefore.%Id()
		.. s CommunicationBeforeName =  tempFamilyEarthquakeInfo.CommunicationBefore.Description
		
		.s bCommunicationAverage = tempFamilyEarthquakeInfo.bCommunicationAverage
		
		.s TimeOfInterrupt = tempFamilyEarthquakeInfo.TimeOfInterrupt
		.s HaveTBPatient = tempFamilyEarthquakeInfo.HaveTBPatient
		
		.s NumberOfTB = tempFamilyEarthquakeInfo.NumberOfTB
		.s bTreatment = tempFamilyEarthquakeInfo.bTreatment
		
		.set OperatorInputName = ""
		.set OperatorInput = ""
		.i tempFamilyEarthquakeInfo.OperatorInput '= "" d
		..s OperatorInput = tempFamilyEarthquakeInfo.OperatorInput.%Id()
		..s OperatorInputName = tempFamilyEarthquakeInfo.OperatorInput.SSUSRName
		
		.set DateInput = tempFamilyEarthquakeInfo.DateInput
		.i DateInput '= "" d
		..s DateInput = $zd(DateInput,3)
		
		.
		.Set tmp = RowId_"^"_FamilyProperty_"^"_FamilyPropertyName_"^"_NumOfLabourBefore_"^"_NumOfOtherBefore_"^"_NumOfManBefore_"^"_NumOfWomenBefore_"^"_NumOfLabourAfter_"^"_NumOfOtherAfter_"^"_NumOfManAfter_"^"_NumOfWomenAfter_"^"_PerIncomeBefore_"^"_AllIncomeBefore_"^"_PerIncomeAfter_"^"_AllIncomeAfter_"^"_ExpensesOfFoodBefore_"^"_ExpensesOfDressBefore_"^"_ExpensesOfFacilitiesBefore_"^"_ExpensesOfHealthCareBefore_"^"_ExpensesOfTransportBefore_"^"_ExpensesOfRecreationBefore_"^"_ExpensesOfLiveBefore_"^"_ExpensesOfOverheadsBefore_"^"_ExpensesOfFoodAfter_"^"_ExpensesOfDressAfter_"^"_ExpensesOfFacilitiesAfter_"^"_ExpensesOfHealthCareAfter_"^"_ExpensesOfTransportAfter_"^"_ExpensesOfLiveAfter_"^"_ExpensesOfRecreationAfter_"^"_ExpensesOfOverheadsAfter_"^"_bHighwaysBefore_"^"_HighwayType_"^"_HighwayTypeName_"^"_bHighwayAverage_"^"_TimeOfInterdiction_"^"_CommunicationBefore_"^"_CommunicationBeforeName_"^"_bCommunicationAverage_"^"_TimeOfInterrupt_"^"_HaveTBPatient_"^"_NumberOfTB_"^"_bTreatment_"^"_OperatorInput_"^"_OperatorInputName_"^"_DateInput
	    .Set count=count+1
	    .If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.
		.
	    Set resultString = json.getJsonData("RowId^FamilyProperty^FamilyPropertyName^NumOfLabourBefore^NumOfOtherBefore^NumOfManBefore^NumOfWomenBefore^NumOfLabourAfter^NumOfOtherAfter^NumOfManAfter^NumOfWomenAfter^PerIncomeBefore^AllIncomeBefore^PerIncomeAfter^AllIncomeAfter^ExpensesOfFoodBefore^ExpensesOfDressBefore^ExpensesOfFacilitiesBefore^ExpensesOfHealthCareBefore^ExpensesOfTransportBefore^ExpensesOfRecreationBefore^ExpensesOfLiveBefore^ExpensesOfOverheadsBefore^ExpensesOfFoodAfter^ExpensesOfDressAfter^ExpensesOfFacilitiesAfter^ExpensesOfHealthCareAfter^ExpensesOfTransportAfter^ExpensesOfLiveAfter^ExpensesOfRecreationAfter^ExpensesOfOverheadsAfter^bHighwaysBefore^HighwayType^HighwayTypeName^bHighwayAverage^TimeOfInterdiction^CommunicationBefore^CommunicationBeforeName^bCommunicationAverage^TimeOfInterrupt^HaveTBPatient^NumberOfTB^bTreatment^OperatorInput1^OperatorInput1Name^DateInput1",count)
	 	k json
	 	
		Quit resultString
}

/// Creator: lyy
/// CreatDate：2009—06-23
/// Description:添加家庭地震伤亡情况
/// Table：FamilyEarthquakeInfo
/// Input: FamilyEarthquakeInfo
/// Output：
/// Return：
/// Others：
ClassMethod Insert(FamilyRowId As %Integer, FamilyProperty As %Integer, NumOfLabourBefore As %Numeric, NumOfOtherBefore As %Numeric, NumOfManBefore As %Numeric, NumOfWomenBefore As %Numeric, NumOfLabourAfter As %Numeric, NumOfOtherAfter As %Numeric, NumOfManAfter As %Numeric, NumOfWomenAfter As %Numeric, PerIncomeBefore As %Float, AllIncomeBefore As %Float, PerIncomeAfter As %Float, AllIncomeAfter As %Float, ExpensesOfFoodBefore As %Float, ExpensesOfDressBefore As %Float, ExpensesOfFacilitiesBefore As %Float, ExpensesOfHealthCareBefore As %Float, ExpensesOfTransportBefore As %Float, ExpensesOfRecreationBefore As %Float, ExpensesOfLiveBefore As %Float, ExpensesOfOverheadsBefore As %Float, ExpensesOfFoodAfter As %Float, ExpensesOfDressAfter As %Float, ExpensesOfFacilitiesAfter As %Float, ExpensesOfHealthCareAfter As %Float, ExpensesOfTransportAfter As %Float, ExpensesOfLiveAfter As %Float, ExpensesOfRecreationAfter As %Float, ExpensesOfOverheadsAfter As %Float, bHighwaysBefore As %String, HighwayType As %Integer, bHighwayAverage As %String, TimeOfInterdiction As %Numeric, CommunicationBefore As %Integer, bCommunicationAverage As %String, TimeOfInterrupt As %Numeric, HaveTBPatient As %String, NumberOfTB As %Numeric, bTreatment As %String, OperatorInput As %Integer, DateInput As %Date) As %String
{
    
    s tempFamilyEarthquakeInfo=""
	s tempFamilyEarthquakeInfo=##class(CHSS.FamilyEarthquakeInfo).%New()
	q:(tempFamilyEarthquakeInfo="") 0
	
	s FamilyRowIdobj=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	s tempFamilyEarthquakeInfo.FamilyRowIdParref=FamilyRowIdobj
		
	i FamilyProperty '= "" d
	.s FamilyPropertyobj=##class(CHSS.DictFamilyProperty).%OpenId(FamilyProperty)
	.s tempFamilyEarthquakeInfo.FamilyProperty=FamilyPropertyobj
	
	s tempFamilyEarthquakeInfo.NumOfLabourBefore = NumOfLabourBefore
	s tempFamilyEarthquakeInfo.NumOfOtherBefore = NumOfOtherBefore
	s tempFamilyEarthquakeInfo.NumOfManBefore = NumOfManBefore
	s tempFamilyEarthquakeInfo.NumOfWomenBefore = NumOfWomenBefore
	
	s tempFamilyEarthquakeInfo.NumOfLabourAfter = NumOfLabourAfter
	s tempFamilyEarthquakeInfo.NumOfOtherAfter = NumOfOtherAfter
	s tempFamilyEarthquakeInfo.NumOfManAfter = NumOfManAfter
	s tempFamilyEarthquakeInfo.NumOfWomenAfter = NumOfWomenAfter
	
	s tempFamilyEarthquakeInfo.PerIncomeBefore = PerIncomeBefore
	s tempFamilyEarthquakeInfo.AllIncomeBefore = AllIncomeBefore
	s tempFamilyEarthquakeInfo.PerIncomeAfter = PerIncomeAfter
	s tempFamilyEarthquakeInfo.AllIncomeAfter = AllIncomeAfter
	
	s tempFamilyEarthquakeInfo.ExpensesOfFoodBefore = ExpensesOfFoodBefore
	s tempFamilyEarthquakeInfo.ExpensesOfDressBefore = ExpensesOfDressBefore
	s tempFamilyEarthquakeInfo.ExpensesOfFacilitiesBefore = ExpensesOfFacilitiesBefore
	s tempFamilyEarthquakeInfo.ExpensesOfHealthCareBefore = ExpensesOfHealthCareBefore
	
	s tempFamilyEarthquakeInfo.ExpensesOfTransportBefore = ExpensesOfTransportBefore
	s tempFamilyEarthquakeInfo.ExpensesOfRecreationBefore = ExpensesOfRecreationBefore
	s tempFamilyEarthquakeInfo.ExpensesOfLiveBefore = ExpensesOfLiveBefore
	s tempFamilyEarthquakeInfo.ExpensesOfOverheadsBefore = ExpensesOfOverheadsBefore
	
	s tempFamilyEarthquakeInfo.ExpensesOfFoodAfter = ExpensesOfFoodAfter
	s tempFamilyEarthquakeInfo.ExpensesOfDressAfter = ExpensesOfDressAfter
	s tempFamilyEarthquakeInfo.ExpensesOfFacilitiesAfter = ExpensesOfFacilitiesAfter
	s tempFamilyEarthquakeInfo.ExpensesOfHealthCareAfter = ExpensesOfHealthCareAfter
	
	s tempFamilyEarthquakeInfo.ExpensesOfTransportAfter = ExpensesOfTransportAfter
	s tempFamilyEarthquakeInfo.ExpensesOfLiveAfter = ExpensesOfLiveAfter
	s tempFamilyEarthquakeInfo.ExpensesOfRecreationAfter = ExpensesOfRecreationAfter
	s tempFamilyEarthquakeInfo.ExpensesOfOverheadsAfter = ExpensesOfOverheadsAfter
		
	s tempFamilyEarthquakeInfo.bHighwaysBefore = bHighwaysBefore
	
	i HighwayType '= "" d
	.s HighwayTypeobj=##class(CHSS.HighWayType).%OpenId(HighwayType)
	.s tempFamilyEarthquakeInfo.HighwayType=HighwayTypeobj
	
	s tempFamilyEarthquakeInfo.bHighwayAverage = bHighwayAverage
	s tempFamilyEarthquakeInfo.TimeOfInterdiction = TimeOfInterdiction
	
	i CommunicationBefore '= "" d
	.s CommunicationBeforeobj=##class(CHSS.DictCommunication).%OpenId(CommunicationBefore)
	.s tempFamilyEarthquakeInfo.CommunicationBefore=CommunicationBeforeobj
	
	
	s tempFamilyEarthquakeInfo.bCommunicationAverage = bCommunicationAverage
	
	s tempFamilyEarthquakeInfo.TimeOfInterrupt = TimeOfInterrupt
	s tempFamilyEarthquakeInfo.HaveTBPatient = HaveTBPatient
	
	s tempFamilyEarthquakeInfo.NumberOfTB = NumberOfTB
	s tempFamilyEarthquakeInfo.bTreatment = bTreatment
	
	i OperatorInput '= "" d
	.s OperatorInputobj=##class(User.SSUser).%OpenId(OperatorInput)
	.s tempFamilyEarthquakeInfo.OperatorInput=OperatorInputobj
	
	i DateInput '= "" d
	.s DateInput=$zdh(DateInput,3)
	s tempFamilyEarthquakeInfo.DateInput=DateInput
	

	s result=""
    s result=tempFamilyEarthquakeInfo.%Save()
    i result = "1" d
    .w "{""success"":""true"",""info"":"_tempFamilyEarthquakeInfo.%Id()_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    .
}

/// Creator: lyy
/// CreatDate：2009—06-23
/// Description:更新家庭地震伤亡情况
/// Table：FamilyEarthquakeInfo
/// Input: FamilyEarthquakeInfo
/// Output：
/// Return：
/// Others：
ClassMethod Update(RowId As %Integer, FamilyProperty As %Integer, NumOfLabourBefore As %Numeric, NumOfOtherBefore As %Numeric, NumOfManBefore As %Numeric, NumOfWomenBefore As %Numeric, NumOfLabourAfter As %Numeric, NumOfOtherAfter As %Numeric, NumOfManAfter As %Numeric, NumOfWomenAfter As %Numeric, PerIncomeBefore As %Float, AllIncomeBefore As %Float, PerIncomeAfter As %Float, AllIncomeAfter As %Float, ExpensesOfFoodBefore As %Float, ExpensesOfDressBefore As %Float, ExpensesOfFacilitiesBefore As %Float, ExpensesOfHealthCareBefore As %Float, ExpensesOfTransportBefore As %Float, ExpensesOfRecreationBefore As %Float, ExpensesOfLiveBefore As %Float, ExpensesOfOverheadsBefore As %Float, ExpensesOfFoodAfter As %Float, ExpensesOfDressAfter As %Float, ExpensesOfFacilitiesAfter As %Float, ExpensesOfHealthCareAfter As %Float, ExpensesOfTransportAfter As %Float, ExpensesOfLiveAfter As %Float, ExpensesOfRecreationAfter As %Float, ExpensesOfOverheadsAfter As %Float, bHighwaysBefore As %String, HighwayType As %Integer, bHighwayAverage As %String, TimeOfInterdiction As %Numeric, CommunicationBefore As %Integer, bCommunicationAverage As %String, TimeOfInterrupt As %Numeric, HaveTBPatient As %String, NumberOfTB As %Numeric, bTreatment As %String, OperatorInput As %Integer, DateInput As %Date) As %String
{
  
    q:($d(RowId)=0)||(RowId="")
	
	s tempFamilyEarthquakeInfo="",result=""
	s tempFamilyEarthquakeInfo=##class(CHSS.FamilyEarthquakeInfo).%OpenId(RowId)
	q:(tempFamilyEarthquakeInfo="") 0
	
	
	i FamilyProperty '= "" d
	.s FamilyPropertyobj=##class(CHSS.DictFamilyProperty).%OpenId(FamilyProperty)
	.s tempFamilyEarthquakeInfo.FamilyProperty=FamilyPropertyobj
	
	s tempFamilyEarthquakeInfo.NumOfLabourBefore = NumOfLabourBefore
	s tempFamilyEarthquakeInfo.NumOfOtherBefore = NumOfOtherBefore
	s tempFamilyEarthquakeInfo.NumOfManBefore = NumOfManBefore
	s tempFamilyEarthquakeInfo.NumOfWomenBefore = NumOfWomenBefore
	
	s tempFamilyEarthquakeInfo.NumOfLabourAfter = NumOfLabourAfter
	s tempFamilyEarthquakeInfo.NumOfOtherAfter = NumOfOtherAfter
	s tempFamilyEarthquakeInfo.NumOfManAfter = NumOfManAfter
	s tempFamilyEarthquakeInfo.NumOfWomenAfter = NumOfWomenAfter
	
	s tempFamilyEarthquakeInfo.PerIncomeBefore = PerIncomeBefore
	s tempFamilyEarthquakeInfo.AllIncomeBefore = AllIncomeBefore
	s tempFamilyEarthquakeInfo.PerIncomeAfter = PerIncomeAfter
	s tempFamilyEarthquakeInfo.AllIncomeAfter = AllIncomeAfter
	
	s tempFamilyEarthquakeInfo.ExpensesOfFoodBefore = ExpensesOfFoodBefore
	s tempFamilyEarthquakeInfo.ExpensesOfDressBefore = ExpensesOfDressBefore
	s tempFamilyEarthquakeInfo.ExpensesOfFacilitiesBefore = ExpensesOfFacilitiesBefore
	s tempFamilyEarthquakeInfo.ExpensesOfHealthCareBefore = ExpensesOfHealthCareBefore
	
	s tempFamilyEarthquakeInfo.ExpensesOfTransportBefore = ExpensesOfTransportBefore
	s tempFamilyEarthquakeInfo.ExpensesOfRecreationBefore = ExpensesOfRecreationBefore
	s tempFamilyEarthquakeInfo.ExpensesOfLiveBefore = ExpensesOfLiveBefore
	s tempFamilyEarthquakeInfo.ExpensesOfOverheadsBefore = ExpensesOfOverheadsBefore
	
	s tempFamilyEarthquakeInfo.ExpensesOfFoodAfter = ExpensesOfFoodAfter
	s tempFamilyEarthquakeInfo.ExpensesOfDressAfter = ExpensesOfDressAfter
	s tempFamilyEarthquakeInfo.ExpensesOfFacilitiesAfter = ExpensesOfFacilitiesAfter
	s tempFamilyEarthquakeInfo.ExpensesOfHealthCareAfter = ExpensesOfHealthCareAfter
	
	s tempFamilyEarthquakeInfo.ExpensesOfTransportAfter = ExpensesOfTransportAfter
	s tempFamilyEarthquakeInfo.ExpensesOfLiveAfter = ExpensesOfLiveAfter
	s tempFamilyEarthquakeInfo.ExpensesOfRecreationAfter = ExpensesOfRecreationAfter
	s tempFamilyEarthquakeInfo.ExpensesOfOverheadsAfter = ExpensesOfOverheadsAfter
	
	s tempFamilyEarthquakeInfo.bHighwaysBefore = bHighwaysBefore
	
	i HighwayType '= "" d
	.s HighwayTypeobj=##class(CHSS.HighWayType).%OpenId(HighwayType)
	.s tempFamilyEarthquakeInfo.HighwayType=HighwayTypeobj
	
	s tempFamilyEarthquakeInfo.bHighwayAverage = bHighwayAverage
	s tempFamilyEarthquakeInfo.TimeOfInterdiction = TimeOfInterdiction
	
	i CommunicationBefore '= "" d
	.s CommunicationBeforeobj=##class(CHSS.DictCommunication).%OpenId(CommunicationBefore)
	.s tempFamilyEarthquakeInfo.CommunicationBefore=CommunicationBeforeobj
	
	s tempFamilyEarthquakeInfo.bCommunicationAverage = bCommunicationAverage
	
	s tempFamilyEarthquakeInfo.TimeOfInterrupt = TimeOfInterrupt
	s tempFamilyEarthquakeInfo.HaveTBPatient = HaveTBPatient
	
	s tempFamilyEarthquakeInfo.NumberOfTB = NumberOfTB
	s tempFamilyEarthquakeInfo.bTreatment = bTreatment
	
	i OperatorInput '= "" d
	.s OperatorInputobj=##class(User.SSUser).%OpenId(OperatorInput)
	.s tempFamilyEarthquakeInfo.OperatorInput=OperatorInputobj
	
	i DateInput '= "" d
	.s DateInput=$zdh(DateInput,3)
	s tempFamilyEarthquakeInfo.DateInput=DateInput
	
	s result=""
	s result=tempFamilyEarthquakeInfo.%Save()
	i result = "1" d
    .w "{""success"":""true"",""info"":"_RowId_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
}

Storage Default
{
<Data name="FamilyEarthquakeInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.FamilyEarthqACAD</DataLocation>
<DefaultData>FamilyEarthquakeInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.FamilyEarthqACAD</IdLocation>
<IndexLocation>^CHSSWeb.FamilyEarthqACAI</IndexLocation>
<StreamLocation>^CHSSWeb.FamilyEarthqACAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
