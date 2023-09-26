Class CHSSWeb.BussCustodyConfigNewService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod list(start, limit)
{
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.DictWorkIndexVsItem "
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	 s IndexVsItemRowId=result.Data("IndexVsItemRowId")
	 s tempChild= ##class(CHSS.DictWorkIndexVsItem).%OpenId(IndexVsItemRowId)
	 
	s ItemRowId=""
	s ItemValue=""
	i tempChild.ItemRowId'="" d
	.s ItemValue=tempChild.ItemRowId.Description
	.s ItemRowId=tempChild.ItemRowId.%Id()
	
	s IndexRowId=""
	s IndexValue=""
	i tempChild.IndexRowId'="" d
	.s IndexRowId=tempChild.IndexRowId.%Id()
	.s IndexValue=tempChild.IndexRowId.IndexContent
	
	
	s Value=tempChild.WorkValue
	s Year=tempChild.Year
	s tmp=""
	s tmp=IndexVsItemRowId_"^"_ItemRowId_"^"_ItemValue_"^"_IndexRowId_"^"_IndexValue_"^"_Value_"^"_Year
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
    d result.Close()	
	s resultString = json.getJsonData("IndexVsItemRowId^ItemRowId^ItemValue^IndexRowId^IndexValue^Value^Year",count)
	k json
	
    Quit resultString
}

ClassMethod listconfig(start, limit, year)
{
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.DictWorkIndexVsItem where year="_year
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	 s IndexVsItemRowId=result.Data("IndexVsItemRowId")
	 s tempChild= ##class(CHSS.DictWorkIndexVsItem).%OpenId(IndexVsItemRowId)
	 
	s ItemRowId=""
	s ItemValue=""
	i tempChild.ItemRowId'="" d
	.s ItemValue=tempChild.ItemRowId.Description
	.s ItemRowId=tempChild.ItemRowId.%Id()
	
	s IndexRowId=""
	s IndexValue=""
	i tempChild.IndexRowId'="" d
	.s IndexRowId=tempChild.IndexRowId.%Id()
	.s IndexValue=tempChild.IndexRowId.IndexContent
	
	
	s Value=tempChild.WorkValue
	s Year=tempChild.Year
	s tmp=""
	s tmp=IndexVsItemRowId_"^"_ItemRowId_"^"_ItemValue_"^"_IndexRowId_"^"_IndexValue_"^"_Value_"^"_Year
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
    d result.Close()	
	s resultString = json.getJsonData("IndexVsItemRowId^ItemRowId^ItemValue^IndexRowId^IndexValue^Value^Year",count)
	k json
	
    Quit resultString
}

ClassMethod insertOrEdit(IndexVsItemRowId, ItemRowId, IndexRowId, Value, Year)
{
	s tempChild=""
	i IndexVsItemRowId'="" d
	.s tempChild=##class(CHSS.DictWorkIndexVsItem).%OpenId(IndexVsItemRowId)
	e  d
	.s tempChild =##class(CHSS.DictWorkIndexVsItem).%New()


	
	i IndexRowId'="" d
	.s IndexRowIdobj=##class(CHSS.DictBussCustodyIndex).%OpenId(IndexRowId)
    .s tempChild.IndexRowId=IndexRowIdobj
	 
	  i ItemRowId '= "" d
    .s ItemRowIdobj=##class(CHSS.DictBussCustodyConfigItem).%OpenId(ItemRowId)
    .s tempChild.ItemRowId=ItemRowIdobj
	
	
	s tempChild.WorkValue=Value
	s tempChild.Year=Year
	
	
	s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempChild.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

Storage Default
{
<Data name="BussCustodyConfigNewServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.BussCustodyCAD9D</DataLocation>
<DefaultData>BussCustodyConfigNewServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.BussCustodyCAD9D</IdLocation>
<IndexLocation>^CHSSWeb.BussCustodyCAD9I</IndexLocation>
<StreamLocation>^CHSSWeb.BussCustodyCAD9S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
