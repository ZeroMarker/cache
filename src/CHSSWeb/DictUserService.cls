Class CHSSWeb.DictUserService Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

ClassMethod UserList(Start, Limit, UserId) As %String
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

Storage Default
{
<Data name="DictUserServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DictUserServiceD</DataLocation>
<DefaultData>DictUserServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.DictUserServiceD</IdLocation>
<IndexLocation>^CHSSWeb.DictUserServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.DictUserServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
