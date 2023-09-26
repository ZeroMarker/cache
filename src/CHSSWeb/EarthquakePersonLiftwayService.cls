Class CHSSWeb.EarthquakePersonLiftwayService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod EarthquakePersonLiftwayList(PersonRowIdDR As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
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
		set RowId = 0
		
		
		For  Set RowId=$O(^CHSS.EarthquakePersonLiftwayI("PersonRowIdDRIndex",PersonRowIdDR,RowId)) q:RowId=""  d
		.s tempEarthquakePersonLiftway=##class(CHSS.EarthquakePersonLiftway).%OpenId(RowId)
		.set bSmoke  = tempEarthquakePersonLiftway.bSmoke 
		.set SmokeYears  = tempEarthquakePersonLiftway.SmokeYears 
		.set SmokeNum  = tempEarthquakePersonLiftway.SmokeNum 
		.set bStopSmoke  = tempEarthquakePersonLiftway.bStopSmoke 
		.set StopSmokeTime  = tempEarthquakePersonLiftway.StopSmokeTime
		.set bDrink  = tempEarthquakePersonLiftway.bDrink
		.set DrinkType=""
		.set DrinkTypeName=""
		.i tempEarthquakePersonLiftway.DrinkType '= "" d
		..set DrinkType = tempEarthquakePersonLiftway.DrinkType.%Id()
		..set DrinkTypeName = tempEarthquakePersonLiftway.DrinkType.Description
		.set DrinkTime  = tempEarthquakePersonLiftway.DrinkTime
		.set DPAC  = tempEarthquakePersonLiftway.DPAC
		.set bDryOut  = tempEarthquakePersonLiftway.bDryOut
		.set DryOutTime  = tempEarthquakePersonLiftway.DryOutTime
		.set bDrinkCur  = tempEarthquakePersonLiftway.bDrinkCur
		.set DPACCur  = tempEarthquakePersonLiftway.DPACCur
		.set bExerciseBefore  = tempEarthquakePersonLiftway.bExerciseBefore
		.set bExerciseCur  = tempEarthquakePersonLiftway.bExerciseCur
		.set ExerTypeChangeReason  = tempEarthquakePersonLiftway.ExerTypeChangeReason
		.set bExerRateChange  = tempEarthquakePersonLiftway.bExerRateChange
		.set bLifeOrderliness  = tempEarthquakePersonLiftway.bLifeOrderliness
		.set LifeOrderlinessReason  = tempEarthquakePersonLiftway.LifeOrderlinessReason
		.set bLifeOrderlinessCur  = tempEarthquakePersonLiftway.bLifeOrderlinessCur
		.set LifeOrderlinessCurReason  = tempEarthquakePersonLiftway.LifeOrderlinessCurReason
		.set SleepBefore=""
		.set SleepBeforeName=""
		.i tempEarthquakePersonLiftway.SleepBefore '= "" d
		..set SleepBefore = tempEarthquakePersonLiftway.SleepBefore.%Id()
		..set SleepBeforeName = tempEarthquakePersonLiftway.SleepBefore.Description
		.set SleepCur=""
		.set SleepCurName=""
		.i tempEarthquakePersonLiftway.SleepCur '= "" d
		..set SleepCur = tempEarthquakePersonLiftway.SleepCur.%Id()
		..set SleepCurName = tempEarthquakePersonLiftway.SleepCur.Description
		.set bSleepChange  = tempEarthquakePersonLiftway.bSleepChange
		.set SleepWorseReason  = tempEarthquakePersonLiftway.SleepWorseReason
		.set bFoodChange  = tempEarthquakePersonLiftway.bFoodChange
		.set bFoodAdapt  = tempEarthquakePersonLiftway.bFoodAdapt
		.set bCookOneself  = tempEarthquakePersonLiftway.bCookOneself
		.set bAiriness  = tempEarthquakePersonLiftway.bAiriness
		.set bClean  = tempEarthquakePersonLiftway.bClean
		.set bTBHealthEducation  = tempEarthquakePersonLiftway.bTBHealthEducation
		.set TBHealthEduType=""
		.set TBHealthEduTypeName=""
		.i tempEarthquakePersonLiftway.TBHealthEduType '= "" d
		..set TBHealthEduType = tempEarthquakePersonLiftway.TBHealthEduType.%Id()
		..set TBHealthEduTypeName = tempEarthquakePersonLiftway.TBHealthEduType.Description	
	    .set bHBVHealthEducation  = tempEarthquakePersonLiftway.bHBVHealthEducation
	    .set HBVHealthEduType=""
	    .set HBVHealthEduTypeName=""
		.i tempEarthquakePersonLiftway.HBVHealthEduType '= "" d
		..set HBVHealthEduType = tempEarthquakePersonLiftway.HBVHealthEduType.%Id()
		..set HBVHealthEduTypeName = tempEarthquakePersonLiftway.HBVHealthEduType.Description	
		.set bSaticifyToSanitation  = tempEarthquakePersonLiftway.bSaticifyToSanitation
		.set bSaticifyToEstablish  = tempEarthquakePersonLiftway.bSaticifyToEstablish
		.set bSaticifyToFood  = tempEarthquakePersonLiftway.bSaticifyToFood
		.set bSaticifyToMedical  = tempEarthquakePersonLiftway.bSaticifyToMedical
		.set bSaticifyToHealthEdu  = tempEarthquakePersonLiftway.bSaticifyToHealthEdu
		.Set tmp= RowId_"^"_bSmoke_"^"_SmokeYears_"^"_SmokeNum_"^"_bStopSmoke_"^"_StopSmokeTime_"^"_bDrink_"^"_DrinkType_"^"_DrinkTypeName_"^"_DrinkTime_"^"_DPAC_"^"_bDryOut_"^"_DryOutTime_"^"_bDrinkCur_"^"_DPACCur_"^"_bExerciseBefore_"^"_bExerciseCur_"^"_ExerTypeChangeReason_"^"_bExerRateChange_"^"_bLifeOrderliness_"^"_LifeOrderlinessReason_"^"_bLifeOrderlinessCur_"^"_LifeOrderlinessCurReason_"^"_SleepBefore_"^"_SleepBeforeName_"^"_SleepCur_"^"_SleepCurName_"^"_bSleepChange_"^"_SleepWorseReason_"^"_bFoodChange_"^"_bFoodAdapt_"^"_bCookOneself_"^"_bAiriness_"^"_bClean_"^"_bTBHealthEducation_"^"_TBHealthEduType_"^"_TBHealthEduTypeName_"^"_bHBVHealthEducation_"^"_HBVHealthEduType_"^"_HBVHealthEduTypeName_"^"_bSaticifyToSanitation_"^"_bSaticifyToEstablish_"^"_bSaticifyToFood_"^"_bSaticifyToMedical_"^"_bSaticifyToHealthEdu   
	    .Set count=count+1
	   	.If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("RowId^bSmoke^SmokeYears^SmokeNum^bStopSmoke^StopSmokeTime^bDrink^DrinkType^DrinkTypeName^DrinkTime^DPAC^bDryOut^DryOutTime^bDrinkCur^DPACCur^bExerciseBefore^bExerciseCur^ExerTypeChangeReason^bExerRateChange^bLifeOrderliness^LifeOrderlinessReason^bLifeOrderlinessCur^LifeOrderlinessCurReason^SleepBefore^SleepBeforeName^SleepCur^SleepCurName^bSleepChange^SleepWorseReason^bFoodChange^bFoodAdapt^bCookOneself^bAiriness^bClean^bTBHealthEducation^TBHealthEduType^TBHealthEduTypeName^bHBVHealthEducation^HBVHealthEduType^HBVHealthEduTypeName^bSaticifyToSanitation^bSaticifyToEstablish^bSaticifyToFood^bSaticifyToMedical^bSaticifyToHealthEdu ",count)
	 	k json
		Quit resultString
}

ClassMethod Insert(RowId As %Integer, PersonRowIdDR As %Integer, bSmoke As %String, SmokeYears As %Numeric, SmokeNum As %Numeric, bStopSmoke As %String, StopSmokeTime As %Numeric, bDrink As %String, DrinkType As %Integer, DrinkTime As %Numeric, DPAC As %Numeric, bDryOut As %String, DryOutTime As %Numeric, bDrinkCur As %String, DPACCur As %Numeric, bExerciseBefore As %String, bExerciseCur As %String, ExerTypeChangeReason As %String, bExerRateChange As %String, bLifeOrderliness As %String, LifeOrderlinessReason As %String, bLifeOrderlinessCur As %String, LifeOrderlinessCurReason As %String, SleepBefore As %Integer, SleepCur As %Integer, bSleepChange As %String, SleepWorseReason As %String, bFoodChange As %String, bFoodAdapt As %String, bCookOneself As %String, bAiriness As %String, bClean As %String, bTBHealthEducation As %String, TBHealthEduType As %Integer, bHBVHealthEducation As %String, HBVHealthEduType As %Integer, bSaticifyToSanitation As %String, bSaticifyToEstablish As %String, bSaticifyToFood As %String, bSaticifyToMedical As %String, bSaticifyToHealthEdu As %String) As %String
{

	s result=""					
	s tempEarthquakePersonLiftway=""
    s ReturnCode=..existPersonRowIdDR(PersonRowIdDR)
	i (ReturnCode'="0") d
	.q:($d(PersonRowIdDR)=0)||(PersonRowIdDR="")
	.Set RowId=$O(^CHSS.EarthquakePersonLiftwayI("PersonRowIdDRIndex",PersonRowIdDR,RowId))
	.s tempEarthquakePersonLiftway=##class(CHSS.EarthquakePersonLiftway).%OpenId(RowId)
	e  d
	.s tempEarthquakePersonLiftway=##class(CHSS.EarthquakePersonLiftway).%New()
    i PersonRowIdDR '="" d
	.s tempPersonobj = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdDR)
	.s tempEarthquakePersonLiftway.PersonRowIdDR = tempPersonobj
	 s tempEarthquakePersonLiftway.bSmoke=bSmoke
	 s tempEarthquakePersonLiftway.SmokeNum=SmokeNum
	 s tempEarthquakePersonLiftway.SmokeYears=SmokeYears 
	 s tempEarthquakePersonLiftway.bStopSmoke=bStopSmoke 
	 s tempEarthquakePersonLiftway.StopSmokeTime=StopSmokeTime 
	 s tempEarthquakePersonLiftway.bDrink=bDrink 
	 i DrinkType '="" d
	.s DrinkTypeobj=##class(CHSS.DictDrinkType).%OpenId(DrinkType)
	.s tempEarthquakePersonLiftway.DrinkType=DrinkTypeobj
	 s tempEarthquakePersonLiftway.DrinkTime=DrinkTime 
	 s tempEarthquakePersonLiftway.DPAC=DPAC 
	 s tempEarthquakePersonLiftway.bDryOut=bDryOut 
	 s tempEarthquakePersonLiftway.DryOutTime=DryOutTime 
	 s tempEarthquakePersonLiftway.bDrinkCur=bDrinkCur 
	 s tempEarthquakePersonLiftway.DPACCur=DPACCur 
	 s tempEarthquakePersonLiftway.bExerciseBefore=bExerciseBefore  
     s tempEarthquakePersonLiftway.bExerciseCur=bExerciseCur 
	 s tempEarthquakePersonLiftway.ExerTypeChangeReason=ExerTypeChangeReason 
	 s tempEarthquakePersonLiftway.bExerRateChange=bExerRateChange 
	 s tempEarthquakePersonLiftway.bLifeOrderliness=bLifeOrderliness 
	 s tempEarthquakePersonLiftway.LifeOrderlinessReason=LifeOrderlinessReason 
	 s tempEarthquakePersonLiftway.bLifeOrderlinessCur=bLifeOrderlinessCur 
	 s tempEarthquakePersonLiftway.LifeOrderlinessCurReason=LifeOrderlinessCurReason 
	 i SleepBefore '="" d
	.s SleepBeforeobj=##class(CHSS.DictSleepBefore).%OpenId(SleepBefore)
	.s tempEarthquakePersonLiftway.SleepBefore=SleepBeforeobj
	 i SleepCur '="" d
	.s SleepCurobj=##class(CHSS.DictSleepCur).%OpenId(SleepCur)
	.s tempEarthquakePersonLiftway.SleepCur=SleepCurobj
	 s tempEarthquakePersonLiftway.bSleepChange=bSleepChange 
	 s tempEarthquakePersonLiftway.SleepWorseReason=SleepWorseReason 
	 s tempEarthquakePersonLiftway.bFoodChange=bFoodChange 
	 s tempEarthquakePersonLiftway.bFoodAdapt=bFoodAdapt
	 s tempEarthquakePersonLiftway.bCookOneself=bCookOneself
	 s tempEarthquakePersonLiftway.bAiriness=bAiriness
	 s tempEarthquakePersonLiftway.bClean=bClean
	 s tempEarthquakePersonLiftway.bTBHealthEducation=bTBHealthEducation
	 i TBHealthEduType '="" d
	.s TBHealthEduTypeobj=##class(CHSS.DictTBHealthEduType).%OpenId(TBHealthEduType)
	.s tempEarthquakePersonLiftway.TBHealthEduType=TBHealthEduTypeobj
	 s tempEarthquakePersonLiftway.bHBVHealthEducation=bHBVHealthEducation
	 i HBVHealthEduType '="" d
	.s HBVHealthEduTypeobj=##class(CHSS.DictHBVHealthEduType).%OpenId(HBVHealthEduType)
	.s tempEarthquakePersonLiftway.HBVHealthEduType=HBVHealthEduTypeobj
	 s tempEarthquakePersonLiftway.bSaticifyToSanitation=bSaticifyToSanitation
	 s tempEarthquakePersonLiftway.bSaticifyToEstablish=bSaticifyToEstablish
	 s tempEarthquakePersonLiftway.bSaticifyToFood=bSaticifyToFood
	 s tempEarthquakePersonLiftway.bSaticifyToMedical=bSaticifyToMedical
	 s tempEarthquakePersonLiftway.bSaticifyToHealthEdu=bSaticifyToHealthEdu 
	 s result=tempEarthquakePersonLiftway.%Save()
	 i result = "1" d
     .S resultString =  "{""success:true,info:"_tempEarthquakePersonLiftway.%Id()_"}"
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
	q:$d(^CHSS.EarthquakePersonLiftwayI("PersonRowIdDRIndex",PersonRowIdDR)) "1"
	q "0"
}

Storage Default
{
<Data name="EarthquakePersonLiftwayServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.EarthquakePeC33D</DataLocation>
<DefaultData>EarthquakePersonLiftwayServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.EarthquakePeC33D</IdLocation>
<IndexLocation>^CHSSWeb.EarthquakePeC33I</IndexLocation>
<StreamLocation>^CHSSWeb.EarthquakePeC33S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
