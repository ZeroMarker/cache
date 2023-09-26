Class CHSSWeb.EarthquakePersonPsychologyService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod EarthquakePersonPsychologyList(PersonRowIdDR As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
		//n (communityCode, start, limit, sort)
        Set PersonRowIdDR=$G(PersonRowIdDR)
        //s PersonRowIdDR=" "_PersonRowIdDR
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set tmp = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set RowId = 0
		For  Set RowId=$O(^CHSS.EqPersonPsychologyI("PersonRowIdDRIndex",PersonRowIdDR,RowId)) q:RowId=""  d
		.s tempEarthquakePersonPsychology=##class(CHSS.EqPersonPsychology).%OpenId(RowId)
		.set CanFocusAttention  = tempEarthquakePersonPsychology.CanFocusAttention 
		.set bInsomnia  = tempEarthquakePersonPsychology.bInsomnia 
		.set bActive  = tempEarthquakePersonPsychology.bActive 
		.set bDecision  = tempEarthquakePersonPsychology.bDecision 
		.set bUnderPressure  = tempEarthquakePersonPsychology.bUnderPressure
		.set bOvercomeTrouble  = tempEarthquakePersonPsychology.bOvercomeTrouble
		.set bHaveFun  = tempEarthquakePersonPsychology.bHaveFun
		.set bHaveBraveToFace  = tempEarthquakePersonPsychology.bHaveBraveToFace
		.set bAwfulness  = tempEarthquakePersonPsychology.bAwfulness
		.set bNotSelfTrust  = tempEarthquakePersonPsychology.bNotSelfTrust
		.set bAwfulness  = tempEarthquakePersonPsychology.bAwfulness
		.set bNotSelfTrust  = tempEarthquakePersonPsychology.bNotSelfTrust
		.set bUsefulness  = tempEarthquakePersonPsychology.bUsefulness
		.set bThinkComprehensive  = tempEarthquakePersonPsychology.bThinkComprehensive
		.Set tmp= RowId_"^"_CanFocusAttention_"^"_bInsomnia_"^"_bActive_"^"_bDecision_"^"_bUnderPressure_"^"_bOvercomeTrouble _"^"_bHaveFun_"^"_bHaveBraveToFace_"^"_bAwfulness_"^"_bNotSelfTrust_"^"_bUsefulness_"^"_bThinkComprehensive
	    .Set count=count+1
	   	.If (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("RowId^CanFocusAttention^bInsomnia^bActive^bDecision^bUnderPressure^bOvercomeTrouble ^bHaveFun^bHaveBraveToFace^bAwfulness^bNotSelfTrust^bUsefulness^bThinkComprehensive",count)
	 	k json
		Quit resultString
}

ClassMethod Insert(RowId As %Integer, PersonRowIdDR As %Integer, CanFocusAttention As %String, bInsomnia As %String, bActive As %String, bDecision As %String, bUnderPressure As %String, bOvercomeTrouble As %String, bHaveFun As %String, bHaveBraveToFace As %String, bAwfulness As %String, bNotSelfTrust As %String, bUsefulness As %String, bThinkComprehensive As %String) As %String
{
	s result=""
	s tempEarthquakePersonPsychology=""
    s ReturnCode=..existPersonRowIdDR(PersonRowIdDR)
	i (ReturnCode'="0") d
	.q:($d(PersonRowIdDR)=0)||(PersonRowIdDR="")
	.Set RowId=$O(^CHSS.EqPersonPsychologyI("PersonRowIdDRIndex",PersonRowIdDR,RowId))
	.s tempEarthquakePersonPsychology=##class(CHSS.EqPersonPsychology).%OpenId(RowId)
	e  d
	.s tempEarthquakePersonPsychology=##class(CHSS.EqPersonPsychology).%New()
    i PersonRowIdDR '="" d
	.s tempPersonobj = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdDR)
	.s tempEarthquakePersonPsychology.PersonRowIdDR = tempPersonobj
	 s tempEarthquakePersonPsychology.CanFocusAttention=CanFocusAttention
	 s tempEarthquakePersonPsychology.bInsomnia=bInsomnia 
	 s tempEarthquakePersonPsychology.bActive=bActive 
	 s tempEarthquakePersonPsychology.bDecision=bDecision 
	 s tempEarthquakePersonPsychology.bUnderPressure=bUnderPressure 
	 s tempEarthquakePersonPsychology.bOvercomeTrouble=bOvercomeTrouble 
	 s tempEarthquakePersonPsychology.bHaveFun=bHaveFun 
	 s tempEarthquakePersonPsychology.bHaveBraveToFace=bHaveBraveToFace 
	 s tempEarthquakePersonPsychology.bAwfulness=bAwfulness 
	 s tempEarthquakePersonPsychology.bNotSelfTrust=bNotSelfTrust 
	 s tempEarthquakePersonPsychology.bUsefulness=bUsefulness 
	 s tempEarthquakePersonPsychology.bThinkComprehensive=bThinkComprehensive     
	 s result=tempEarthquakePersonPsychology.%Save()

	 i result = "1" d
     .s resultString = "{""success:true,info:"_tempEarthquakePersonPsychology.%Id()_"}"
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
	q:$d(^CHSS.EqPersonPsychologyI("PersonRowIdDRIndex",PersonRowIdDR)) "1"
	q "0"
}

Storage Default
{
<Data name="EarthquakePersonPsychologyServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.EarthquakePeD84D</DataLocation>
<DefaultData>EarthquakePersonPsychologyServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.EarthquakePeD84D</IdLocation>
<IndexLocation>^CHSSWeb.EarthquakePeD84I</IndexLocation>
<StreamLocation>^CHSSWeb.EarthquakePeD84S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
