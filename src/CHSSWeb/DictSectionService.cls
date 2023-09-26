Class CHSSWeb.DictSectionService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//列出所有记录

ClassMethod ListPage(Start, Limit, RowIdParref) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowID,Code,Description,StartDate,EndDate,Active,Sort,Sepllcode,RowIdParref,UpCode FROM CHSS.DictSection where RowIdParref="_RowIdParref
	
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
	
	
	s RowIdParrefName=""
	i RowIdParref'="" d
	.s tempCity=##class(CHSS.DictCity).%OpenId(RowIdParref)
	.s RowIdParrefName=tempCity.Description
	.s CityId=tempCity.%Id()
	.
	.s ProvinceId=tempCity.RowIdParref.%Id()
	.s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
	.s ProvinceName=tempProvince.Description
	.
	.s UpCode=ProvinceName_RowIdParrefName
	.
	s tmp=Rowid_"^"_Code_"^"_Description_"^"_StartDate_"^"_EndDate_"^"_Active_"^"_Sort_"^"_SepllCode_"^"_RowIdParref_"^"_RowIdParrefName_"^"_UpCode
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Description^StartDate^EndDate^Active^Sort^SepllCode^RowIdParref^RowIdParrefName^UpCode",count)
	k json
	q resultString
}

//添加记录

ClassMethod insert(Code, Description, StartDate, EndDate, Active, Sort, SepllCode, RowIdParref) As %String
{
	
	s rowId=""
	//s rowId=..rCode(code)
	q:rowId'="" "code-rep"
	
	i StartDate '= "" d
	.s start=$zdh(StartDate,3)
	i EndDate '= "" d
	.s end=$zdh(EndDate,3)
	
	s returncode =..existCode(Code)
	i returncode '="0" d
	.w "{""success"":""false"",""info"":""地区编码: "_Code_"已存在！请重输入！""}"  
	e  d 
	.&sql(insert into CHSS.DictSection (Code,Description,StartDate,EndDate,Active,Sort,SepllCode,RowIdParref) values(:Code,:Description,:start,:end,:Active,:Sort,:SepllCode,:RowIdParref))
	.i SQLCODE="0" d
	..w "{""success"":""true"",""info"":"_%ROWID_"}"
	.e  d
	..w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
	q ""
}

ClassMethod update(RowId, Code, Description, StartDate, EndDate, Active, Sort, SepllCode, RowIdParref) As %String
{
	
	q:(RowId="") "code-rep"
	i StartDate '= "" d
	.s start=$zdh(StartDate,3)
	i EndDate '= "" d
	.s end=$zdh(EndDate,3)
	&sql(update CHSS.DictSection set Code=:Code,Description=:Description,StartDate=:start,EndDate=:end,Active=:Active,Sort=:Sort,Sepllcode=:SepllCode,RowIdParref=:RowIdParref where %ID=:RowId)
	q SQLCODE
}

//删除一条数据库中已经存在的记录

ClassMethod delete(RowId) As %String
{
	 s mess=""
	s count=0
	&sql(select count(*) into:count from chss.dictstreet where RowIdParref=:RowId)
	
	i count=0 d
	.&sql(delete from CHSS.DictSection where %ID=:RowId)
	.s mess="{success:'true',info:'删除成功'}"
	e  d
	.s mess="{success:'false',info:'外键关联无法删除'}"
	w mess
}

ClassMethod existCode(Code) As %String
{
	q "0"
	q:Code="" "-1"
	s Code=""_Code
	q:$d(^CHSS.DictSectionI("CodeIndex",Code)) "1"
    q "0"
}

//列出所有的地区

ClassMethod ListSection(Start, Limit) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr= " SELECT RowID,Description,RowIdParref FROM CHSS.DictSection " 
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s text=""
	s CityName=""
	s ProvinceName=""
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s id = result.Data("RowId")
	s Description = result.Data("Description")
	s RowIdParref = result.Data("RowIdParref")
	
	i RowIdParref '="" d
	.s tempCity = ##class(CHSS.DictCity).%OpenId(RowIdParref)
	.s CityName = tempCity.Description
	.s ProvinceId = tempCity.RowIdParref.%Id()
	.
	.i ProvinceId '= "" d
	..s tempProvince = ##class(CHSS.DictProvince).%OpenId(ProvinceId)
	..
	..s ProvinceName = tempProvince.Description
	..s text =ProvinceName_CityName_Description 
	
	s leaf = "true"
	
	s tmp=id_"^"_text_"^"_leaf
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
<Data name="DictSectionServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DictSectionServiceD</DataLocation>
<DefaultData>DictSectionServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.DictSectionServiceD</IdLocation>
<IndexLocation>^CHSSWeb.DictSectionServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.DictSectionServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
