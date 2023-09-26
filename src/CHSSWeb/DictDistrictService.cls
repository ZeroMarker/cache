Class CHSSWeb.DictDistrictService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod ListPage(Start, Limit, TableName, RowIdParref) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowId,Code,Description FROM CHSS."_TableName_" where RowIdParref = "_RowIdParref
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s Rowid = result.Data("RowId")
	s Code = result.Data("Code")
	s Description = result.Data("Description")
	
	s tmp=Rowid_"^"_Code_"^"_Description
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Description",count)
	k json
	q resultString
}

Storage Default
{
<Data name="DictDistrictServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DictDistrictServiceD</DataLocation>
<DefaultData>DictDistrictServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.DictDistrictServiceD</IdLocation>
<IndexLocation>^CHSSWeb.DictDistrictServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.DictDistrictServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
