Class CHSSWeb.HealthEducationMaterialService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

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
	s RowId=0
	s tmp =""
	
	For  Set RowId=$O(^CHSS.HealthEducationMaterialI("CommunityCodeIndex",CommunityCode,RowId)) q:RowId=""  d
	
	.s tempMate = ##class(CHSS.HealthEducationMaterial).%OpenId(RowId)
	.s Title = tempMate.Title
	.s People = tempMate.People
	.s Unit = tempMate.Unit
	.
	.s SendDate = tempMate.SendDate
	.i SendDate '= "" d
	..s SendDate =$zd(SendDate,3)
	.
	.s SendNum = tempMate.SendNum
	.
	.s DateOfStart = tempMate.DateOfStart
	.i DateOfStart '= "" d
	..s DateOfStart = $zd(DateOfStart,3)
	.
	.s Target = tempMate.Target
	.s Content = tempMate.Content
	.s Summarize = tempMate.Summarize
	.s Remark = tempMate.Remark
	.
	.s CreateDate = tempMate.CreateDate
	.i CreateDate '= "" d
	..s CreateDate = $zd(CreateDate,3)
	.
	.s StaffOfCreate = tempMate.StaffOfCreate
	.
	.s tmp=RowId_"^"_Title_"^"_People_"^"_Unit_"^"_SendDate_"^"_SendNum_"^"_DateOfStart_"^"_Target_"^"_Content_"^"_Summarize_"^"_Remark_"^"_CreateDate_"^"_StaffOfCreate_"^"_CommunityCode
	.s count = count +1
	.i (count>start)&&(count<=end) d
	..d json.InsertRowData(tmp)
	
	s resultString = json.getJsonData("RowId^Title^People^Unit^SendDate^SendNum^DateOfStart^Target^Content^Summarize^Remark^CreateDate^StaffOfCreate^CommunityCode",count)
    k json
    
    q resultString
}

ClassMethod insert(Title, People, Unit, SendDate, SendNum, DateOfStart, Target, Content, Summarize, Remark, CreateDate, StaffOfCreate, CommunityCode)
{
	s tempMater = ""
	s tempMater = ##class(CHSS.HealthEducationMaterial).%New()
	q:(tempMater="") 0
	
	s tempMater.Title = Title
	s tempMater.People = People
	s tempMater.Unit = Unit
	
	i SendDate '= "" d
	.s SendDate = $zdh(SendDate,3)
	.s tempMater.SendDate=SendDate
	
	s tempMater.SendNum = SendNum
	
	i DateOfStart '= "" d
	.s tempMater.DateOfStart = $zdh(DateOfStart,3)
	
	s tempMater.Target = Target
	s tempMater.Content = Content
	s tempMater.Summarize = Summarize
	s tempMater.Remark = Remark
	
	i CreateDate '= "" d
	.s tempMater.CreateDate = $zdh(CreateDate,3)
	
	s tempMater.StaffOfCreate = StaffOfCreate
	s tempMater.CommunityCode = CommunityCode 
	
	s result = ""
	s result = tempMater.%Save()
	
	i result = "1" d
	.w "{""success"":""true"",""info"":"_tempMater.%Id()_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

ClassMethod updata(RowId, Title, People, Unit, SendDate, SendNum, DateOfStart, Target, Content, Summarize, Remark, CreateDate, StaffOfCreate, CommunityCode)
{
	q:($d(RowId)=0)||(RowId="")
	s tempMater="",result=""
	s tempMater=##class(CHSS.HealthEducationMaterial).%OpenId(RowId)
	q:(tempMater="") 0
	
	s tempMater.Title = Title
	s tempMater.People = People
	s tempMater.Unit = Unit
	
	i SendDate '= "" d
	.s SendDate = $zdh(SendDate,3)
	.s tempMater.SendDate=SendDate
	
	s tempMater.SendNum = SendNum
	
	i DateOfStart '= "" d
	.s tempMater.DateOfStart = $zdh(DateOfStart,3)
	
	s tempMater.Target = Target
	s tempMater.Content = Content
	s tempMater.Summarize = Summarize
	s tempMater.Remark = Remark
	
	i CreateDate '= "" d
	.s tempMater.CreateDate = $zdh(CreateDate,3)
	
	s tempMater.StaffOfCreate = StaffOfCreate
	s tempMater.CommunityCode = CommunityCode 
	
	s result = ""
	s result = tempMater.%Save()
	
	i result = "1" d
	.w "{""success"":""true"",""info"":""ok""}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
	q ""
}

ClassMethod delete(RowId)
{
	&sql(delete from CHSS.HealthEducationMaterial where %ID=:RowId)	
	q SQLCODE
}

Storage Default
{
<Data name="HealthEducationMaterialServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HealthEducatBF2D</DataLocation>
<DefaultData>HealthEducationMaterialServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HealthEducatBF2D</IdLocation>
<IndexLocation>^CHSSWeb.HealthEducatBF2I</IndexLocation>
<StreamLocation>^CHSSWeb.HealthEducatBF2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
