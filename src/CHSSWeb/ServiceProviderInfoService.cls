Class CHSSWeb.ServiceProviderInfoService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//列出所有记录

ClassMethod List(Start, Limit, Sort, Dir, Code, Description) As %String
{
	Set TopNum= Start+Limit
	Set result = ##class(%Library.ResultSet).%New()
	Set prepareString = "SELECT RowID,Code,Description,StartDate,EndDate,Active FROM sqlUser.CHSSHighWayType WHERE RowID >= 1"
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
	s sqlStr = "SELECT InfoRowId,机构代码,机构名称,医生姓名,医生类别,医生年龄,医生职称,医生职务,医生性别 FROM CHSS.ServiceProviderInfo"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s InfoRowId = result.Data("InfoRowId")
	s 机构代码 = result.Data("机构代码")
	s 机构名称 = result.Data("机构名称")
	s 医生姓名 = result.Data("医生姓名")
	s 医生类别 = result.Data("医生类别")
	s 医生年龄 = result.Data("医生年龄")
	s 医生职称 = result.Data("医生职称")
	s 医生职务 = result.Data("医生职务")
	s 医生性别 = result.Data("医生性别")
	s tmp=InfoRowId_"^"_机构代码_"^"_机构名称_"^"_医生姓名_"^"_医生类别_"^"_医生年龄_"^"_医生职称_"^"_医生职务_"^"_医生性别
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("InfoRowId^机构代码^机构名称^医生姓名^医生类别^医生年龄^医生职称^医生职务^医生性别",count)
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
	.w "{""success"":""false"",""info"":""高速公路代码: "_HospCode_" 已存在! 请重新输入!""}"
	e  i (ReturnName'="0") d
	.w "{""success"":""false"",""info"":""高速公路名称: "_HospName_" 已存在! 请重新输入!""}"
	e  d
	.e  w 1
	.&sql(insert into CHSS.HighWayType (Code,Description) values(:Code,:Description))
	.i SQLCODE'=0 w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
	.e  w "{""success"":""true"",""info"":""添加成功!""}"
}

ClassMethod insert(机构代码, 机构名称, 医生姓名, 医生类别, 医生年龄, 医生职称, 医生职务, 医生性别) As %String
{
	
	s InfoRowId=""
	q:InfoRowId'="" "code-rep"
	&sql(insert into CHSS.ServiceProviderInfo (机构代码, 机构名称, 医生姓名, 医生类别, 医生年龄, 医生职称,医生职务,医生性别) values(:机构代码, :机构名称, :医生姓名, :医生类别, :医生年龄, :医生职称,:医生职务,:医生性别))
	q SQLCODE
}

ClassMethod update(InfoRowId, 机构代码, 机构名称, 医生姓名, 医生类别, 医生年龄, 医生职称, 医生职务, 医生性别) As %String
{
	
	q:(InfoRowId="") "code-rep"
	&sql(update CHSS.ServiceProviderInfo set 机构代码=:机构代码, 机构名称=:机构名称, 医生姓名=:医生姓名, 医生类别=:医生类别, 医生年龄=:医生年龄, 医生职称=:医生职称,医生职务=:医生职务,医生性别=:医生性别 where %ID=:InfoRowId)
	q SQLCODE
}

//删除一条数据库中已经存在的记录

ClassMethod delete(InfoRowId) As %String
{
	&sql(delete from CHSS.ServiceProviderInfo where %ID=:InfoRowId)
	q SQLCODE
}

Storage Default
{
<Data name="ServiceProviderInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ServiceProviA79D</DataLocation>
<DefaultData>ServiceProviderInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ServiceProviA79D</IdLocation>
<IndexLocation>^CHSSWeb.ServiceProviA79I</IndexLocation>
<StreamLocation>^CHSSWeb.ServiceProviA79S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
