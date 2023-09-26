Class CHSSWeb.system.PersonUtil Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// creator:zhangyong
/// date:2011-10-14
/// description: 药剂师ComboBox
/// input:  Start(起始数值)  Limit(增长数值)  PhaDept(药房)
/// output: String "RowId^Description"
/// others:
ClassMethod GetApothecary(Start, Limit, PhaDept)
{
	s result = ##class(%Library.ResultSet).%New()
	SET WHERE = ""
	IF PhaDept '= "" DO
	.SET PhaDept = $ORDER(^DHCPHLOCi("LOC",PhaDept,0))
	.SET WHERE = "WHERE PHP_PHL_DR = "_$G(PhaDept)
	s sqlStr = "SELECT DISTINCT PHP_RowId AS RowId, PHP_NAME AS Description FROM DHC_PHPERSON "_WHERE_" ORDER BY PHP_ROWID"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	s Rowid = result.Data("RowId")
	s Description = result.Data("Description")
	s tmp=Rowid_"^"_Description
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Description",count)
	k json
	q resultString
}

/// creator:zhangyong
/// date:2011-10-14
/// description: 医生ComboBox
/// input:  Start(起始数值)  Limit(增长数值)  DeptLoc(科室)
/// output: String "RowId^Description"
/// others:
ClassMethod GetDoctor(Start, Limit, DeptLoc)
{
	s result = ##class(%Library.ResultSet).%New()
	SET WHERE = ""
	IF DeptLoc '= "" DO
	.SET WHERE = "AND B.OTHLL_CTLOC_DR = "_$G(DeptLoc)
	s sqlStr = "SELECT DISTINCT A.SSUSR_RowId AS RowId, A.SSUSR_Name AS Description FROM SS_USER A , SS_UserOtherLogonLoc B WHERE A.SSUSR_RowId = B.OTHLL_ParRef AND A.SSUSR_IsThisDoctor = 'Y' "_WHERE_" ORDER BY A.SSUSR_RowId"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	s Rowid = result.Data("RowId")
	s Description = result.Data("Description")
	s tmp=Rowid_"^"_Description
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Description",count)
	k json
	Q resultString
}

Storage Default
{
<Data name="PersonUtilDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.system.PersonUtilD</DataLocation>
<DefaultData>PersonUtilDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.system.PersonUtilD</IdLocation>
<IndexLocation>^CHSSWeb.system.PersonUtilI</IndexLocation>
<StreamLocation>^CHSSWeb.system.PersonUtilS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
