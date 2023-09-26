Class dbo.RPHLAMachineResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_HLAMachineResult, StorageStrategy = Default ]
{

Index IndexAdmNo On (AdmNo, AssayNo) [ SqlName = Index_AdmNo, Type = index ];

Index IndexAdmNoDate On (AdmNo, ReceiveDate, AssayNo) [ SqlName = Index_AdmNoDate, Type = index ];

/// Foreign Key FKMachineResultWg created via DDL
ForeignKey FKHLAMachineResultWg(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_HLAMachineResultWg ];

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
Property AdmNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 检测状态  
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 8 ];

/// 接收日期  
Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 接收时间  
Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 接收时间  
Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 扩展结果  
Property HLAA As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 12 ];

/// 扩展结果  
Property HLAB As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 13 ];

/// 扩展结果  
Property HLAC As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 14 ];

/// 扩展结果  
Property HLADRB As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

/// 扩展结果  
Property HLADQB As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 16 ];

/// 扩展结果  
Property HLADPB As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 17 ];

/// 扩展结果  
Property KIRC As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 18 ];

/// 扩展结果  
Property KIRT As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 19 ];

/// 扩展结果  
Property KIRNum As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 20 ];

/// 扩展结果  
Property KIRResult As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="RPHLAMachineResultDefaultData">
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
<Value>AdmNo</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>AuthDate</Value>
</Value>
<Value name="9">
<Value>AuthTime</Value>
</Value>
<Value name="10">
<Value>AuthUserDR</Value>
</Value>
<Value name="11">
<Value>HLAA</Value>
</Value>
<Value name="12">
<Value>HLAB</Value>
</Value>
<Value name="13">
<Value>HLAC</Value>
</Value>
<Value name="14">
<Value>HLADRB</Value>
</Value>
<Value name="15">
<Value>HLADQB</Value>
</Value>
<Value name="16">
<Value>HLADPB</Value>
</Value>
<Value name="17">
<Value>KIRC</Value>
</Value>
<Value name="18">
<Value>KIRT</Value>
</Value>
<Value name="19">
<Value>KIRNum</Value>
</Value>
<Value name="20">
<Value>KIRResult</Value>
</Value>
</Data>
<DataLocation>^dbo.RPHLAMachineResultD</DataLocation>
<DefaultData>RPHLAMachineResultDefaultData</DefaultData>
<IdLocation>^dbo.RPHLAMachineResultD</IdLocation>
<IndexLocation>^dbo.RPHLAMachineResultI</IndexLocation>
<StreamLocation>^dbo.RPHLAMachineResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
