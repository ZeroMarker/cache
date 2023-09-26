Class CHSSWeb.DictDentitionService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(Start, Limit, Sort, Dir, Code, Description) As %String
{
	Set TopNum= Start+Limit
	Set result = ##class(%Library.ResultSet).%New()
	Set prepareString = "SELECT RowID,Code,Description,StartDate,EndDate,Active FROM CHSS.DictDentition WHERE RowID >= 1"
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
	s sqlStr = "SELECT RowID,Code,Description,StartDate,EndDate,Active,Sort FROM CHSS.DictDentition"
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

//添加记录

ClassMethod Add(Code, Description) As %String
{
	;s ReturnCode=..existHospCode(HospCode)
	;s ReturnName=..existHospName(HospName)
	s ReturnCode= "0"
	s ReturnName= "0"
	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""医院代码: "_HospCode_" 已存在! 请重新输入!""}"
	e  i (ReturnName'="0") d
	.w "{""success"":""false"",""info"":""医院名称: "_HospName_" 已存在! 请重新输入!""}"
	e  d
	.e  w 1
	.&sql(insert into CHSS.DictDentition (Code,Description) values(:Code,:Description))
	.i SQLCODE'=0 w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
	.e  w "{""success"":""true"",""info"":""添加成功!""}"
}

ClassMethod insert(Code, Description, StartDate, EndDate, Active, Sort) As %String
{
	//调用方法：d ##class(CBCS.CBCS.UDHCCAHospital).insert("001","医院","Y")
	
	//code重复不允许插入
	//name重复不允许插入
	
	s rowId=""
	//s rowId=..rCode(code)
	q:rowId'="" "code-rep"
	//s rowId=..rName(Description)
	//q:rowId'="" "name-rep"
	
	//i (active'="Y")||(active'="N") s active="Y"
	i StartDate '= "" d
	.s start=$zdh(StartDate,3)
	i EndDate '= "" d
	.s end=$zdh(EndDate,3)
	&sql(insert into CHSS.DictDentition (Code,Description,StartDate,EndDate,Active,Sort) values(:Code,:Description,:start,:end,:Active,:Sort))
	q SQLCODE
}

ClassMethod update(RowId, Code, Description, StartDate, EndDate, Active, Sort) As %String
{
	//调用方法：d ##class(CBCS.UDHCCAHospital).update(1,"001","医院","Y")
	
	//code重复不允许修改
	//name重复不允许修改
	/*
	s rowId=""
	s rowId=..rCode(code)
	q:(rowId'="")&(rowId'=dr) "code-rep" //rowId不为空且rowId'=dr不可以修改
	s rowId=..rName(name)
	q:(rowId'="")&(rowId'=dr) "name-rep"
	*/
	q:(RowId="") "code-rep"
	i StartDate '= "" d
	.s start=$zdh(StartDate,3)
	i EndDate '= "" d
	.s end=$zdh(EndDate,3)
	&sql(update CHSS.DictDentition set Code=:Code,Description=:Description,StartDate=:start,EndDate=:end,Active=:Active,Sort=:Sort where %ID=:RowId)
	q SQLCODE
}

//删除一条数据库中已经存在的记录

ClassMethod delete(RowId) As %String
{
	&sql(delete from CHSS.DictDentition where %ID=:RowId)
	q SQLCODE
}

Storage Default
{
<Data name="DictDentitionServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DictDentitionServiceD</DataLocation>
<DefaultData>DictDentitionServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.DictDentitionServiceD</IdLocation>
<IndexLocation>^CHSSWeb.DictDentitionServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.DictDentitionServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
