Class CHSSWeb.PersonHealthAppraiseService Extends %Persistent
{

ClassMethod insert(PersonRowId As %Integer, YearCheckRowId As %Integer) As %String
{
	s HealthAppraiseRowId = ""
	&SQL(select HealthAppraiseRowId into :HealthAppraiseRowId from CHSS.PersonHealthAppraise where YearCheckRowId=:YearCheckRowId)
   	;w PersonRowId,!
   	;w YearCheckRowId,!
    i HealthAppraiseRowId = "" d
	.&SQL(insert into CHSS.PersonHealthAppraise (YearCheckRowId,PersonRowIdParref) values (:YearCheckRowId,:PersonRowId))
    q ""
}

ClassMethod List(YearCheckRowId As %Integer, PersonRowId As %Integer, start As %Integer, limit As %Integer) As %String
{
	d ..insert(PersonRowId, YearCheckRowId)
	Set start = $G( start )
	Set limit = $G( limit )	
	Set end   = start + limit 
	Set count = 0
	Set resultString = ""
	Set json  = ##class(Code.JsonObj).%New()
	Set checkRowId = 0
	s HealthAppraiseRowId = 0
	&SQL(select HealthAppraiseRowId into :HealthAppraiseRowId from CHSS.PersonHealthAppraise where YearCheckRowId=:YearCheckRowId)
    ;w HealthAppraiseRowId,!
    Set tempPersonCheck = ##class(CHSS.PersonHealthAppraise).%OpenId(HealthAppraiseRowId)
	i tempPersonCheck '= "" d
	.
	.Set CheckResult = tempPersonCheck.CheckResult
	.Set HealthSuggest = tempPersonCheck.HealthSuggest
	.Set DangerInfo = tempPersonCheck.DangerInfo
	.Set PersonRowIdParref =  PersonRowId
	.Set YearCheckRowId = YearCheckRowId
	.set CheckResultInfo = tempPersonCheck.CheckResultInfo
	.Set DangerControl = tempPersonCheck.DangerControl
	.Set tmp= ""
	.Set tmp = HealthAppraiseRowId_"^"_CheckResult_"^"_HealthSuggest_"^"_DangerInfo_"^"_PersonRowIdParref_"^"_YearCheckRowId_"^"_CheckResultInfo_"^"_DangerControl
	.Set count=count+1
	.If (count>start)&(count<=end) d
    ..d json.InsertRowData(tmp)
	Set resultString = json.getJsonData("HealthAppraiseRowId^CheckResult^HealthSuggest^DangerInfo^PersonRowIdParref^YearCheckRowId^CheckResultInfo^DangerControl",count)
	k json	
	Quit resultString
}

ClassMethod update(HealthAppraiseRowId, CheckResult, HealthSuggest, DangerInfo, CheckResultInfo, DangerControl) As %String
{
	
	Set tempCheck = ""
	Set tempCheck = ##class(CHSS.PersonHealthAppraise).%OpenId(HealthAppraiseRowId)

	q:(tempCheck = "" ) 0
	Set tempCheck.CheckResult = CheckResult
	Set tempCheck.HealthSuggest = HealthSuggest
	Set tempCheck.DangerInfo = DangerInfo
	Set tempCheck.CheckResultInfo = CheckResultInfo
	Set tempCheck.DangerControl = DangerControl
	
	s result=""
    s result=tempCheck.%Save()
    i result = "1" d
    .w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
    .d ..insertIntoChronic(HealthAppraiseRowId)
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    
    q ""
}

ClassMethod insertIntoChronic(HealthAppraiseRowId) As %String
{
	
	Set tempCheck = ""
	Set tempCheck = ##class(CHSS.PersonHealthAppraise).%OpenId(HealthAppraiseRowId)

	q:(tempCheck = "" ) 0
	s PersonRowId = tempCheck.PersonRowIdParref
	s PersonRowId = PersonRowId.%Id()

	S HealthSuggest = tempCheck.HealthSuggest

	//Set tempPerson = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	s bHave = $Find(HealthSuggest,"纳入高血压随访")
	i bHave '= 0 d
	.d ..insertIntoHealthDiagnose(PersonRowId,"高血压")
	.
	s bHave = $Find(HealthSuggest,"纳入糖尿病随访")
	i bHave '= 0 d
	.d ..insertIntoHealthDiagnose(PersonRowId,"糖尿病")
	
	s bHave = $Find(HealthSuggest,"纳入精神病随访")
	i bHave '= 0 d
	.d ..insertIntoHealthDiagnose(PersonRowId,"精神病")
	.
	
	s bHave = $Find(HealthSuggest,"纳入乙肝随访")
	i bHave '= 0 d
	.d ..insertIntoHealthDiagnose(PersonRowId,"乙肝")
	
	s bHave = $Find(HealthSuggest,"纳入结核病随访")
	i bHave '= 0 d
	.d ..insertIntoHealthDiagnose(PersonRowId,"结核病")


    q ""
}

ClassMethod insertIntoHealthDiagnose(PersonRowIdParref As %Integer, ItemAssortName As %String) As %String
{
	s chronicStr = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowIdParref,"22")
	
	s bHave = $Find(chronicStr,ItemAssortName)
	s ItemAssortName2 = ItemAssortName
	i bHave = 0 d
	.;d ##class(CHSSWeb.PersonHealthDiagnoseService).insert("",PersonRowIdParref,ItemAssortName,"22","22",ItemAssortName,"", "", "", "", "", "","","")
	.;&sql(insert into CHSS.PersonHealthDiagnose (PersonRowIdParref, ItemName, ItemdCode, ItemAssortName) values(PersonRowIdParref, :ItemAssortName2, 22, :ItemAssortName2))
	.;w SQLCODE
	i bHave = 0 d
	.s result = ##class(%Library.ResultSet).%New()
	.s sqlStr = "insert into CHSS.PersonHealthDiagnose (PersonRowIdParref, ItemName, ItemdCode, ItemAssortName) values("_PersonRowIdParref_", '"_ItemAssortName2_"', '22','"_ItemAssortName2_"')"
	.d result.Prepare(sqlStr)
	.;w sqlStr
	.d result.Execute()
	.d result.Close()
	
	q ""
}

Storage Default
{
<Data name="PersonHealthAppraiseServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonHealthAD3D</DataLocation>
<DefaultData>PersonHealthAppraiseServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonHealthAD3D</IdLocation>
<IndexLocation>^CHSSWeb.PersonHealthAD3I</IndexLocation>
<StreamLocation>^CHSSWeb.PersonHealthAD3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
