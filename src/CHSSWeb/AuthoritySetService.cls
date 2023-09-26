Class CHSSWeb.AuthoritySetService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(Start, Limit, GroupRowId)
{
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set end = start+limit
	s GroupRowId=$G(GroupRowId)
	
	s count = 0
	s flag=0
	s SetRowId=""
	s resultString =""
	Set json = ##class(Code.JsonObj).%New()
	
	s Display="",Insert="",Update="",Delete="",Print="",Search=""
	
	s groupVsstr = "select a.GroupRowId,a.ResRowId ,a.ReVsGrRowId,c.ResName,b.SetRowId,b.Display,b.Ins,b.Upd,b.Del,b.Print,b.Search from CHSS.CHSSResourceVsGroup a "
	s groupVsstr =groupVsstr_" left join CHSS.CHSSResource c on a.ResRowId = c.ResRowId "
    s groupVsstr =groupVsstr_" left join CHSS.AuthoritySet b on a.ReVsGrRowId = b.ReVsGrRowId where a.GroupRowId="_GroupRowId
    s groupVsstr =groupVsstr_" order by a.GroupRowId"
	;w groupVsstr,!
	s tempGroupVs = ##class(%Library.ResultSet).%New()
	d tempGroupVs.Prepare(groupVsstr)
	d tempGroupVs.Execute()
	while(tempGroupVs.Next())
	{
		
		s ResourceRowId = tempGroupVs.Data("ResRowId")
		s ReVsGrRowId = tempGroupVs.Data("ReVsGrRowId")
		s ResName = tempGroupVs.Data("ResName")	
		s SetRowId=tempGroupVs.Data("SetRowId")
	    s Display=tempGroupVs.Data("Display")
		s Insert=tempGroupVs.Data("Ins")
		s Update=tempGroupVs.Data("Upd")
		s Delete=tempGroupVs.Data("Del")
		s Print=tempGroupVs.Data("Print")
		s Search=tempGroupVs.Data("Search")
		s tmp=SetRowId_"^"_ReVsGrRowId_"^"_ResName_"^"_Display_"^"_Insert_"^"_Update_"^"_Delete_"^"_Print_"^"_Search
		;w tmp,!
		s count=count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		
	}
	d tempGroupVs.Close()
	s resultString=json.getJsonData("SetRowId^ReVsGrRowId^ResName^Display^Insert^Update^Delete^Print^Search",count)
	k json 
	Quit resultString
}

ClassMethod insert(setRowId, ReVsGrRowId, Display, Insert, Update, Delete, Print, Search)
{
	s count=0
	
	i setRowId'="" d
	.s tempSet=##class(CHSS.AuthoritySet).%OpenId(setRowId)
	e  d
	.s tempSet=##class(CHSS.AuthoritySet).%New()
	
	i ReVsGrRowId'= "" d
	.s tempSet.ReVsGrRowId=##class(CHSS.CHSSResourceVsGroup).%OpenId(ReVsGrRowId)
	
    i Display="false" d
	.s tempSet.Display=""
	e  d
	.s tempSet.Display=Display
	
	i Insert="false" d
	.s tempSet.Ins=""
	e  d
	.s tempSet.Ins=Insert
	i Update="false" d
	.s tempSet.Upd=""
	e  d
	.s tempSet.Upd=Update
	i Delete="false" d
	.s tempSet.Del=""
	e  d
	.s tempSet.Del=Delete
	i Print="false" d
	.s tempSet.Print=""
	e  d
	.s tempSet.Print=Print
	
	i Search="false" d
	.s tempSet.Search=""
	e  d
	.s tempSet.Search=Search
	
	s result=""
	s result=tempSet.%Save()
	
	s resultString=""
	i result="1" d
	.s resultString="{""success"":""true"",""info"":""数据保存成功！""}"
	e  d
	.s resultString="{""success"":""false"",""info"":""数据保存出错！""}"
	q resultString
}

ClassMethod deleteAll()
{
	s count=0

    For  Set SetRowId=$O(^CHSS.AuthoritySetD(SetRowId)) q:SetRowId=""  d
	.s tempRes=##class(CHSS.AuthoritySet).%OpenId(SetRowId)
	.s result=tempRes.%DeleteId(SetRowId)
	.i result="1" d
	..s count=count+1
	
	q count
}

Storage Default
{
<Data name="AuthoritySetServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.AuthoritySetServiceD</DataLocation>
<DefaultData>AuthoritySetServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.AuthoritySetServiceD</IdLocation>
<IndexLocation>^CHSSWeb.AuthoritySetServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.AuthoritySetServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
