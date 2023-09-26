Class CHSSWeb.DictVillageService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//删除一条数据库中已经存在的记录

ClassMethod ListPage(Start, Limit, RowIdParrefRowId) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowID,Code,Description,StartDate,EndDate,Active,Sort,Sepllcode,RowIdParref,UpCode FROM CHSS.DictVillage where RowIdParref="_RowIdParrefRowId
	
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
	s SectionName=""
	s CityName=""
	s ProvinceName=""
	
	i RowIdParref'="" d
	.s tempStreet=##class(CHSS.DictStreet).%OpenId(RowIdParref)
	.s RowIdParrefName=tempStreet.Description
	.
	.i tempStreet.RowIdParref '="" d
	..s SectionId=tempStreet.RowIdParref.%Id()
	..s tempSection=##class(CHSS.DictSection).%OpenId(SectionId)
	..s SectionName=tempSection.Description
	..
	..i tempSection.RowIdParref '="" d
	...s CityId=tempSection.RowIdParref.%Id()
	...s tempCity=##class(CHSS.DictCity).%OpenId(CityId)
	...s CityName=tempCity.Description
	...
	...i tempCity.RowIdParref'="" d
	....s ProvinceId=tempCity.RowIdParref.%Id()
	....s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
	....s ProvinceName=tempProvince.Description
	....
	....s UpCode=ProvinceName_CityName_"市"_SectionName_RowIdParrefName
	
	
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

ClassMethod insert(Code, Description, StartDate, EndDate, Active, Sort, SepllCode, RowIdParref) As %String
{
	i StartDate '= "" d
	.s start=$zdh(StartDate,3)
	i EndDate '= "" d
	.s end=$zdh(EndDate,3)
	s returncode =..existCode(Code)
	i returncode '=0 d
	.w "{""success"":""false"",""info"":""所属村编码: "_Code_"已存在！请重输入！""}"
	e  d
	.&sql(insert into CHSS.DictVillage (Code,Description,StartDate,EndDate,Active,Sort,SepllCode,RowIdParref) values(:Code,:Description,:start,:end,:Active,:Sort,:SepllCode,:RowIdParref))
	.i SQLCODE = 0 d
	..w "{""success"":""true"",""info"":"_%ROWID_"}"
	.e  d
	..w "{""success"":""false"",""info"":""添加出错!"_SQLCODE_"}"
	q ""
}

ClassMethod update(RowId, Code, Description, StartDate, EndDate, Active, Sort, SepllCode, RowIdParref) As %String
{
	q:(RowId="") "code-rep"
	i StartDate '= "" d
	.s start=$zdh(StartDate,3)
	i EndDate '= "" d
	.s end=$zdh(EndDate,3)
	&sql(update CHSS.DictVillage set Code=:Code,Description=:Description,StartDate=:start,EndDate=:end,Active=:Active,Sort=:Sort,Sepllcode=:SepllCode,RowIdParref=:RowIdParref where %ID=:RowId)
	q SQLCODE
}

ClassMethod delete(RowId) As %String
{
	&sql(delete FROM CHSS.DictVillage where %ID=:RowId)
	q SQLCODE
}

ClassMethod existCode(Code) As %String
{
   q "0"
   q:Code="" "-1"
   s Code=""_Code
   q:$d(^CHSS.DictVillageI("CodeIndex",Code)) "1"
   q "0"
}

Storage Default
{
<Data name="DictVillageServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DictVillageServiceD</DataLocation>
<DefaultData>DictVillageServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.DictVillageServiceD</IdLocation>
<IndexLocation>^CHSSWeb.DictVillageServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.DictVillageServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
