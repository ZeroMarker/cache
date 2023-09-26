Class CHSSWeb.PersonYearCheckTBService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod PersonTBCheckList(YearCheckRowIdParref As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
		//n (communityCode, start, limit, sort)
        Set YearCheckRowIdParref=$G(YearCheckRowIdParref)
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		set tmp = ""
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New() 
		Set TBRowId = 0
		
		For  Set TBRowId=$O(^CHSS.PersonYearCheckTBI("YearCheckRowIdParrefIndex",YearCheckRowIdParref,TBRowId)) q:TBRowId=""  d
		.s tempPersonYearCheckTB=##class(CHSS.PersonYearCheckTB).%OpenId(TBRowId)
		.///set TBRowId  = tempPersonYearCheckTB.TBRowId
		.set PPDResult   = tempPersonYearCheckTB.PPDResult   
		.set DateOfPPD =tempPersonYearCheckTB.DateOfPPD
		.i DateOfPPD '="" d
		..s DateOfPPD = $zd(DateOfPPD,3)
		.set Inanition   = tempPersonYearCheckTB.Inanition      
		.set XRayNum   = tempPersonYearCheckTB.XRayNum
		.set SputumSmearResult = ""
		.set SputumSmearResultName=""
		.i tempPersonYearCheckTB.SputumSmearResult '= "" d
		..set SputumSmearResult = tempPersonYearCheckTB.SputumSmearResult.%Id()
		..set SputumSmearResultName = tempPersonYearCheckTB.SputumSmearResult.Description
		.set SputumSmearResultR =tempPersonYearCheckTB.SputumSmearResultR
		.set ReasonOfNotCheckSS =tempPersonYearCheckTB.ReasonOfNotCheckSS
		.set DateOfSputumSmear =tempPersonYearCheckTB.DateOfSputumSmear
		.i DateOfSputumSmear '="" d
		..s DateOfSputumSmear = $zd(DateOfSputumSmear,3)
		.set DateOfDrugSensitiveTest =tempPersonYearCheckTB.DateOfDrugSensitiveTest
		.i DateOfDrugSensitiveTest '="" d
		..s DateOfDrugSensitiveTest = $zd(DateOfDrugSensitiveTest,3) 
		.set SputumCultureResult = ""
		.set SputumCultureResultName=""
		.i tempPersonYearCheckTB.SputumCultureResult '= "" d
		..set SputumCultureResult = tempPersonYearCheckTB.SputumCultureResult.%Id()
		..set SputumCultureResultName = tempPersonYearCheckTB.SputumCultureResult.Description  
		.set ReasonOfNotCheckSC =tempPersonYearCheckTB.ReasonOfNotCheckSC
		.set DateOfCheckSC =tempPersonYearCheckTB.DateOfCheckSC
		.i DateOfCheckSC '="" d
		..s DateOfCheckSC = $zd(DateOfCheckSC,3)
		.set DrugSensitiveTestH = ""
		.set DrugSensitiveTestHName=""
		.i tempPersonYearCheckTB.DrugSensitiveTestH '= "" d
		..set DrugSensitiveTestH = tempPersonYearCheckTB.DrugSensitiveTestH.%Id()
		..set DrugSensitiveTestHName = tempPersonYearCheckTB.DrugSensitiveTestH.Description  
		.set DrugSensitiveTestR = ""
		.set DrugSensitiveTestRName=""
		.i tempPersonYearCheckTB.DrugSensitiveTestR '= "" d
		..set DrugSensitiveTestR = tempPersonYearCheckTB.DrugSensitiveTestR.%Id()
		..set DrugSensitiveTestRName = tempPersonYearCheckTB.DrugSensitiveTestR.Description
		.set DrugSensitiveTestE = ""
		.set DrugSensitiveTestEName=""
		.i tempPersonYearCheckTB.DrugSensitiveTestE '= "" d
		..set DrugSensitiveTestE = tempPersonYearCheckTB.DrugSensitiveTestE.%Id()
		..set DrugSensitiveTestEName = tempPersonYearCheckTB.DrugSensitiveTestE.Description
		.set DrugSensitiveTestS = ""
		.set DrugSensitiveTestSName=""
		.i tempPersonYearCheckTB.DrugSensitiveTestS '= "" d
		..set DrugSensitiveTestS = tempPersonYearCheckTB.DrugSensitiveTestS.%Id()
		..set DrugSensitiveTestSName = tempPersonYearCheckTB.DrugSensitiveTestS.Description
		.set HIVTest = ""
		.set HIVTestName=""
		.i tempPersonYearCheckTB.HIVTest '= "" d
		..set HIVTest = tempPersonYearCheckTB.HIVTest.%Id()
		..set HIVTestName = tempPersonYearCheckTB.HIVTest.Description
		.set CD4 =tempPersonYearCheckTB.CD4
		.set DateOfHIVTest =tempPersonYearCheckTB.DateOfHIVTest
		.i DateOfHIVTest '="" d
		..s DateOfHIVTest = $zd(DateOfHIVTest,3)
		.set DateOfCheck =tempPersonYearCheckTB.DateOfCheck
		.i DateOfCheck '="" d
		..s DateOfCheck = $zd(DateOfCheck,3)
		.set CureType = ""
		.set CureTypeName=""
		.i tempPersonYearCheckTB.CureType '= "" d
		..set CureType = tempPersonYearCheckTB.CureType.%Id()
		..set CureTypeName = tempPersonYearCheckTB.CureType.Description 
		.set CurePlan =tempPersonYearCheckTB.CurePlan
		.set PayType = ""
		.set PayTypeName=""
		.i tempPersonYearCheckTB.PayType '= "" d
		..set PayType = tempPersonYearCheckTB.PayType.%Id()
		..set PayTypeName = tempPersonYearCheckTB.PayType.Description   
		.set CureManageType = ""
		.set CureManageTypeName=""
		.i tempPersonYearCheckTB.CureManageType '= "" d
		..set CureManageType = tempPersonYearCheckTB.CureManageType.%Id()
		..set CureManageTypeName = tempPersonYearCheckTB.CureManageType.Description 
		.set CurePlanChange =tempPersonYearCheckTB.CurePlanChange
		.set DateOfPlanChange =tempPersonYearCheckTB.DateOfPlanChange
		.i DateOfPlanChange '="" d
		..s DateOfPlanChange = $zd(DateOfPlanChange,3)
	    .set SputumCultureResultR =tempPersonYearCheckTB.SputumCultureResultR
		.Set tmp= TBRowId_"^"_PPDResult_"^"_DateOfPPD_"^"_Inanition_"^"_XRayNum_"^"_SputumSmearResult_"^"_SputumSmearResultName_"^"_SputumSmearResultR_"^"_ReasonOfNotCheckSS_"^"_DateOfSputumSmear_"^"_SputumCultureResult_"^"_SputumCultureResultName_"^"_ReasonOfNotCheckSC_"^"_DrugSensitiveTestH _"^"_DrugSensitiveTestHName _"^"_DrugSensitiveTestR_"^"_DrugSensitiveTestRName_"^"_DrugSensitiveTestE_"^"_DrugSensitiveTestEName_"^"_DrugSensitiveTestS_"^"_DrugSensitiveTestSName_"^"_HIVTest_"^"_HIVTestName_"^"_CD4_"^"_DateOfHIVTest_"^"_DateOfCheck_"^"_CureType_"^"_CureTypeName_"^"_CurePlan_"^"_PayType_"^"_PayTypeName_"^"_CureManageType_"^"_ CureManageTypeName_"^"_CurePlanChange_"^"_DateOfPlanChange_"^"_DateOfCheckSC_"^"_SputumCultureResultR_"^"_DateOfDrugSensitiveTest
	    .Set count=count+1
	    .If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    //Set resultString = json.getJsonData("TBRowId^PPDResult^DateOfPPD^Inanition^XRayNum^SputumSmearResult^SputumSmearResultName^SputumSmearResultR^ReasonOfNotCheckSS^DateOfSputumSmear^SputumCultureResult^SputumCultureResultName^ReasonOfNotCheckSC^DrugSensitiveTestH^DrugSensitiveTestR^DrugSensitiveTestE^DrugSensitiveTestS^HIVTest^CD4^DateOfHIVTest^DateOfCheck^CureType^CurePlan^PayType^CureManageType^CurePlanChange^DateOfPlanChange^DateOfCheckSC",count)
	 	k json
		Quit tmp
}

ClassMethod Insert(TBRecordRowId As %Integer, RowId As %Integer, PPDResult As %String, DateOfPPD As %Date, XRayNum As %String, SputumSmearResult As %Integer, SputumSmearResultR As %String, ReasonOfNotCheckSS As %String, ReasonOfNotCheckSC As %String, DrugSensitiveTestH As %Integer, DrugSensitiveTestR As %Integer, DrugSensitiveTestE As %Integer, DrugSensitiveTestS As %Integer, HIVTest As %Integer, CD4 As %String, DateOfHIVTest As %Date, DateOfCheck As %Date, CureType As %Integer, CurePlan As %String, PayType As %Integer, CureManageType As %Integer, CurePlanChange As %String, DateOfPlanChange As %Date, SputumCultureResult As %Integer, SputumCultureResultR As %String, DateOfCheckSC As %Date, DateOfDrugSensitiveTest As %Date) As %String
{

	q:($d(RowId)=0)||(RowId="")
	s result=""
	s tempPersonYearCheckTB=""
    s ReturnCode=..existYearCheckRowIdParref(RowId)
	i (ReturnCode'="0") d
	.s tempPersonYearCheckTB=##class(CHSS.PersonYearCheckTB).%OpenId(TBRecordRowId)
	e  d
	.s tempPersonYearCheckTB=##class(CHSS.PersonYearCheckTB).%New()
	 s tempPersonYearCheckMain = ##class(CHSS.PersonYearCheckRecord).%OpenId(RowId)
	 s tempPersonYearCheckTB.YearCheckRowIdParref = tempPersonYearCheckMain
      s tempPersonYearCheckTB.PPDResult = PPDResult 
      i DateOfPPD  '="" d
      .s DateOfPPDobj = $zdh(DateOfPPD ,3)
      .s tempPersonYearCheckTB.DateOfPPD=DateOfPPDobj
      s tempPersonYearCheckTB.XRayNum =XRayNum 
      i SputumSmearResult '="" d
	 .s SputumSmearResultobj=##class(CHSS.DictSputumSmearResult).%OpenId(SputumSmearResult)
	 .s tempPersonYearCheckTB.SputumSmearResult=SputumSmearResultobj 
      s tempPersonYearCheckTB.SputumSmearResultR=SputumSmearResultR    
      s tempPersonYearCheckTB.ReasonOfNotCheckSS=ReasonOfNotCheckSS 
      //i DateOfSputumSmear '="" d
     //.s DateOfSputumSmearobj = $zdh(DateOfSputumSmear ,3)
     //.s tempPersonYearCheckTB.DateOfSputumSmear=DateOfSputumSmearobj 
      s tempPersonYearCheckTB.ReasonOfNotCheckSC=ReasonOfNotCheckSC
      i DateOfDrugSensitiveTest  '="" d
     .s DateOfDrugSensitiveTestobj=$zdh(DateOfDrugSensitiveTest ,3)
     .s tempPersonYearCheckTB.DateOfDrugSensitiveTest =DateOfDrugSensitiveTestobj 
      i DateOfCheckSC  '="" d
     .s DateOfCheckSCobj=$zdh(DateOfCheckSC ,3)
     .s tempPersonYearCheckTB.DateOfCheckSC =DateOfCheckSCobj 
      i DrugSensitiveTestH '="" d
	 .s DrugSensitiveTestHobj=##class(CHSS.DictDrugSensitiveTest).%OpenId(DrugSensitiveTestH)
	 .s tempPersonYearCheckTB.DrugSensitiveTestH=DrugSensitiveTestHobj
	  i DrugSensitiveTestR '="" d
	 .s DrugSensitiveTestRobj=##class(CHSS.DictDrugSensitiveTest).%OpenId(DrugSensitiveTestR)
	 .s tempPersonYearCheckTB.DrugSensitiveTestR=DrugSensitiveTestRobj
	  i DrugSensitiveTestE '="" d
	 .s DrugSensitiveTestEobj=##class(CHSS.DictDrugSensitiveTest).%OpenId(DrugSensitiveTestE)
	 .s tempPersonYearCheckTB.DrugSensitiveTestE=DrugSensitiveTestEobj
	  i DrugSensitiveTestS '="" d
	 .s DrugSensitiveTestSobj=##class(CHSS.DictDrugSensitiveTest).%OpenId(DrugSensitiveTestS)
	 .s tempPersonYearCheckTB.DrugSensitiveTestS=DrugSensitiveTestSobj   
	  i HIVTest '="" d
	 .s HIVTestobj=##class(CHSS.DictHIVTest).%OpenId(HIVTest)
	 .s tempPersonYearCheckTB.HIVTest=HIVTestobj   
      s tempPersonYearCheckTB.CD4 =CD4   
      i DateOfHIVTest  '="" d
     .s DateOfHIVTestobj = $zdh(DateOfHIVTest ,3)
     .s tempPersonYearCheckTB.DateOfHIVTest =DateOfHIVTestobj 
      i DateOfCheck  '="" d
     .s DateOfCheckobj = $zdh(DateOfCheck ,3)
     .s tempPersonYearCheckTB.DateOfCheck =DateOfCheckobj  
      i CureType '="" d
	 .s CureTypeobj=##class(CHSS.DictCureType).%OpenId(CureType)
	 .s tempPersonYearCheckTB.CureType=CureTypeobj      
      s tempPersonYearCheckTB.CurePlan =CurePlan
      i PayType '="" d
	 .s PayTypeobj=##class(CHSS.DictPayType).%OpenId(PayType)
	 .s tempPersonYearCheckTB.PayType=PayTypeobj        
      i CureManageType '="" d
	 .s CureManageTypeobj=##class(CHSS.DictCureManageType).%OpenId(CureManageType)
	 .s tempPersonYearCheckTB.CureManageType=CureManageTypeobj 
	  i SputumCultureResult '="" d
	 .s SputumCultureResultobj=##class(CHSS.DictSputumCultureResult).%OpenId(SputumCultureResult)
	 .s tempPersonYearCheckTB.SputumCultureResult=SputumCultureResultobj 
	  s tempPersonYearCheckTB.CurePlanChange=CurePlanChange 
	  i DateOfPlanChange  '="" d
     .s DateOfPlanChangeobj = $zdh(DateOfPlanChange ,3)
     .s tempPersonYearCheckTB.DateOfPlanChange =DateOfPlanChangeobj
      s tempPersonYearCheckTB.SputumCultureResultR=SputumCultureResultR
      s result=tempPersonYearCheckTB.%Save()
	  i result = "1" d
     .S resultString = "success:true,info:"_tempPersonYearCheckTB.%Id()
	 e  d
	.s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
	.///w "{""success"":""false"",""info"":""数据保存出错!""}"
	q resultString
}

/// 添加
ClassMethod existYearCheckRowIdParref(YearCheckRowIdParref) As %String
{
	q:YearCheckRowIdParref="" "-1"
	q:$d(^CHSS.PersonYearCheckTBI("YearCheckRowIdParrefIndex",YearCheckRowIdParref)) "1"
	q "0"
}

Storage Default
{
<Data name="PersonYearCheckTBServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonYearCh94DD</DataLocation>
<DefaultData>PersonYearCheckTBServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonYearCh94DD</IdLocation>
<IndexLocation>^CHSSWeb.PersonYearCh94DI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonYearCh94DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
