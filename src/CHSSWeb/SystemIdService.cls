Class CHSSWeb.SystemIdService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 编码组成：社区机构编码+日期+序列号
/// 从csp读取出来有长度限制，待解决
/// modify by wangbo 2009-09-02  增加一种编码方式
ClassMethod GetSystemId(CommunityCode As %String, TableName As %String) As %String
{
	;卫生部编码方式（绵阳标准）
	q ..GetSystemId1(CommunityCode,TableName)
	;华西医院-金堂编码格式
	;q ..GetSystemId2(CommunityCode,TableName)
	;q ""
	;
	;卫生部编码方式（机构编码+6为编码）
	;q ..GetSystemIdNew(CommunityCode,TableName)
}

/// modify by wangbo 2010-06-23  
ClassMethod GetSystemIdWithVillageDR(CommunityCode As %String, VillageName As %String, TableName As %String) As %String
{
	;卫生部编码方式（省+市+区+街道办事处+居委会+5位编码）
	q ..GetSystemIdWithVillageCode(CommunityCode,VillageName,TableName)
}

ClassMethod GetSystemId1(CommunityCode As %String, TableName As %String) As %String
{
	;卫生部编码方式（社区机构编码+日期+序列号）
	;**卫生部编码方式*********************
	s ReturnId = ""
	set CurDate = $zd($Horolog,8)
	s ReturnCommunityCode=..existCommunityCode(CommunityCode,TableName)
	;w ReturnCommunityCode,!
	
	;w TableName
	;q ""
	i ReturnCommunityCode '= 1 d
	.&sql(insert into CHSS.DictSystemId (SystemId,DateOfLast,TableName,CommunityCode,bValid) values(1,:CurDate,:TableName,:CommunityCode,1))
	.s ReturnId = CommunityCode_CurDate_"000001"
	e  d
	.s ReturnDate=..existCommunityCodeAndDate(CommunityCode,CurDate,TableName)
	.i ReturnDate '= 1 d
	..&sql(insert into CHSS.DictSystemId (SystemId,DateOfLast,TableName,CommunityCode,bValid) values(1,:CurDate,:TableName,:CommunityCode,1))
	..s ReturnId = CommunityCode_CurDate_"000001"
	.e  i ReturnDate = 1 d
	..&sql(update CHSS.DictSystemId set SystemId = SystemId+1,DateOfLast=:CurDate,TableName=:TableName where CommunityCode = :CommunityCode and TableName=:TableName)
	..s ReturnId=..GetSystemIdWithFilter(CommunityCode,CurDate,TableName)
	..;w ReturnId
	q ReturnId
	;**卫生部编码方式*********************
}

ClassMethod GetSystemId2(CommunityCode As %String, TableName As %String) As %String
{
	;华西医院编码方式（省+市+区+街道办事处+社区机构编码+序列号）
	s ReturnId = ""
	s CommunityType = ..GetCommunityType(CommunityCode)
	
	s SystemId = ..GetCommunityCode(CommunityCode,CommunityType)
	set CurDate = $zd($Horolog,8)
	s ReturnCommunityCode=..existCommunityCode(CommunityCode,TableName)
	i ReturnCommunityCode '= 1 d
	.&sql(insert into CHSS.DictSystemId (SystemId,DateOfLast,TableName,CommunityCode,bValid) values(1,:CurDate,:TableName,:CommunityCode,1))
	.s ReturnId = SystemId_CommunityCode_"000001"
	e  d
	.&sql(update CHSS.DictSystemId set SystemId = SystemId+1,DateOfLast=:CurDate,TableName=:TableName where CommunityCode = :CommunityCode and TableName=:TableName)
	.s ReturnId=..GetSystemIdWithTable(CommunityCode, TableName)
	.s ReturnId =  SystemId_CommunityCode_ReturnId
	q ReturnId
}

ClassMethod GetSystemIdWithVillageCode(CommunityCode As %String, VillageName As %String, TableName As %String) As %String
{
	;卫生部编码方式（省+市+区+街道办事处+居委会+序列号）
	
	s ReturnCommunityCode=..existCommunityCode(CommunityCode,TableName)

	s VillageCode=..GetVillageCodeWithName(VillageName)
	i ReturnCommunityCode '= 1 d
	.&sql(insert into CHSS.DictSystemId (SystemId,DateOfLast,TableName,CommunityCode,bValid) values(1,:CurDate,:TableName,:CommunityCode,1))
	.s ReturnId = VillageCode_"00001"
	e  d
	.&sql(update CHSS.DictSystemId set SystemId = SystemId+1,DateOfLast=:CurDate,TableName=:TableName where CommunityCode = :CommunityCode and TableName=:TableName)
	.s ReturnId=..GetSystemId5WithTable(CommunityCode, TableName)
	.s ReturnId =  VillageCode_ReturnId
	q ReturnId
}

ClassMethod GetVillageCodeWithName(VillageName As %String) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Code,Description from CHSS.DictVillage where Description = '"_VillageName_"'"
	;w VillageName
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s Start = 0
	s Limit = 1
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	s Code = ""
	While(result.Next())
	{
	s Code = result.Data("Code")
	}
	d result.Close()
	q Code
}

ClassMethod GetSystemIdNew(CommunityCode As %String, TableName As %String) As %String
{
	;卫生部编码方式（社区机构编码+6位序列号）
	;**卫生部编码方式*********************
	s ReturnId = ""
	s CommunityType = ..GetCommunityType(CommunityCode)
	
	set CurDate = $zd($Horolog,8)
	s ReturnCommunityCode=..existCommunityCode(CommunityCode,TableName)
	i ReturnCommunityCode '= 1 d
	.&sql(insert into CHSS.DictSystemId (SystemId,DateOfLast,TableName,CommunityCode,bValid) values(1,:CurDate,:TableName,:CommunityCode,1))
	.s ReturnId = CommunityCode_"000001"
	e  d
	.&sql(update CHSS.DictSystemId set SystemId = SystemId+1,DateOfLast=:CurDate,TableName=:TableName where CommunityCode = :CommunityCode and TableName=:TableName)
	.s ReturnId=..GetSystemIdWithTable(CommunityCode, TableName)
	.s ReturnId =  CommunityCode_ReturnId
	q ReturnId
}

ClassMethod GetCommunityType(CommunityCode As %String) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where CommunityCode = '"_CommunityCode_"'"

	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s Start = 0
	s Limit = 1
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	s CommunityType = ""
	While(result.Next())
	{
	s CommunityType = result.Data("CommunityType")
	}
	d result.Close()
	
	q CommunityType
}

/// Modify by wangb 2009-09-02 添加读取编码 
ClassMethod GetCommunityCode(CommunityCode As %String, CommunityType As %String) As %String
{
	;s CommunityType = "村卫生所"
	;s CommunityType = "社区卫生服务中心"
    ;s CommunityType = "社区卫生服务站"
	s resultString = ""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = ""
	i CommunityType = "村卫生所" d
	.s sqlStr = " select RowId as VillageDR,Code as VillageCode,Description as VillageName,RowIdParref as StreetDR,RowIdParref->Code as StreetCode, RowIdParref->Description as StreetName,RowIdParref->RowIdParref as SectionDR,RowIdParref->RowIdParref->Code as SectionCode,RowIdParref->RowIdParref->Description as SectionName,RowIdParref->RowIdParref->RowIdParref as CityDR,RowIdParref->RowIdParref->RowIdParref->Code as CityCode,RowIdParref->RowIdParref->RowIdParref->Description as CityName,RowIdParref->RowIdParref->RowIdParref->RowIdParref as ProvinceDR,RowIdParref->RowIdParref->RowIdParref->RowIdParref->Code as ProvinceCode,RowIdParref->RowIdParref->RowIdParref->RowIdParref->Description as ProvinceName from CHSS.DictVillage where RowId in ( select RecordDR from CHSS.DictHospital where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	e  i CommunityType = "社区卫生服务中心" d
	.s sqlStr = " select RowId as StreetDR,Code as StreetCode,Description as StreetName,RowIdParref as SectionDR,RowIdParref->Code as SectionCode,RowIdParref->Description as SectionName,RowIdParref->RowIdParref as CityDR,RowIdParref->RowIdParref->Code as CityCode,RowIdParref->RowIdParref->Description as CityName,RowIdParref->RowIdParref->RowIdParref as ProvinceDR,RowIdParref->RowIdParref->RowIdParref->Code as ProvinceCode,RowIdParref->RowIdParref->RowIdParref->Description as ProvinceName from CHSS.DictStreet where RowId in ( select RecordDR from CHSS.DictHospital where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	e  i CommunityType = "社区卫生服务站" d
	.s sqlStr = " select RowId as VillageDR,Code as VillageCode,Description as VillageName,RowIdParref as StreetDR,RowIdParref->Code as StreetCode, RowIdParref->Description as StreetName,RowIdParref->RowIdParref as SectionDR,RowIdParref->RowIdParref->Code as SectionCode,RowIdParref->RowIdParref->Description as SectionName,RowIdParref->RowIdParref->RowIdParref as CityDR,RowIdParref->RowIdParref->RowIdParref->Code as CityCode,RowIdParref->RowIdParref->RowIdParref->Description as CityName,RowIdParref->RowIdParref->RowIdParref->RowIdParref as ProvinceDR,RowIdParref->RowIdParref->RowIdParref->RowIdParref->Code as ProvinceCode,RowIdParref->RowIdParref->RowIdParref->RowIdParref->Description as ProvinceName from CHSS.DictVillage where RowId in ( select RecordDR from CHSS.DictHospital where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	e  i CommunityType = "乡镇卫生院" d
	.s sqlStr = " select RowId as StreetDR,Code as StreetCode,Description as StreetName,RowIdParref as SectionDR,RowIdParref->Code as SectionCode,RowIdParref->Description as SectionName,RowIdParref->RowIdParref as CityDR,RowIdParref->RowIdParref->Code as CityCode,RowIdParref->RowIdParref->Description as CityName,RowIdParref->RowIdParref->RowIdParref as ProvinceDR,RowIdParref->RowIdParref->RowIdParref->Code as ProvinceCode,RowIdParref->RowIdParref->RowIdParref->Description as ProvinceName from CHSS.DictStreet where RowId in ( select RecordDR from CHSS.DictHospital where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	
	;w sqlStr,!
	;q ""
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s Start = 0
	s Limit = 1
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s VillageCode = ""
	if (CommunityType="村卫生所")
	{
	    s VillageCode = result.Data("VillageCode")
	}
	s StreetCode = result.Data("StreetCode")
	s SectionCode = result.Data("SectionCode")
	s CityCode = result.Data("CityCode")
	s ProvinceCode = result.Data("ProvinceCode")
	
	s resultString = ProvinceCode_CityCode_SectionCode_StreetCode
	if (CommunityType="村卫生所")
	{
	    s resultString = resultString_result.Data("VillageCode")
	}
	
	}
	q resultString
}

/// Modify by wangb 2010-06-23 卫生部标准 省+市+区+街道+居委会
ClassMethod GetCommunityCode3(CommunityCode As %String, CommunityType As %String) As %String
{
	;s CommunityType = "村卫生所"
	;s CommunityType = "社区卫生服务中心"
    ;s CommunityType = "社区卫生服务站"
	s resultString = ""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = ""
	i CommunityType = "村卫生所" d
	.s sqlStr = " select RowId as VillageDR,Code as VillageCode,Description as VillageName,RowIdParref as StreetDR,RowIdParref->Code as StreetCode, RowIdParref->Description as StreetName,RowIdParref->RowIdParref as SectionDR,RowIdParref->RowIdParref->Code as SectionCode,RowIdParref->RowIdParref->Description as SectionName,RowIdParref->RowIdParref->RowIdParref as CityDR,RowIdParref->RowIdParref->RowIdParref->Code as CityCode,RowIdParref->RowIdParref->RowIdParref->Description as CityName,RowIdParref->RowIdParref->RowIdParref->RowIdParref as ProvinceDR,RowIdParref->RowIdParref->RowIdParref->RowIdParref->Code as ProvinceCode,RowIdParref->RowIdParref->RowIdParref->RowIdParref->Description as ProvinceName from CHSS.DictVillage where RowId in ( select RecordDR from CHSS.DictHospital where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	e  i CommunityType = "社区卫生服务中心" d
	.s sqlStr = " select RowId as StreetDR,Code as StreetCode,Description as StreetName,RowIdParref as SectionDR,RowIdParref->Code as SectionCode,RowIdParref->Description as SectionName,RowIdParref->RowIdParref as CityDR,RowIdParref->RowIdParref->Code as CityCode,RowIdParref->RowIdParref->Description as CityName,RowIdParref->RowIdParref->RowIdParref as ProvinceDR,RowIdParref->RowIdParref->RowIdParref->Code as ProvinceCode,RowIdParref->RowIdParref->RowIdParref->Description as ProvinceName from CHSS.DictStreet where RowId in ( select RecordDR from CHSS.DictHospital where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	e  i CommunityType = "社区卫生服务站" d
	.s sqlStr = " select RowId as VillageDR,Code as VillageCode,Description as VillageName,RowIdParref as StreetDR,RowIdParref->Code as StreetCode, RowIdParref->Description as StreetName,RowIdParref->RowIdParref as SectionDR,RowIdParref->RowIdParref->Code as SectionCode,RowIdParref->RowIdParref->Description as SectionName,RowIdParref->RowIdParref->RowIdParref as CityDR,RowIdParref->RowIdParref->RowIdParref->Code as CityCode,RowIdParref->RowIdParref->RowIdParref->Description as CityName,RowIdParref->RowIdParref->RowIdParref->RowIdParref as ProvinceDR,RowIdParref->RowIdParref->RowIdParref->RowIdParref->Code as ProvinceCode,RowIdParref->RowIdParref->RowIdParref->RowIdParref->Description as ProvinceName from CHSS.DictVillage where RowId in ( select RecordDR from CHSS.DictHospital where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	e  i CommunityType = "乡镇卫生院" d
	.s sqlStr = " select RowId as StreetDR,Code as StreetCode,Description as StreetName,RowIdParref as SectionDR,RowIdParref->Code as SectionCode,RowIdParref->Description as SectionName,RowIdParref->RowIdParref as CityDR,RowIdParref->RowIdParref->Code as CityCode,RowIdParref->RowIdParref->Description as CityName,RowIdParref->RowIdParref->RowIdParref as ProvinceDR,RowIdParref->RowIdParref->RowIdParref->Code as ProvinceCode,RowIdParref->RowIdParref->RowIdParref->Description as ProvinceName from CHSS.DictStreet where RowId in ( select RecordDR from CHSS.DictHospital where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	
	;w sqlStr,!
	;q ""
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s Start = 0
	s Limit = 1
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s VillageCode = ""
	if (CommunityType="村卫生所")
	{
	    s VillageCode = result.Data("VillageCode")
	}
	s StreetCode = result.Data("StreetCode")
	s SectionCode = result.Data("SectionCode")
	s CityCode = result.Data("CityCode")
	s ProvinceCode = result.Data("ProvinceCode")
	
	s resultString = ProvinceCode_CityCode_SectionCode_StreetCode
	if (CommunityType="村卫生所")
	{
	    //s resultString = resultString_result.Data("VillageCode")
	}
	
	}
	q resultString
}

/// 判断code是否存在,-1入参为空，1重复，0不重复
ClassMethod existCommunityCode(CommunityCode, TableName) As %String
{
	q:CommunityCode="" "-1"
	;s CommunityCode=" "_CommunityCode
	;s TableName=" "_TableName
	;q:$d(^CHSS.DictSystemIdI("CommunityCodeIndex",CommunityCode,TableName)) "1"
	;q "0"
	s SystemId = ""
	s result = ##class(%Library.ResultSet).%New()
	Set prepareString = "SELECT SystemId,DateOfLast,CommunityCode FROM CHSS.DictSystemId WHERE CommunityCode='"_CommunityCode_"' and TableName='"_TableName_"'"
  
	Do result.Prepare(prepareString)
	Do result.Execute()
	While (result.Next()){
	 s SystemId = result.Data("SystemId")
	}
	q:(SystemId'="") "1"
	q "0"
}

ClassMethod existCommunityCodeAndDate(CommunityCode, DateOfLast, TableName) As %String
{
	s SystemId = ""
	s result = ##class(%Library.ResultSet).%New()
	Set prepareString = "SELECT top 1 SystemId,DateOfLast,CommunityCode FROM CHSS.DictSystemId WHERE CommunityCode='"_CommunityCode_"' and DateOfLast = '"_DateOfLast_"' and TableName='"_TableName_"'"
  
	Do result.Prepare(prepareString)
	Do result.Execute()
	While (result.Next()){
	 s SystemId = result.Data("SystemId")
	}
	q:(SystemId'="") "1"
	q "0"
}

ClassMethod GetSystemIdWithFilter(CommunityCode, CurDate, TableName) As %String
{
	q:CommunityCode="" "-1"

	///$lg(^CHSS.PersonHealthRecordMainD(PersonRowId),32)
	s SystemId = ""
	s result = ##class(%Library.ResultSet).%New()
	Set prepareString = "SELECT SystemId,DateOfLast,CommunityCode FROM CHSS.DictSystemId WHERE CommunityCode='"_CommunityCode_"' and DateOfLast = '"_CurDate_"' and TableName='"_TableName_"'"
  
	Do result.Prepare(prepareString)
	Do result.Execute()
	While (result.Next()){
	 s SystemId = result.Data("SystemId")
	 while ($l(SystemId) < 6)
	 {
		 s SystemId = "0"_SystemId
		 }
	 s SystemId = result.Data("CommunityCode")_result.Data("DateOfLast")_SystemId
	 
	}
	q SystemId
}

ClassMethod GetSystemIdWithTable(CommunityCode, TableName) As %String
{
	q:CommunityCode="" "-1"

	///$lg(^CHSS.PersonHealthRecordMainD(PersonRowId),32)
	s SystemId = ""
	s result = ##class(%Library.ResultSet).%New()
	Set prepareString = "SELECT SystemId,DateOfLast,CommunityCode FROM CHSS.DictSystemId WHERE CommunityCode='"_CommunityCode_"' and TableName='"_TableName_"'"
  
	Do result.Prepare(prepareString)
	Do result.Execute()
	While (result.Next()){
	 s SystemId = result.Data("SystemId")
	 while ($l(SystemId) < 6)
	 {
		 s SystemId = "0"_SystemId
		 }
	 s SystemId = SystemId
	 
	}
	q SystemId
}

//列出所有记录

ClassMethod List(Start, Limit, Sort, Dir, Code, Description) As %String
{
	Set TopNum= Start+Limit
	Set result = ##class(%Library.ResultSet).%New()
	Set prepareString = "SELECT RowID,Code,Description,StartDate,EndDate,Active FROM sqlUser.CHSSDictKin WHERE RowID >= 1"
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
	s sqlStr = "SELECT RowID,Code,Description,StartDate,EndDate,Active,Sort FROM CHSS.DictPolice"
	
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
	.&sql(insert into CHSS.DictPolice (Code,Description) values(:Code,:Description))
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
	&sql(insert into CHSS.DictPolice (Code,Description,StartDate,EndDate,Active,Sort) values(:Code,:Description,:start,:end,:Active,:Sort))
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
	&sql(update CHSS.DictPolice set Code=:Code,Description=:Description,StartDate=:start,EndDate=:end,Active=:Active,Sort=:Sort where %ID=:RowId)
	q SQLCODE
}

//删除一条数据库中已经存在的记录

ClassMethod delete(RowId) As %String
{
	&sql(delete from CHSS.DictPolice where %ID=:RowId)
	q SQLCODE
}

/// add by liuchao 2010-03-18 应用于 年检表中条形码 的生成
ClassMethod GetSystemId3(CommunityCode As %String, TableName As %String) As %String
{
	;编码方式（省县乡+序列号）
	
	set CurDate = $zd($Horolog,8)
	
	s ReturnCommunityCode=..existCommunityCode(CommunityCode,$ZCONVERT(TableName,"U"))
	i ReturnCommunityCode '= 1 d
	.&sql(insert into CHSS.DictSystemId (SystemId,DateOfLast,TableName,CommunityCode,bValid) values(1,:CurDate,:TableName,:CommunityCode,1))
	e  i ReturnCommunityCode = 1 d
	.&sql(update CHSS.DictSystemId set SystemId = SystemId+1,DateOfLast=:CurDate,TableName=:TableName where CommunityCode = :CommunityCode and TableName=:TableName)
	s ReturnId = ..GetSystemIdWithTable(CommunityCode,TableName)
	s ReturnId = $E(ReturnId,2,6)
	q ReturnId
}

/// 卫生部标准
ClassMethod GetSystemId5WithTable(CommunityCode, TableName) As %String
{
	q:CommunityCode="" "-1"

	///$lg(^CHSS.PersonHealthRecordMainD(PersonRowId),32)
	s SystemId = ""
	s result = ##class(%Library.ResultSet).%New()
	Set prepareString = "SELECT SystemId,DateOfLast,CommunityCode FROM CHSS.DictSystemId WHERE CommunityCode='"_CommunityCode_"' and TableName='"_TableName_"'"
  
	Do result.Prepare(prepareString)
	Do result.Execute()
	While (result.Next()){
	 s SystemId = result.Data("SystemId")
	 while ($l(SystemId) < 5)
	 {
		 s SystemId = "0"_SystemId
		 }
	 s SystemId = SystemId
	 
	}
	q SystemId
}

/// 卫生部标准
ClassMethod GetPersonCodeWithFamilyId(FamilyRowId) As %String
{
	s FamilyCode = ""
	s result = ##class(%Library.ResultSet).%New()
	Set prepareString = "SELECT FamilyRowId,FamilyCode FROM CHSS.FamilyHealthRecord WHERE FamilyRowId="_FamilyRowId
  
	Do result.Prepare(prepareString)
	Do result.Execute()
	While (result.Next()){
	 s FamilyCode = result.Data("FamilyCode")
	}
	;w FamilyCode
	s personcount = 0
	&SQL(select count(PersonRowId) into :personcount from CHSS.PersonHealthRecordMain where FamilyRowId = :FamilyRowId)

	s personcount = personcount + 1
	 while ($l(personcount) < 2)
	 {
		 s personcount = "0"_personcount
	}
	s FamilyCode = FamilyCode_personcount
	s coderepeat = 0
	&SQL(select count(PersonRowId) into :coderepeat from CHSS.PersonHealthRecordMain where PersonCode = :FamilyCode)
	s num = 1
	while(coderepeat > 0)
	{
		s FamilyCode = ..GetPersonCodeWithFamilyId2(FamilyRowId,num)
		s coderepeat = 0
	}
	Do result.Close()
	q FamilyCode
}

ClassMethod GetPersonCodeWithFamilyId2(FamilyRowId, Num) As %String
{
	s FamilyCode = ""
	s result = ##class(%Library.ResultSet).%New()
	Set prepareString = "SELECT FamilyRowId,FamilyCode FROM CHSS.FamilyHealthRecord WHERE FamilyRowId="_FamilyRowId
  
	Do result.Prepare(prepareString)
	Do result.Execute()
	While (result.Next()){
	 s FamilyCode = result.Data("FamilyCode")
	}
	s personcount = 0
	&SQL(select count(PersonRowId) into :personcount from CHSS.PersonHealthRecordMain where FamilyRowId = :FamilyRowId)

	s personcount = personcount + 1 + Num

	 while ($l(personcount) < 2)
	 {
		 s personcount = "0"_personcount
	}
	s FamilyCode = FamilyCode_personcount
	Do result.Close()
	q FamilyCode
}

Storage Default
{
<Data name="SystemIdServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.SystemIdServiceD</DataLocation>
<DefaultData>SystemIdServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.SystemIdServiceD</IdLocation>
<IndexLocation>^CHSSWeb.SystemIdServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.SystemIdServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
