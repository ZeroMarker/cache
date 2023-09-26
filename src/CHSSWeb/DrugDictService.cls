Class CHSSWeb.DrugDictService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod ListPage(Start, Limit, TableName, DrugType As %Integer) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowID,Code,Description,StartDate,EndDate,Active,Sort FROM CHSS."_TableName_" "
	i (DrugType'="") d
	.s sqlStr = sqlStr_" where Type ="_DrugType
	
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
	s StartDate = result.Data("StartDate")
	i (StartDate'="") d
	.s StartDate = $zd(StartDate,3)
	s EndDate = result.Data("EndDate")
	i (EndDate'="") d
	.s EndDate = $zd(EndDate,3)
	s Active = result.Data("Active")
	s Sort = result.Data("Sort")
	s tmp=Rowid_"^"_Code_"^"_Description_"^"_StartDate_"^"_EndDate_"^"_Active_"^"_Sort
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Description^StartDate^EndDate^Active^Sort",count)
	k json
	q resultString
}

/// Creator:jinming
/// CreatDate:2011-6-30
/// Description:下拉列表支持搜索功能
ClassMethod ListSearchPage(Start, Limit, TableName, DrugType As %Integer, SearchStr As %String) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowID,Code,Description,StartDate,EndDate,Active,Sort FROM CHSS."_TableName_" "
	i (DrugType'="") d
	.s sqlStr = sqlStr_" where Type ="_DrugType_" and Description like '%"_SearchStr_"%'"

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
	s StartDate = result.Data("StartDate")
	i (StartDate'="") d
	.s StartDate = $zd(StartDate,3)
	s EndDate = result.Data("EndDate")
	i (EndDate'="") d
	.s EndDate = $zd(EndDate,3)
	s Active = result.Data("Active")
	s Sort = result.Data("Sort")
	s tmp=Rowid_"^"_Code_"^"_Description_"^"_StartDate_"^"_EndDate_"^"_Active_"^"_Sort
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Description^StartDate^EndDate^Active^Sort",count)
	k json
	q resultString
}

Storage Default
{
<Data name="DrugDictServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DrugDictServiceD</DataLocation>
<DefaultData>DrugDictServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.DrugDictServiceD</IdLocation>
<IndexLocation>^CHSSWeb.DrugDictServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.DrugDictServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
