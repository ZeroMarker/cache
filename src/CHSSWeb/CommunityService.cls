Class CHSSWeb.CommunityService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod GetCommunityCode(UserId As %Integer) As %String
{
	q:UserId=""
	///select OEORI_ItmMast_DR->arcim_desc from OE_OrdItem where OEORI_OEORD_ParRef=2290801 and OEORI_ItmMast_DR->arcim_inscodesc is null
	s CommunityCode = ""
	;本地使用
	;&sql( select HOSP_Hospital_DR->HOSP_Code into :CommunityCode from SQLUser.SS_GroupHospitals where HOSP_ParRef = :UserId)
	;华西服务器使用
	&sql( select SSUsr_Hospital_DR->HOSP_Code into :CommunityCode from SQLUser.SS_User where SSUSR_RowId = :UserId)
	//w "{""success"":""true"",""info"":"_CommunityCode_"}"
	q CommunityCode
}

ClassMethod GetCommunityType(UserId As %Integer) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	//s sqlStr = "select HOSP_Hospital_DR->HOSP_Code,HOSP_Desc from SQLUser.SS_GroupHospitals where HOSP_ParRef = "_UserId
	;本地使用
	;s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where HospitalDR in (select HOSP_Hospital_DR from SQLUser.SS_GroupHospitals where HOSP_ParRef = "_UserId_")"
	;华西医院使用
    s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where HospitalDR in (select SSUsr_Hospital_DR from SQLUser.SS_User where SSUSR_RowId = "_UserId_")"
	
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
	s CommunityCode = result.Data("CommunityCode")
	s CommunityName = result.Data("CommunityName")
	s CommunityType = result.Data("CommunityType")
	s tmp=CommunityCode_"^"_CommunityName_"^"_CommunityType
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("CommunityCode^CommunityName^CommunityType",count)
	k json
	q resultString
}

ClassMethod GetCommunityInfo(UserId As %Integer) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	//s sqlStr = "select HOSP_Hospital_DR->HOSP_Code,HOSP_Desc from SQLUser.SS_GroupHospitals where HOSP_ParRef = "_UserId
	;本地使用
	;s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where HospitalDR in (select HOSP_Hospital_DR from SQLUser.SS_GroupHospitals where HOSP_ParRef = "_UserId_")"
	;华西医院使用
	s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where HospitalDR in (select SSUsr_Hospital_DR from SQLUser.SS_User where SSUSR_RowId = "_UserId_")"
	
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
	s CommunityCode = result.Data("CommunityCode")
	s CommunityName = result.Data("CommunityName")
	s CommunityType = result.Data("CommunityType")
	s tmp=CommunityCode_"^"_CommunityName_"^"_CommunityType
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("CommunityCode^CommunityName^CommunityType",count)
	k json
	q resultString
}

ClassMethod GetCommunityInfoWithType(RecordDR As %Integer, CommunityType As %String) As %String
{
	s CommunityType = "村卫生所"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where CommunityType = '"_CommunityType_"' and RecordDR = "_RecordDR
	
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
	s CommunityCode = result.Data("CommunityCode")
	s CommunityName = result.Data("CommunityName")
	s CommunityType = result.Data("CommunityType")
	s tmp=CommunityCode_"^"_CommunityName_"^"_CommunityType
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("CommunityCode^CommunityName^CommunityType",count)
	k json
	q resultString
}

ClassMethod GetCommunityInfoWithCode(CommunityCode As %Integer, CommunityType As %String) As %String
{
	q:(CommunityCode="") ""
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
	
	While(result.Next())
	{
	s CommunityCode = result.Data("CommunityCode")
	s CommunityName = result.Data("CommunityName")
	s CommunityType = result.Data("CommunityType")
	s tmp=CommunityCode_"^"_CommunityName_"^"_CommunityType
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("CommunityCode^CommunityName^CommunityType",count)
	k json
	q resultString
}

/// Modify by wangb 2009-09-02 添加读取编码 
ClassMethod GetCurrentCommunity(CommunityCode As %String, CommunityType As %String) As %String
{
	;s CommunityType = "村卫生所"
	;s CommunityType = "社区卫生服务中心"
    ;s CommunityType = "社区卫生服务站"
	;w CommunityType
	;q ""
	
	s CommunityType = ..GetCommunityTypeWithCode(CommunityCode)
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
	e  i CommunityType = "县（区）卫生局" d
	.s sqlStr =" select '' as StreetDR,0 as StreetCode, null as StreetName, RowId as SectionDR, Code as SectionCode,Description as SectionName,RowIdParref as CityDR, RowIdParref->Code as CityCode,RowIdParref->Description as CityName,RowIdParref->RowIdParref as ProvinceDR,RowIdParref->RowIdParref->Code as ProvinceCode,RowIdParref->RowIdParref->Description as ProvinceName "
	.s sqlStr =sqlStr_" from CHSS.DictSection where RowId in ( select RecordDR from CHSS.DictHospital "
	.s sqlStr =sqlStr_" where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	e  i CommunityType = "市卫生局" d
	.s sqlStr =" select '' as StreetDR,0 as StreetCode, null as StreetName, '' as SectionDR, 0 as SectionCode,null as SectionName,RowId as CityDR, Code as CityCode,Description as CityName,RowIdParref as ProvinceDR,RowIdParref->Code as ProvinceCode,RowIdParref->Description as ProvinceName "
	.s sqlStr =sqlStr_" from CHSS.DictCity where RowId in ( select RecordDR from CHSS.DictHospital "
	.s sqlStr =sqlStr_" where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	e  i CommunityType = "省卫生厅" d
	.s sqlStr =" select 0 as StreetDR,0 as StreetCode,null as StreetName,0 as SectionDR,null as SectionCode,null as SectionName,0 as CityDR, "
	.s sqlStr =sqlStr_" null as CityCode,null as CityName,RowId as ProvinceDR,Code as ProvinceCode,Description as ProvinceName from CHSS.DictProvince where RowId in ( select RecordDR from CHSS.DictHospital "
	.s sqlStr =sqlStr_" where CommunityCode = '"_CommunityCode_"' and CommunityType = '"_CommunityType_"')"
	
	;w sqlStr,!
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
	s VillageDR = ""
	;result.Data("VillageDR")
	s VillageName = ""
	;result.Data("VillageName")
	;w CommunityType,!
	if (CommunityType="村卫生所")
	{
		s VillageDR = result.Data("VillageDR")
		s VillageName = result.Data("VillageName")	
	}
	elseif (CommunityType="社区卫生服务站")
	{
		s VillageDR = result.Data("VillageDR")
		s VillageName = result.Data("VillageName")	
	}
	s StreetDR = result.Data("StreetDR")
	s SectionDR = result.Data("SectionDR")
	s CityDR = result.Data("CityDR")
	s ProvinceDR = result.Data("ProvinceDR")
	
	s StreetName = result.Data("StreetName")
	s SectionName = result.Data("SectionName")
	s CityName = result.Data("CityName")
	s ProvinceName = result.Data("ProvinceName")
	;add by wangbo 2009-09-02
	s StreetCode = result.Data("StreetCode")
	s SectionCode = result.Data("SectionCode")
	s CityCode = result.Data("CityCode")
	s ProvinceCode = result.Data("ProvinceCode")
	
	s tmp=VillageDR_"^"_StreetDR_"^"_SectionDR_"^"_CityDR_"^"_ProvinceDR_"^"_VillageName_"^"_StreetName_"^"_SectionName_"^"_CityName_"^"_ProvinceName
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("VillageDR^StreetDR^SectionDR^CityDR^ProvinceDR^VillageName^StreetName^SectionName^CityName^ProvinceName",count)
	k json
	q resultString
}

ClassMethod GetCommunityFromHospital(RecordDR As %String, CommunityType As %String, WhereStr As %String) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where ((RecordDR = "_RecordDR
	s sqlStr = sqlStr_" and (CommunityType = '乡镇卫生院' or CommunityType = '社区卫生服务中心'))"
	s sqlStr = sqlStr_" OR (RecordDR in (select RowId As RecordDR from CHSS.DictVillage where RowIdParref = "_RecordDR_")"
	s sqlStr = sqlStr_" and CommunityType = '村卫生所'))"
	s sqlStr = sqlStr_WhereStr
	;w sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s Start = 0
	s Limit = 100
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s CommunityCode = result.Data("CommunityCode")
	s CommunityName = result.Data("CommunityName")
	s CommunityType = result.Data("CommunityType")
	s tmp=CommunityCode_"^"_CommunityName_"^"_CommunityType
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("CommunityCode^CommunityName^CommunityType",count)
	k json
	q resultString
}

/// Creator: wangbo
/// CreatDate：2010—05-10
/// Description:根据UserId检索医疗机构
/// Table：PersonHealthRecordMain
/// Input:UserId
/// Output：
/// Return：
/// Others：
ClassMethod GetCommunityListWithUserId(UserId As %Integer) As %String
{
	;绵阳使用
	;q ..GetAllCommunityList()
	
	s result = ##class(%Library.ResultSet).%New()
	//s sqlStr = "select HOSP_Hospital_DR->HOSP_Code,HOSP_Desc from SQLUser.SS_GroupHospitals where HOSP_ParRef = "_UserId
	;本地使用
	;s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where HospitalDR in (select HOSP_Hospital_DR from SQLUser.SS_GroupHospitals where HOSP_ParRef = "_UserId_")"
	;华西医院使用
	s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where HospitalDR in (select SSUsr_Hospital_DR from SQLUser.SS_User where SSUSR_RowId = "_UserId_")"
	;测试
	;s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital "
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s Start = 0
	s Limit = 1
	s resultString = ""
	s end = Start+Limit
	
	
	s CommunityCode =""
	s CommunityCodeStr =""
	While(result.Next())
	{
		s CommunityCode = result.Data("CommunityCode")
	}
	d result.Close()
	;w CommunityCode,!
	;s CommunityCode = "100"
	i CommunityCode '= "" d
	.s CommunityCodeStr = ..GetDownCommunityCode(CommunityCode)
	.i CommunityCodeStr '= "" d
	..s CommunityCodeStr = CommunityCode_CommunityCodeStr
	.e  d
	..s CommunityCodeStr = CommunityCode
	;w CommunityCodeStr,!
	s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where CommunityCode in ("_CommunityCodeStr_") order by UpCommunityCode"
	;w sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	s json = ##class(Code.JsonObj).%New()
	s CommunityType2 = ""
	While(result.Next())
	{
	s CommunityCode = result.Data("CommunityCode")
	s CommunityName = result.Data("CommunityName")
	s CommunityType = result.Data("CommunityType")
	if (CommunityType = "市卫生局")
	{
	  s CommunityType2 = CommunityType
	  w ..GetAllCommunityList()
	  break
	}
	s tmp=CommunityCode_"^"_CommunityName_"^"_CommunityType
	s count = count+1
	d json.InsertRowData(tmp)
	}
	d result.Close()
	if (CommunityType2 '= "市卫生局")
	{
	s resultString = json.getJsonData("CommunityCode^CommunityName^CommunityType",count)
	k json
	q resultString
	}
	q ""
}

ClassMethod GetDownCommunityCode(CommunityCode As %String) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where UpCommunityCode = '"_CommunityCode_"'"
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	s count = 0
	s resultString = ""
	s CommunityCodeStr = ""
	;w CommunityCodeStr
	While(result.Next())
	{
		s tempCommunityCode = result.Data("CommunityCode")
		;w tempCommunityCode
		i tempCommunityCode '= "" d
		.;s CommunityCodeStr = ..GetDownCommunityCode(tempCommunityCode)
		.;w CommunityCodeStr,!
		.s CommunityCodeStr = CommunityCodeStr_","_tempCommunityCode
		
	}
	d result.Close()
	q CommunityCodeStr
}

ClassMethod GetDownCommunityCode111(CommunityCode As %String) As %String
{
	s CommunityCodeStr = ""
	s tempCommunityCode = ""
	&SQL(select CommunityCode into :tempCommunityCode from CHSS.DictHospital where UpCommunityCode = :CommunityCode)

	i tempCommunityCode '= "" d
	.s CommunityCodeStr = ..GetDownCommunityCode(tempCommunityCode)
	.;w CommunityCodeStr,!
	.s CommunityCodeStr = CommunityCodeStr_","_tempCommunityCode

	q CommunityCodeStr
}

/// Creator: wangbo
/// CreatDate：2010—05-10
/// Description:检索所有医疗机构
/// Table：PersonHealthRecordMain
/// Input:UserId
/// Output：
/// Return：
/// Others：
ClassMethod GetAllCommunityList() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	//s sqlStr = "select HOSP_Hospital_DR->HOSP_Code,HOSP_Desc from SQLUser.SS_GroupHospitals where HOSP_ParRef = "_UserId
	;本地使用
	;s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where HospitalDR in (select HOSP_Hospital_DR from SQLUser.SS_GroupHospitals where HOSP_ParRef = "_UserId_")"
	;华西医院使用
	;s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where HospitalDR in (select SSUsr_Hospital_DR from SQLUser.SS_User where SSUSR_RowId = "_UserId_")"
	;测试
	;s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where CommunityType != '村卫生所' and CommunityType != '社区卫生服务站'  order by UpCommunityCode"
	s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital  order by UpCommunityCode"
	
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
	s CommunityCode = result.Data("CommunityCode")
	s CommunityName = result.Data("CommunityName")
	s CommunityType = result.Data("CommunityType")
	s tmp=CommunityCode_"^"_CommunityName_"^"_CommunityType
	s count = count+1
	d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("CommunityCode^CommunityName^CommunityType",count)
	k json
	q resultString
}

ClassMethod GetCommunityTypeWithCode(CommunityCode As %String) As %String
{
	s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where CommunityCode = '"_CommunityCode_"'"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	s CommunityType = ""
	While(result.Next())
	{
	s CommunityType = result.Data("CommunityType")

	}
	d result.Close()
	q CommunityType
}

/// 设置机构Session
ClassMethod SetCommunitySession(userid As %Integer)
{
	s result = ##class(%Library.ResultSet).%New()
	//s sqlStr = "select HOSP_Hospital_DR->HOSP_Code,HOSP_Desc from SQLUser.SS_GroupHospitals where HOSP_ParRef = "_UserId
	;本地使用
	;s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where HospitalDR in (select HOSP_Hospital_DR from SQLUser.SS_GroupHospitals where HOSP_ParRef = "_UserId_")"
	;华西医院使用
	s sqlStr = "select CommunityCode,CommunityName,CommunityType from CHSS.DictHospital where HospitalDR in (select SSUsr_Hospital_DR from SQLUser.SS_User where SSUSR_RowId = "_userid_")"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s ^tmptest22 = "wangbo"
	While(result.Next())
	{
	s CommunityCode = result.Data("CommunityCode")
	s CommunityName = result.Data("CommunityName")
	s CommunityType = result.Data("CommunityType")
	;设置session
	s %session.Data("LOGON.COMMUNITYCODE") = CommunityCode
	s %session.Data("LOGON.COMMUNITYTYPE") = CommunityType
	s %session.Data("LOGON.CURCOMMUNITYTYPE") = CommunityType
	s %session.Data("LOGON.COMMUNITYNAME") = CommunityName
	
	}
	d result.Close()
}

/// 设置机构Session
ClassMethod SetCommunitySession2(userid As %Integer)
{
	s CommunityCode = ""
	s CommunityType = ""
	s CommunityName = ""
	;&sql(select CommunityCode into :CommunityCode , CommunityName into :CommunityName , CommunityType into :CommunityType from CHSS.DictHospital where HospitalDR in (select SSUsr_Hospital_DR from SQLUser.SS_User where SSUSR_RowId = :userid))
	
	;设置session
	s %session.Data("LOGON.COMMUNITYCODE") = CommunityCode
	s %session.Data("LOGON.COMMUNITYTYPE") = CommunityType
	s %session.Data("LOGON.CURCOMMUNITYTYPE") = CommunityType
	s %session.Data("LOGON.COMMUNITYNAME") = CommunityName
}

Storage Default
{
<Data name="CommunityServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CommunityServiceD</DataLocation>
<DefaultData>CommunityServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CommunityServiceD</IdLocation>
<IndexLocation>^CHSSWeb.CommunityServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.CommunityServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
