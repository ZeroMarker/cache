Class CHSSWeb.system.OrgUtil Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// creator:zhangyong
/// date:2011-10-14
/// description: 药房ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetPhaDept(Start, Limit)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTLOC_ROWID AS RowId, CTLOC_DESC AS Description FROM CT_Loc WHERE CTLOC_TYPE = 'D' ORDER BY CTLOC_ROWID"
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
/// description: 药房窗口ComboBox
/// input:  Start(起始数值)  Limit(增长数值)  PhaDept(药房)
/// output: String "RowId^Description"
/// others:
ClassMethod GetPhaWindow(Start, Limit, PhaDept)
{
	s result = ##class(%Library.ResultSet).%New()
	SET WHERE = ""
	IF PhaDept '= "" DO
	.SET PhaDept = $ORDER(^DHCPHLOCi("LOC",PhaDept,0))
	.SET WHERE = "WHERE PHW_PHL_DR = "_$G(PhaDept)
	s sqlStr = "SELECT PHW_ROWID AS RowId, PHW_Desc_ AS Description FROM dhc_phwindow "_WHERE_" ORDER BY PHW_ROWID"
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

/// creator:zhangyong
/// date:2011-10-14
/// description: 临床科室ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetClinicDept(Start, Limit)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTLOC_ROWID AS RowId, CTLOC_DESC AS Description FROM CT_Loc WHERE CTLOC_TYPE = 'E' ORDER BY CTLOC_ROWID"
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
/// description: 科室ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetDeptLoc(Start, Limit)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTLOC_ROWID AS RowId, CTLOC_DESC AS Description FROM CT_Loc ORDER BY CTLOC_ROWID"
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

Storage Default
{
<Data name="OrgUtilDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.system.OrgUtilD</DataLocation>
<DefaultData>OrgUtilDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.system.OrgUtilD</IdLocation>
<IndexLocation>^CHSSWeb.system.OrgUtilI</IndexLocation>
<StreamLocation>^CHSSWeb.system.OrgUtilS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
