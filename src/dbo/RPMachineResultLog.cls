/// 仪器结果日志
Class dbo.RPMachineResultLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MachineResultLog, StorageStrategy = Default ]
{

Index IndexEpisodeNo On (AssayNo, ReceiveDate, WorkGroupMachineDR) [ SqlName = Index_EpisodeNo, Type = index ];

Index IndexMachine On (MachineParameterDR, EpisodeNo, ReceiveDate) [ SqlName = Index_Machine, Type = index ];

Index IndexMaster On (WorkGroupMachineDR, ReceiveDate, AssayNo, TestCodeDR, OrderNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexMachTestCode On (MachineParameterDR, TestCodeDR, ReceiveDate, ReceiveTime) [ SqlName = Index_MachTestCode, Type = index ];

Index IndexTestCode On (AssayNo, TestCodeDR, WorkGroupMachineDR) [ SqlName = Index_TestCode, Type = index ];

/// DDL Primary Key Specification
Index PKRPMACHINERESULTLOG On RowID [ PrimaryKey, SqlName = PK_RP_MACHINERESULTLOG, Type = index, Unique ];

/// Foreign Key FKMachineResultLogMi created via DDL
ForeignKey FKMachineResultLogMi(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineResultLogMi ];

/// Foreign Key FKMachineResultLogTc created via DDL
ForeignKey FKMachineResultLogTc(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_MachineResultLogTc ];

/// Foreign Key FKMachineResultLogWg created via DDL
ForeignKey FKMachineResultLogWg(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_MachineResultLogWg ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 工作组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 日期  
Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 时间  
Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 检测号  
Property AssayNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 6 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 序号  
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 9 ];

/// 定性结果  
Property TextRes As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 10 ];

/// 扩展结果  
Property ExtraRes As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

/// 结果日期  
Property ResultDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 结果时间  
Property ResultTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 流水号  
Property EpisodeNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 15 ];

/// 异常提示  
Property ResultFlag As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 16 ];

///       
Property OtherRes As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

///       
Property ResNoes As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="RPMachineResultLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>ReceiveDate</Value>
</Value>
<Value name="4">
<Value>ReceiveTime</Value>
</Value>
<Value name="5">
<Value>AssayNo</Value>
</Value>
<Value name="6">
<Value>TestCodeDR</Value>
</Value>
<Value name="7">
<Value>Order</Value>
</Value>
<Value name="8">
<Value>Result</Value>
</Value>
<Value name="9">
<Value>TextRes</Value>
</Value>
<Value name="10">
<Value>ExtraRes</Value>
</Value>
<Value name="11">
<Value>ResultDate</Value>
</Value>
<Value name="12">
<Value>ResultTime</Value>
</Value>
<Value name="13">
<Value>MachineParameterDR</Value>
</Value>
<Value name="14">
<Value>EpisodeNo</Value>
</Value>
<Value name="15">
<Value>ResultFlag</Value>
</Value>
<Value name="16">
<Value>OrderNo</Value>
</Value>
<Value name="17">
<Value>OtherRes</Value>
</Value>
<Value name="18">
<Value>ResNoes</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMachineResultLogD</DataLocation>
<DefaultData>RPMachineResultLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPMachineResultLogD</IdLocation>
<IndexLocation>^dbo.RPMachineResultLogI</IndexLocation>
<StreamLocation>^dbo.RPMachineResultLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
