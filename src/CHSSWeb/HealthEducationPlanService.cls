Class CHSSWeb.HealthEducationPlanService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//检索

ClassMethod ListPage(CommunityCode As %String, start As %Integer, limit As %Integer)
{
	Set start=$G(start)
	Set limit=$G(limit)
	Set CommunityCode=$G(CommunityCode)
	s CommunityCode=" "_CommunityCode
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	s PlanRowId=0
	s tmp =""
	
	For  Set PlanRowId=$O(^CHSS.HealthEducationPlanI("CommunityCodeIndex",CommunityCode,PlanRowId)) q:PlanRowId=""  d
   
	.s tempPerson=##class(CHSS.HealthEducationPlan).%OpenId(PlanRowId)
	
	.set PlanName = tempPerson.PlanName
	.set PlanType = tempPerson.PlanType
	.set PlanContent = tempPerson.PlanContent
	.set PlanTarget = tempPerson.PlanTarget
	.set ProgressInfo = tempPerson.ProgressInfo
	.set Summarize = tempPerson.Summarize
	
	.set DateOfCreate = tempPerson.DateOfCreate
	.i DateOfCreate '="" d
	..set DateOfCreate = $zd(DateOfCreate,3)
	
	.s DateOfStart = tempPerson.DateOfStart
	.i DateOfStart '="" d
	..s DateOfStart = $zd(DateOfStart,3)
	
	.s DateOfEnd = tempPerson.DateOfEnd
	.i DateOfEnd '="" d
	..s DateOfEnd = $zd(DateOfEnd,3)
	
	.s StaffOfCreate = tempPerson.StaffOfCreate
	
	.Set tmp= PlanRowId_"^"_PlanName_"^"_PlanType_"^"_PlanContent_"^"_PlanTarget_"^"_ProgressInfo_"^"_Summarize_"^"_DateOfCreate_"^"_DateOfStart_"^"_DateOfEnd_"^"_StaffOfCreate_"^"_CommunityCode
	.Set count=count+1
	.If (count>start)&(count<=end) d
    ..d json.InsertRowData(tmp)
    Set resultString = json.getJsonData("PlanRowId^PlanName^PlanType^PlanContent^PlanTarget^ProgressInfo^Summarize^DateOfCreate^DateOfStart^DateOfEnd^StaffOfCreate^CommunityCode",count)
	k json
	 	
	Quit resultString
}

//添加

ClassMethod insert(PlanName, PlanType, PlanContent, PlanTarget, ProgressInfo, Summarize, DateOfCreate, DateOfStart, DateOfEnd, StaffOfCreate, CommunityCode) As %String
{
	s tempPerson=""
	s tempPerson=##class(CHSS.HealthEducationPlan).%New()
	q:(tempPerson="") 0
	
	s ReturnName=..existPlanName(PlanName)
	i (ReturnName'="0") d
	.w "{""success"":""false"",""info"":""计划名称: "_PlanName_" 已存在! 请重新输入!""}"
	e  d
	.s tempPerson.CommunityCode = CommunityCode
	.s tempPerson.PlanName = PlanName
	.s tempPerson.PlanType = PlanType
	.s tempPerson.PlanContent = PlanContent
	.s tempPerson.PlanTarget = PlanTarget
	.s tempPerson.ProgressInfo = ProgressInfo
	.s tempPerson.Summarize = Summarize
	
	.i DateOfCreate '="" d
	..s DateOfCreate= $zdh(DateOfCreate,3)
	..s tempPerson.DateOfCreate = DateOfCreate

	.i DateOfStart '="" d
	..s DateOfStart = $zdh(DateOfStart,3)
	..s tempPerson.DateOfStart = DateOfStart
	
	.i DateOfEnd '="" d
	..s DateOfEnd= $zdh(DateOfEnd,3)
	..s tempPerson.DateOfEnd = DateOfEnd
	
	.s tempPerson.StaffOfCreate = StaffOfCreate

	.s result=""
    .s result=tempPerson.%Save()
    .i result = "1" d
    ..w "{""success"":""true"",""info"":"_tempPerson.%Id()_"}"
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

//修改

ClassMethod update(PlanRowId, PlanName, PlanType, PlanContent, PlanTarget, ProgressInfo, Summarize, DateOfCreate, DateOfStart, DateOfEnd, StaffOfCreate, CommunityCode) As %String
{
	q:($d(PlanRowId)=0)||(PlanRowId="")
	s tempPerson="",result=""
	s tempPerson=##class(CHSS.HealthEducationPlan).%OpenId(PlanRowId)
	q:(tempPerson="") 0
	
	s tempPerson.PlanName=PlanName
	s tempPerson.PlanType=PlanType
	s tempPerson.PlanContent=PlanContent
	s tempPerson.PlanTarget=PlanTarget
	s tempPerson.ProgressInfo=ProgressInfo
	s tempPerson.Summarize=Summarize
	
	i DateOfCreate '="" d
	.s DateOfCreate=$zdh(DateOfCreate,3)
	.s tempPerson.DateOfCreate=DateOfCreate
	i DateOfStart '="" d
	.s DateOfStart= $zdh(DateOfStart,3)
	.s tempPerson.DateOfStart=DateOfStart
	i DateOfEnd '= "" d
	.s DateOfEnd = $zdh(DateOfEnd,3)
	.s tempPerson.DateOfEnd=DateOfEnd
	
	s tempPerson.StaffOfCreate = StaffOfCreate
	s tempPerson.CommunityCode = CommunityCode
	
	s result=""
	s result=tempPerson.%Save()
	i result = "1" d
    .w "{""success"":""true"",""info"":""修改成功!""}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

//删除

ClassMethod delete(PlanRowId) As %String
{
	&sql(delete from CHSS.HealthEducationPlan where %ID=:PlanRowId)
	q SQLCODE
}

//判断计划名称是否重复

ClassMethod existPlanName(PlanName) As %String
{
	q:PlanName="" "-1"
	s PlanName=" "_PlanName
	q:$d(^CHSS.HealthEducationPlanI("NameIndex",PlanName)) "1"
	q "0"
}

//查询

ClassMethod Search(CommunityCode, Start, Limit, SqlStr)
{
	s result = ##class(%Library.ResultSet).%New()	
	s sqlStr = "SELECT *  FROM CHSS.HealthEducationPlan where CommunityCode= "_CommunityCode_SqlStr 
	
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s PlanRowId = result.Data("PlanRowId")
	s PlanName = result.Data("PlanName")
	s PlanType = result.Data("PlanType")
	s PlanContent = result.Data("PlanContent")
	s PlanTarget = result.Data("PlanTarget")
	s ProgressInfo = result.Data("ProgressInfo")
	s Summarize = result.Data("Summarize")
	
	s DateOfCreate = result.Data("DateOfCreate")
	i (DateOfCreate'="") d
	.s DateOfCreate = $zd(DateOfCreate,3)
	
	s DateOfStart = result.Data("DateOfStart")
	i (DateOfStart'="") d
	.s DateOfStart = $zd(DateOfStart,3)
	
	s DateOfEnd =result.Data("DateOfEnd")
	i (DateOfEnd'="") d
	.s DateOfEnd = $zd(DateOfEnd,3)
	
	s StaffOfCreate = result.Data("StaffOfCreate")
	s CommunityCode = result.Data("CommunityCode")
	
	Set tmp= PlanRowId_"^"_PlanName_"^"_PlanType_"^"_PlanContent_"^"_PlanTarget_"^"_ProgressInfo_"^"_Summarize_"^"_DateOfCreate_"^"_DateOfStart_"^"_DateOfEnd_"^"_StaffOfCreate_"^"_CommunityCode
	Set count=count+1
	i (count>Start)&(count<=end) d
	d json.InsertRowData(tmp)
	}
	d result.Close()
	Set resultString = json.getJsonData("PlanRowId^PlanName^PlanType^PlanContent^PlanTarget^ProgressInfo^Summarize^DateOfCreate^DateOfStart^DateOfEnd^StaffOfCreate^CommunityCode",count)
	k json
	q resultString
}

Storage Default
{
<Data name="HealthEducationPlanServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HealthEducatA4ED</DataLocation>
<DefaultData>HealthEducationPlanServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HealthEducatA4ED</IdLocation>
<IndexLocation>^CHSSWeb.HealthEducatA4EI</IndexLocation>
<StreamLocation>^CHSSWeb.HealthEducatA4ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
