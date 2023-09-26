Class CHSSWeb.CHSSResourceGroupService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(Start, Limit)
{
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	s GroupRowId=0

    For  Set GroupRowId=$O(^CHSS.CHSSResourceGroupD(GroupRowId)) q:GroupRowId=""  d
	.s tempRes=##class(CHSS.CHSSResourceGroup).%OpenId(GroupRowId)

	.s GroupCode=tempRes.GroupCode
	.s GroupName=tempRes.GroupName
	.s GroupDescription=tempRes.GroupDescription
	.s GroupType = tempRes.GroupType
	.s GroupTypeName = ""
	.i GroupType = 1 d
	..s GroupTypeName = "社区"
	.e  i GroupType = 2 d
	..s GroupTypeName = "档案浏览器"
	.s tmp=""
	.s tmp=GroupRowId_"^"_GroupCode_"^"_GroupName_"^"_GroupDescription_"^"_GroupType_"^"_GroupTypeName
	.s count=count+1
	.i (count>start)&(count<=end) d
	..d json.InsertRowData(tmp)
	s resultString=json.getJsonData("GroupRowId^GroupCode^GroupName^GroupDescription^GroupType^GroupTypeName",count)
	k json        
	Quit resultString
}

ClassMethod insertupdata(GroupRowId, GroupCode, GroupName, GroupDescription, GroupType)
{
	s tempRes=""
	
	i GroupRowId="" d
	.s tempRes=##class(CHSS.CHSSResourceGroup).%New()
	e  d
	.s tempRes=##class(CHSS.CHSSResourceGroup).%OpenId(GroupRowId)
	
	s tempRes.GroupCode=GroupCode
	s tempRes.GroupName=GroupName
	s tempRes.GroupDescription=GroupDescription
	s tempRes.GroupType=GroupType
	s result=""
	s result=tempRes.%Save()
	
	s resultString=""
	i result="1" d
	.s resultString="{""success"":""true"",""info"":"_tempRes.%Id()_"}"
	e  d
	.s resultString="{""success"":""true"",""info"":""数据保存出错！""}"
	q resultString
}

ClassMethod del(GroupRowId)
{
	q:(GroupRowId="") ""
	s tempRes=##class(CHSS.CHSSResourceGroup).%OpenId(GroupRowId)	
	q:(tempRes="") ""
	
	s result=tempRes.%DeleteId(GroupRowId)
	
	i result="1" d
	 .w "{""success"":""true"",""info"":""数据删除成功！""}"
    e  d
    .w "{""success"":""false"",""info"":""数据删除出错！""}"
    
    q ""
}

Storage Default
{
<Data name="CHSSResourceGroupServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CHSSResource957D</DataLocation>
<DefaultData>CHSSResourceGroupServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CHSSResource957D</IdLocation>
<IndexLocation>^CHSSWeb.CHSSResource957I</IndexLocation>
<StreamLocation>^CHSSWeb.CHSSResource957S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
