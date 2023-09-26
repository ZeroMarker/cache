/// 仪器结果
Class dbo.RPMachineResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MachineResult, StorageStrategy = Default ]
{

Index IndexTestCode On (AssayNo, TestCodeDR, WorkGroupMachineDR) [ SqlName = Index_TestCode, Type = index ];

Index IndexAssayNoWGM On (AssayNo, WorkGroupMachineDR) [ SqlName = Index_AssayNoWGM, Type = index ];

Index IndexEpisodeNo On (AssayNo, ReceiveDate) [ SqlName = Index_EpisodeNo, Type = index ];

Index IndexMachine On (MachineParameterDR, EpisodeNo, ReceiveDate) [ SqlName = Index_Machine, Type = index ];

Index IndexMaster On (WorkGroupMachineDR, ReceiveDate, AssayNo, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRPMACHINERESULT On RowID [ PrimaryKey, SqlName = PK_RP_MACHINERESULT, Type = index, Unique ];

/// Foreign Key FKMachineResultMi created via DDL
ForeignKey FKMachineResultMi(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineResultMi ];

/// Foreign Key FKMachineResultTc created via DDL
ForeignKey FKMachineResultTc(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_MachineResultTc ];

/// Foreign Key FKMachineResultWg created via DDL
ForeignKey FKMachineResultWg(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_MachineResultWg ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 接收日期  
Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 接收时间  
Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 检测号  
Property AssayNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 6 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 8 ];

/// 定性结果  
Property TextRes As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 9 ];

/// 扩展结果  
Property ExtraRes As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 10 ];

/// 结果日期  
Property ResultDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 结果时间  
Property ResultTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 流水号  
Property EpisodeNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 14 ];

/// 异常提示  
Property ResultFlag As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 15 ];

///       
Property OtherRes As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

///       
Property ResNoes As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="RPMachineResultDefaultData">
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
<Value>Result</Value>
</Value>
<Value name="8">
<Value>TextRes</Value>
</Value>
<Value name="9">
<Value>ExtraRes</Value>
</Value>
<Value name="10">
<Value>ResultDate</Value>
</Value>
<Value name="11">
<Value>ResultTime</Value>
</Value>
<Value name="12">
<Value>MachineParameterDR</Value>
</Value>
<Value name="13">
<Value>EpisodeNo</Value>
</Value>
<Value name="14">
<Value>ResultFlag</Value>
</Value>
<Value name="15">
<Value>OtherRes</Value>
</Value>
<Value name="16">
<Value>ResNoes</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMachineResultD</DataLocation>
<DefaultData>RPMachineResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPMachineResultD</IdLocation>
<IndexLocation>^dbo.RPMachineResultI</IndexLocation>
<StreamLocation>^dbo.RPMachineResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
