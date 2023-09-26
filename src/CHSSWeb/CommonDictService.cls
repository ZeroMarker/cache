Class CHSSWeb.CommonDictService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod ListPage(Start, Limit, TableName) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowId,Code,Description,StartDate,EndDate,Active,Sort FROM CHSS."_TableName_" "
	//s sqlStr = "SELECT RowId,Code,Description,StartDate,EndDate,Active,Sort FROM CHSS.DictAddressType"
	d result.Prepare(sqlStr)
	d result.Execute()
	//w Start,!
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	//w end,!
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
	s Active = "true"
	s Sort = ""
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

ClassMethod ListPageWithType(Start, Limit, TableName, Type) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowId,Code,Description,StartDate,EndDate,Active,Sort FROM CHSS."_TableName_" where Type = "_Type
	//s sqlStr = "SELECT RowId,Code,Description,StartDate,EndDate,Active,Sort FROM CHSS.DictAddressType"
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
	s Active = "true"
	s Sort = ""
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

ClassMethod ListOld(Start, Limit, TableName) As %String
{
	s sqlStr = ""
	
	s rowid = ""
	s code = ""
	s description = ""
	
	i TableName = "CT_Country" d
	.s rowid = "CTCOU_RowId"
	.s code = "CTCOU_Code"
	.s description = "CTCOU_Desc"
	e  i TableName = "CT_Nation" d
	.s rowid = "CTNAT_RowId"
	.s code = "CTNAT_Code"
	.s description = "CTNAT_Desc"
	e  i TableName = "PAC_BloodType" d
	.s rowid = "BLDT_RowId"
	.s code = "BLDT_Code"
	.s description = "BLDT_Desc"
	.
	e  i TableName = "CT_Education" d
	.s rowid = "EDU_RowId"
	.s code = "EDU_Code"
	.s description = "EDU_Desc"
	
	e  i TableName = "CT_Occupation" d
	.s rowid = "CTOCC_RowId"
	.s code = "CTOCC_Code"
	.s description = "CTOCC_Desc"
	
	e  i TableName = "CT_Marital" d
	.s rowid = "CTMAR_RowId"
	.s code = "CTMAR_Code"
	.s description = "CTMAR_Desc"
	.
	e  i TableName = "SS_User" d
	.s rowid = "SSUSR_RowId"
	.s code = "SSUSR_Initials"
	.s description = "SSUSR_Name"
	e  i TableName = "CT_Relation" d
	.s rowid = "CTRLT_RowId"
	.s code = "CTRLT_Code"
	.s description = "CTRLT_Desc"
	e  i TableName = "PAC_CardType" d
	.s rowid = "CARD_RowId"
	.s code = "CARD_Code"
	.s description = "CARD_Desc"
	e  i TableName = "CT_Loc" d
	.s rowid = "CTLOC_RowID"
	.s code = "CTLOC_Code"
	.s description = "CTLOC_Desc"
	e  i TableName = "MRC_ICDDx" d
	.s rowid = "MRCID_RowId"
	.s code = "MRCID_Code"
	.s description = "MRCID_Desc"
	e  i TableName = "CT_Hospital" d
	.s rowid = "HOSP_RowId"
	.s code = "HOSP_Code"
	.s description = "HOSP_Desc"
	e  i TableName = "CT_Sex" d
	.s rowid = "CTSEX_RowId"
	.s code = "CTSEX_Code"
	.s description = "CTSEX_Desc"
	e  i TableName = "SS_Group" d
	.s rowid = "SSGRP_RowId"
	.s code = "SSGRP_RowId"
	.s description = "SSGRP_Desc"
	e  i TableName="SS_Group" d
	.s rowid="SSGRP_RowId"
	.s code = "SSGRP_RowId"
	.s description="SSGRP_Desc"
	.
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM SQLUser."_TableName_" "
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit

	s json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
	s RowId = result.Data(rowid)
	s Code = result.Data(code)
	s Description = result.Data(description)
	
	s tmp=RowId_"^"_Code_"^"_Description
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Description",count)
	k json
	q resultString
}

ClassMethod ListOldSearch(Start, Limit, TableName, SearchStr) As %String
{
	s sqlStr = ""
	s rowid = ""
	s code = ""
	s description = ""

	
	i TableName = "CT_Country" d
	.s rowid = "CTCOU_RowId"
	.s code = "CTCOU_Code"
	.s description = "CTCOU_Desc"
	e  i TableName = "CT_Nation" d
	.s rowid = "CTNAT_RowId"
	.s code = "CTNAT_Code"
	.s description = "CTNAT_Desc"
	e  i TableName = "PAC_BloodType" d
	.s rowid = "BLDT_RowId"
	.s code = "BLDT_Code"
	.s description = "BLDT_Desc"
	.
	e  i TableName = "CT_Education" d
	.s rowid = "EDU_RowId"
	.s code = "EDU_Code"
	.s description = "EDU_Desc"
	
	e  i TableName = "CT_Occupation" d
	.s rowid = "CTOCC_RowId"
	.s code = "CTOCC_Code"
	.s description = "CTOCC_Desc"
	
	e  i TableName = "CT_Marital" d
	.s rowid = "CTMAR_RowId"
	.s code = "CTMAR_Code"
	.s description = "CTMAR_Desc"
	.
	e  i TableName = "SS_User" d
	.s rowid = "SSUSR_RowId"
	.s code = "SSUSR_Initials"
	.s description = "SSUSR_Name"
	e  i TableName = "CT_Relation" d
	.s rowid = "CTRLT_RowId"
	.s code = "CTRLT_Code"
	.s description = "CTRLT_Desc"
	e  i TableName = "PAC_CardType" d
	.s rowid = "CARD_RowId"
	.s code = "CARD_Code"
	.s description = "CARD_Desc"
	e  i TableName = "CT_Loc" d
	.s rowid = "CTLOC_RowID"
	.s code = "CTLOC_Code"
	.s description = "CTLOC_Desc"
	e  i TableName = "MRC_ICDDx" d
	.s TableName = "MRC_ICDAlias"
	.s rowid = "MRCID_RowId"
	.s code = "MRCID_Code"
	.s description = "MRCID_Desc"
	e  i TableName = "CT_Hospital" d
	.s rowid = "HOSP_RowId"
	.s code = "HOSP_Code"
	.s description = "HOSP_Desc"
	e  i TableName="SS_Group" d
	.s rowid="SSGRP_RowId"
	.s code = "SSGRP_RowId"
	.s description="SSGRP_Desc"
	
	s result = ##class(%Library.ResultSet).%New()
	s whereStr = ""
	i SearchStr '= "" d
	.s whereStr = " where "_description_" like '%"_SearchStr_"%'"
	.i TableName = "MRC_ICDAlias" d
	..s whereStr = " where ALIAS_Text like '%"_SearchStr_"%'"
	..s whereStr = whereStr_" or ALIAS_ParRef->MRCID_Desc like '%"_SearchStr_"%'"
	.
	;查询社区人员
	i TableName = "SS_User" d
	.s whereStr = " where "_SearchStr_" "
	i TableName '= "MRC_ICDAlias" d
	.s sqlStr = "SELECT "_rowid_","_code_","_description_" FROM SQLUser."_TableName_whereStr
	e  d
	.;疾病名称按拼音查询
	.s sqlStr = "SELECT distinct  ALIAS_ParRef->MRCID_RowId MRCID_RowId,ALIAS_ParRef->MRCID_Code MRCID_Code,ALIAS_ParRef->MRCID_Desc MRCID_Desc FROM SQLUser."_TableName_whereStr

	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	//w Start,!
	//w end,!
	s json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
	s RowId = result.Data(rowid)
	s Code = result.Data(code)
	s Description = result.Data(description)

	s tmp=RowId_"^"_Code_"^"_Description
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Description",count)
	k json
	q resultString
}

ClassMethod ListSearch(Start, Limit, TableName, SearchStr) As %String
{
	s Start=$g(Start)
	s Limit=$g(Limit)
	s TableName=$g(TableName)
	s SearchStr=$g(SearchStr)
	
	s result = ##class(%Library.ResultSet).%New()
	s whereStr = ""
	i SearchStr '= "" d
	.s whereStr = " where Description like '%"_SearchStr_"%'"

	s sqlStr = "SELECT RowId,Code,Description,StartDate,EndDate,Active,Sort FROM CHSS."_TableName_whereStr
	;w sqlStr,!
	//s sqlStr = "SELECT RowId,Code,Description,StartDate,EndDate,Active,Sort FROM CHSS.DictAddressType"
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
	s Active = "true"
	s Sort = ""
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

ClassMethod ListOldSearchGroup(Start, Limit, TableName, SearchStr) As %String
{

	s sqlStr = ""
	s rowid = ""
	s code = ""
	s description = ""
	
	i TableName="SS_Group" d
	.s rowid="SSGRP_RowId"
	.s code = "SSGRP_RowId"
	.s description="SSGRP_Desc"
	
	s result = ##class(%Library.ResultSet).%New()
	s whereStr = ""
	i SearchStr '= "" d
	.s whereStr = " where "_description_" like '%"_SearchStr_"%'"
	e  d
	.;s whereStr=" where ssgrp_rowid "_" in ( select UserRowId from CHSS.CHSSUserVsResource) "
	s sqlStr = "SELECT * FROM SQLUser."_TableName_whereStr
	
	;w sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	//w Start,!
	//w end,!
	s json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
	s RowId = result.Data(rowid)
	s Code = result.Data(code)
	s Description = result.Data(description)

	s tmp=RowId_"^"_Code_"^"_Description
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Description",count)
	k json
	q resultString
}

Storage Default
{
<Data name="CommonDictServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CommonDictServiceD</DataLocation>
<DefaultData>CommonDictServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CommonDictServiceD</IdLocation>
<IndexLocation>^CHSSWeb.CommonDictServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.CommonDictServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
