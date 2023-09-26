Class CHSSWeb.PHAService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(PersonRowId As %String, start As %Integer, limit As %Integer) As %String
{
	
	Set PersonRowId = $G( PersonRowId )
	Set start = $G( start )
	Set limit = $G( limit )	
	Set end   = start + limit 
	Set count = 0
	Set resultString = ""
	Set json  = ##class(Code.JsonObj).%New()
	Set AppraiseRowId = 0

	For  Set AppraiseRowId = $O(^CHSS.PersonHealthAppraiseI("PersonRowIdParrefIndex",PersonRowId,AppraiseRowId)) q:AppraiseRowId=""  d
	.Set tempAppraise = ##class(CHSS.PersonHealthAppraise).%OpenId(AppraiseRowId)
	
	.Set DateCheck = $zd(tempAppraise.DateCheck,3)
	.Set CheckAdd = tempAppraise.CheckAdd
	.Set CheckDoctor = tempAppraise.CheckDoctor
	.Set EvaluationScore = tempAppraise.EvaluationScore
	
	
	.Set ChronicControl = ""
	.Set ChronicControlId = ""
	.if tempAppraise.ChronicControl '= "" do
	..Set ChronicControl = tempAppraise.ChronicControl.Description
	..Set ChronicControlId = tempAppraise.ChronicControl.%Id()
	
	.Set Physiology = ""
	.Set PhysiologyId = ""
	.if tempAppraise.Physiology '= "" do
	..Set Physiology = tempAppraise.Physiology.Description
	..Set PhysiologyId = tempAppraise.Physiology.%Id()
	
	.Set PhysiologyInfo =   tempAppraise.PhysiologyInfo
	
	.Set PhysiologyCure = ""
	.Set PhysiologyCureId = ""
	.if tempAppraise.PhysiologyCure '= "" do
	..Set PhysiologyCure = tempAppraise.PhysiologyCure.Description
	..Set PhysiologyCureId = tempAppraise.PhysiologyCure.%Id()
	
	.Set Mentality = ""
	.Set MentalityId = ""
	.if tempAppraise.Mentality '= "" do
	..Set Mentality = tempAppraise.Mentality.Description
	..Set MentalityId = tempAppraise.Mentality.%Id()
	
	.Set MentalityCure = ""
	.Set MentalityCureId = ""
	.if tempAppraise.MentalityCure '= "" do
	..Set MentalityCure = tempAppraise.MentalityCure.Description
	..Set MentalityCureId = tempAppraise.MentalityCure.%Id()
	
	.Set DangerInfo =  tempAppraise.DangerInfo
	
	.Set PeriodicalCheck = ""
	.Set PeriodicalCheckId = ""
	.if tempAppraise.PeriodicalCheck '= "" do
	..Set PeriodicalCheck = tempAppraise.PeriodicalCheck.Description
	..Set PeriodicalCheckId = tempAppraise.PeriodicalCheck.%Id()
	
	.Set DangerControl = tempAppraise.DangerControl
	
	
	.Set LiveQualityScore = tempAppraise.LiveQualityScore
	
	
	.Set Deal = tempAppraise.Deal
	
	.Set PersonName =##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId).PersonName
	
	.Set tmp= ""
	.Set tmp = PersonRowId_"^"_PersonName_"^"_AppraiseRowId_"^"_DateCheck_"^"_CheckAdd_"^"_CheckDoctor_"^"_EvaluationScore_"^"_ChronicControl_"^"_ChronicControlId_"^"_Physiology_"^"_PhysiologyId_"^"_PhysiologyInfo_"^"_PhysiologyCure_"^"_PhysiologyCureId_"^"_Mentality_"^"_MentalityId_"^"_MentalityCure_"^"_MentalityCureId_"^"_DangerInfo_"^"_PeriodicalCheck_"^"_PeriodicalCheckId_"^"_DangerControl_"^"_LiveQualityScore_"^"_Deal
	.Set count=count+1
	.If (count>start)&(count<=end) d
    ..d json.InsertRowData(tmp)
	Set resultString = json.getJsonData("PersonRowId^PersonName^AppraiseRowId^DateCheck^CheckAdd^CheckDoctor^EvaluationScore^ChronicControl^ChronicControlId^Physiology^PhysiologyId^PhysiologyInfo^PhysiologyCure^PhysiologyCureId^Mentality^MentalityId^MentalityCure^MentalityCureId^DangerInfo^PeriodicalCheck^PeriodicalCheckId^DangerControl^LiveQualityScore^Deal",count)
	k json	
	Quit resultString
}

ClassMethod Insert(PersonRowId As %String, DateCheck As %Date, CheckDoctor As %String, EvaluationScore As %Float, ChronicControlId As %Integer, PhysiologyId As %Integer, PhysiologyInfo As %String, PhysiologyCureId As %Integer, MentalityId As %Integer, MentalityCureId As %Integer, DangerInfo As %String, PeriodicalCheckId As %Integer, DangerControl As %String, LiveQualityScore As %Float, Deal As %String, CheckAdd As %String) As %String
{
	Set tempAppraise = ""
	Set tempAppraise = ##class(CHSS.PersonHealthAppraise).%New()
	q:(tempAppraise = "" ) 0
	/*
	Set ReturnId = ..existPersonRowId(PersonRowIdParref)
	
	i (ReturnId'="0") d
	.w "{""success"":""false"",""info"":""个人编码: "_ReturnId_" 已存在! 请重新输入!""}"
	e  d
	*/
	if (PersonRowId '= "" ) d
	.Set tempAppraise.PersonRowIdParref = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	
	.i DateCheck '= "" do
	..Set tempAppraise.DateCheck = $zdh(DateCheck,3)
	.Set tempAppraise.CheckDoctor = CheckDoctor
	.Set tempAppraise.EvaluationScore = EvaluationScore
	.Set tempAppraise.ChronicControl = ##class(CHSS.DictChronicControl).%OpenId(ChronicControlId)
	.Set tempAppraise.Physiology = ##class(CHSS.DictPhysiology).%OpenId(PhysiologyId)
	.Set tempAppraise.PhysiologyInfo  = PhysiologyInfo 
	.Set tempAppraise.PhysiologyCure = ##class(CHSS.DictPhysiologyCure).%OpenId(PhysiologyCureId)
	.Set tempAppraise.Mentality = ##class(CHSS.DictMentality).%OpenId(MentalityId)
	.Set tempAppraise.MentalityCure = ##class(CHSS.DictPhysiologyCure).%OpenId(MentalityCureId)
	.Set tempAppraise.DangerInfo  = DangerInfo
	.Set tempAppraise.PeriodicalCheck = ##class(CHSS.DictPeriodicalCheck).%OpenId(PeriodicalCheckId)
	.Set tempAppraise.DangerControl  = DangerControl
	.Set tempAppraise.LiveQualityScore   = LiveQualityScore  
	.Set tempAppraise.Deal   = Deal 
	.Set tempAppraise.CheckAdd = CheckAdd 
	
	.s result=""
    .s result=tempAppraise.%Save()

    .i result = "1" d
    ..w "{""success"":""true"",""info"":"_tempAppraise.%Id()_"}"
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
}

ClassMethod Update(AppraiseRowId, PersonRowId As %String, DateCheck As %Date, CheckDoctor As %String, EvaluationScore As %Float, ChronicControlId As %Integer, PhysiologyId As %Integer, PhysiologyInfo As %String, PhysiologyCureId As %Integer, MentalityId As %Integer, MentalityCureId As %Integer, DangerInfo As %String, PeriodicalCheckId As %Integer, DangerControl As %String, LiveQualityScore As %Float, Deal As %String, CheckAdd As %String) As %String
{

	q:($d(AppraiseRowId)=0)
	Set tempAppraise = ""
	Set tempAppraise = ##class(CHSS.PersonHealthAppraise).%OpenId(AppraiseRowId)

	q:(tempAppraise = "" ) 0

	if (PersonRowId '= "" ) d
	.Set tempAppraise.PersonRowIdParref = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	
	.i DateCheck '= "" do
	..Set tempAppraise.DateCheck = $zdh(DateCheck,3)
	.Set tempAppraise.CheckDoctor = CheckDoctor
	.Set tempAppraise.EvaluationScore = EvaluationScore
	.Set tempAppraise.ChronicControl = ##class(CHSS.DictChronicControl).%OpenId(ChronicControlId)
	.Set tempAppraise.Physiology = ##class(CHSS.DictPhysiology).%OpenId(PhysiologyId)
	.Set tempAppraise.PhysiologyInfo  = PhysiologyInfo 
	.Set tempAppraise.PhysiologyCure = ##class(CHSS.DictPhysiologyCure).%OpenId(PhysiologyCureId)
	.Set tempAppraise.Mentality = ##class(CHSS.DictMentality).%OpenId(MentalityId)
	.Set tempAppraise.MentalityCure = ##class(CHSS.DictPhysiologyCure).%OpenId(MentalityCureId)
	.Set tempAppraise.DangerInfo  = DangerInfo
	.Set tempAppraise.PeriodicalCheck = ##class(CHSS.DictPeriodicalCheck).%OpenId(PeriodicalCheckId)
	.Set tempAppraise.DangerControl  = DangerControl
	.Set tempAppraise.LiveQualityScore   = LiveQualityScore  
	.Set tempAppraise.Deal   = Deal  
	.Set tempAppraise.CheckAdd = CheckAdd 
	
	.s result=""
    .s result=tempAppraise.%Save()

	s result=""
    s result=tempAppraise.%Save()
    
    i result = "1" d
    .w "{""success"":""true"",""info"":"_tempAppraise.%Id()_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
}

ClassMethod existPersonRowId(PersonRowId As %String) As %String
{
	q:PersonRowId="" "-1"
	s PersonRowId=" "_PersonRowId
	q:$d(^CHSS.PersonYearCheckRecordI("PersonRowIdParrefIndex",PersonRowId)) "1"
	q "0"
}

ClassMethod Delete(AppraiseRowId As %String) As %String
{
	&sql(delete from CHSS.PersonHealthAppraise where HealthAppraiseRowId= :AppraiseRowId)
	w SQLCODE
	q "0"
}

Storage Default
{
<Data name="PHAServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PHAServiceD</DataLocation>
<DefaultData>PHAServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PHAServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PHAServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PHAServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
