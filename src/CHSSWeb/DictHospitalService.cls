Class CHSSWeb.DictHospitalService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//列出所有记录

ClassMethod List(Start, Limit, Sort, Dir, Code, Description) As %String
{
	Set TopNum= Start+Limit
	Set result = ##class(%Library.ResultSet).%New()
	Set prepareString = "SELECT RowID,Code,Description,StartDate,EndDate,Active,SepllCode,RowIdParref FROM sqlUser.CHSSDictCity WHERE RowID >= 1"
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
	s sqlStr = "SELECT RowId,CommunityCode,CommunityName,SpellCode,UpCommunityCode,CommunityCodePrex,CommunityType,HospitalDR,RecordDR FROM CHSS.DictHospital"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s Rowid = result.Data("RowId")
	s CommunityCode = result.Data("CommunityCode")
	s CommunityName = result.Data("CommunityName")
	s SepllCode = result.Data("SpellCode")
	s UpCommunityCode = result.Data("UpCommunityCode")
	s CommunityCodePrex = result.Data("CommunityCodePrex")
	s CommunityType = result.Data("CommunityType")
	s HospitalDR = result.Data("HospitalDR")
	s RecordDR = result.Data("RecordDR")
    s HospitalName = ""
    s ProvinceName = ""
    s CityName = ""
    s SectionName = ""
    s StreetName = ""
    s HospitalName = ""
    s UpCommunityName = ""
    i CommunityType = "省卫生厅" d
	.s tempHospital = ##class(CHSS.DictProvince).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s HospitalName = tempHospital.Description
	..
    i CommunityType = "市卫生局" d
	.s tempHospital = ##class(CHSS.DictCity).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s HospitalName = tempHospital.Description
	..s ProvinceId=tempHospital.RowIdParref.%Id()
	..s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
	..s ProvinceName=tempProvince.Description
	.s HospitalName=ProvinceName_HospitalName
	e  i (CommunityType = "县（区）卫生局") d
	.s tempHospital = ##class(CHSS.DictSection).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s HospitalName = tempHospital.Description
	..s tempSection=tempHospital.RowIdParref
	..i tempSection'="" d
	...s CityName=tempSection.Description
	...i tempSection.RowIdParref'="" d
	....s ProvinceName=tempSection.RowIdParref.Description
	.s HospitalName=ProvinceName_CityName_HospitalName
	.
	e  i ((CommunityType = "乡镇卫生院")||(CommunityType = "社区卫生服务中心")) d
	.s tempHospital = ##class(CHSS.DictStreet).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s HospitalName = tempHospital.Description
	..
	..s SectionId=tempHospital.RowIdParref.%Id()
	..i SectionId '= "" d
	...s tempSection=##class(CHSS.DictSection).%OpenId(SectionId)
	...s SectionName=tempSection.Description
	...
	...s CityId=tempSection.RowIdParref.%Id()
	...i CityId '= "" d
	....s tempCity=##class(CHSS.DictCity).%OpenId(CityId)
	....s CityName=tempCity.Description
	....
	....s ProvinceId=tempCity.RowIdParref.%Id()
	....s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
	....s ProvinceName=tempProvince.Description
	.s HospitalName=ProvinceName_CityName_SectionName_HospitalName
	e  i ((CommunityType = "村卫生所")||(CommunityType = "社区卫生服务站")) d
	.s tempHospital = ##class(CHSS.DictVillage).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s HospitalName = tempHospital.Description
	..s streetId = tempHospital.RowIdParref.%Id()
	..s tempStreet=##class(CHSS.DictStreet).%OpenId(streetId)
	..s StreetName=tempStreet.Description
	..
	..s SectionId=tempStreet.RowIdParref.%Id()
	..s tempSection=##class(CHSS.DictSection).%OpenId(SectionId)
	..s SectionName=tempSection.Description
	..
	..s CityId=tempSection.RowIdParref.%Id()
	..s tempCity=##class(CHSS.DictCity).%OpenId(CityId)
	..s CityName=tempCity.Description
	..
	..s ProvinceId=tempCity.RowIdParref.%Id()
	..s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
	..s ProvinceName=tempProvince.Description
	
	.s HospitalName=ProvinceName_CityName_SectionName_StreetName_HospitalName_UpCommunityName
	i UpCommunityCode '= "" d
	.s UpCommunityName = ..GetCommunityName(UpCommunityCode)
	s tmp=Rowid_"^"_CommunityCode_"^"_CommunityName_"^"_SepllCode_"^"_UpCommunityCode_"^"_CommunityCodePrex_"^"_CommunityType_"^"_HospitalDR_"^"_RecordDR_"^"_HospitalName_"^"_UpCommunityName

	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^CommunityCode^CommunityName^SepllCode^UpCommunityCode^CommunityCodePrex^CommunityType^HospitalDR^RecordDR^HospitalName^UpCommunityName",count)
	k json
	q resultString
}

//添加记录

ClassMethod insert(CommunityCode, CommunityName, SpellCode, UpCommunityCode, CommunityCodePrex, CommunityType, HospitalDR, RecordDR) As %String
{
	s ReturnCode=..existCommunityCode(CommunityCode)
	s hospitalcode=..existCTHospital("","add",CommunityCode)
	S ctloc = ..existCTLoc(CommunityCode)
	s HospitalDR = ""
	
	i (ReturnCode '="0") d
	.w "{""success"":""false"",""info"":""社区机构编码: "_CommunityCode_"已存在！请重输入！""}"
    e  d
    .i (hospitalcode '= "0") d
    ..i (ctloc '= "0") d
    ...&sql(select HOSP_RowId into :HospitalDR from SQLUser.CT_Hospital where HOSP_Code= :CommunityCode)
    ...i (SQLCODE ="0") d
    ....&sql(insert into CHSS.DictHospital (CommunityCode,CommunityName,SpellCode,UpCommunityCode,CommunityCodePrex,CommunityType,HospitalDR,RecordDR) values(:CommunityCode,:CommunityName,:SpellCode,:UpCommunityCode,:CommunityCodePrex,:CommunityType,:HospitalDR,:RecordDR))

	....i (SQLCODE ="0") d
    .....w "{""success"":""true"",""info"":""添加成功!""}"
	....e  d
	.....w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
    ..e  d
    ...&sql(select HOSP_RowId into :HospitalDR from SQLUser.CT_Hospital where HOSP_Code= :CommunityCode)
    ...i (SQLCODE ="0") d
    ....&sql(insert into CHSS.DictHospital (CommunityCode,CommunityName,SpellCode,UpCommunityCode,CommunityCodePrex,CommunityType,HospitalDR,RecordDR) values(:CommunityCode,:CommunityName,:SpellCode,:UpCommunityCode,:CommunityCodePrex,:CommunityType,:HospitalDR,:RecordDR))
    ....&sql(insert into SQLUser.CT_Loc (CTLOC_Code,CTLOC_Desc) values (:CommunityCode,:CommunityName))
    ....i (SQLCODE ="0") d
    .....w "{""success"":""true"",""info"":""添加成功!""}"
	....e  d
	.....w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
    .e  d
    ..i (ctloc '= "0")  d
    ...&sql(insert into SQLUser.CT_Hospital(HOSP_Code,HOSP_Desc) values(:CommunityCode,:CommunityName))
    ...&sql(select HOSP_RowId into :HospitalDR from SQLUser.CT_Hospital where HOSP_Code= :CommunityCode)
	...&sql(insert into CHSS.DictHospital (CommunityCode,CommunityName,SpellCode,UpCommunityCode,CommunityCodePrex,CommunityType,HospitalDR,RecordDR) values(:CommunityCode,:CommunityName,:SpellCode,:UpCommunityCode,:CommunityCodePrex,:CommunityType,:HospitalDR,:RecordDR))
	...i (SQLCODE = "0") d
	....w "{""success"":""true"",""info"":""添加成功!""}"
	...e  d
	....w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
    ..e  d
    ...&sql(insert into SQLUser.CT_Hospital(HOSP_Code,HOSP_Desc) values(:CommunityCode,:CommunityName))
    ...&sql(select HOSP_RowId into :HospitalDR from SQLUser.CT_Hospital where HOSP_Code= :CommunityCode)
	...&sql(insert into CHSS.DictHospital (CommunityCode,CommunityName,SpellCode,UpCommunityCode,CommunityCodePrex,CommunityType,HospitalDR,RecordDR) values(:CommunityCode,:CommunityName,:SpellCode,:UpCommunityCode,:CommunityCodePrex,:CommunityType,:HospitalDR,:RecordDR))
	...&sql(insert into SQLUser.CT_Loc(CTLOC_Code,CTLOC_Desc) values (:CommunityCode,:CommunityName))
	...i (SQLCODE = "0") d
	....w "{""success"":""true"",""info"":""添加成功!""}"
	...e  d
	....w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
	q ""
}

ClassMethod update(RowId, CommunityCode, CommunityName, SpellCode, UpCommunityCode, CommunityCodePrex, CommunityType, HospitalDR, RecordDR) As %String
{
	q:(RowId="") "code-rep"
	s CTLocCode = ..existCTLoc(CommunityCode)
	s CTLocName = ..existCTLocName(CommunityName)
	&sql(update CHSS.DictHospital set CommunityCode=:CommunityCode,CommunityName=:CommunityName,SpellCode=:SpellCode,UpCommunityCode=:UpCommunityCode,CommunityCodePrex=:CommunityCodePrex,CommunityType=:CommunityType,HospitalDR=:HospitalDR,RecordDR=:RecordDR where %ID=:RowId)
	&sql(update SQLUser.CT_Hospital  set HOSP_Code=:CommunityCode,HOSP_Desc=:CommunityName where %ID=:HospitalDR)
	if (CTLocCode '="0")
	{
		if (CTLocName ="0")
		{
			&sql(update SQLUser.CT_Loc set CTLoc_Desc=:CommunityName where CTLoc_Code=:CommunityCode)
		}	
	}
	else 
	{
		if (CTLocName '="0")
		{
		  	&sql(update SQLUser.CT_Loc set CTLOC_Code = :CommunityCode where CTLoc_Desc=:CommunityName)		
		}	
		else 
		{
			&sql(insert into SQLUser.CT_Loc(CTLOC_Code,CTLOC_Desc) values (:CommunityCode,:CommunityName))
		}
	}
	
	i (SQLCODE = "0") d
	.w "{""success"":""true"",""info"":""修改成功！""}"
	e  d
	.w "{""success"":""false"",""info"":""修改失败！"_SQLCODE_"""}"
	q ""
}

//删除一条数据库中已经存在的记录

ClassMethod delete(RowId) As %String
{
   &sql(delete FROM SQLUser.CT_Loc where CTLOC_Code in (select CommunityCode FROM CHSS.DictHospital where RowId =:RowId))
   &sql(delete FROM SQLUser.CT_Hospital where HOSP_RowId in (select HospitalDR FROM CHSS.DictHospital where RowId =:RowId))
   &sql(delete FROM CHSS.DictHospital where RowId =:RowId)
   q SQLCODE
}

//返回社区名称

ClassMethod GetCommunityName(CommunityCode As %String) As %String
{
	q:CommunityCode="" ""
	s CommunityName = ""

    
    s result1 = ##class(%Library.ResultSet).%New()
	s sqlStr1 = "select CommunityName FROM CHSS.DictHospital where CommunityCode = "_CommunityCode
	
	d result1.Prepare(sqlStr1)
	d result1.Execute()
	
	While(result1.Next())
	{
		s CommunityName = result1.Data("CommunityName")
	}
	q CommunityName
}

//判断社区编码是否重复

ClassMethod existCommunityCode(CommunityCode As %String) As %String
{
	q:CommunityCode="" "-1"
	s CommunityCode=""_CommunityCode
	q:$d(^CHSS.DictHospitalI("CommunityCodeIndex",CommunityCode)) "1"
    q "0"
}

ClassMethod existCode(CommunityCode As %String) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT HOSP_Code FROM SQLUser.CT_Hospital"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		s Code = result.Data("HOSP_Code")
		i (Code = CommunityCode) d
		.q:"1"
	}
}

ClassMethod getxc(Start, Limit, Name) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	i Name = "1" d
	.s sqlStr = "SELECT RowId,Code,Description,StartDate,EndDate,Active,Sort FROM CHSS.DictStreet"
	e  d 
	.s sqlStr = "SELECT RowId,Code,Description,StartDate,EndDate,Active,Sort FROM CHSS.DictVillage"
	
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

ClassMethod listct(Start, Limit)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlstr = "select HOSP_RowId,HOSP_Desc from SQLUser.CT_Hospital"
	
	d result.Prepare(sqlstr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s RowId = result.Data("HOSP_RowId")
	s Description = result.Data("HOSP_Desc")
	s tmp=RowId_"^"_Description
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Description",count)
	k json
	q resultString
}

ClassMethod existCTHospital(RowId As %Integer, RecordType As %String, CommunityCode As %String) As %String
{
 set count = 0
 set tempRowId = 0
 Set json = ##class(Code.JsonObj).%New()
 s result = ##class(%Library.ResultSet).%New()
 s sqlStr = "SELECT HOSP_RowId FROM SQLUser.CT_Hospital where HOSP_Code = '"_CommunityCode_"'"

 d result.Prepare(sqlStr)
 d result.Execute()
 While(result.Next())
{
 set tempRowId = result.Get("HOSP_RowId")
 s count = count + 1
}
 if (RecordType = "add")
{
	 if (count>0)
	{
	 q "1"
	}
	 elseif (count=0)
	{
		 q "0"
	}
}
 elseif (RecordType = "edit")
{
	 if (count=1 && (RowId '= tempRowId))
	{
		 q "1"
	}
	 elseif (count>1)
	{
	 	q "1"
	}
	 else
	{
		 q "0"
	}
}
}

ClassMethod ListSearch(Start, Limit, TableName, SearchStr, RowIdParref) As %String
{

	s result = ##class(%Library.ResultSet).%New()
	s whereStr = ""
	i SearchStr '= "" d
	.s whereStr = " WHERE Description LIKE '%"_SearchStr_"%'" //" AND RowIdParref="_RowIdParref
    e  d
    .s whereStr = " WHERE RowIdParref ="_RowIdParref
   
	s sqlStr = "SELECT RowId,Code,Description,StartDate,EndDate,Active,Sort FROM CHSS."_TableName_whereStr
	
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

ClassMethod existCTLoc(CommunityCode As %String) As %String
{
 set count = 0
 Set json = ##class(Code.JsonObj).%New()
 s result = ##class(%Library.ResultSet).%New()
 s sqlStr = "SELECT CTLOC_RowID FROM SQLUser.CT_Loc where CTLOC_Code = '"_CommunityCode_"'"

 d result.Prepare(sqlStr)
 d result.Execute()
 While(result.Next())
{
 set tempRowId = result.Get("CTLOC_RowID")
 s count = count + 1
}
	 if (count>0)
	{
		 q "1"
	}
	 elseif (count=0)
	{
		q "0"
	}
}

ClassMethod existCTLocName(CommunityName) As %String
{
 set count = 0
 Set json = ##class(Code.JsonObj).%New()
 s result = ##class(%Library.ResultSet).%New()
 s sqlStr = "SELECT CTLOC_RowID FROM SQLUser.CT_Loc where CTLOC_Desc = '"_CommunityName_"'"

 d result.Prepare(sqlStr)
 d result.Execute()
 While(result.Next())
{
 set tempRowId = result.Get("CTLOC_RowID")
 s count = count + 1
}
	 if (count>0)
	{
		 q "1"
	}
	  elseif (count=0)
	{
		q "0"
	}
}

//搜索记录

ClassMethod search(Start, Limit, SearchValue) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowId,CommunityCode,CommunityName,SpellCode,UpCommunityCode,CommunityCodePrex,CommunityType,HospitalDR,RecordDR FROM CHSS.DictHospital WHERE CommunityName like '%"_SearchValue_"%'"

	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s Rowid = result.Data("RowId")
	s CommunityCode = result.Data("CommunityCode")
	s CommunityName = result.Data("CommunityName")
	s SepllCode = result.Data("SpellCode")
	s UpCommunityCode = result.Data("UpCommunityCode")
	s CommunityCodePrex = result.Data("CommunityCodePrex")
	s CommunityType = result.Data("CommunityType")
	s HospitalDR = result.Data("HospitalDR")
	s RecordDR = result.Data("RecordDR")
    s HospitalName = ""
    s ProvinceName = ""
    s CityName = ""
    s SectionName = ""
    s StreetName = ""
    s HospitalName = ""
    s UpCommunityName = ""
    i CommunityType = "省卫生厅" d
	.s tempHospital = ##class(CHSS.DictProvince).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s HospitalName = tempHospital.Description
	..
    i CommunityType = "市卫生局" d
	.s tempHospital = ##class(CHSS.DictCity).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s HospitalName = tempHospital.Description
	..s ProvinceId=tempHospital.RowIdParref.%Id()
	..s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
	..s ProvinceName=tempProvince.Description
	.s HospitalName=ProvinceName_HospitalName
	e  i (CommunityType = "县（区）卫生局") d
	.s tempHospital = ##class(CHSS.DictSection).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s HospitalName = tempHospital.Description
	e  i ((CommunityType = "乡镇卫生院")||(CommunityType = "社区卫生服务中心")) d
	.s tempHospital = ##class(CHSS.DictStreet).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s HospitalName = tempHospital.Description
	..
	..s SectionId=tempHospital.RowIdParref.%Id()
	..i SectionId '= "" d
	...s tempSection=##class(CHSS.DictSection).%OpenId(SectionId)
	...s SectionName=tempSection.Description
	...
	...s CityId=tempSection.RowIdParref.%Id()
	...i CityId '= "" d
	....s tempCity=##class(CHSS.DictCity).%OpenId(CityId)
	....s CityName=tempCity.Description
	....
	....s ProvinceId=tempCity.RowIdParref.%Id()
	....s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
	....s ProvinceName=tempProvince.Description
	.s HospitalName=ProvinceName_CityName_SectionName_HospitalName
	e  i ((CommunityType = "村卫生所")||(CommunityType = "社区卫生服务站")) d
	.s tempHospital = ##class(CHSS.DictVillage).%OpenId(RecordDR)
	.i tempHospital '= "" d
	..s HospitalName = tempHospital.Description
	..s streetId = tempHospital.RowIdParref.%Id()
	..s tempStreet=##class(CHSS.DictStreet).%OpenId(streetId)
	..s StreetName=tempStreet.Description
	..
	..s SectionId=tempStreet.RowIdParref.%Id()
	..s tempSection=##class(CHSS.DictSection).%OpenId(SectionId)
	..s SectionName=tempSection.Description
	..
	..s CityId=tempSection.RowIdParref.%Id()
	..s tempCity=##class(CHSS.DictCity).%OpenId(CityId)
	..s CityName=tempCity.Description
	.
	..s ProvinceId=tempCity.RowIdParref.%Id()
	..s tempProvince=##class(CHSS.DictProvince).%OpenId(ProvinceId)
	..s ProvinceName=tempProvince.Description
	.
	.s HospitalName=ProvinceName_CityName_SectionName_StreetName_HospitalName_UpCommunityName
	i UpCommunityCode '= "" d
	.s UpCommunityName = ..GetCommunityName(UpCommunityCode)
	s tmp=Rowid_"^"_CommunityCode_"^"_CommunityName_"^"_SepllCode_"^"_UpCommunityCode_"^"_CommunityCodePrex_"^"_CommunityType_"^"_HospitalDR_"^"_RecordDR_"^"_HospitalName_"^"_UpCommunityName

	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^CommunityCode^CommunityName^SepllCode^UpCommunityCode^CommunityCodePrex^CommunityType^HospitalDR^RecordDR^HospitalName^UpCommunityName",count)
	k json
	q resultString
}

ClassMethod UpdateHospitalDR() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * from CHSS.DictHospital"

	d result.Prepare(sqlStr)
	d result.Execute()
	
	s result2 = ##class(%Library.ResultSet).%New()
	
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s CommunityCode = result.Data("CommunityCode")
		
		s HOSPRowId = ""
		&sql(select HOSP_RowId into :HOSPRowId from SQLUser.CT_Hospital where HOSP_Code = :CommunityCode)
		i HOSPRowId '= "" d
		.&sql(update CHSS.DictHospital set HospitalDR = :HOSPRowId where CommunityCode = :CommunityCode)

		
	}
	d result.Close()
	d result2.Close()
	q ""
}

Storage Default
{
<Data name="DictHospitalServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DictHospitalServiceD</DataLocation>
<DefaultData>DictHospitalServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.DictHospitalServiceD</IdLocation>
<IndexLocation>^CHSSWeb.DictHospitalServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.DictHospitalServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
