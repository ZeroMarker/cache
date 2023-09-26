Class CHSSWeb.CHSSResourceVsGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(Start, Limit, GroupRowId)
{
	Set start=$G(Start)
	Set limit=$G(Limit)
	s GroupRowId=$G(GroupRowId)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	s ReVsGrRowId=0
	
	s sqlstr = " select ReVsGrRowId,ResRowId,GroupRowId, ResRowId->ResCode as ResCode,ResRowId->ResName from CHSS.CHSSResourceVsGroup where GroupRowId="_GroupRowId
	s tempRes = ##class(%Library.ResultSet).%New()
	d tempRes.Prepare(sqlstr)
	d tempRes.Execute()

   	while(tempRes.Next())
   	{
	s ReVsGrRowId = tempRes.Data("ReVsGrRowId")   
	s ResRowId = tempRes.Data("ResRowId") 
	s GroupRowId = tempRes.Data("GroupRowId") 
	s ResCode = tempRes.Data("ResCode") 
	s ResName = tempRes.Data("ResName") 	
	
	s tmp=""
	s tmp=ReVsGrRowId_"^"_ResRowId_"^"_GroupRowId_"^"_ResCode_"^"_ResName
	s count=count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	.
	}
	d tempRes.Close()
	s resultString=json.getJsonData("ReVsGrRowId^ResRowId^GroupRowId^ResCode^ResName",count)
	k json        
	Quit resultString
}

ClassMethod insert(Limit, GroupRowId, ResRowId, ReVsGrRowId)
{
	s Limit = $G(Limit)
	s GroupRowId = $G(GroupRowId)
	s ResRowId=$G(ResRowId)
	s ReVsGrRowId = $G(ReVsGrRowId)
	s count=0
	
	i Limit=0 d
	. s count=..deleteAll(GroupRowId)
	
	i ReVsGrRowId ="" d
	.s tempRes=##class(CHSS.CHSSResourceVsGroup).%New()
	
	i GroupRowId '="" d
	.s tempRes.GroupRowId=##class(CHSS.CHSSResourceGroup).%OpenId(GroupRowId)
	
	i ResRowId '="" d
	.s tempRes.ResRowId=##class(CHSS.CHSSResource).%OpenId(ResRowId)
	s result=""
	s result=tempRes.%Save()
	
	s resultString=""
	i result="1" d
	.s resultString="{""success"":""true"",""info"":""1""}"
	e  d
	.s resultString="{""success"":""false"",""info"":""数据保存出错！""}"
	q resultString
}

ClassMethod deleteAll(GroupRowId)
{
	s GroupRowId=$G(GroupRowId)
    /*
    For  Set ReVsGrRowId=$O(^CHSS.CHSSResourceVsGroupI("GroupIndex",GroupRowId,ReVsGrRowId)) q:ReVsGrRowId=""  d
	.w ReVsGrRowId,!
	.;s ReVsGrRowIdId = $p(ReVsGrRowId,"||",2)
	
	.s tempRes=##class(CHSS.CHSSResourceVsGroup).%OpenId(ReVsGrRowId)
	.s ReVsGrRowId=GroupRowId_"||"_ReVsGrRowId
	.w ReVsGrRowId,!
	.s result=tempRes.%DeleteId(ReVsGrRowId)
	.
	.i result="1" d
	..s count=count+1
	
	q count
   */	
	&sql(delete from CHSS.CHSSResourceVsGroup where GroupRowId=:GroupRowId)
	q SQLCODE
}

Storage Default
{
<Data name="CHSSResourceVsGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CHSSResourceVsGroupD</DataLocation>
<DefaultData>CHSSResourceVsGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CHSSResourceVsGroupD</IdLocation>
<IndexLocation>^CHSSWeb.CHSSResourceVsGroupI</IndexLocation>
<StreamLocation>^CHSSWeb.CHSSResourceVsGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
