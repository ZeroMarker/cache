Class CHSSWeb.WomenDangerRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod listDetail(Start, Limit, DangerItemID, ItemType)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.DictDangerItemVsDetail where RowIdMain="_DangerItemID_" and ItemType='"_ItemType_"'"

    d result.Prepare(sqlStr)
	d result.Execute()   
	
    s count = 0
	s resultString = ""
	s end = Start+Limit 
    s json = ##class(Code.JsonObj).%New()
    
    While(result.Next())
    {
	  s ItemVsDetailRowId = result.Data("ItemVsDetailRowId")
	  s temp=##class(CHSS.DictDangerItemVsDetail).%OpenId(ItemVsDetailRowId)
	  i temp.RowIdDetail '="" d
	  .s ItemVsDetailRowId=temp.RowIdDetail.%Id()
	  .s RowIdDetailName=temp.RowIdDetail.Description
	  
	  s tmp=ItemVsDetailRowId_"^"_RowIdDetailName
	  s count = count+1
	  i (count>Start)&(count<=end) d
	  .d json.InsertRowData(tmp)
	  
	}
	d result.Close()
	s resultString = json.getJsonData("ItemVsDetailRowId^RowIdDetailName",count)
    k json
	q resultString
}

Storage Default
{
<Data name="WomenDangerRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.WomenDangerR987D</DataLocation>
<DefaultData>WomenDangerRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.WomenDangerR987D</IdLocation>
<IndexLocation>^CHSSWeb.WomenDangerR987I</IndexLocation>
<StreamLocation>^CHSSWeb.WomenDangerR987S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
