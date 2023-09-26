/// 移动均值日志
Class dbo.BTMachineMovingAverageLog Extends %Persistent
{

Index IndexMaster On (MachineDR, TestCodeDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKMachineParameter created via DDL
ForeignKey FKMachineParameter(MachineDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineParameter ];

/// Foreign Key FKTestCode created via DDL
ForeignKey FKTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCode ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 仪器  
Property MachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 记录日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 记录时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// TotalNum  
Property TotalNum As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

/// TotalAvg  
Property TotalAvg As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

/// ReagNo  
Property ReagNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTMachineMovingAverageLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>TotalNum</Value>
</Value>
<Value name="7">
<Value>TotalAvg</Value>
</Value>
<Value name="8">
<Value>ReagNo</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMachineMovingAverageLogD</DataLocation>
<DefaultData>BTMachineMovingAverageLogDefaultData</DefaultData>
<IdLocation>^dbo.BTMachineMovingAverageLogD</IdLocation>
<IndexLocation>^dbo.BTMachineMovingAverageLogI</IndexLocation>
<StreamLocation>^dbo.BTMachineMovingAverageLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
