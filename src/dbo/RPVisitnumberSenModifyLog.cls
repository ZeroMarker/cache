/// 药敏结果日志
Class dbo.RPVisitnumberSenModifyLog Extends %Library.Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitnumberSenModifyLog ]
{

Index IndexMaster On (VisitnumberDR, WorkGroupMachineDR, OrderNo, TestCodeDR, AntibioticsDR) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKRPRPVisitnumberSenModifyLog On RowID [ PrimaryKey, SqlName = PK_RP_VisitnumberSenModifyLog, Type = index, Unique ];

/// Foreign Key FKRPVisitnumberSenModifyLogAntibiocs created via DDL
ForeignKey FKRPVisitnumberSenModifyLogAntibiocs(AntibioticsDR) References dbo.BTAntibiotics(PKBTANTIBIOTICS) [ SqlName = FK_RPVisitnumberSenModifyLogAntibiocs ];

/// Foreign Key FKRPVisitnumberResModifyHistoryBTWorkGroupMachine created via DDL
ForeignKey FKRPVisitnumberSenModifyHistoryBTWorkGroupMachine(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_RP_VisitnumberSenModifyHistory_BT_WorkGroupMachine ];

/// Foreign Key FKRPVisitnumberResModifyHistoryRPVisitNumber created via DDL
ForeignKey FKRPVisitnumberSenModifyHistoryRPVisitNumber(VisitnumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_RP_VisitnumberSenModifyHistory_RP_VisitNumber ];

/// Foreign Key FKRPVisitnumberResModifyHistoryRPVisitnumberResModifyHistory created via DDL
ForeignKey FKRPVisitnumberSenModifyHistoryRPVisitnumberResModifyHistory(ModifyUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_VisitnumberSenModifyHistory_RP_VisitnumberResModifyHistory ];

/// RowID  
Property RowID As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告  
Property VisitnumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 抗生素  
Property AntibioticsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 审核日期  
Property ModifyDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 审核时间  
Property ModifyTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

/// 审核者  
Property ModifyUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

/// 检测号  
Property ModifyClinetIp As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 11 ];

/// 结果  
Property ModifiedResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 定性结果  
Property ModifiedTextResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 13 ];

/// 扩展结果  
Property ModifiedExtraRes As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 14 ];

/// 其它结果  
Property ModifiedOtherRes As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 15 ];

/// 结果说明  
Property ModifiedResNoes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 16 ];

/// 异常提示  
Property AbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 17 ];

/// 单位  
Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 18 ];

/// 前次结果      
Property PreResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 19 ];

/// 前次文本结果      
Property PreTextResult As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 20 ];

/// 前次扩展结果      
Property PreExtraRes As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="RPVisitnumberSenModifyLogDefaultData">
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
<Value>OrderNo</Value>
</Value>
<Value name="5">
<Value>TestCodeDR</Value>
</Value>
<Value name="6">
<Value>AntibioticsDR</Value>
</Value>
<Value name="7">
<Value>ModifyDate</Value>
</Value>
<Value name="8">
<Value>ModifyTime</Value>
</Value>
<Value name="9">
<Value>ModifyUserDR</Value>
</Value>
<Value name="10">
<Value>ModifyClinetIp</Value>
</Value>
<Value name="11">
<Value>ModifiedResult</Value>
</Value>
<Value name="12">
<Value>ModifiedTextResult</Value>
</Value>
<Value name="13">
<Value>ModifiedExtraRes</Value>
</Value>
<Value name="14">
<Value>ModifiedOtherRes</Value>
</Value>
<Value name="15">
<Value>ModifiedResNoes</Value>
</Value>
<Value name="16">
<Value>AbFlag</Value>
</Value>
<Value name="17">
<Value>Unit</Value>
</Value>
<Value name="18">
<Value>PreResult</Value>
</Value>
<Value name="19">
<Value>PreTextResult</Value>
</Value>
<Value name="20">
<Value>PreExtraRes</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitnumberSenModifyLogD</DataLocation>
<DefaultData>RPVisitnumberSenModifyLogDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitnumberSenModifyLogD</IdLocation>
<IndexLocation>^dbo.RPVisitnumberSenModifyLogI</IndexLocation>
<StreamLocation>^dbo.RPVisitnumberSenModifyLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
