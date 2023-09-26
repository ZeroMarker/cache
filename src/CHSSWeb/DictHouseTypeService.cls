Class CHSSWeb.DictHouseTypeService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//列出所有记录

ClassMethod List(Start, Limit, Sort, Dir, Code, Description) As %String
{
	Set TopNum= Start+Limit
	Set result = ##class(%Library.ResultSet).%New()
	Set prepareString = "SELECT RowID,Code,Description,StartDate,EndDate,Active,Type FROM sqlUser.CHSSDictKin WHERE RowID >= 1"
	i (Sort'="")&(Dir="DESC") Set prepareString = prepareString_"ORDER BY Sort DESC"
	e  i (Sort'="")&(Dir="ASC") Set prepareString = prepareString_"ORDER BY Sort ASC"
	Do result.Prepare(prepareString)
	Do result.Execute()
	
	s mess=""
	s count=0
	While (result.Next()){
	continue:(result.Get("Code")'[Code)
	continue:(result.Get("Description")'[Description)
	s count=count+1
	continue:(count<=Start)!(count>TopNum)
	;w "Start=",Start," TopNum=",TopNum
	i (mess'="") s mess=mess_","
	s mess=mess_"{""RowID"":"""_result.Get("RowID")_""",""Code"":"""_result.Get("Code")_""",""Description"":"""_result.Get("Description")_"""}"}
	s mess="{""TotalRowNum"":"""_count_""",""Hospital"":["_mess_"]}"
	Write mess
}

ClassMethod ListPage(Start, Limit) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowID,Code,Description,StartDate,EndDate,Active,Sort,Type FROM CHSS.DictHouseTypeBefore"
	
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
	s Type = result.Data("Type")
	s tmp=Rowid_"^"_Code_"^"_Description_"^"_StartDate_"^"_EndDate_"^"_Active_"^"_Sort_"^"_Type
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Description^StartDate^EndDate^Active^Sort^Type",count)
	k json
	q resultString
}

//添加记录

ClassMethod Add(Code, Description) As %String
{
	;s ReturnCode=..existHospCode(HospCode)
	;s ReturnName=..existHospName(HospName)
	s ReturnCode= "0"
	s ReturnName= "0"
	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""住房类型代码: "_HospCode_" 已存在! 请重新输入!""}"
	e  i (ReturnName'="0") d
	.w "{""success"":""false"",""info"":""住房类型名称: "_HospName_" 已存在! 请重新输入!""}"
	e  d
	.e  w 1
	.&sql(insert into CHSS.DictHouseTypeBefore (Code,Description) values(:Code,:Description))
	.i SQLCODE'=0 w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
	.e  w "{""success"":""true"",""info"":""添加成功!""}"
}

ClassMethod insert(Code, Description, StartDate, EndDate, Active, Sort, Type) As %String
{
	s rowId=""
	q:rowId'="" "code-rep"
	i StartDate '= "" d
	.s start=$zdh(StartDate,3)
	i EndDate '= "" d
	.s end=$zdh(EndDate,3)
	&sql(insert into CHSS.DictHouseTypeBefore (Code,Description,StartDate,EndDate,Active,Sort,Type) values(:Code,:Description,:start,:end,:Active,:Sort,:Type))
	q SQLCODE
}

ClassMethod update(RowId, Code, Description, StartDate, EndDate, Active, Sort, Type) As %String
{
	q:(RowId="") "code-rep"
	i StartDate '= "" d
	.s start=$zdh(StartDate,3)
	i EndDate '= "" d
	.s end=$zdh(EndDate,3)
	&sql(update CHSS.DictHouseTypeBefore set Code=:Code,Description=:Description,StartDate=:start,EndDate=:end,Active=:Active,Sort=:Sort,Type=:Type where %ID=:RowId)
	q SQLCODE
}

//删除一条数据库中已经存在的记录

ClassMethod delete(RowId) As %String
{
	&sql(delete from CHSS.DictHouseTypeBefore where %ID=:RowId)
	q SQLCODE
}

Storage Default
{
<Data name="DictHouseTypeServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DictHouseTypeServiceD</DataLocation>
<DefaultData>DictHouseTypeServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.DictHouseTypeServiceD</IdLocation>
<IndexLocation>^CHSSWeb.DictHouseTypeServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.DictHouseTypeServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
