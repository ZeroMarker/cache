Class CHSSWeb.CTSexService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(Start, Limit) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTSEX_RowId,CTSEX_Code,CTSEX_Desc FROM SQLUser.CT_Sex"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s CTSEXRowId = result.Data("CTSEX_RowId")
	s CTSEXCode = result.Data("CTSEX_Code")
	s CTSEXDesc = result.Data("CTSEX_Desc")
	
	s tmp=CTSEXRowId_"^"_CTSEXCode_"^"_CTSEXDesc
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("CTSEXRowId^CTSEXCode^CTSEXDesc",count)
	k json
	q resultString
}

Storage Default
{
<Data name="CTSexServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CTSexServiceD</DataLocation>
<DefaultData>CTSexServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CTSexServiceD</IdLocation>
<IndexLocation>^CHSSWeb.CTSexServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.CTSexServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
