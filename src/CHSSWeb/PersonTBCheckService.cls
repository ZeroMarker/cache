Class CHSSWeb.PersonTBCheckService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod PersonTBCheckList(PersonRowIdDR As %Integer, YearCheckRowIdParref As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
		//n (communityCode, start, limit, sort)
        Set PersonRowIdDR=$G(PersonRowIdDR)
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set tmp = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set TBHomeRowId = 0
		
		
		For  Set TBHomeRowId=$O(^CHSS.PersonTBCheckHomeI("PersonRowIdDRIndex",PersonRowIdDR,TBHomeRowId)) q:TBHomeRowId=""  d
		.
		.
		.s tempPersonTBCheck=##class(CHSS.PersonTBCheckHome).%OpenId(TBHomeRowId)
		.set bCough = tempPersonTBCheck.bCough
		.set CoughStartDate =tempPersonTBCheck.CoughStartDate
		.i CoughStartDate '="" d
		..s CoughStartDate = $zd(CoughStartDate,3)
		.set CoughEndDate =tempPersonTBCheck.CoughEndDate
		.i CoughEndDate '="" d
		..s CoughEndDate = $zd(CoughEndDate,3)
		.set bEmptysis  = tempPersonTBCheck.bEmptysis 
		.set EmptysisStartDate =tempPersonTBCheck.EmptysisStartDate
		.i EmptysisStartDate '="" d
		..s EmptysisStartDate = $zd(EmptysisStartDate,3)
		.set EmptysisEndDate =tempPersonTBCheck.EmptysisStartDate
		.i EmptysisEndDate '="" d
		..s EmptysisEndDate = $zd(EmptysisEndDate,3)
		.set bBCG = tempPersonTBCheck.bBCG   
		.set bCirrhosis = tempPersonTBCheck.bCirrhosis 
		.set bNephrotic  = tempPersonTBCheck.bNephrotic
		.set bContact  = tempPersonTBCheck.bContact 
		.set DrugAllergy  = tempPersonTBCheck.DrugAllergy 
		.set bShiftingPopulation  = tempPersonTBCheck.bShiftingPopulation 
		.set bTeacher  = tempPersonTBCheck.bTeacher 
		.set bHealthServiceIndustry  = tempPersonTBCheck.bHealthServiceIndustry 
		.set bContactHarmfulSubstance  = tempPersonTBCheck.bContactHarmfulSubstance 
		.set bDiabetes  = tempPersonTBCheck.bDiabetes 
		.set bInfectionCure  = tempPersonTBCheck.bInfectionCure 
		.set bSilicosis  = tempPersonTBCheck.bSilicosis 
		.set bAIDS  = tempPersonTBCheck.bAIDS 
		.set DateOfFirtCheck =tempPersonTBCheck.DateOfFirtCheck
		.i DateOfFirtCheck '="" d
		..s DateOfFirtCheck = $zd(DateOfFirtCheck,3)
		.set bCureHistory  = tempPersonTBCheck.bCureHistory
		.set DateOfFirstCure =tempPersonTBCheck.DateOfFirstCure
		.i DateOfFirstCure '="" d
		..s DateOfFirstCure = $zd(DateOfFirstCure,3)  
		.set bEatDrugRegular  = tempPersonTBCheck.bEatDrugRegular
		.set OtherDrug =tempPersonTBCheck.OtherDrug
		.i OtherDrug '="" d
		..s OtherDrug = $zd(OtherDrug,3)
		.set DateOfOther =tempPersonTBCheck.DateOfOther
		.i DateOfOther '="" d
		..s DateOfOther = $zd(DateOfOther,3)  
		.set CureMangeType = ""
		.set CureMangeTypeName=""
		.i tempPersonTBCheck.CureMangeType '= "" d
		..set CureMangeType = tempPersonTBCheck.CureMangeType.%Id()
		..set CureMangeTypeName = tempPersonTBCheck.CureMangeType.Description
		.set bHIVCure    = tempPersonTBCheck.bHIVCure 
		.set DateOfCure =tempPersonTBCheck.DateOfCure
		.i DateOfCure '="" d
		..s DateOfCure = $zd(DateOfCure,3)   
		.set bCPTCure  = tempPersonTBCheck.bCPTCure
		.set DateOfCPTCure =tempPersonTBCheck.DateOfCPTCure
		.i DateOfCPTCure '="" d
		..s DateOfCPTCure = $zd(DateOfCPTCure,3)
		.set DateOfStopCure =tempPersonTBCheck.DateOfStopCure
		.
		.i DateOfStopCure '="" d
		..s DateOfStopCure = $zd(DateOfStopCure,3)
		.s ReasonOfStopCure = ""
		.s ReasonOfStopCureName = ""
		.i tempPersonTBCheck.ReasonOfStopCure '= "" d
		..set ReasonOfStopCure = tempPersonTBCheck.ReasonOfStopCure.%Id()
		..set ReasonOfStopCureName = tempPersonTBCheck.ReasonOfStopCure.Description 
		.set other= tempPersonTBCheck.other
		.Set tmp= TBHomeRowId_"^"_bCough_"^"_CoughStartDate_"^"_CoughEndDate_"^"_bEmptysis_"^"_EmptysisStartDate_"^"_EmptysisEndDate _"^"_bBCG_"^"_bCirrhosis_"^"_bNephrotic_"^"_bContact_"^"_DrugAllergy_"^"_bShiftingPopulation_"^"_bTeacher_"^"_bHealthServiceIndustry_"^"_bContactHarmfulSubstance_"^"_bDiabetes_"^"_bInfectionCure_"^"_bSilicosis_"^"_bAIDS_"^"_DateOfFirtCheck_"^"_bCureHistory_"^"_DateOfFirstCure_"^"_bEatDrugRegular_"^"_OtherDrug_"^"_DateOfOther_"^"_CureMangeType_"^"_CureMangeTypeName_"^"_bHIVCure_"^"_DateOfCure_"^"_bCPTCure_"^"_DateOfCPTCure_"^"_DateOfStopCure_"^"_ReasonOfStopCure_"^"_ReasonOfStopCureName_"^"_other
	    .
	    .Set count=count+1
	   	If (count>start)&(count<=end) d
		.set tmpPersonYearCheckTB = ##class(CHSSWeb.PersonYearCheckTBService).PersonTBCheckList(YearCheckRowIdParref,start,limit,sort)
		.set tmp = tmp_"^"_tmpPersonYearCheckTB
		.d json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("TBHomeRowId^bCough^CoughStartDate^CoughEndDate^bEmptysis^EmptysisStartDate^EmptysisEndDate^bBCG^bCirrhosis^bNephrotic^bContact^DrugAllergy^bShiftingPopulation^bTeacher^bHealthServiceIndustry^bContactHarmfulSubstance^bDiabetes^bInfectionCure^bSilicosis^bAIDS^DateOfFirtCheck^bCureHistory^DateOfFirstCure^bEatDrugRegular^OtherDrug^DateOfOther^CureMangeType^CureMangeTypeName^bHIVCure^DateOfCure^bCPTCure^DateOfCPTCure^DateOfStopCure^ReasonOfStopCure^ReasonOfStopCureName^other^TBRowId^PPDResult^DateOfPPD^Inanition^XRayNum^SputumSmearResult^SputumSmearResultName^SputumSmearResultR^ReasonOfNotCheckSS^DateOfSputumSmear^SputumCultureResult^SputumCultureResultName^ReasonOfNotCheckSC^DrugSensitiveTestH ^DrugSensitiveTestHName ^DrugSensitiveTestR^DrugSensitiveTestRName^DrugSensitiveTestE^DrugSensitiveTestEName^DrugSensitiveTestS^DrugSensitiveTestSName^HIVTest^HIVTestName^CD4^DateOfHIVTest^DateOfCheck^CureType^CureTypeName^CurePlan^PayType^PayTypeName^CureManageType^ CureManageTypeName^CurePlanChange^DateOfPlanChange^DateOfCheckSC^SputumCultureResultR^DateOfDrugSensitiveTest",count)
	 	k json
		Quit resultString
}

ClassMethod Insert(TBRowId As %Integer, PersonRowIdDR As %Integer, bCough As %String, CoughStartDate As %Date, CoughEndDate As %Date, bEmptysis As %String, EmptysisStartDate As %Date, EmptysisEndDate As %Date, bBCG As %String, bNephrotic As %String, bCirrhosis As %String, bContact As %String, bShiftingPopulation As %String, bTeacher As %String, bHealthServiceIndustry As %String, bContactHarmfulSubstance As %String, bDiabetes As %String, bInfectionCure As %String, bSilicosis As %String, bAIDS As %String, DateOfFirtCheck As %Date, bCureHistory As %Date, DateOfFirstCure As %Date, bEatDrugRegular As %String, OtherDrug As %String, CureMangeType As %Integer, bHIVCure As %String, DateOfCure As %Date, bCPTCure As %String, DateOfCPTCure As %Date, DateOfStopCure As %Date, DrugAllergy As %String, other As %String, ReasonOfStopCure As %Integer) As %String
{

	s result=""
	s tempPersonTBCheck=""
    s ReturnCode=..existPersonRowIdDR(PersonRowIdDR)
	i (ReturnCode'="0") d
	.q:($d(PersonRowIdDR)=0)||(PersonRowIdDR="")
	.s tempPersonTBCheck=##class(CHSS.PersonTBCheckHome).%OpenId(TBRowId)
	e  d
	.s tempPersonTBCheck=##class(CHSS.PersonTBCheckHome).%New()
    i PersonRowIdDR '="" d
	.s tempPersonobj = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdDR)
	.s tempPersonTBCheck.PersonRowIdDR = tempPersonobj
	s tempPersonTBCheck.bCough=bCough
	s tempPersonTBCheck.DrugAllergy=DrugAllergy  
	i DateOfFirstCure '="" d
	.s DateOfFirstCure = $zdh(DateOfFirstCure ,3)
	.s tempPersonTBCheck.DateOfFirstCure =DateOfFirstCure 
	i CoughStartDate '="" d
	.s CoughStartDate = $zdh(CoughStartDate ,3)
	.s tempPersonTBCheck.CoughStartDate =CoughStartDate 
	i CoughEndDate '="" d
	.s CoughEndDate = $zdh(CoughEndDate ,3)
	.s tempPersonTBCheck.CoughEndDate =CoughEndDate
	s tempPersonTBCheck.bEmptysis=bEmptysis
	i EmptysisStartDate '="" d
	.s EmptysisStartDate = $zdh(EmptysisStartDate ,3)
	.s tempPersonTBCheck.EmptysisStartDate =EmptysisStartDate
	i EmptysisEndDate '="" d
	.s EmptysisEndDate = $zdh(EmptysisEndDate ,3)
	.s tempPersonTBCheck.EmptysisEndDate =EmptysisEndDate 
	s tempPersonTBCheck.bBCG=bBCG
	s tempPersonTBCheck.bCirrhosis =bCirrhosis 
	s tempPersonTBCheck.bNephrotic =bNephrotic 
	s tempPersonTBCheck.bContact =bContact 
	s tempPersonTBCheck.bShiftingPopulation  =bShiftingPopulation
	s tempPersonTBCheck.bTeacher =bTeacher
	s tempPersonTBCheck.bHealthServiceIndustry =bHealthServiceIndustry
	s tempPersonTBCheck.bContactHarmfulSubstance =bContactHarmfulSubstance
	s tempPersonTBCheck.bDiabetes = bDiabetes   
	s tempPersonTBCheck.bInfectionCure =bInfectionCure 
	s tempPersonTBCheck.bSilicosis =bSilicosis 
	s tempPersonTBCheck.OtherDrug =OtherDrug 
	s tempPersonTBCheck.bAIDS =bAIDS
	i DateOfFirtCheck '="" d
	.s DateOfFirtCheck = $zdh(DateOfFirtCheck ,3)
	.s tempPersonTBCheck.DateOfFirtCheck =DateOfFirtCheck  
	s tempPersonTBCheck.bEatDrugRegular =bEatDrugRegular    
	s tempPersonTBCheck.bCureHistory =bCureHistory
	 i ReasonOfStopCure '="" d
	.s ReasonOfStopCureobj=##class(CHSS.DictReasonOfStopCure).%OpenId(ReasonOfStopCure)
	.s tempPersonTBCheck.ReasonOfStopCure=ReasonOfStopCureobj
     i CureMangeType '="" d
	.s CureMangeTypeobj=##class(CHSS.DictCureManageType).%OpenId(CureMangeType)
	.s tempPersonTBCheck.CureMangeType=CureMangeTypeobj
	 s tempPersonTBCheck.bCPTCure=bCPTCure
	 s tempPersonTBCheck.bHIVCure = bHIVCure    
     i DateOfCure  '="" d
     .s DateOfCureobj = $zdh(DateOfCure ,3)
     .s tempPersonTBCheck.DateOfCure=DateOfCureobj
     i DateOfCPTCure  '="" d
     .s DateOfCPTCureobj = $zdh(DateOfCPTCure ,3)
     .s tempPersonTBCheck.DateOfCPTCure=DateOfCPTCureobj
     i DateOfStopCure  '="" d
     .s DateOfStopCureobj = $zdh(DateOfStopCure ,3)
     .s tempPersonTBCheck.DateOfStopCure=DateOfStopCureobj 
	  s tempPersonTBCheck.other=other    
	 s result=tempPersonTBCheck.%Save()
	 i result = "1" d
     .S resultString = "success:true,info:"_tempPersonTBCheck.%Id()
	 e  d
	.s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
	.///w "{""success"":""false"",""info"":""数据保存出错!""}"
	q resultString
}

/// 添加
ClassMethod existPersonRowIdDR(PersonRowIdDR) As %String
{
	q:PersonRowIdDR="" "-1"
	//w PersonRowIdDR
	q:$d(^CHSS.PersonTBCheckHomeI("PersonRowIdDRIndex",PersonRowIdDR)) "1"
	q "0"
}

Storage Default
{
<Data name="PersonTBCheckServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonTBCheckServiceD</DataLocation>
<DefaultData>PersonTBCheckServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonTBCheckServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PersonTBCheckServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonTBCheckServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
