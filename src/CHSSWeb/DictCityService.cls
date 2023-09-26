Class CHSSWeb.DictCityService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//列出所有记录

ClassMethod ListPage(Start, Limit) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowId,Code,Description,StartDate,EndDate,Active,Sort,Sepllcode,RowIdParref,UpCode FROM CHSS.DictCity"
	
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
	s SepllCode=result.Data("SepllCode")
	s RowIdParref=result.Data("RowIdParref")
	s UpCode = result.Data("UpCode")
	s ProvinceName = ""
	i RowIdParref '= "" d
	.s tempProvince=##class(CHSS.DictProvince).%OpenId(RowIdParref)
	.s ProvinceName = tempProvince.Description
	.;w tempProvince.Description,!
	
	s tmp=Rowid_"^"_Code_"^"_Description_"^"_StartDate_"^"_EndDate_"^"_Active_"^"_Sort_"^"_SepllCode_"^"_RowIdParref_"^"_UpCode
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Description^StartDate^EndDate^Active^Sort^SepllCode^RowIdParref^UpCode",count)
	k json
	q resultString
}

//添加记录

ClassMethod insert(Code, Description, StartDate, EndDate, Active, Sort, SepllCode, RowIdParref, UpCode) As %String
{
	
	i StartDate '= "" d
	.s start=$zdh(StartDate,3)
	i EndDate '= "" d
	.s end=$zdh(EndDate,3)
	s returncode = ..existCode(Code)
	i returncode '= "0" d
	.w "{""success"":""false"",""info"":""所属市编码: "_Code_"已存在！请重输入！""}" 
	e  d
	. &sql(insert into CHSS.DictCity (Code,Description,StartDate,EndDate,Active,Sort,SepllCode,RowIdParref,UpCode) values(:Code,:Description,:start,:end,:Active,:Sort,:SepllCode,:RowIdParref,:UpCode))
	.i SQLCODE ="0" d
	..w "{""success"":""true"",""info"":""添加成功！""}"
	.e  d
	..w "{""success"":""false"",""info"":""添加出错"_SQLCODE_"}"
	q ""
}

ClassMethod update(RowId, Code, Description, StartDate, EndDate, Active, Sort, SepllCode, RowIdParref, UpCode) As %String
{
	
	q:(RowId="") "code-rep"
	i StartDate '= "" d
	.s start=$zdh(StartDate,3)
	i EndDate '= "" d
	.s end=$zdh(EndDate,3)
	&sql(update CHSS.DictCity set Code=:Code,Description=:Description,StartDate=:start,EndDate=:end,Active=:Active,Sort=:Sort,Sepllcode=:SepllCode,RowIdParref=:RowIdParref,UpCode=:UpCode where %ID=:RowId)
	q SQLCODE
}

//删除一条数据库中已经存在的记录

ClassMethod delete(RowId) As %String
{
	
	 s mess=""
	s count=0
	&sql(select count(*) into:count from chss.dictsection where RowIdParref=:RowId)
	
	i count=0 d
	.&sql(delete from CHSS.DictCity where %ID=:RowId)
	.s mess="{success:'true',info:'删除成功'}"
	e  d
	.s mess="{success:'false',info:'外键关联无法删除'}"
	w mess
}

ClassMethod existCode(Code) As %String
{
    q:Code="" "-1"
	s Code=""_Code
	q:$d(^CHSS.DictCityI("CodeIndex",Code)) "1"
    q "0"
}

//列出所有的市

ClassMethod ListCity(Start, Limit) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr= " SELECT RowId,Description,RowIdParref FROM CHSS.DictCity " 
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	s ProvinceName= ""
	
	While(result.Next())
	{
	s RowId = result.Data("RowId")
	s Description = result.Data("Description")
	s RowIdParref = result.Data("RowIdParref")

	i RowIdParref '= "" d
	.s tempProvince = ##class(CHSS.DictProvince).%OpenId(RowIdParref)
	.s ProvinceName = tempProvince.Description
	.
	.s text = ProvinceName_Description
	s leaf = "true"
	
	s tmp=RowId_"^"_text_"^"_leaf
	
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getTreeJsonData("id^text^leaf",count)
	k json
	q resultString
}

Storage Default
{
<Data name="DictCityServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DictCityServiceD</DataLocation>
<DefaultData>DictCityServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.DictCityServiceD</IdLocation>
<IndexLocation>^CHSSWeb.DictCityServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.DictCityServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
