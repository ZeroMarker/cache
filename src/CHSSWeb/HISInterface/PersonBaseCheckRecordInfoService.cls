Class CHSSWeb.HISInterface.PersonBaseCheckRecordInfoService Extends %Persistent
{

/// Creator: jinming
/// CreateDate: 2011-05-20
/// Description: 健康体检表->【一般状况】列表数据
ClassMethod PersonBaseCheckRecordList(personRowId As %String, start As %String, limit As %String) As %String
{
	Set PersonRowId = $G(personRowId)
	Set start = $G( start )
	Set limit = $G( limit )	
	Set end   = start + limit 
	Set count = 0
	Set resultString = ""
	set reportData=""
	Set json  = ##class(Code.JsonObj).%New()
	Set checkRowId = 0
	For  Set checkRowId = $O(^CHSS.PersonYearCheckRecordI("PersonRowIdParrefIndex",PersonRowId,checkRowId)) q:checkRowId=""  d
	.s count=count+1
	.s reportData = ##class(CHSSWeb.HISInterface.PersonBaseCheckRecordInfo).%New()
	.Set tempCheck = ##class(CHSS.PersonYearCheckRecord).%OpenId(checkRowId)
	.s reportData.YearCheckRowId = checkRowId
	.Set reportData.DateCheck = $zd(tempCheck.DateCheck,3)
	.Set reportData.CheckDoctor = tempCheck.CheckDoctor
	.s reportData.Symptom = ""
	.i tempCheck.Symptom'="" d
    ..s tempSymptom = tempCheck.Symptom
    ..s countSymptom = $l(tempSymptom,",")
    ..s j=1
    ..f i=1:1:countSymptom d
    ...s tempSymptomCode = $p(tempSymptom,",",j,i)
    ...s j=j+1
    ...s tempSymptomDes=""
    ...&sql(select Description into:tempSymptomDes from CHSS.DictSymptom where Code=:tempSymptomCode)
    ...i reportData.Symptom="" d
    ....s reportData.Symptom = tempSymptomDes
    ...e  d
    ....s reportData.Symptom = reportData.Symptom_","_tempSymptomDes
	.Set reportData.Temperature = tempCheck.Temperature
	.Set reportData.Pulse =  tempCheck.Pulse
	.Set reportData.Breath = tempCheck.Breath
	.Set reportData.nHighPressure = tempCheck.nHighPressure
	.Set reportData.nLowPressure =  tempCheck.nLowPressure
	.Set reportData.Weight =  tempCheck.Weight
	.Set reportData.Height =  tempCheck.Height
	.Set reportData.BMI =   tempCheck.BMI
	.Set reportData.WaistlineStern = tempCheck.WaistlineStern
	.s reportData.Waist = tempCheck.Waist
	.s reportData.Saddle = tempCheck.Saddle
	.Set reportData.OlderCongnize = ""
	.Set reportData.OlderCongnizeId = ""
	.if tempCheck.OlderCongnize '= "" do
	..Set reportData.OlderCongnize = tempCheck.OlderCongnize.Description
	..Set reportData.OlderCongnizeId = tempCheck.OlderCongnize.%Id()	
	.Set reportData.OlderCongnizeScore = tempCheck.OlderCongnizeScore	
	.Set reportData.OlderSensibility = ""
	.Set reportData.OlderSensibilityId = ""
	.if tempCheck.OlderSensibility '= "" do
	..Set reportData.OlderSensibility = tempCheck.OlderSensibility.Description
	..Set reportData.OlderSensibilityId = tempCheck.OlderSensibility.%Id()	
	.Set reportData.OlderSensibilityScore = tempCheck.OlderSensibilityScore
	.Set reportData.LiveQuality = tempCheck.LiveQuality
	.i (count>start)&(count<=end) d
	..s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.PersonBaseCheckRecordInfo") 	
	..s countProperties = cdef.Properties.Count()
	..s returnData = "<PYCRecord>"
	..f i = 1:1:countProperties d
    ...s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	..s returnData = returnData_"</PYCRecord>"
 	..i resultString = "" d
 	...s resultString = returnData
 	..e  d
 	...s resultString = resultString_returnData
	s result="<PYCRecords count='"_count_"'>"_resultString_"</PYCRecords>"
	q result
}

Storage Default
{
<Data name="PersonBaseCheckRecordInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonBaseChC8CD</DataLocation>
<DefaultData>PersonBaseCheckRecordInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonBaseChC8CD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonBaseChC8CI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonBaseChC8CS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
