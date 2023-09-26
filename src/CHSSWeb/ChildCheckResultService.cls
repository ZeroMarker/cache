Class CHSSWeb.ChildCheckResultService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(ChildCheckRecordRowId, Start, Limit)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM CHSS.ChildCheckResult where CheckRowId = "_ChildCheckRecordRowId
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	 s ResultRowId=result.Data("ResultRowId")
	 s tempChild= ##class(CHSS.ChildCheckResult).%OpenId(ResultRowId)
	 
	 s CheckResult=tempChild.CheckResult
	 
	 s Suggestion=tempChild.Suggestion
	 
	 s tmp=""
	s tmp=ResultRowId_"^"_CheckResult_"^"_Suggestion
	s count=count+1
	i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("ResultRowId^CheckResult^Suggestion",count)
	k json
	Quit resultString
}

ClassMethod insert(ChildCheckRecordRowId, CheckResult, Suggestion)
{
    s tempChild = ""
	s tempChild =##class(CHSS.ChildCheckResult).%New()
	
	i ChildCheckRecordRowId '= "" d
	.s tempChild.CheckRowId = ##class(CHSS.ChildCheckRecord).%OpenId(ChildCheckRecordRowId)
	
	s tempChild.CheckResult=CheckResult
	
	
	s tempChild.Suggestion=Suggestion
	s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempChild.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod edit(RowId, CheckResult, Suggestion)
{
    s tempChild = ""
	s tempChild =##class(CHSS.ChildCheckResult).%OpenId(RowId)
	
	
	s tempChild.CheckResult=CheckResult
	s tempChild.Suggestion=Suggestion
	s result=""
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
<Data name="ChildCheckResultServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChildCheckRe912D</DataLocation>
<DefaultData>ChildCheckResultServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChildCheckRe912D</IdLocation>
<IndexLocation>^CHSSWeb.ChildCheckRe912I</IndexLocation>
<StreamLocation>^CHSSWeb.ChildCheckRe912S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
