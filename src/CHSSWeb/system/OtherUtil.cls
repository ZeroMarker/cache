Class CHSSWeb.system.OtherUtil Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// creator:zhangyong
/// date:2011-10-18
/// description: 退药原因ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetReturnPhaReason(Start, Limit)
{
	s result = ##class(%Library.ResultSet).%New()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	s rfr=""
    f  s rfr=$o(^BLC("RFR",rfr)) q:rfr=""  d
	.s rfrdesc=""
	.s rfrdesc=$p(^BLC("RFR",rfr),"^",2)
	.q:rfr=0
	.s tmp=rfr_"^"_rfrdesc
	.s count = count+1
	.i (count>Start)&(count<=end) d
	..d json.InsertRowData(tmp)
	s resultString = json.getJsonData("RowId^Description",count)
	k json
	q resultString
}

/// creator:zhangyong
/// date:2011-10-18
/// description: 退费原因ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetReturnChargeReason(Start, Limit)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT IRR_Desc AS Description, IRR_RowID AS RowId, IRR_Code  FROM DHC_INVOPRefReason"
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
<Data name="OtherUtilDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.system.OtherUtilD</DataLocation>
<DefaultData>OtherUtilDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.system.OtherUtilD</IdLocation>
<IndexLocation>^CHSSWeb.system.OtherUtilI</IndexLocation>
<StreamLocation>^CHSSWeb.system.OtherUtilS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
