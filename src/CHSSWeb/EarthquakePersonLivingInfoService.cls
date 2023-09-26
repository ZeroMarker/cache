Class CHSSWeb.EarthquakePersonLivingInfoService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod EarthquakePersonLivingInfoList(PersonRowIdDR As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
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
		For  Set RowId=$O(^CHSS.EqPersonLiveInfoI("PersonRowIdDRIndex",PersonRowIdDR,RowId)) q:RowId=""  d
		.s tempEqPersonLiveInfo=##class(CHSS.EqPersonLiveInfo).%OpenId(RowId)
		.set FamilyIncome = tempEqPersonLiveInfo.FamilyIncome 
		.s HouseBefore = ""
		.s HouseBeforeName = ""
		.i tempEqPersonLiveInfo.HouseBefore '= "" d
		..set HouseBefore = tempEqPersonLiveInfo.HouseBefore.%Id()
		..set HouseBeforeName = tempEqPersonLiveInfo.HouseBefore.Description
		.set AreaBefore  = tempEqPersonLiveInfo.AreaBefore 
		.set PersonNumBefore  = tempEqPersonLiveInfo.PersonNumBefore 
		.set HospitalDistanceBefore  = tempEqPersonLiveInfo.HospitalDistanceBefore
		.set HospitalTimeBefore  = tempEqPersonLiveInfo.HospitalTimeBefore
		.s HouseCur = ""
		.s HouseCurName = ""
		.i tempEqPersonLiveInfo.HouseCur '= "" d
		..set HouseCur = tempEqPersonLiveInfo.HouseCur.%Id()
		..set HouseCurName = tempEqPersonLiveInfo.HouseCur.Description
		.set AreaCur  = tempEqPersonLiveInfo.AreaCur
		.set PersonNumCur  = tempEqPersonLiveInfo.PersonNumCur
		.set HospitalDistanceCur  = tempEqPersonLiveInfo.HospitalDistanceCur
		.set HospitalTimeCur  = tempEqPersonLiveInfo.HospitalTimeCur
		.set bLiveTent  = tempEqPersonLiveInfo.bLiveTent
		.set TimeOfLiveTent  = tempEqPersonLiveInfo.TimeOfLiveTent
		.set AreaOfTent  = tempEqPersonLiveInfo.AreaOfTent
		.set PersonNumOfTent  = tempEqPersonLiveInfo.PersonNumOfTent
		.set bLiveBungalow  = tempEqPersonLiveInfo.bLiveBungalow
		.set TimeOfLiveBungalow  = tempEqPersonLiveInfo.TimeOfLiveBungalow
		.set AreaOfBungalow  = tempEqPersonLiveInfo.AreaOfBungalow
		.set PersonNumOfBungalow  = tempEqPersonLiveInfo.PersonNumOfBungalow
		.set FrameHousePersonNum  = tempEqPersonLiveInfo.FrameHousePersonNum
		.set FrameHouseArea  = tempEqPersonLiveInfo.FrameHouseArea
		.set FrameHouseTolit  = tempEqPersonLiveInfo.FrameHouseTolit
		.set FrameHouseUrinalNum  = tempEqPersonLiveInfo.FrameHouseUrinalNum
		.set PublicBalnearyNum  = tempEqPersonLiveInfo.PublicBalnearyNum
		.set PublicKitchenNum  = tempEqPersonLiveInfo.PublicKitchenNum
		.set HearthNum  = tempEqPersonLiveInfo.HearthNum
		.set WaterQuality  = tempEqPersonLiveInfo.WaterQuality
		.set DustmanNum  = tempEqPersonLiveInfo.DustmanNum
		.set CleanRate  = tempEqPersonLiveInfo.CleanRate
		.set IndispositionNum  = tempEqPersonLiveInfo.IndispositionNum
		.set IndispositionRate  = tempEqPersonLiveInfo.IndispositionRate
		.;w IndispositionRate
		.Set tmp= RowId_"^"_FamilyIncome_"^"_HouseBefore_"^"_HouseBeforeName_"^"_AreaBefore_"^"_PersonNumBefore_"^"_HospitalDistanceBefore_"^"_HospitalTimeBefore_"^"_HouseCur_"^"_HouseCurName_"^"_AreaCur_"^"_PersonNumCur_"^"_HospitalDistanceCur_"^"_HospitalTimeCur_"^"_bLiveTent_"^"_TimeOfLiveTent_"^"_AreaOfTent_"^"_PersonNumOfTent_"^"_bLiveBungalow_"^"_TimeOfLiveBungalow_"^"_AreaOfBungalow_"^"_PersonNumOfBungalow_"^"_FrameHousePersonNum_"^"_FrameHouseArea_"^"_FrameHouseTolit_"^"_FrameHouseUrinalNum_"^"_PublicBalnearyNum_"^"_PublicKitchenNum_"^"_HearthNum_"^"_WaterQuality_"^"_DustmanNum_"^"_CleanRate_"^"_IndispositionNum_"^"_IndispositionRate
	    .Set count=count+1
	   	.If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("RowId^FamilyIncome^HouseBefore^HouseBeforeName^AreaBefore^PersonNumBefore^HospitalDistanceBefore^HospitalTimeBefore^HouseCur^HouseCurName^AreaCur^PersonNumCur^HospitalDistanceCur^HospitalTimeCur^bLiveTent^TimeOfLiveTent^AreaOfTent^PersonNumOfTent^bLiveBungalow^TimeOfLiveBungalow^AreaOfBungalow^PersonNumOfBungalow^FrameHousePersonNum^FrameHouseArea^FrameHouseTolit^FrameHouseUrinalNum^PublicBalnearyNum^PublicKitchenNum^HearthNum^WaterQuality^DustmanNum^CleanRate^IndispositionNum^IndispositionRate",count)
	 	k json
		Quit resultString
}

ClassMethod Insert(RowId As %Integer, PersonRowIdDR As %Integer, FamilyIncome As %Numeric, HouseBefore As %Integer, AreaBefore As %Numeric, PersonNumBefore As %Numeric, HospitalDistanceBefore As %Numeric, HospitalTimeBefore As %Numeric, HouseCur As %Integer, AreaCur As %Numeric, PersonNumCur As %Numeric, HospitalDistanceCur As %Numeric, HospitalTimeCur As %Numeric, bLiveTent As %String, TimeOfLiveTent As %Numeric, AreaOfTent As %Numeric, PersonNumOfTent As %Numeric, bLiveBungalow As %String, TimeOfLiveBungalow As %Numeric, AreaOfBungalow As %Numeric, PersonNumOfBungalow As %Numeric, FrameHousePersonNum As %Numeric, FrameHouseArea As %Numeric, FrameHouseTolit As %Numeric, FrameHouseUrinalNum As %Numeric, PublicBalnearyNum As %Numeric, PublicKitchenNum As %Numeric, HearthNum As %Numeric, WaterQuality As %Numeric, DustmanNum As %Numeric, CleanRate As %Numeric, IndispositionNum As %Numeric, IndispositionRate As %Numeric) As %String
{

	s result=""
	s tempEqPersonLiveInfo=""
    s ReturnCode=..existPersonRowIdDR(PersonRowIdDR)
	i (ReturnCode'="0") d
	.q:($d(PersonRowIdDR)=0)||(PersonRowIdDR="")
	.Set RowId=$O(^CHSS.EqPersonLiveInfoI("PersonRowIdDRIndex",PersonRowIdDR,RowId))
	.s tempEqPersonLiveInfo=##class(CHSS.EqPersonLiveInfo).%OpenId(RowId)
	e  d
	.s tempEqPersonLiveInfo=##class(CHSS.EqPersonLiveInfo).%New()
    i PersonRowIdDR '="" d
	.s tempPersonobj = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdDR)
	.s tempEqPersonLiveInfo.PersonRowIdDR = tempPersonobj
	 s tempEqPersonLiveInfo.FamilyIncome=FamilyIncome
	 i HouseBefore '="" d
	.s HouseBeforeobj=##class(CHSS.DictHouseBefore).%OpenId(HouseBefore)
	.s tempEqPersonLiveInfo.HouseBefore=HouseBeforeobj
	 s tempEqPersonLiveInfo.AreaBefore=AreaBefore 
	 s tempEqPersonLiveInfo.PersonNumBefore=PersonNumBefore 
	 s tempEqPersonLiveInfo.HospitalDistanceBefore=HospitalDistanceBefore 
	 s tempEqPersonLiveInfo.HospitalTimeBefore=HospitalTimeBefore
	 s tempEqPersonLiveInfo.HouseCur=HouseCur 
	 s tempEqPersonLiveInfo.AreaCur=AreaCur 
	 s tempEqPersonLiveInfo.PersonNumCur=PersonNumCur 
	 s tempEqPersonLiveInfo.HospitalDistanceCur=HospitalDistanceCur 
	 s tempEqPersonLiveInfo.HospitalTimeCur=HospitalTimeCur 
	 s tempEqPersonLiveInfo.bLiveTent=bLiveTent  
     s tempEqPersonLiveInfo.TimeOfLiveTent=TimeOfLiveTent 
	 s tempEqPersonLiveInfo.AreaOfTent=AreaOfTent 
	 s tempEqPersonLiveInfo.HospitalTimeBefore=HospitalTimeBefore 
	 s tempEqPersonLiveInfo.PersonNumOfTent=PersonNumOfTent 
	 s tempEqPersonLiveInfo.bLiveBungalow=bLiveBungalow 
	 s tempEqPersonLiveInfo.TimeOfLiveBungalow=TimeOfLiveBungalow 
	 s tempEqPersonLiveInfo.AreaOfBungalow=AreaOfBungalow 
	 s tempEqPersonLiveInfo.PersonNumOfBungalow=PersonNumOfBungalow 
	 s tempEqPersonLiveInfo.FrameHousePersonNum=FrameHousePersonNum 
	 s tempEqPersonLiveInfo.FrameHouseArea=FrameHouseArea 
	 s tempEqPersonLiveInfo.FrameHouseTolit=FrameHouseTolit 
	 s tempEqPersonLiveInfo.FrameHouseUrinalNum=FrameHouseUrinalNum
	 s tempEqPersonLiveInfo.PublicBalnearyNum=PublicBalnearyNum
	 s tempEqPersonLiveInfo.PublicKitchenNum=PublicKitchenNum
	 s tempEqPersonLiveInfo.HearthNum=HearthNum
	 s tempEqPersonLiveInfo.WaterQuality=WaterQuality
	 s tempEqPersonLiveInfo.DustmanNum=DustmanNum
	 s tempEqPersonLiveInfo.CleanRate=CleanRate
	 s tempEqPersonLiveInfo.IndispositionNum=IndispositionNum
	 s tempEqPersonLiveInfo.IndispositionRate=IndispositionRate
	 s result=tempEqPersonLiveInfo.%Save()
	 i result = "1" d
     .S resultString = "{""success:true,info:"_tempEqPersonLiveInfo.%Id()_"}"
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
	q:$d(^CHSS.EqPersonLiveInfoI("PersonRowIdDRIndex",PersonRowIdDR)) "1"
	q "0"
}

Storage Default
{
<Data name="EarthquakePersonLivingInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.EarthquakePeD48D</DataLocation>
<DefaultData>EarthquakePersonLivingInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.EarthquakePeD48D</IdLocation>
<IndexLocation>^CHSSWeb.EarthquakePeD48I</IndexLocation>
<StreamLocation>^CHSSWeb.EarthquakePeD48S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
