Class CHSSWeb.HealthEducationLectureService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
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
	s LectureRowId=0
	s tmp =""
	
	For  Set LectureRowId=$O(^CHSS.HealthEducationLectureI("CommunityCodeIndex",CommunityCode,LectureRowId)) q:LectureRowId=""  d
   
	.s tempPerson=##class(CHSS.HealthEducationLecture).%OpenId(LectureRowId)
	
	.set LectureTitel = tempPerson.LectureTitel
	.set LectureName = tempPerson.LectureName
	.set LectureAddress = tempPerson.LectureAddress
	.set People = tempPerson.People
	.set Unit = tempPerson.Unit
	.set PlanContent = tempPerson.PlanContent
	.set PlanTarget = tempPerson.PlanTarget
	.set Remark = tempPerson.Remark
	.set Summarize = tempPerson.Summarize
	
	.set LectureDATE = tempPerson.LectureDATE
	.i LectureDATE '="" d
	..set LectureDATE = $zd(LectureDATE,3)
	
	.s LectureTime = tempPerson.LectureTime
	.i LectureTime '="" d
	..s LectureTime = $zd(LectureTime,3)
	
	.s DateOfCreate = tempPerson.DateOfCreate
	.i DateOfCreate '="" d
	..s DateOfCreate = $zd(DateOfCreate,3)
	
	.s StaffOfCreate = tempPerson.StaffOfCreate
	
	.Set tmp= LectureRowId_"^"_LectureTitel_"^"_LectureName_"^"_LectureAddress_"^"_People_"^"_Unit_"^"_PlanContent_"^"_PlanTarget_"^"_Remark_"^"_Summarize_"^"_LectureDATE_"^"_LectureTime_"^"_DateOfCreate_"^"_StaffOfCreate_"^"_CommunityCode
	.Set count=count+1
	.If (count>start)&(count<=end) d
    ..d json.InsertRowData(tmp)
    Set resultString = json.getJsonData("LectureRowId^LectureTitel^LectureName^LectureAddress^People^Unit^PlanContent^PlanTarget^Remark^Summarize^LectureDATE^LectureTime^DateOfCreate^StaffOfCreate^CommunityCode",count)
	k json
	 	
	Quit resultString
}

//添加

ClassMethod insert(LectureTitel, LectureName, LectureAddress, People, Unit, PlanContent, PlanTarget, Remark, Summarize, LectureDATE, LectureTime, DateOfCreate, StaffOfCreate, CommunityCode) As %String
{
	s tempPerson=""
	s tempPerson=##class(CHSS.HealthEducationLecture).%New()
	q:(tempPerson="") 0
	
	s ReturnName=..existPlanName(LectureTitel)
	i (ReturnName'="0") d
	.w "{""success"":""false"",""info"":""演讲主题: "_LectureTitel_" 已存在! 请重新输入!""}"
	e  d
	.s tempPerson.CommunityCode = CommunityCode
	.set tempPerson.LectureTitel = LectureTitel
	.set tempPerson.LectureName = LectureName 
	.set tempPerson.LectureAddress = LectureAddress
	.set tempPerson.People = People 
	.set tempPerson.Unit = Unit 
	.set tempPerson.PlanContent = PlanContent 
	.set tempPerson.PlanTarget = PlanTarget
	.set tempPerson.Remark = Remark 
	.set tempPerson.Summarize = Summarize 
	
	.i LectureDATE '="" d
	..set LectureDATE = $zdh(LectureDATE,3)
	..s tempPerson.LectureDATE = LectureDATE 
	
	.i LectureTime '="" d
	..s LectureTime = $zdh(LectureTime,3)
	..s tempPerson.LectureTime = LectureTime 
	
	.i DateOfCreate '="" d
	..s DateOfCreate = $zdh(DateOfCreate,3)
	..s tempPerson.DateOfCreate = DateOfCreate
	
	.s tempPerson.StaffOfCreate =  StaffOfCreate
	
	.s result=""
    .s result=tempPerson.%Save()
    .i result = "1" d
    ..w "{""success"":""true"",""info"":"_tempPerson.%Id()_"}"
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

//修改

ClassMethod update(LectureRowId, LectureTitel, LectureName, LectureAddress, People, Unit, PlanContent, PlanTarget, Remark, Summarize, LectureDATE, LectureTime, DateOfCreate, StaffOfCreate, CommunityCode) As %String
{
	q:($d(LectureRowId)=0)||(LectureRowId="")
	s tempPerson="",result=""
	s tempPerson=##class(CHSS.HealthEducationLecture).%OpenId(LectureRowId)
	q:(tempPerson="") 0
	
	set tempPerson.LectureTitel = LectureTitel
	set tempPerson.LectureName = LectureName 
	set tempPerson.LectureAddress = LectureAddress
	set tempPerson.People = People 
	set tempPerson.Unit = Unit 
	set tempPerson.PlanContent = PlanContent 
	set tempPerson.PlanTarget = PlanTarget
	set tempPerson.Remark = Remark 
	set tempPerson.Summarize = Summarize 
	
	i LectureDATE '="" d
    .set LectureDATE = $zdh(LectureDATE,3)
	.s tempPerson.LectureDATE = LectureDATE 
	
	i LectureTime '="" d
	.s LectureTime = $zdh(LectureTime,3)
	.s tempPerson.LectureTime = LectureTime 
	
	i DateOfCreate '="" d
	.s DateOfCreate = $zdh(DateOfCreate,3)
	.s tempPerson.DateOfCreate = DateOfCreate
	
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

ClassMethod delete(LectureRowId) As %String
{
	&sql(delete from CHSS.HealthEducationLecture where %ID=:LectureRowId)
	q SQLCODE
}

//判断演讲主题是否重复

ClassMethod existPlanName(LectureTitel) As %String
{
	q:LectureTitel="" "-1"
	s LectureTitel=" "_LectureTitel
	q:$d(^CHSS.HealthEducationLectureI("TitelIndex",LectureTitel)) "1"
	q "0"
}

//查询

ClassMethod Search(CommunityCode, Start, Limit, SqlStr)
{
	s result = ##class(%Library.ResultSet).%New()	
	s sqlStr = "SELECT *  FROM CHSS.HealthEducationLecture where CommunityCode= "_CommunityCode_SqlStr 
	
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s LectureRowId = result.Data("LectureRowId")
	set LectureTitel = result.Data("LectureTitel")
	set LectureName = result.Data("LectureName") 
	set LectureAddress = result.Data("LectureAddress")
	set People = result.Data("People") 
	set Unit = result.Data("Unit") 
	set PlanContent = result.Data("PlanContent") 
	set PlanTarget = result.Data("PlanTarget")
	set Remark = result.Data("Remark") 
	set Summarize = result.Data("Summarize") 
	
	s LectureDATE = result.Data("LectureDATE")
	i (LectureDATE'="") d
	.s LectureDATE = $zd(LectureDATE,3)
	
	s LectureTime = result.Data("LectureTime")
	i (LectureTime'="") d
	.s LectureTime = $zd(LectureTime,3)
	
	s DateOfCreate = result.Data("DateOfCreate")
	i (DateOfCreate'="") d
	.s DateOfCreate = $zd(DateOfCreate,3)
	
	s StaffOfCreate = result.Data("StaffOfCreate")
	s CommunityCode = result.Data("CommunityCode")
	
	Set tmp= LectureRowId_"^"_LectureTitel_"^"_LectureName_"^"_LectureAddress_"^"_People_"^"_Unit_"^"_PlanContent_"^"_PlanTarget_"^"_Remark_"^"_Summarize_"^"_LectureDATE_"^"_LectureTime_"^"_DateOfCreate_"^"_StaffOfCreate_"^"_CommunityCode
	Set count=count+1
	i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	d result.Close()
	Set resultString = json.getJsonData("LectureRowId^LectureTitel^LectureName^LectureAddress^People^Unit^PlanContent^PlanTarget^Remark^Summarize^LectureDATE^LectureTime^DateOfCreate^StaffOfCreate^CommunityCode",count)
	k json
	q resultString
}

Storage Default
{
<Data name="HealthEducationLectureServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HealthEducatB97D</DataLocation>
<DefaultData>HealthEducationLectureServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HealthEducatB97D</IdLocation>
<IndexLocation>^CHSSWeb.HealthEducatB97I</IndexLocation>
<StreamLocation>^CHSSWeb.HealthEducatB97S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
