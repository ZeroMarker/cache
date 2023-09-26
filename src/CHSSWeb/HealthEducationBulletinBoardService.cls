Class CHSSWeb.HealthEducationBulletinBoardService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//列出所有的记录

ClassMethod ListPage(CommunityCode, Start, Limit) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.HealthEducationBulletinBoard where CommunityCode ="_CommunityCode
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s RowId = result.Data("RowId")
	s Titel = result.Data("Titel")
	s Address = result.Data("Address")
	s Unit = result.Data("Unit")
	s PutDate = result.Data("PutDate")
	i (PutDate'="") d
	.s PutDate=$zd(PutDate,3)
	s PlanContent = result.Data("PlanContent")
	s PlanTarget = result.Data("PlanTarget")
	s Summarize = result.Data("Summarize")
	s DateOfStart = result.Data("DateOfStart")
	i (DateOfStart '= "") d
	.s DateOfStart = $zd(DateOfStart,3)
	s DateOfEnd = result.Data("DateOfEnd")
	i (DateOfEnd'="") d
	.s DateOfEnd=$zd(DateOfEnd,3)
	s Remark = result.Data("Remark")
	s DateOfCreate = result.Data("DateOfCreate")
	i (DateOfCreate'="") d
	.s DateOfCreate = $zd(DateOfCreate,3)
	s StaffOfCreate = result.Data("StaffOfCreate")
	s CommunityCode = result.Data("CommunityCode")
	
	s tmp=RowId_"^"_Titel_"^"_Address_"^"_Unit_"^"_PutDate_"^"_PlanContent_"^"_PlanTarget_"^"_Summarize_"^"_DateOfStart_"^"_DateOfEnd_"^"_Remark_"^"_DateOfCreate_"^"_StaffOfCreate_"^"_CommunityCode
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Titel^Address^Unit^PutDate^PlanContent^PlanTarget^Summarize^DateOfStart^DateOfEnd^Remark^DateOfCreate^StaffOfCreate^CommunityCode",count)
	k json
	q resultString
}

//添加记录

ClassMethod insert(Titel, Address, Unit, PutDate, PlanContent, PlanTarget, Summarize, DateOfStart, DateOfEnd, Remark, DateOfCreate, StaffOfCreate, CommunityCode) As %String
{
	i PutDate '= "" d
	.s PutDate=$zdh(PutDate,3)
	i DateOfStart '= "" d
	.s DateOfStart=$zdh(DateOfStart,3)
	i DateOfEnd '= "" d
	.s DateOfEnd=$zdh(DateOfEnd,3)
	i DateOfCreate '= "" d
	.s DateOfCreate=$zdh(DateOfCreate,3)
	
	&sql(insert into CHSS.HealthEducationBulletinBoard (Titel,Address, Unit, PutDate, PlanContent, PlanTarget,Summarize ,DateOfStart ,DateOfEnd ,Remark, DateOfCreate,StaffOfCreate,CommunityCode) values(:Titel,:Address, :Unit, :PutDate, :PlanContent, :PlanTarget,:Summarize ,:DateOfStart ,:DateOfEnd ,:Remark, :DateOfCreate,:StaffOfCreate,:CommunityCode))
	i SQLCODE ="0" d
	.w "{""success"":""true"",""info"":"_%ROWID_"}"
	e  d
	.w "{""success"":""false"",""info"":""添加出错"_SQLCODE_"}"
	q ""
}

//修改记录

ClassMethod update(RowId, Titel, Address, Unit, PutDate, PlanContent, PlanTarget, Summarize, DateOfStart, DateOfEnd, Remark, DateOfCreate, StaffOfCreate, CommunityCode) As %String
{
	
	q:(RowId="") "code-rep"
	
	i PutDate '= "" d
	.s PutDate=$zdh(PutDate,3)
	i DateOfStart '= "" d
	.s DateOfStart=$zdh(DateOfStart,3)
	i DateOfEnd '= "" d
	.s DateOfEnd=$zdh(DateOfEnd,3)
	i DateOfCreate '= "" d
	.s DateOfCreate=$zdh(DateOfCreate,3)
	
	&sql(update CHSS.HealthEducationBulletinBoard set Titel=:Titel, Address=:Address, Unit=:Unit, PutDate=:PutDate, PlanContent=:PlanContent, PlanTarget=:PlanTarget,Summarize=:Summarize ,DateOfStart=:DateOfStart ,DateOfEnd=:DateOfEnd ,Remark=:Remark, DateOfCreate=:DateOfCreate ,StaffOfCreate=:Sex,CommunityCode=:CommunityCode where %ID=:RowId)
	q SQLCODE
	q ""
}

//删除一条数据库中已经存在的记录

ClassMethod delete(RowId) As %String
{
	&sql(delete from CHSS.HealthEducationBulletinBoard where %ID=:RowId)
	q SQLCODE
}

//查询

ClassMethod Search(CommunityCode, Start, Limit, SqlStr)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.HealthEducationBulletinBoard where CommunityCode ="_CommunityCode_SqlStr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s RowId = result.Data("RowId")
	s Titel = result.Data("Titel")
	s Address = result.Data("Address")
	s Unit = result.Data("Unit")
	s PutDate = result.Data("PutDate")
	i (PutDate'="") d
	.s PutDate=$zd(PutDate,3)
	s PlanContent = result.Data("PlanContent")
	s PlanTarget = result.Data("PlanTarget")
	s Summarize = result.Data("Summarize")
	s DateOfStart = result.Data("DateOfStart")
	i (DateOfStart '= "") d
	.s DateOfStart = $zd(DateOfStart,3)
	s DateOfEnd = result.Data("DateOfEnd")
	i (DateOfEnd'="") d
	.s DateOfEnd=$zd(DateOfEnd,3)
	s Remark = result.Data("Remark")
	s DateOfCreate = result.Data("DateOfCreate")
	i (DateOfCreate'="") d
	.s DateOfCreate = $zd(DateOfCreate,3)
	s StaffOfCreate = result.Data("StaffOfCreate")
	s CommunityCode = result.Data("CommunityCode")
	
	s tmp=RowId_"^"_Titel_"^"_Address_"^"_Unit_"^"_PutDate_"^"_PlanContent_"^"_PlanTarget_"^"_Summarize_"^"_DateOfStart_"^"_DateOfEnd_"^"_Remark_"^"_DateOfCreate_"^"_StaffOfCreate_"^"_CommunityCode
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Titel^Address^Unit^PutDate^PlanContent^PlanTarget^Summarize^DateOfStart^DateOfEnd^Remark^DateOfCreate^StaffOfCreate^CommunityCode",count)
	k json
	q resultString
}

Storage Default
{
<Data name="HealthEducationBulletinBoardServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HealthEducatDEAD</DataLocation>
<DefaultData>HealthEducationBulletinBoardServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HealthEducatDEAD</IdLocation>
<IndexLocation>^CHSSWeb.HealthEducatDEAI</IndexLocation>
<StreamLocation>^CHSSWeb.HealthEducatDEAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
