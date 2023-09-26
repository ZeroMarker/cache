Class dbo.RPMachineResultMic Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MachineResultMic, StorageStrategy = Default ]
{

/// Foreign Key FKMachineResultMicTc created via DDL
ForeignKey FKMachineResultMicTc(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_MachineResultMicTc ];

Index IndexTestCode On (AssayNo, TestCodeDR, WorkGroupMachineDR) [ SqlName = Index_TestCode, Type = index ];

Index IndexEpisodeNo On (AssayNo, ReceiveDate) [ SqlName = Index_EpisodeNo, Type = index ];

Index IndexMachine On (MachineParameterDR, EpisodeNo, ReceiveDate) [ SqlName = Index_Machine, Type = index ];

Index IndexMaster On (WorkGroupMachineDR, ReceiveDate, AssayNo, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRPMACHINERESULTMIC On RowID [ PrimaryKey, SqlName = PK_RP_MACHINERESULTMIC, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property AssayNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 6 ];

Property ResultDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property ResultTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property EpisodeNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

Property ResultFlag As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 11 ];

/// 专家规则
Property ExpertRule As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 12 ];

/// 备注
Property Memo As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 13 ];

/// 菌落计数
Property ColonyCount As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 14 ];

/// 菌落说明
Property ColonyMorphology As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 15 ];

/// 说明
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 16 ];

/// 多耐
Property MultipleResistant As %Library.Boolean [ SqlColumnNumber = 17 ];

/// 项目对应BTMCResistanceItem编码   值阴性：N,阳性：P
Property A0001 As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 18 ];

Property A0002 As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 19 ];

Property A0003 As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 20 ];

Property A0004 As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 21 ];

Property A0005 As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 22 ];

Property A0006 As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 23 ];

Property A0007 As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 24 ];

Property A0008 As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 25 ];

Property A0009 As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 26 ];

Property A0010 As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 27 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 28 ];

/// 多耐菌群  
Property MultipleResChild As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 29 ];

Storage Default
{
<Data name="RPMachineResultMicDefaultData">
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
<Value>ResultDate</Value>
</Value>
<Value name="7">
<Value>ResultTime</Value>
</Value>
<Value name="8">
<Value>MachineParameterDR</Value>
</Value>
<Value name="9">
<Value>EpisodeNo</Value>
</Value>
<Value name="10">
<Value>ResultFlag</Value>
</Value>
<Value name="11">
<Value>ExpertRule</Value>
</Value>
<Value name="12">
<Value>Memo</Value>
</Value>
<Value name="13">
<Value>ColonyCount</Value>
</Value>
<Value name="14">
<Value>ColonyMorphology</Value>
</Value>
<Value name="15">
<Value>Remark</Value>
</Value>
<Value name="16">
<Value>MultipleResistant</Value>
</Value>
<Value name="17">
<Value>A0001</Value>
</Value>
<Value name="18">
<Value>A0002</Value>
</Value>
<Value name="19">
<Value>A0003</Value>
</Value>
<Value name="20">
<Value>A0004</Value>
</Value>
<Value name="21">
<Value>A0005</Value>
</Value>
<Value name="22">
<Value>A0006</Value>
</Value>
<Value name="23">
<Value>A0007</Value>
</Value>
<Value name="24">
<Value>A0008</Value>
</Value>
<Value name="25">
<Value>A0009</Value>
</Value>
<Value name="26">
<Value>A0010</Value>
</Value>
<Value name="27">
<Value>TestCodeDR</Value>
</Value>
<Value name="28">
<Value>MultipleResChild</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMachineResultMicD</DataLocation>
<DefaultData>RPMachineResultMicDefaultData</DefaultData>
<IdLocation>^dbo.RPMachineResultMicD</IdLocation>
<IndexLocation>^dbo.RPMachineResultMicI</IndexLocation>
<StreamLocation>^dbo.RPMachineResultMicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
