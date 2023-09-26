Class CHSSWeb.system.CommUtil Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// creator:zhangyong
/// date:2011-10-14
/// description: 卡类型ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetCardType(Start, Limit)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select CTD_RowId AS RowId, CTD_Desc AS Description from DHC_CardTypeDef where CTD_ActiveFlag='IE' order by CTD_RowID"
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
/// description: 支付方式ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetPayMode(Start, Limit)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTPM_RowId AS RowId, CTPM_Desc AS Description FROM CT_PayMode where CTPM_NotUseFlag = 'Y' ORDER BY CTPM_RowId"
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
/// description: 时段ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others
ClassMethod GetTimeRange(Start, Limit) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT TR_RowId AS RowId, TR_Desc AS Description FROM DHC_TimeRange ORDER BY TR_RowId"
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
<Data name="CommUtilDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.system.CommUtilD</DataLocation>
<DefaultData>CommUtilDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.system.CommUtilD</IdLocation>
<IndexLocation>^CHSSWeb.system.CommUtilI</IndexLocation>
<StreamLocation>^CHSSWeb.system.CommUtilS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
