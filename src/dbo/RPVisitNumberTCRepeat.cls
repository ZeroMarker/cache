/// 项目复查
Class dbo.RPVisitNumberTCRepeat Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberTCRepeat, StorageStrategy = Default ]
{

/// Foreign Key FKRPVisitNumberTCRepeatBTMIMachineParameter created via DDL
ForeignKey FKRPVisitNumberTCRepeatBTMIMachineParameter(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_RP_VisitNumberTCRepeat_BTMI_MachineParameter ];

/// Foreign Key FKRPVisitNumberTCRepeatBTTestCode created via DDL
ForeignKey FKRPVisitNumberTCRepeatBTTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_RP_VisitNumberTCRepeat_BT_TestCode ];

/// Foreign Key FKRPVisitNumberTCRepeatRPVisitNumberTCRepeat created via DDL
ForeignKey FKRPVisitNumberTCRepeatRPVisitNumberTCRepeat(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_RP_VisitNumberTCRepeat_RP_VisitNumberTCRepeat ];

/// Foreign Key FKRPVisitNumberTCRepeatSYSUser created via DDL
ForeignKey FKRPVisitNumberTCRepeatSYSUser(CreateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_VisitNumberTCRepeat_SYS_User ];

/// DDL Primary Key Specification
Index PKRPVisitNumberTCRepeat On RowID [ PrimaryKey, SqlName = PK_RP_VisitNumberTCRepeat, Type = index, Unique ];

Index IndexMaster On (VisitNumberReportDR, TestCodeDR, CreateDate, CreateTime) [ SqlName = Index_Master, Type = index ];

Index IndexMachineParameterDR On (MachineParameterDR, CreateDate, ReAssayNo) [ SqlName = Index_MachineParameterDR, Type = index ];

Index IndexMachineTestCodeDR On (MachineParameterDR, ReAssayNo, TestCodeDR) [ SqlName = Index_MachineTestCodeDR, Type = index ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 标本报告  
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 复查日期  
Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 复查时间  
Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 复查号  
Property ReAssayNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 7 ];

/// 复查用户  
Property CreateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 是否发送  {1:true,0:false}
Property IsSended As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 检测仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

/// DilCode  
Property DilCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// DilName  
Property DilName As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 12 ];

/// 复查结果  
Property RepeatRes As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 13 ];

/// 结果类型 1：原始结果，2:复查结果
Property ResType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 14 ];

/// 检测仪器  
Property RepeatMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 复查日期  
Property RepeatResDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 复查时间  
Property RepeatResTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 复查扩展
Property RepeatExtraRes As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 18 ];

/// 复查其他结果  
Property RepeatOtherRes As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 19 ];

Storage Default
{
<Data name="RPVisitNumberTCRepeatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
<Value name="6">
<Value>ReAssayNo</Value>
</Value>
<Value name="7">
<Value>CreateUserDR</Value>
</Value>
<Value name="8">
<Value>IsSended</Value>
</Value>
<Value name="9">
<Value>MachineParameterDR</Value>
</Value>
<Value name="10">
<Value>DilCode</Value>
</Value>
<Value name="11">
<Value>DilName</Value>
</Value>
<Value name="12">
<Value>RepeatRes</Value>
</Value>
<Value name="13">
<Value>ResType</Value>
</Value>
<Value name="14">
<Value>RepeatMachineDR</Value>
</Value>
<Value name="15">
<Value>RepeatResDate</Value>
</Value>
<Value name="16">
<Value>RepeatResTime</Value>
</Value>
<Value name="17">
<Value>RepeatExtraRes</Value>
</Value>
<Value name="18">
<Value>RepeatOtherRes</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberTCRepeatD</DataLocation>
<DefaultData>RPVisitNumberTCRepeatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberTCRepeatD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberTCRepeatI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberTCRepeatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
