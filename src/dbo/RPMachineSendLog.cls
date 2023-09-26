/// 仪器发送日志
Class dbo.RPMachineSendLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MachineSendLog, StorageStrategy = Default ]
{

/// Foreign Key FKMachineSendLogMi created via DDL
ForeignKey FKMachineSendLogMi(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineSendLogMi ];

/// Foreign Key FKMachineSendLogTc created via DDL
ForeignKey FKMachineSendLogTc(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_MachineSendLogTc ];

Index IndexMaster On (MachineParameterDR, EpisodeNo, TestCodeDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTestCode On (MachineParameterDR, AddDate, TestCodeDR) [ SqlName = Index_TestCode, Type = index ];

Index IndexEpisodeNo On (EpisodeNo, TestCodeDR, MachineParameterDR) [ SqlName = Index_EpisodeNo, Type = index ];

/// DDL Primary Key Specification
Index PKRPMACHINESENDLOG On RowID [ PrimaryKey, SqlName = PK_RP_MACHINESENDLOG, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 流水号  
Property EpisodeNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 通道号  
Property Channel As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="RPMachineSendLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>EpisodeNo</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>Channel</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMachineSendLogD</DataLocation>
<DefaultData>RPMachineSendLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPMachineSendLogD</IdLocation>
<IndexLocation>^dbo.RPMachineSendLogI</IndexLocation>
<StreamLocation>^dbo.RPMachineSendLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
