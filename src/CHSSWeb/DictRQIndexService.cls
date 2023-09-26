Class CHSSWeb.DictRQIndexService Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod List(Start, Limit)
{
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set json = ##class(Code.JsonObj).%New()
	S id = 0
	 For  Set id=$O(^CHSS.DictRecordQualiIndexD(id)) q:id=""  d
	 .s DictRecord=##class(CHSS.DictRecordQualiIndex).%OpenId(id)
	 .s RowId =DictRecord.%Id()
	 .s TableName = DictRecord.TableName
	 .s ColumnName = DictRecord.ColumnName
	 .s ColumnCode = DictRecord.ColumnCode
	 .s bValid = DictRecord.bValid
	 .s IndexContent=DictRecord.IndexContent
	 .s IndexType = DictRecord.IndexType
	 .s Remark  = DictRecord.Remark
	 
	 .s tmp=RowId_"^"_TableName_"^"_ColumnName_"^"_ColumnCode_"^"_bValid_"^"_IndexContent_"^"_IndexType_"^"_Remark
	 .s count=count+1
	 .i (count>start)&(count<=end) d
     ..d json.InsertRowData(tmp)
     s resultString = json.getJsonData("RowId^TableName^ColumnName^ColumnCode^bValid^IndexContent^IndexType^Remark",count)
     k json	
	 Quit resultString
}

ClassMethod insertupdata(RowId, TableName, ColumnName, ColumnCode, bValid, IndexContent, IndexType, Remark)
{
	s tempMode=""
	
	i RowId '="" d
	.s tempMode=##class(CHSS.DictRecordQualiIndex).%OpenId(RowId)
	e  d
	.s tempMode=##class(CHSS.DictRecordQualiIndex).%New()
	
	s tempMode.TableName=TableName
	s tempMode.ColumnName=ColumnName
	s tempMode.ColumnCode=ColumnCode
	s tempMode.bValid=bValid
	s tempMode.IndexContent=IndexContent
	s tempMode.IndexType=IndexType
	s tempMode.Remark=Remark

	
	s result=""
    s result=tempMode.%Save()
  
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempMode.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod Delete(RowId)
{
	s tempMode=""
	s result=""
	s resultString=""
	i RowId '="" d
	.s tempMode=##class(CHSS.DictRecordQualiIndex).%OpenId(RowId)
	.s result=tempMode.%DeleteId(RowId)
	i result="1" d
	. s resultString="{""success"":""true"",""info"":""数据删除成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
    q resultString
}

Storage Default
{
<Data name="DictRQIndexServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DictRQIndexServiceD</DataLocation>
<DefaultData>DictRQIndexServiceDefaultData</DefaultData>
<IdLocation>^CHSSWeb.DictRQIndexServiceD</IdLocation>
<IndexLocation>^CHSSWeb.DictRQIndexServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.DictRQIndexServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
