/// 报告结果修改日志
Class dbo.RPVisitnumberResModifyLog Extends %Library.Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitnumberResModifyLog, StorageStrategy = Default ]
{

Index IndexMaster On (VisitnumberDR, WorkGroupMachineDR, TestCodeDR) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKRPVisitnumberResModifyHistory On RowID [ PrimaryKey, SqlName = PK_RP_VisitnumberResModifyHistory, Type = index, Unique ];

/// Foreign Key FKVisitnumberResModifyLogBTTestCode created via DDL
ForeignKey FKVisitnumberResModifyLogBTTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_RP_VisitNumberResModifyLog_BT_TestCode ];

/// Foreign Key FKRPVisitnumberResModifyHistoryBTWorkGroupMachine created via DDL
ForeignKey FKRPVisitnumberResModifyHistoryBTWorkGroupMachine(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_RP_VisitnumberResModifyHistory_BT_WorkGroupMachine ];

/// Foreign Key FKRPVisitnumberResModifyHistoryRPVisitNumber created via DDL
ForeignKey FKRPVisitnumberResModifyHistoryRPVisitNumber(VisitnumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_RP_VisitnumberResModifyHistory_RP_VisitNumber ];

/// Foreign Key FKRPVisitnumberResModifyHistoryRPVisitnumberResModifyHistory created via DDL
ForeignKey FKRPVisitnumberResModifyHistoryRPVisitnumberResModifyHistory(ModifyUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_VisitnumberResModifyHistory_RP_VisitnumberResModifyHistory ];

/// RowID  
Property RowID As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告  
Property VisitnumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 审核日期  
Property ModifyDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 审核时间  
Property ModifyTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 审核者  
Property ModifyUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 检测号  
Property ModifyClinetIp As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 9 ];

/// 结果  
Property ModifiedResult As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 10 ];

/// 定性结果  
Property ModifiedTextResult As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 11 ];

/// 扩展结果  
Property ModifiedExtraRes As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 12 ];

/// 其它结果  
Property ModifiedOtherRes As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 13 ];

/// 结果说明  
Property ModifiedResNoes As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 14 ];

/// 异常提示  
Property AbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

/// 单位  
Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 16 ];

///       
Property PreResult As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 17 ];

///       
Property PreTextResult As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 18 ];

///       
Property PreExtraRes As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 19 ];

Storage Default
{
<Data name="RPVisitnumberResModifyLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitnumberDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>ModifyDate</Value>
</Value>
<Value name="6">
<Value>ModifyTime</Value>
</Value>
<Value name="7">
<Value>ModifyUserDR</Value>
</Value>
<Value name="8">
<Value>ModifyClinetIp</Value>
</Value>
<Value name="9">
<Value>ModifiedResult</Value>
</Value>
<Value name="10">
<Value>ModifiedTextResult</Value>
</Value>
<Value name="11">
<Value>ModifiedExtraRes</Value>
</Value>
<Value name="12">
<Value>ModifiedOtherRes</Value>
</Value>
<Value name="13">
<Value>ModifiedResNoes</Value>
</Value>
<Value name="14">
<Value>AbFlag</Value>
</Value>
<Value name="15">
<Value>Unit</Value>
</Value>
<Value name="16">
<Value>PreResult</Value>
</Value>
<Value name="17">
<Value>PreTextResult</Value>
</Value>
<Value name="18">
<Value>PreExtraRes</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitnumberResModifyLogD</DataLocation>
<DefaultData>RPVisitnumberResModifyLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitnumberResModifyLogD</IdLocation>
<IndexLocation>^dbo.RPVisitnumberResModifyLogI</IndexLocation>
<StreamLocation>^dbo.RPVisitnumberResModifyLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
